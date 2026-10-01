## The grammar actions in the parser bison writes for `gram.y`: each rule's
## number, its `lhs: rhs` comment, and the C code of its action, with
## bison's `(yyvsp[k].member)`, `(yylsp[k])`, `(yyval.member)` and `(yyloc)`
## as they are.
GramC :: [].{
	Action : { rule : U64, rule_text : Str, code : Str }

	## The length of each rule, `yyr2`, indexed by rule number.
	rule_lengths : Str -> List(U64)
	rule_lengths = |gram_c| {
		after = gram_c.split_first(" yyr2[] =").map_ok(|s| s.after) ?? ""
		body = (after.split_first("{").map_ok(|s| s.after) ?? "").split_first("}").map_ok(|s| s.before) ?? ""
		body.split_on(",").map(|s| s.trim()).keep_if(|s| !s.is_empty()).map(|s| U64.from_str(s) ?? 0)
	}

	actions : Str -> List(GramC.Action)
	actions = |gram_c| {
		body = (gram_c.split_first("switch (yyn)\n    {\n").map_ok(|s| s.after) ?? "").split_first("\n      default: break;").map_ok(|s| s.before) ?? ""
		parts = "\n${body}".split_on("\n  case ")
		parts.drop_first(1).fold(
			[],
			|acc, part| {
				number_text = part.split_first(":").map_ok(|s| s.before) ?? ""
				rest = part.split_first(":").map_ok(|s| s.after) ?? ""
				rule_text = (rest.split_first("/*").map_ok(|s| s.after) ?? "").split_first("*/").map_ok(|s| s.before) ?? ""
				lines = rest.split_on("\n").drop_first(1).keep_if(|l| !l.starts_with("#line") and l.trim() != "break;")
				code = Str.join_with(lines, "\n")
				match U64.from_str(number_text.trim()) {
					Ok(rule) => acc.append({ rule, rule_text: rule_text.trim(), code })
					Err(_) => acc
				}
			},
		)
	}
}
