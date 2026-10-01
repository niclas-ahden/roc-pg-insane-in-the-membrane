## What a piece of parsed C refers to: the functions it calls and the node
## types it makes with `makeNode` or `palloc(sizeof(...))`.
import CParse

Walk :: [].{
	calls : CParse.Stmt -> List(Str)
	calls = |s| stmt_names(s, Calls)

	made : CParse.Stmt -> List(Str)
	made = |s| stmt_names(s, Made)
}

stmt_names : CParse.Stmt, [Calls, Made] -> List(Str)
stmt_names = |s, what|
	match s {
		Block(items) => items.fold([], |acc, x| acc.concat(stmt_names(x, what)))
		Decl(_, decls) =>
			decls.fold(
				[],
				|acc, d|
					match d.init {
						Ok(e) => acc.concat(expr_names(e, what))
						Err(_) => acc
					},
			)
		ExprStmt(e) => expr_names(e, what)
		If(c, a, b) => {
			rest =
				match b {
					Ok(x) => stmt_names(x, what)
					Err(_) => []
				}
			expr_names(c, what).concat(stmt_names(a, what)).concat(rest)
		}
		While(c, b) => expr_names(c, what).concat(stmt_names(b, what))
		DoWhile(b, c) => stmt_names(b, what).concat(expr_names(c, what))
		For(i, c, st, b) => {
			cs =
				match c {
					Ok(x) => expr_names(x, what)
					Err(_) => []
				}
			ss =
				match st {
					Ok(x) => expr_names(x, what)
					Err(_) => []
				}
			stmt_names(i, what).concat(cs).concat(ss).concat(stmt_names(b, what))
		}
		Foreach(_, args, b) => args.fold([], |acc, a| acc.concat(expr_names(a, what))).concat(stmt_names(b, what))
		Switch(x, cases) => cases.fold(expr_names(x, what), |acc, c| acc.concat(c.body.fold([], |a2, st| a2.concat(stmt_names(st, what)))))
		Return(Ok(e)) => expr_names(e, what)
		_ => []
	}

expr_names : CParse.Expr, [Calls, Made] -> List(Str)
expr_names = |e, what|
	match e {
		Call(Ident(name), args) => {
			inner = args.fold([], |acc, a| acc.concat(expr_names(a, what)))
			own =
				match what {
					Calls => [name]
					Made =>
						if name == "makeNode" {
							match args {
								[Ident(t)] => [t]
								_ => []
							}
						} else if name == "palloc" or name == "palloc0" {
							match args {
								[SizeOf(t)] => [t.replace_each("struct ", "").trim()]
								_ => []
							}
						} else {
							[]
						}
				}
			own.concat(inner)
		}
		Call(f, args) => args.fold(expr_names(f, what), |acc, a| acc.concat(expr_names(a, what)))
		Field(x, _) => expr_names(x, what)
		Index(x, i) => expr_names(x, what).concat(expr_names(i, what))
		Prefix(_, x) => expr_names(x, what)
		Postfix(_, x) => expr_names(x, what)
		Binary(_, a, b) => expr_names(a, what).concat(expr_names(b, what))
		Assign(_, a, b) => expr_names(a, what).concat(expr_names(b, what))
		Cond(c, a, b) => expr_names(c, what).concat(expr_names(a, what)).concat(expr_names(b, what))
		Cast(_, x) => expr_names(x, what)
		Comma(items) => items.fold([], |acc, x| acc.concat(expr_names(x, what)))
		_ => []
	}
