## The struct and union definitions in Postgres's node headers, both
## `typedef struct Name { ... } Name;` and `struct Name { ... };`: each
## field's name, C type and `pg_node_attr(...)` annotation words. The
## `NodeTag type` and `Expr xpr` headers that only say which node it is are
## dropped.
import CLex

Structs :: [].{
	## A field: its name, its C type, and the words of its `pg_node_attr`.
	Field : { name : Str, type : Str, attrs : List(Str) }

	Struct : { name : Str, fields : List(Structs.Field), is_union : Bool }

	collect : List(Str) -> List(Structs.Struct)
	collect = |sources| sources.fold([], |acc, source| acc.concat(structs_of(CLex.tokens(source))))
}

tok_at : List(CLex.Token), U64 -> CLex.Tok
tok_at = |toks, i| (toks.get(i) ?? { tok: End, line: 0 }).tok

text_of : CLex.Tok -> Str
text_of = |t|
	match t {
		Ident(n) => n
		Num(n) => n
		Punct(p) => p
		StrLit(_) => "\"\""
		CharLit(_) => "''"
		End => ""
	}

## The index of the bracket that closes the one at `open`.
closing : List(CLex.Token), U64 -> U64
closing = |toks, open| {
	var $depth = 0
	var $i = open
	var $done = Bool.False
	while !$done {
		t = tok_at(toks, $i)
		if t == End {
			$done = Bool.True
		} else {
			if t == Punct("{") or t == Punct("(") or t == Punct("[") {
				$depth = $depth + 1
			} else if t == Punct("}") or t == Punct(")") or t == Punct("]") {
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

structs_of : List(CLex.Token) -> List(Structs.Struct)
structs_of = |toks| {
	var $out = []
	var $i = 0
	var $depth = 0
	while tok_at(toks, $i) != End {
		t = tok_at(toks, $i)
		if t == Punct("{") {
			$depth = $depth + 1
			$i = $i + 1
		} else if t == Punct("}") {
			$depth = $depth - 1
			$i = $i + 1
		} else if $depth == 0 and (t == Ident("struct") or t == Ident("union")) {
			is_union = t == Ident("union")
			tag_name =
				match tok_at(toks, $i + 1) {
					Ident(n) => n
					_ => ""
				}
			brace = if tag_name.is_empty() $i + 1 else $i + 2
			if tok_at(toks, brace) == Punct("{") {
				close = closing(toks, brace)
				body = toks.sublist({ start: brace + 1, len: close - brace - 1 })
				after =
					match tok_at(toks, close + 1) {
						Ident(n) => n
						_ => ""
					}
				name = if after.is_empty() tag_name else after
				fields = declarations(body).fold([], |acc, decl| acc.concat(fields_of(decl)))
				if !name.is_empty() {
					$out = $out.append({ name, fields, is_union })
				}
				$i = close + 1
			} else {
				$i = $i + 1
			}
		} else {
			$i = $i + 1
		}
	}
	$out
}

## The body's declarations, split at `;`, as text, with the words of their
## `pg_node_attr(...)` annotations apart.
declarations : List(CLex.Token) -> List({ text : Str, attrs : List(Str) })
declarations = |body| {
	var $out = []
	var $cur = []
	var $attrs = []
	var $i = 0
	while $i < body.len() {
		t = tok_at(body, $i)
		if t == Ident("pg_node_attr") and tok_at(body, $i + 1) == Punct("(") {
			close = closing(body, $i + 1)
			words = body.sublist({ start: $i + 2, len: close - $i - 2 }).keep_oks(
				|tok|
					match tok.tok {
						Ident(n) => Ok(n)
						_ => Err(NotWord)
					},
			)
			$attrs = $attrs.concat(words)
			$i = close + 1
		} else if t == Punct(";") {
			$out = $out.append({ text: Str.join_with($cur, " "), attrs: $attrs })
			$cur = []
			$attrs = []
			$i = $i + 1
		} else if t == Punct("{") {
			# A nested struct or union: its fields are not ours.
			$i = closing(body, $i) + 1
		} else {
			$cur = $cur.append(text_of(t))
			$i = $i + 1
		}
	}
	$out
}

## The fields of one declaration, such as `char * a , * b` or `List * args`.
fields_of : { text : Str, attrs : List(Str) } -> List(Structs.Field)
fields_of = |decl| {
	words = decl.text.split_on(" ").keep_if(|w| !w.is_empty())
	# The type runs up to the first `*`, or up to the last word before the
	# first `,`, or up to the last word.
	first_star = words.find_first_index(|w| w == "*") ?? words.len()
	first_comma = words.find_first_index(|w| w == ",") ?? words.len()
	type_end = if first_star < first_comma first_star else if first_comma < words.len() first_comma - 1 else words.len() - 1
	type_words = words.take_first(type_end).keep_if(|w| w != "const" and w != "struct" and w != "union" and w != "volatile")
	base = Str.join_with(type_words, " ")
	declarators = split_commas(words.drop_first(type_end))
	declarators.fold(
		[],
		|acc, d| {
			stars = d.keep_if(|w| w == "*").len()
			name = d.find_first(|w| w != "*") ?? ""
			type = if stars > 0 "${base} ${Str.repeat("*", stars)}" else base
			if name.is_empty() or base.is_empty() or (name == "type" and base == "NodeTag") or (name == "xpr" and base == "Expr") {
				acc
			} else {
				acc.append({ name, type, attrs: decl.attrs })
			}
		},
	)
}

## Words split at `,`, dropping array bounds such as `[ 4 ]`.
split_commas : List(Str) -> List(List(Str))
split_commas = |words| {
	var $out = []
	var $cur = []
	var $in_bounds = Bool.False
	for w in words {
		if w == "[" {
			$in_bounds = Bool.True
		} else if w == "]" {
			$in_bounds = Bool.False
		} else if !$in_bounds {
			if w == "," {
				$out = $out.append($cur)
				$cur = []
			} else {
				$cur = $cur.append(w)
			}
		}
	}
	$out.append($cur)
}
