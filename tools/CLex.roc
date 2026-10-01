## A lexer for the C that Postgres's grammar actions and parser helpers are
## written in. Comments and preprocessor lines are dropped. Adjacent string
## literals are left apart; the parser joins them.
CLex :: [].{
	Tok : [Ident(Str), Num(Str), StrLit(List(U8)), CharLit(U8), Punct(Str), End]

	Token : { tok : CLex.Tok, line : U64 }

	tokens : Str -> List(CLex.Token)
	tokens = |source| {
		bytes = source.to_utf8()
		len = bytes.len()
		var $i = 0
		var $line = 1
		var $out = []
		var $line_start = Bool.True
		while $i < len {
			b = at(bytes, $i)
			next = at(bytes, $i + 1)
			if b == '\n' {
				$line = $line + 1
				$line_start = Bool.True
				$i = $i + 1
			} else if b == ' ' or b == '\t' or b == '\r' or b == 12 or b == 11 {
				$i = $i + 1
			} else if b == '#' and $line_start {
				# A preprocessor line, with its backslash continuations.
				var $j = $i
				while $j < len and !(at(bytes, $j) == '\n' and at(bytes, $j - 1) != '\\') {
					if at(bytes, $j) == '\n' {
						$line = $line + 1
					}
					$j = $j + 1
				}
				$i = $j
			} else if b == '/' and next == '*' {
				var $j = $i + 2
				while $j < len and !(at(bytes, $j) == '*' and at(bytes, $j + 1) == '/') {
					if at(bytes, $j) == '\n' {
						$line = $line + 1
					}
					$j = $j + 1
				}
				$i = $j + 2
			} else if b == '/' and next == '/' {
				var $j = $i
				while $j < len and at(bytes, $j) != '\n' {
					$j = $j + 1
				}
				$i = $j
			} else {
				$line_start = Bool.False
				if is_ident_start(b) {
					end = run_end(bytes, $i, is_ident_char)
					$out = $out.append({ tok: Ident(text(bytes, $i, end)), line: $line })
					$i = end
				} else if is_digit(b) or (b == '.' and is_digit(next)) {
					end = run_end(bytes, $i, |c| is_ident_char(c) or c == '.')
					$out = $out.append({ tok: Num(text(bytes, $i, end)), line: $line })
					$i = end
				} else if b == '"' {
					lit = quoted(bytes, $i + 1, '"')
					$out = $out.append({ tok: StrLit(lit.value), line: $line })
					$i = lit.next
				} else if b == '\'' {
					lit = quoted(bytes, $i + 1, '\'')
					$out = $out.append({ tok: CharLit(lit.value.get(0) ?? 0), line: $line })
					$i = lit.next
				} else {
					p = punct(bytes, $i)
					$out = $out.append({ tok: Punct(p), line: $line })
					$i = $i + p.to_utf8().len()
				}
			}
		}
		$out.append({ tok: End, line: $line })
	}
}

## The longest operator at `i`.
punct : List(U8), U64 -> Str
punct = |bytes, i| {
	three = text(bytes, i, i + 3)
	two = text(bytes, i, i + 2)
	if three == "<<=" or three == ">>=" or three == "..." {
		three
	} else if two == "->" or two == "++" or two == "--" or two == "<<" or two == ">>" or two == "<=" or two == ">=" or two == "==" or two == "!=" or two == "&&" or two == "||" or two == "+=" or two == "-=" or two == "*=" or two == "/=" or two == "%=" or two == "&=" or two == "|=" or two == "^=" {
		two
	} else {
		text(bytes, i, i + 1)
	}
}

## A string or character literal after its opening quote, escapes applied.
quoted : List(U8), U64, U8 -> { value : List(U8), next : U64 }
quoted = |bytes, start, close| {
	var $j = start
	var $value = []
	while $j < bytes.len() and at(bytes, $j) != close {
		c = at(bytes, $j)
		if c == '\\' {
			e = at(bytes, $j + 1)
			if e >= '0' and e <= '7' {
				n = run_len(bytes, $j + 1, 3, |d| d >= '0' and d <= '7')
				v = bytes.sublist({ start: $j + 1, len: n }).fold(0.U64, |acc, d| acc * 8 + (d - '0').to_u64())
				$value = $value.append((v % 256).to_u8_wrap())
				$j = $j + 1 + n
			} else if e == 'x' {
				n = run_len(bytes, $j + 2, 2, is_hex)
				v = bytes.sublist({ start: $j + 2, len: n }).fold(0.U64, |acc, d| acc * 16 + hex_digit(d))
				$value = $value.append((v % 256).to_u8_wrap())
				$j = $j + 2 + n
			} else {
				v =
					match e {
						'n' => '\n'
						't' => '\t'
						'r' => '\r'
						'b' => 8
						'f' => 12
						'v' => 11
						'a' => 7
						_ => e
					}
				$value = $value.append(v)
				$j = $j + 2
			}
		} else {
			$value = $value.append(c)
			$j = $j + 1
		}
	}
	{ value: $value, next: $j + 1 }
}

hex_digit : U8 -> U64
hex_digit = |c|
	if c >= '0' and c <= '9' {
		(c - '0').to_u64()
	} else if c >= 'a' and c <= 'f' {
		(c - 'a').to_u64() + 10
	} else {
		(c - 'A').to_u64() + 10
	}

is_hex : U8 -> Bool
is_hex = |c| (c >= '0' and c <= '9') or (c >= 'a' and c <= 'f') or (c >= 'A' and c <= 'F')

is_digit : U8 -> Bool
is_digit = |c| c >= '0' and c <= '9'

is_ident_start : U8 -> Bool
is_ident_start = |c| (c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or c == '_' or c == '$'

is_ident_char : U8 -> Bool
is_ident_char = |c| is_ident_start(c) or is_digit(c)

run_len : List(U8), U64, U64, (U8 -> Bool) -> U64
run_len = |bytes, p, max, pred| {
	var $n = 0
	while $n < max and p + $n < bytes.len() and pred(at(bytes, p + $n)) {
		$n = $n + 1
	}
	$n
}

run_end : List(U8), U64, (U8 -> Bool) -> U64
run_end = |bytes, p, pred| p + run_len(bytes, p, bytes.len(), pred)

at : List(U8), U64 -> U8
at = |bytes, i| bytes.get(i) ?? 0

text : List(U8), U64, U64 -> Str
text = |bytes, start, end| Str.from_utf8_lossy(bytes.sublist({ start, len: end - start }))
