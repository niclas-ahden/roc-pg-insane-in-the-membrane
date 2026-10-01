## Writes `tests/NodeJson.roc`: the parse tree as JSON, laid out the way
## libpg_query writes Postgres's own trees, so that the two can be compared
## as text. Each node type's fields come in the order of its C struct, and
## how a field is written follows from its C type.
import Structs
import Translate

TreeJson :: [].{
	## The module's source, and the C types it did not know how to write.
	source : Str, Str, List(Str), Dict(Str, List(Structs.Field)), Dict(Str, List((Str, I64))) -> { code : Str, unknown : List(Str) }
	source = |header, hand, types, structs, enums| {
		kinds = types.map(|t| (t, (structs.get(t) ?? []).map(|f| (f, kind_of(f.type, structs, enums)))))
		unknown = kinds.fold(
			[],
			|acc, (t, fields)|
				fields.fold(
					acc,
					|a, (f, k)|
						match k {
							Unknown(what) => a.append("${t}.${f.name}: ${what}")
							_ => a
						},
				),
		)
		used_enums = kinds.fold(
			[],
			|acc, (_, fields)|
				fields.fold(
					acc,
					|a, (_, k)|
						match k {
							Enum(e) => if a.contains(e) a else a.append(e)
							_ => a
						},
				),
		)
		writers = kinds.map(|(t, fields)| writer(t, fields))
		enum_code = used_enums.map(|e| enum_writer(e, enums.get(e) ?? []))
		node_arms = types.map(|t| "\t\t${tag(t)}(r) => \"{\\\"${t}\\\":{\${${fn_name(t)}(r)}}}\"")
		body_arms = types.map(|t| "\t\t${tag(t)}(r) => ${fn_name(t)}(r)")
		code = Str.join_with(
			[
				header,
				"## Parse trees as JSON, written the way libpg_query writes Postgres's own",
				"## trees, so that the two can be compared as text. Written by",
				"## `tools/actions.roc`, do not edit.",
				"import pg.Node",
				"",
				"NodeJson :: [].{",
				"\t## The `RawStmt` nodes of a parse, as the `stmts` array.",
				"\tstmts : List(Node) -> Str",
				"\tstmts = |raw| stmts_json(raw)",
				"",
				"\t## One node, with its type around it.",
				"\tnode : Node -> Str",
				"\tnode = |n| node_json(n)",
				"}",
				"",
				"node_json : Node -> Str",
				"node_json = |n|",
				"\tmatch n {",
				"\t\tNull => \"null\"",
				"\t\tNodeList(items) => if items.is_empty() \"null\" else \"{\\\"List\\\":{\\\"items\\\":\${elements(items)}}}\"",
			]
				.concat(node_arms)
				.concat(["\t}", "", "## A node's fields without its type around it.", "body : Node -> Str", "body = |n|", "\tmatch n {", "\t\tNull | NodeList(_) => \"\""])
				.concat(body_arms)
				.concat(["\t}", "", hand])
				.concat(writers)
				.concat(enum_code),
			"\n",
		)
		{ code, unknown }
	}
}

Kind : [Int, UInt, Char, Boolean, Enum(Str), Text, List, NodePtr, SpecificPtr, Specific, Skipped, Unknown(Str)]

kind_of : Str, Dict(Str, List(Structs.Field)), Dict(Str, List((Str, I64))) -> Kind
kind_of = |text, structs, enums| {
	words = text.replace_each("*", " * ").split_on(" ").map(|w| w.trim()).keep_if(|w| !w.is_empty() and w != "const" and w != "struct" and w != "union" and w != "volatile" and w != "unsigned" and w != "signed")
	stars = words.keep_if(|w| w == "*").len()
	base = words.find_first(|w| w != "*") ?? ""
	if stars > 0 {
		if stars > 1 {
			Unknown(text)
		} else if base == "char" {
			Text
		} else if base == "List" {
			List
		} else if base == "Node" or base == "Expr" {
			NodePtr
		} else if base == "Bitmapset" {
			Skipped
		} else if structs.contains(base) {
			SpecificPtr
		} else {
			Unknown(text)
		}
	} else if base == "bool" {
		Boolean
	} else if base == "char" {
		Char
	} else if structs.contains(base) {
		Specific
	} else if enums.contains(base) {
		Enum(base)
	} else if ["int", "int8", "int16", "int32", "int64", "long", "ParseLoc", "AttrNumber"].contains(base) {
		Int
	} else if ["Oid", "Index", "uint8", "uint16", "uint32", "bits32", "SubTransactionId", "RelFileNumber"].contains(base) {
		UInt
	} else {
		Unknown(text)
	}
}

## The writer of one node type's fields, special for `A_Const` and the value
## nodes, whose JSON libpg_query writes by hand.
writer : Str, List((Structs.Field, Kind)) -> Str
writer = |t, fields| {
	name = fn_name(t)
	head = "${name} : Node.${tag(t)} -> Str\n${name} = |r|"
	special =
		match t {
			"A_Const" => Ok("(if r.isnull \"\\\"isnull\\\":true\" else a_const_value(r.val)).concat(\",\\\"location\\\":\${r.location.to_str()}\")")
			"Integer" => Ok("if r.ival != 0 \"\\\"ival\\\":\${r.ival.to_str()}\" else \"\"")
			"Float" => Ok("\"\\\"fval\\\":\${token(r.fval)}\"")
			"Boolean" => Ok("\"\\\"boolval\\\":\${if r.boolval \"true\" else \"false\"}\"")
			"String" => Ok("\"\\\"sval\\\":\${token(r.sval)}\"")
			"BitString" => Ok("\"\\\"bsval\\\":\${token(r.bsval)}\"")
			_ => Err(NotSpecial)
		}
	match special {
		Ok(text) => "${head} ${text}\n"
		Err(NotSpecial) => {
			parts = fields.keep_oks(|(f, k)| field_writer(t, f, k))
			if parts.is_empty() {
				"${name} : Node.${tag(t)} -> Str\n${name} = |_r| \"\"\n"
			} else {
				"${head}\n\tfields(\n\t\t[\n${Str.join_with(parts.map(|p| "\t\t\t${p},"), "\n")}\n\t\t],\n\t)\n"
			}
		}
	}
}

## How one field is written. `SelectStmt.limitOption` is written by hand:
## libpg_query numbers `LimitOption` from a `LIMIT_OPTION_DEFAULT` it adds
## for "no limit clause", where Postgres leaves `LIMIT_OPTION_COUNT`.
field_writer : Str, Structs.Field, Kind -> Try(Str, [Skip])
field_writer = |t, f, kind| {
	if t == "SelectStmt" and f.name == "limitOption" {
		return Ok("enum_field(\"limitOption\", limit_option(r))")
	}
	key = "\"${f.name}\""
	value = "r.${Translate.snake(f.name)}"
	match kind {
		Int => Ok("int_field(${key}, ${value})")
		UInt => Ok("uint_field(${key}, ${value})")
		Char => Ok("char_field(${key}, ${value})")
		Boolean => Ok("bool_field(${key}, ${value})")
		Enum(e) => Ok("enum_field(${key}, ${enum_fn(e)}(${value}))")
		Text => Ok("text_field(${key}, ${value})")
		List => Ok("list_field(${key}, ${value})")
		NodePtr => Ok("node_field(${key}, ${value})")
		SpecificPtr => Ok("specific_ptr_field(${key}, ${value})")
		Specific => Ok("specific_field(${key}, ${value})")
		Skipped | Unknown(_) => Err(Skip)
	}
}

enum_writer : Str, List((Str, I64)) -> Str
enum_writer = |e, values| {
	name = enum_fn(e)
	arms = values.map(|(n, v)| "\t\t${v.to_str()} => \"${n}\"")
	Str.join_with(["${name} : I64 -> Str", "${name} = |v|", "\tmatch v {"].concat(arms).concat(["\t\t_ => \"<${e} \${v.to_str()}>\"", "\t}", ""]), "\n")
}

fn_name : Str -> Str
fn_name = |t| "json_${Translate.snake(t)}"

enum_fn : Str -> Str
enum_fn = |e| "enum_${Translate.snake(e)}"

tag : Str -> Str
tag = |type| type.replace_each("_", "")

