## A parser for the C that Postgres's grammar actions and parser helpers are
## written in: statements, expressions with C's precedence, casts,
## declarations, and function definitions. It knows nothing about what the
## names mean, which is the lowering's job.
import CLex

CParse :: [].{
	Expr := [
		Ident(Str),
		Num(Str),
		StrLit(List(U8)),
		CharLit(U8),
		Call(CParse.Expr, List(CParse.Expr)),
		## `a->b` or `a.b`.
		Field(CParse.Expr, Str),
		Index(CParse.Expr, CParse.Expr),
		## `!`, `-`, `+`, `~`, `*`, `&`, `++` and `--` before the operand.
		Prefix(Str, CParse.Expr),
		## `++` and `--` after the operand.
		Postfix(Str, CParse.Expr),
		Binary(Str, CParse.Expr, CParse.Expr),
		## `=`, `+=`, `|=` and so on.
		Assign(Str, CParse.Expr, CParse.Expr),
		Cond(CParse.Expr, CParse.Expr, CParse.Expr),
		## A cast to the type as written, such as `Node *`.
		Cast(Str, CParse.Expr),
		SizeOf(Str),
		Comma(List(CParse.Expr)),
	]

	Stmt := [
		Block(List(CParse.Stmt)),
		## A declaration: the type, then each name with its initializer.
		Decl(Str, List({ name : Str, init : Try(CParse.Expr, [NoInit]) })),
		ExprStmt(CParse.Expr),
		If(CParse.Expr, CParse.Stmt, Try(CParse.Stmt, [NoElse])),
		While(CParse.Expr, CParse.Stmt),
		DoWhile(CParse.Stmt, CParse.Expr),
		For(CParse.Stmt, Try(CParse.Expr, [NoCond]), Try(CParse.Expr, [NoStep]), CParse.Stmt),
		## `foreach(cell, list)` and its variants, with their arguments.
		Foreach(Str, List(CParse.Expr), CParse.Stmt),
		## The cases with their labels (empty for `default`) and statements.
		Switch(CParse.Expr, List({ labels : List(CParse.Expr), is_default : Bool, body : List(CParse.Stmt) })),
		Return(Try(CParse.Expr, [Void])),
		Break,
		Continue,
		Empty,
	]

	## A function definition: its name, parameters, return type and body.
	Func : { name : Str, params : List({ type : Str, name : Str }), returns : Str, body : CParse.Stmt }

	## Parse a statement, such as a grammar action's `{ ... }`.
	statement : Str -> Try(CParse.Stmt, Str)
	statement = |source| {
		toks = CLex.tokens(source)
		r = stmt(toks, 0)?
		Ok(r.value)
	}

	## Parse one expression, such as the value of a `#define`.
	expression_text : Str -> Try(CParse.Expr, Str)
	expression_text = |source| {
		toks = CLex.tokens(source)
		r = expression(toks, 0)?
		if tok_at(toks, r.next) == End Ok(r.value) else fail(toks, r.next, "expected the end")
	}

	## An S-expression of a statement, for looking at what was parsed.
	show : CParse.Stmt -> Str
	show = |s| show_stmt(s)

	## Every function definition at the top level of `source`, and the name
	## and error of each one that could not be read.
	functions : Str -> { funcs : List(CParse.Func), failed : List({ name : Str, error : Str }) }
	functions = |source| {
		toks = CLex.tokens(source)
		var $i = 0
		var $out = []
		var $failed = []
		var $depth = 0
		while tok_at(toks, $i) != End {
			t = tok_at(toks, $i)
			if t == Punct("{") {
				$depth = $depth + 1
				$i = $i + 1
			} else if t == Punct("}") {
				$depth = $depth - 1
				$i = $i + 1
			} else if $depth == 0 and is_ident(t) and tok_at(toks, $i + 1) == Punct("(") {
				close = matching(toks, $i + 1)
				if tok_at(toks, close + 1) == Punct("{") {
					match function(toks, $i, close) {
						Ok(f) => {
							$out = $out.append(f.value)
							$i = f.next
						}
						Err(error) => {
							$failed = $failed.append({ name: ident_name(tok_at(toks, $i)), error })
							$i = matching(toks, close + 1) + 1
						}
					}
				} else {
					$i = close + 1
				}
			} else {
				$i = $i + 1
			}
		}
		{ funcs: $out, failed: $failed }
	}
}

Parsed(a) : Try({ value : a, next : U64 }, Str)

tok_at : List(CLex.Token), U64 -> CLex.Tok
tok_at = |toks, i| (toks.get(i) ?? { tok: End, line: 0 }).tok

line_at : List(CLex.Token), U64 -> U64
line_at = |toks, i| (toks.get(i) ?? { tok: End, line: 0 }).line

is_ident : CLex.Tok -> Bool
is_ident = |t|
	match t {
		Ident(_) => Bool.True
		_ => Bool.False
	}

ident_name : CLex.Tok -> Str
ident_name = |t|
	match t {
		Ident(n) => n
		_ => ""
	}

fail : List(CLex.Token), U64, Str -> Try(a, Str)
fail = |toks, i, message| Err("line ${line_at(toks, i).to_str()}: ${message} (at ${describe(tok_at(toks, i))})")

describe : CLex.Tok -> Str
describe = |t|
	match t {
		Ident(n) => n
		Num(n) => n
		StrLit(_) => "a string"
		CharLit(_) => "a character"
		Punct(p) => p
		End => "the end"
	}

expect_punct : List(CLex.Token), U64, Str -> Try(U64, Str)
expect_punct = |toks, i, p|
	if tok_at(toks, i) == Punct(p) Ok(i + 1) else fail(toks, i, "expected ${p}")

## The index of the `)` or `}` or `]` that closes the bracket at `open`.
matching : List(CLex.Token), U64 -> U64
matching = |toks, open| {
	var $depth = 0
	var $i = open
	var $done = Bool.False
	while !$done {
		t = tok_at(toks, $i)
		if t == End {
			$done = Bool.True
		} else {
			if t == Punct("(") or t == Punct("{") or t == Punct("[") {
				$depth = $depth + 1
			} else if t == Punct(")") or t == Punct("}") or t == Punct("]") {
				$depth = $depth - 1
			}
			if $depth == 0 {
				$done = Bool.True
			} else {
				$i = $i + 1
			}
		}
	}
	$i
}

## A function definition whose name is at `name_at` and whose parameter
## list closes at `close`.
function : List(CLex.Token), U64, U64 -> Parsed(CParse.Func)
function = |toks, name_at, close| {
	name = ident_name(tok_at(toks, name_at))
	# The return type is on the tokens before the name, back to the previous
	# `;` or `}` at the top level.
	var $k = name_at
	var $ret_words = []
	var $going = Bool.True
	while $going and $k > 0 {
		t = tok_at(toks, $k - 1)
		if t == Punct(";") or t == Punct("}") or t == Punct(")") {
			$going = Bool.False
		} else {
			$ret_words = $ret_words.prepend(describe(t))
			$k = $k - 1
		}
	}
	params = parameters(toks, name_at + 2, close)
	body = stmt(toks, close + 1)?
	Ok({ value: { name, params, returns: Str.join_with($ret_words, " "), body: body.value }, next: body.next })
}

## `type name, type name` between `from` and `close`.
parameters : List(CLex.Token), U64, U64 -> List({ type : Str, name : Str })
parameters = |toks, from, close| {
	var $out = []
	var $words = []
	var $i = from
	while $i <= close {
		t = tok_at(toks, $i)
		if t == Punct(",") or $i == close {
			if !$words.is_empty() {
				name = $words.last() ?? ""
				type_words = $words.drop_last(1)
				$out = $out.append({ type: Str.join_with(type_words, " "), name })
			}
			$words = []
		} else {
			$words = $words.append(describe(t))
		}
		$i = $i + 1
	}
	$out.keep_if(|p| p.name != "void")
}

## Words that start a type in a declaration or a cast.
type_words : List(Str)
type_words = ["const", "static", "volatile", "unsigned", "signed", "struct", "enum", "union", "long", "short", "int", "char", "bool", "float", "double", "void"]

## Scalar type names that may be cast to without a `*`.
scalar_types : List(Str)
scalar_types = ["int", "char", "bool", "long", "short", "unsigned", "signed", "float", "double", "void", "int16", "int32", "int64", "uint8", "uint16", "uint32", "uint64", "Oid", "Size", "size_t", "AclMode", "bits16", "bits32", "Index", "AttrNumber", "RoleSpecType", "ObjectType", "SetOperation", "LimitOption", "DropBehavior", "SortByDir", "SortByNulls", "NodeTag", "CoercionForm"]

## A type at `i`, such as `const char *` or `SelectStmt *`: its text and the
## index after it, if the tokens there read as one.
type_at : List(CLex.Token), U64 -> Try({ text : Str, next : U64, stars : U64, main : Str }, [NotType])
type_at = |toks, i| {
	var $j = i
	var $words = []
	var $main = ""
	var $going = Bool.True
	while $going {
		t = tok_at(toks, $j)
		name = ident_name(t)
		if is_ident(t) and type_words.contains(name) {
			$words = $words.append(name)
			if name != "const" and name != "static" and name != "volatile" and name != "struct" and name != "enum" and name != "union" {
				$main = name
			}
			$j = $j + 1
			# `struct Foo`: the tag is part of the type.
			if (name == "struct" or name == "enum" or name == "union") and is_ident(tok_at(toks, $j)) {
				$words = $words.append(ident_name(tok_at(toks, $j)))
				$main = ident_name(tok_at(toks, $j))
				$j = $j + 1
			}
		} else if is_ident(t) and $main == "" {
			$words = $words.append(name)
			$main = name
			$j = $j + 1
		} else {
			$going = Bool.False
		}
	}
	if $main == "" {
		return Err(NotType)
	}
	var $stars = 0
	while tok_at(toks, $j) == Punct("*") or tok_at(toks, $j) == Ident("const") {
		if tok_at(toks, $j) == Punct("*") {
			$stars = $stars + 1
		}
		$words = $words.append(describe(tok_at(toks, $j)))
		$j = $j + 1
	}
	Ok({ text: Str.join_with($words, " "), next: $j, stars: $stars, main: $main })
}

## A declaration at `i`, if the tokens read as one: a type, then a name
## followed by `=`, `;`, `,` or `[`.
declaration : List(CLex.Token), U64 -> Try(Parsed(CParse.Stmt), [NotDecl])
declaration = |toks, i| {
	ty = type_at(toks, i) ? |_| NotDecl
	after_name = tok_at(toks, ty.next + 1)
	if !is_ident(tok_at(toks, ty.next)) or !(after_name == Punct("=") or after_name == Punct(";") or after_name == Punct(",") or after_name == Punct("[")) {
		return Err(NotDecl)
	}
	Ok(declarators(toks, ty.next, ty.text))
}

declarators : List(CLex.Token), U64, Str -> Parsed(CParse.Stmt)
declarators = |toks, from, type_text| {
	var $i = from
	var $out = []
	var $going = Bool.True
	while $going {
		# More pointers before a later name, as in `int a, *b`.
		while tok_at(toks, $i) == Punct("*") {
			$i = $i + 1
		}
		name = ident_name(tok_at(toks, $i))
		$i = $i + 1
		if tok_at(toks, $i) == Punct("[") {
			$i = matching(toks, $i) + 1
		}
		if tok_at(toks, $i) == Punct("=") {
			init = assignment(toks, $i + 1)?
			$out = $out.append({ name, init: Ok(init.value) })
			$i = init.next
		} else {
			$out = $out.append({ name, init: Err(NoInit) })
		}
		if tok_at(toks, $i) == Punct(",") {
			$i = $i + 1
		} else {
			$going = Bool.False
		}
	}
	next = expect_punct(toks, $i, ";")?
	Ok({ value: Decl(type_text, $out), next })
}

stmt : List(CLex.Token), U64 -> Parsed(CParse.Stmt)
stmt = |toks, i| {
	t = tok_at(toks, i)
	match t {
		Punct("{") => {
			var $j = i + 1
			var $out = []
			while tok_at(toks, $j) != Punct("}") {
				if tok_at(toks, $j) == End {
					return fail(toks, $j, "unclosed block")
				}
				s = stmt(toks, $j)?
				$out = $out.append(s.value)
				$j = s.next
			}
			Ok({ value: Block($out), next: $j + 1 })
		}
		Punct(";") => Ok({ value: Empty, next: i + 1 })
		Ident("if") => {
			after_open = expect_punct(toks, i + 1, "(")?
			cond = expression(toks, after_open)?
			after_close = expect_punct(toks, cond.next, ")")?
			then = stmt(toks, after_close)?
			if tok_at(toks, then.next) == Ident("else") {
				els = stmt(toks, then.next + 1)?
				Ok({ value: If(cond.value, then.value, Ok(els.value)), next: els.next })
			} else {
				Ok({ value: If(cond.value, then.value, Err(NoElse)), next: then.next })
			}
		}
		Ident("while") => {
			after_open = expect_punct(toks, i + 1, "(")?
			cond = expression(toks, after_open)?
			after_close = expect_punct(toks, cond.next, ")")?
			body = stmt(toks, after_close)?
			Ok({ value: While(cond.value, body.value), next: body.next })
		}
		Ident("do") => {
			body = stmt(toks, i + 1)?
			after_while = if tok_at(toks, body.next) == Ident("while") Ok(body.next + 1) else fail(toks, body.next, "expected while")
			after_open = expect_punct(toks, after_while?, "(")?
			cond = expression(toks, after_open)?
			after_close = expect_punct(toks, cond.next, ")")?
			next = expect_punct(toks, after_close, ";")?
			Ok({ value: DoWhile(body.value, cond.value), next })
		}
		Ident("for") => {
			after_open = expect_punct(toks, i + 1, "(")?
			init =
				if tok_at(toks, after_open) == Punct(";") {
					{ value: Empty, next: after_open + 1 }
				} else {
					match declaration(toks, after_open) {
						Ok(d) => d?
						Err(_) => {
							e = expression(toks, after_open)?
							{ value: ExprStmt(e.value), next: expect_punct(toks, e.next, ";")? }
						}
					}
				}
			cond =
				if tok_at(toks, init.next) == Punct(";") {
					{ value: Err(NoCond), next: init.next + 1 }
				} else {
					c = expression(toks, init.next)?
					{ value: Ok(c.value), next: expect_punct(toks, c.next, ";")? }
				}
			step =
				if tok_at(toks, cond.next) == Punct(")") {
					{ value: Err(NoStep), next: cond.next + 1 }
				} else {
					s = expression(toks, cond.next)?
					{ value: Ok(s.value), next: expect_punct(toks, s.next, ")")? }
				}
			body = stmt(toks, step.next)?
			Ok({ value: For(init.value, cond.value, step.value, body.value), next: body.next })
		}
		Ident("switch") => {
			after_open = expect_punct(toks, i + 1, "(")?
			subject = expression(toks, after_open)?
			after_close = expect_punct(toks, subject.next, ")")?
			body_start = expect_punct(toks, after_close, "{")?
			cases = switch_cases(toks, body_start)?
			Ok({ value: Switch(subject.value, cases.value), next: cases.next })
		}
		Ident("return") =>
			if tok_at(toks, i + 1) == Punct(";") {
				Ok({ value: Return(Err(Void)), next: i + 2 })
			} else {
				e = expression(toks, i + 1)?
				next = expect_punct(toks, e.next, ";")?
				Ok({ value: Return(Ok(e.value)), next })
			}
		Ident("break") => Ok({ value: Break, next: expect_punct(toks, i + 1, ";")? })
		Ident("continue") => Ok({ value: Continue, next: expect_punct(toks, i + 1, ";")? })
		Ident(name) =>
			if (name.starts_with("foreach") or name.starts_with("for_each")) and tok_at(toks, i + 1) == Punct("(") {
				close = matching(toks, i + 1)
				args = arguments(toks, i + 2, close)?
				body = stmt(toks, close + 1)?
				Ok({ value: Foreach(name, args, body.value), next: body.next })
			} else {
				match declaration(toks, i) {
					Ok(d) => d
					Err(_) => expression_statement(toks, i)
				}
			}
		_ => expression_statement(toks, i)
	}
}

expression_statement : List(CLex.Token), U64 -> Parsed(CParse.Stmt)
expression_statement = |toks, i| {
	e = expression(toks, i)?
	next = expect_punct(toks, e.next, ";")?
	Ok({ value: ExprStmt(e.value), next })
}

## The cases of a switch body, from after its `{` to its `}`.
switch_cases : List(CLex.Token), U64 -> Parsed(List({ labels : List(CParse.Expr), is_default : Bool, body : List(CParse.Stmt) }))
switch_cases = |toks, from| {
	var $i = from
	var $cases = []
	var $labels = []
	var $is_default = Bool.False
	var $body = []
	var $in_body = Bool.False
	while tok_at(toks, $i) != Punct("}") {
		t = tok_at(toks, $i)
		if t == End {
			return fail(toks, $i, "unclosed switch")
		}
		if t == Ident("case") or t == Ident("default") {
			if $in_body {
				$cases = $cases.append({ labels: $labels, is_default: $is_default, body: $body })
				$labels = []
				$is_default = Bool.False
				$body = []
				$in_body = Bool.False
			}
			if t == Ident("default") {
				$is_default = Bool.True
				$i = expect_punct(toks, $i + 1, ":")?
			} else {
				label = conditional(toks, $i + 1)?
				$labels = $labels.append(label.value)
				$i = expect_punct(toks, label.next, ":")?
			}
		} else {
			s = stmt(toks, $i)?
			$body = $body.append(s.value)
			$in_body = Bool.True
			$i = s.next
		}
	}
	if $in_body or !$labels.is_empty() or $is_default {
		$cases = $cases.append({ labels: $labels, is_default: $is_default, body: $body })
	}
	Ok({ value: $cases, next: $i + 1 })
}

## Comma-separated assignments from `from` up to `close`.
arguments : List(CLex.Token), U64, U64 -> Try(List(CParse.Expr), Str)
arguments = |toks, from, close| {
	if from >= close {
		return Ok([])
	}
	var $i = from
	var $out = []
	var $going = Bool.True
	while $going {
		a = assignment(toks, $i)?
		$out = $out.append(a.value)
		if tok_at(toks, a.next) == Punct(",") {
			$i = a.next + 1
		} else {
			$going = Bool.False
			if a.next != close {
				return fail(toks, a.next, "expected , or )")
			}
		}
	}
	Ok($out)
}

## A full expression, with the comma operator.
expression : List(CLex.Token), U64 -> Parsed(CParse.Expr)
expression = |toks, i| {
	first = assignment(toks, i)?
	if tok_at(toks, first.next) == Punct(",") {
		var $items = [first.value]
		var $j = first.next
		while tok_at(toks, $j) == Punct(",") {
			a = assignment(toks, $j + 1)?
			$items = $items.append(a.value)
			$j = a.next
		}
		Ok({ value: Comma($items), next: $j })
	} else {
		Ok(first)
	}
}

assign_ops : List(Str)
assign_ops = ["=", "+=", "-=", "*=", "/=", "%=", "&=", "|=", "^=", "<<=", ">>="]

assignment : List(CLex.Token), U64 -> Parsed(CParse.Expr)
assignment = |toks, i| {
	left = conditional(toks, i)?
	match tok_at(toks, left.next) {
		Punct(op) =>
			if assign_ops.contains(op) {
				right = assignment(toks, left.next + 1)?
				Ok({ value: Assign(op, left.value, right.value), next: right.next })
			} else {
				Ok(left)
			}
		_ => Ok(left)
	}
}

conditional : List(CLex.Token), U64 -> Parsed(CParse.Expr)
conditional = |toks, i| {
	c = binary(toks, i, 1)?
	if tok_at(toks, c.next) == Punct("?") {
		a = expression(toks, c.next + 1)?
		after_colon = expect_punct(toks, a.next, ":")?
		b = conditional(toks, after_colon)?
		Ok({ value: Cond(c.value, a.value, b.value), next: b.next })
	} else {
		Ok(c)
	}
}

## The precedence of a binary operator, 0 for none.
precedence : CLex.Tok -> U64
precedence = |t|
	match t {
		Punct("||") => 1
		Punct("&&") => 2
		Punct("|") => 3
		Punct("^") => 4
		Punct("&") => 5
		Punct("==") | Punct("!=") => 6
		Punct("<") | Punct(">") | Punct("<=") | Punct(">=") => 7
		Punct("<<") | Punct(">>") => 8
		Punct("+") | Punct("-") => 9
		Punct("*") | Punct("/") | Punct("%") => 10
		_ => 0
	}

binary : List(CLex.Token), U64, U64 -> Parsed(CParse.Expr)
binary = |toks, i, min| {
	first = unary(toks, i)?
	var $left = first.value
	var $j = first.next
	var $going = Bool.True
	while $going {
		t = tok_at(toks, $j)
		p = precedence(t)
		if p >= min and p > 0 {
			right = binary(toks, $j + 1, p + 1)?
			$left = Binary(describe(t), $left, right.value)
			$j = right.next
		} else {
			$going = Bool.False
		}
	}
	Ok({ value: $left, next: $j })
}

unary : List(CLex.Token), U64 -> Parsed(CParse.Expr)
unary = |toks, i| {
	t = tok_at(toks, i)
	match t {
		Punct(op) =>
			if op == "!" or op == "-" or op == "+" or op == "~" or op == "*" or op == "&" or op == "++" or op == "--" {
				operand = unary(toks, i + 1)?
				Ok({ value: Prefix(op, operand.value), next: operand.next })
			} else if op == "(" {
				match cast_type(toks, i) {
					Ok(c) => {
						operand = unary(toks, c.next)?
						Ok({ value: Cast(c.text, operand.value), next: operand.next })
					}
					Err(_) => postfix(toks, i)
				}
			} else {
				postfix(toks, i)
			}
		Ident("sizeof") =>
			if tok_at(toks, i + 1) == Punct("(") {
				close = matching(toks, i + 1)
				var $words = []
				var $k = i + 2
				while $k < close {
					$words = $words.append(describe(tok_at(toks, $k)))
					$k = $k + 1
				}
				Ok({ value: SizeOf(Str.join_with($words, " ")), next: close + 1 })
			} else {
				operand = unary(toks, i + 1)?
				Ok({ value: SizeOf("expr"), next: operand.next })
			}
		_ => postfix(toks, i)
	}
}

## `(type)` at `i` when it is a cast: a type that has a `*` or is a known
## scalar type, and a closing `)` right after.
cast_type : List(CLex.Token), U64 -> Try({ text : Str, next : U64 }, [NotCast])
cast_type = |toks, i| {
	ty = type_at(toks, i + 1) ? |_| NotCast
	if tok_at(toks, ty.next) != Punct(")") {
		return Err(NotCast)
	}
	# `(Name) x`: nothing but a cast has a value right after a bracketed name.
	next = tok_at(toks, ty.next + 1)
	value_follows =
		match next {
			Ident(_) | Num(_) | StrLit(_) | CharLit(_) => Bool.True
			Punct(p) => p == "("
			End => Bool.False
		}
	if ty.stars > 0 or scalar_types.contains(ty.main) or value_follows {
		Ok({ text: ty.text, next: ty.next + 1 })
	} else {
		Err(NotCast)
	}
}

postfix : List(CLex.Token), U64 -> Parsed(CParse.Expr)
postfix = |toks, i| {
	first = primary(toks, i)?
	var $e = first.value
	var $j = first.next
	var $going = Bool.True
	while $going {
		t = tok_at(toks, $j)
		if t == Punct("(") {
			close = matching(toks, $j)
			args = arguments(toks, $j + 1, close)?
			$e = Call($e, args)
			$j = close + 1
		} else if t == Punct("[") {
			idx = expression(toks, $j + 1)?
			after = expect_punct(toks, idx.next, "]")?
			$e = Index($e, idx.value)
			$j = after
		} else if t == Punct("->") or t == Punct(".") {
			$e = Field($e, ident_name(tok_at(toks, $j + 1)))
			$j = $j + 2
		} else if t == Punct("++") or t == Punct("--") {
			$e = Postfix(describe(t), $e)
			$j = $j + 1
		} else {
			$going = Bool.False
		}
	}
	Ok({ value: $e, next: $j })
}

primary : List(CLex.Token), U64 -> Parsed(CParse.Expr)
primary = |toks, i| {
	t = tok_at(toks, i)
	match t {
		Ident(name) => Ok({ value: Ident(name), next: i + 1 })
		Num(n) => Ok({ value: Num(n), next: i + 1 })
		CharLit(c) => Ok({ value: CharLit(c), next: i + 1 })
		StrLit(first) => {
			# Adjacent literals are one string.
			var $bytes = first
			var $j = i + 1
			var $going = Bool.True
			while $going {
				match tok_at(toks, $j) {
					StrLit(more) => {
						$bytes = $bytes.concat(more)
						$j = $j + 1
					}
					_ => {
						$going = Bool.False
					}
				}
			}
			Ok({ value: StrLit($bytes), next: $j })
		}
		Punct("(") => {
			inner = expression(toks, i + 1)?
			next = expect_punct(toks, inner.next, ")")?
			Ok({ value: inner.value, next })
		}
		_ => fail(toks, i, "expected an expression")
	}
}

## An expression as an S-expression, for looking at what was parsed.
show_expr : CParse.Expr -> Str
show_expr = |e|
	match e {
		Ident(n) => n
		Num(n) => n
		StrLit(b) => "\"${Str.from_utf8_lossy(b)}\""
		CharLit(c) => "'${Str.from_utf8_lossy([c])}'"
		Call(f, args) => "(call ${show_expr(f)}${show_list(args)})"
		Field(x, name) => "(. ${show_expr(x)} ${name})"
		Index(x, i) => "(index ${show_expr(x)} ${show_expr(i)})"
		Prefix(op, x) => "(${op} ${show_expr(x)})"
		Postfix(op, x) => "(post${op} ${show_expr(x)})"
		Binary(op, a, b) => "(${op} ${show_expr(a)} ${show_expr(b)})"
		Assign(op, a, b) => "(${op} ${show_expr(a)} ${show_expr(b)})"
		Cond(c, a, b) => "(? ${show_expr(c)} ${show_expr(a)} ${show_expr(b)})"
		Cast(t, x) => "(cast [${t}] ${show_expr(x)})"
		SizeOf(t) => "(sizeof ${t})"
		Comma(items) => "(,${show_list(items)})"
	}

show_list : List(CParse.Expr) -> Str
show_list = |items| items.fold("", |acc, x| "${acc} ${show_expr(x)}")

## A statement as an S-expression.
show_stmt : CParse.Stmt -> Str
show_stmt = |s|
	match s {
		Block(items) => "{${items.fold("", |acc, x| "${acc} ${show_stmt(x)}")} }"
		Decl(t, names) => "(decl [${t}]${names.fold("", |acc, d| "${acc} ${d.name}${match d.init { Ok(x) => "=${show_expr(x)}" Err(_) => "" }}")})"
		ExprStmt(x) => show_expr(x)
		If(c, a, b) => "(if ${show_expr(c)} ${show_stmt(a)}${match b { Ok(x) => " else ${show_stmt(x)}" Err(_) => "" }})"
		While(c, b) => "(while ${show_expr(c)} ${show_stmt(b)})"
		DoWhile(b, c) => "(do ${show_stmt(b)} ${show_expr(c)})"
		For(i, c, st, b) => "(for ${show_stmt(i)} ${match c { Ok(x) => show_expr(x) Err(_) => "-" }} ${match st { Ok(x) => show_expr(x) Err(_) => "-" }} ${show_stmt(b)})"
		Foreach(name, args, b) => "(${name}${show_list(args)} ${show_stmt(b)})"
		Switch(x, cases) => "(switch ${show_expr(x)}${cases.fold("", |acc, c| "${acc} (case${show_list(c.labels)}${if c.is_default " default" else ""}${c.body.fold("", |a2, st| "${a2} ${show_stmt(st)}")})")})"
		Return(r) => "(return${match r { Ok(x) => " ${show_expr(x)}" Err(_) => "" }})"
		Break => "break"
		Continue => "continue"
		Empty => ";"
	}
