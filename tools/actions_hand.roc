## ---- Ported by hand from gram.y (tools/actions_hand.roc) ----
##
## These helpers write through the pointers they are given (a union member,
## an argument the caller keeps using, or out-parameters), which the
## translator does not do. A written argument comes back in a record field
## named after its position, `a0`, `a1` and so on. A constant name between
## two at signs is filled in by the generator.

## makeIntConst
make_int_const : I64, I64 -> Node
make_int_const = |val, location| Node.AConst({ ..Node.a_const_default, val: Node.Integer({ ival: val }), location })

## makeFloatConst
make_float_const : Node.Text, I64 -> Node
make_float_const = |str, location| Node.AConst({ ..Node.a_const_default, val: Node.Float({ fval: str }), location })

## makeStringConst
make_string_const : Node.Text, I64 -> Node
make_string_const = |str, location| Node.AConst({ ..Node.a_const_default, val: Node.String({ sval: str }), location })

## makeBitStringConst
make_bit_string_const : Node.Text, I64 -> Node
make_bit_string_const = |str, location| Node.AConst({ ..Node.a_const_default, val: Node.BitString({ bsval: str }), location })

## makeBoolAConst
make_bool_a_const : Bool, I64 -> Node
make_bool_a_const = |state, location| Node.AConst({ ..Node.a_const_default, val: Node.Boolean({ boolval: state }), location })

## makeNullAConst
make_null_a_const : I64 -> Node
make_null_a_const = |location| Node.AConst({ ..Node.a_const_default, isnull: Bool.True, location })

## makeAConst: only called with an Integer or a Float.
make_a_const : Node, I64 -> Node
make_a_const = |v, location|
	match v {
		Float(f) => make_float_const(f.fval, location)
		Integer(i) => make_int_const(i.ival, location)
		_ => Null
	}

## doNegate: a negated number constant stays a constant, with the location
## of the minus sign; anything else becomes `- x`.
do_negate : Node, I64 -> Node
do_negate = |n, location|
	match n {
		AConst(con) => {
			moved = { ..con, location }
			match con.val {
				Integer(i) => Node.AConst({ ..moved, val: Node.Integer({ ival: 0 - i.ival }) })
				Float(f) => Node.AConst({ ..moved, val: Node.Float({ fval: negate_float(f.fval) }) })
				_ => make_simple_a_expr(@AEXPR_OP@, Ok("-"), Null, Node.AConst(moved), location)
			}
		}
		_ => make_simple_a_expr(@AEXPR_OP@, Ok("-"), Null, n, location)
	}

## doNegateFloat: strip a leading `-`, or add one, after any leading `+`.
negate_float : Node.Text -> Node.Text
negate_float = |fval| {
	bytes = Rt.text_str(fval).to_utf8()
	unsigned = if bytes.first() == Ok('+') bytes.drop_first(1) else bytes
	if unsigned.first() == Ok('-') {
		Ok(Str.from_utf8_lossy(unsigned.drop_first(1)))
	} else {
		Ok("-${Str.from_utf8_lossy(unsigned)}")
	}
}

## insertSelectOptions
insert_select_options : Node, List(Node), List(Node), Node, Node, Rt.Ctx -> Try({ a0 : Node }, Scan.Problem)
insert_select_options = |stmt_node, sort_clause, locking_clause, limit_clause, with_clause, ctx| {
	var $stmt = Node.select_stmt_of(stmt_node)
	if !sort_clause.is_empty() {
		if !$stmt.sort_clause.is_empty() {
			return Err(Rt.error(ctx, "42601", Ok("multiple ORDER BY clauses not allowed"), expr_location(Rt.list_node(sort_clause))))
		}
		$stmt = { ..$stmt, sort_clause }
	}
	$stmt = { ..$stmt, locking_clause: $stmt.locking_clause.concat(locking_clause) }
	match limit_clause {
		SelectLimit(limit) => {
			if !Node.is_null(limit.limit_offset) {
				if !Node.is_null($stmt.limit_offset) {
					return Err(Rt.error(ctx, "42601", Ok("multiple OFFSET clauses not allowed"), limit.offset_loc))
				}
				$stmt = { ..$stmt, limit_offset: limit.limit_offset }
			}
			if !Node.is_null(limit.limit_count) {
				if !Node.is_null($stmt.limit_count) {
					return Err(Rt.error(ctx, "42601", Ok("multiple LIMIT clauses not allowed"), limit.count_loc))
				}
				$stmt = { ..$stmt, limit_count: limit.limit_count }
			}
			if $stmt.sort_clause.is_empty() and limit.limit_option == @LIMIT_OPTION_WITH_TIES@ {
				return Err(Rt.error(ctx, "42601", Ok("WITH TIES cannot be specified without ORDER BY clause"), limit.option_loc))
			}
			if limit.limit_option == @LIMIT_OPTION_WITH_TIES@ and !$stmt.locking_clause.is_empty() {
				for lock in $stmt.locking_clause {
					if Node.locking_clause_of(lock).wait_policy == @LockWaitSkip@ {
						return Err(Rt.error(ctx, "42601", Ok("SKIP LOCKED and WITH TIES options cannot be used together"), limit.option_loc))
					}
				}
			}
			$stmt = { ..$stmt, limit_option: limit.limit_option }
		}
		_ => {}
	}
	if !Node.is_null(with_clause) {
		if !Node.is_null($stmt.with_clause) {
			return Err(Rt.error(ctx, "42601", Ok("multiple WITH clauses not allowed"), expr_location(with_clause)))
		}
		$stmt = { ..$stmt, with_clause }
	}
	Ok({ a0: Node.SelectStmt($stmt) })
}

## SplitColQualList: the COLLATE clause out of a column's constraints.
split_col_qual_list : List(Node), Bool, Bool, Rt.Ctx -> Try({ a1 : List(Node), a2 : Node }, Scan.Problem)
split_col_qual_list = |qual_list, _want_constraints, _want_collate, ctx| {
	var $kept = []
	var $collate = Null
	for n in qual_list {
		match n {
			Constraint(_) => {
				$kept = $kept.append(n)
			}
			CollateClause(c) => {
				if !Node.is_null($collate) {
					return Err(Rt.error(ctx, "42601", Ok("multiple COLLATE clauses not allowed"), c.location))
				}
				$collate = n
			}
			_ => {
				return Err(Rt.error(ctx, "XX000", Ok("unexpected node type ${Node.tag(n)}"), -1))
			}
		}
	}
	Ok({ a1: $kept, a2: $collate })
}

## processCASbits: constraint attribute bits into the flags the caller asks
## for. Asking about a bit the caller has no flag for is an error.
process_cas_bits : I64, I64, Node.Text, Bool, Bool, Bool, Bool, Bool, Rt.Ctx -> Try({ a3 : Bool, a4 : Bool, a5 : Bool, a6 : Bool, a7 : Bool }, Scan.Problem)
process_cas_bits = |cas_bits, location, constr_type, has_deferrable, has_initdeferred, has_is_enforced, has_not_valid, has_no_inherit, ctx| {
	var $deferrable = Bool.False
	var $initdeferred = Bool.False
	var $is_enforced = Bool.True
	var $not_valid = Bool.False
	var $no_inherit = Bool.False
	if Rt.bit_and(cas_bits, Rt.bit_or(@CAS_DEFERRABLE@, @CAS_INITIALLY_DEFERRED@)) != 0 {
		if !has_deferrable {
			return Err(cas_error(ctx, constr_type, "DEFERRABLE", location))
		}
		$deferrable = Bool.True
	}
	if Rt.bit_and(cas_bits, @CAS_INITIALLY_DEFERRED@) != 0 {
		if !has_initdeferred {
			return Err(cas_error(ctx, constr_type, "DEFERRABLE", location))
		}
		$initdeferred = Bool.True
	}
	if Rt.bit_and(cas_bits, @CAS_NOT_VALID@) != 0 {
		if !has_not_valid {
			return Err(cas_error(ctx, constr_type, "NOT VALID", location))
		}
		$not_valid = Bool.True
	}
	if Rt.bit_and(cas_bits, @CAS_NO_INHERIT@) != 0 {
		if !has_no_inherit {
			return Err(cas_error(ctx, constr_type, "NO INHERIT", location))
		}
		$no_inherit = Bool.True
	}
	if Rt.bit_and(cas_bits, @CAS_NOT_ENFORCED@) != 0 {
		if !has_is_enforced {
			return Err(cas_error(ctx, constr_type, "NOT ENFORCED", location))
		}
		$is_enforced = Bool.False
		$not_valid = Bool.True
	}
	if Rt.bit_and(cas_bits, @CAS_ENFORCED@) != 0 {
		if !has_is_enforced {
			return Err(cas_error(ctx, constr_type, "ENFORCED", location))
		}
		$is_enforced = Bool.True
	}
	Ok({ a3: $deferrable, a4: $initdeferred, a5: $is_enforced, a6: $not_valid, a7: $no_inherit })
}

## preprocess_pubobj_list: fill in each object's kind from the one before it.
preprocess_pubobj_list : List(Node), Rt.Ctx -> Try({ a0 : List(Node) }, Scan.Problem)
preprocess_pubobj_list = |list, ctx| {
	if list.is_empty() {
		return Ok({ a0: list })
	}
	first = Node.publication_obj_spec_of(Rt.linitial(list))
	if first.pubobjtype == @PUBLICATIONOBJ_CONTINUATION@ {
		return Err(Rt.error(ctx, "42601", Ok("invalid publication object list"), first.location))
	}
	var $prev = @PUBLICATIONOBJ_CONTINUATION@
	var $out = []
	for item in list {
		var $obj = Node.publication_obj_spec_of(item)
		if $obj.pubobjtype == @PUBLICATIONOBJ_CONTINUATION@ {
			$obj = { ..$obj, pubobjtype: $prev }
		}
		if $obj.pubobjtype == @PUBLICATIONOBJ_TABLE@ {
			if !Rt.text_is_set($obj.name) and Node.is_null($obj.pubtable) {
				return Err(Rt.error(ctx, "42601", Ok("invalid table name"), $obj.location))
			}
			if Rt.text_is_set($obj.name) {
				pubtable = Node.PublicationTable({ ..Node.publication_table_default, relation: make_range_var(Err(Null), $obj.name, $obj.location) })
				$obj = { ..$obj, pubtable, name: Err(Null) }
			}
		} else if $obj.pubobjtype == @PUBLICATIONOBJ_TABLES_IN_SCHEMA@ or $obj.pubobjtype == @PUBLICATIONOBJ_TABLES_IN_CUR_SCHEMA@ {
			match $obj.pubtable {
				PublicationTable(t) => {
					if !Node.is_null(t.where_clause) {
						return Err(Rt.error(ctx, "42601", Ok("WHERE clause not allowed for schema"), $obj.location))
					}
					if !t.columns.is_empty() {
						return Err(Rt.error(ctx, "42601", Ok("column specification not allowed for schema"), $obj.location))
					}
				}
				_ => {}
			}
			if Rt.text_is_set($obj.name) {
				$obj = { ..$obj, pubobjtype: @PUBLICATIONOBJ_TABLES_IN_SCHEMA@ }
			} else if Node.is_null($obj.pubtable) {
				$obj = { ..$obj, pubobjtype: @PUBLICATIONOBJ_TABLES_IN_CUR_SCHEMA@ }
			} else {
				return Err(Rt.error(ctx, "42601", Ok("invalid schema name"), $obj.location))
			}
		}
		$prev = $obj.pubobjtype
		$out = $out.append(Node.PublicationObjSpec($obj))
	}
	Ok({ a0: $out })
}

## updateRawStmtEnd: set a statement's length once.
update_raw_stmt_end : Node, I64 -> { a0 : Node }
update_raw_stmt_end = |rs_node, end_location| {
	rs = Node.raw_stmt_of(rs_node)
	if rs.stmt_len > 0 {
		{ a0: rs_node }
	} else {
		{ a0: Node.RawStmt({ ..rs, stmt_len: end_location - rs.stmt_location }) }
	}
}

## NameListToString (namespace.c): names joined with dots.
name_list_to_string : List(Node) -> Node.Text
name_list_to_string = |names| {
	parts : List(Str)
	parts = names.map(
		|n|
			match n {
				String(s) => Rt.text_str(s.sval)
				AStar(_) => "*"
				_ => "?"
			},
	)
	Ok(Str.join_with(parts, "."))
}

cas_error : Rt.Ctx, Node.Text, Str, I64 -> Scan.Problem
cas_error = |ctx, constr_type, what, location| Rt.error(ctx, "0A000", Ok("${Rt.text_str(constr_type)} constraints cannot be marked ${what}"), location)

## doNegateFloat, on a Float node the caller keeps.
do_negate_float_node : Node -> { a0 : Node }
do_negate_float_node = |v| { a0: Node.Float({ fval: negate_float(Node.float_of(v).fval) }) }
