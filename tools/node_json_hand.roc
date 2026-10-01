## The part of `tests/NodeJson.roc` written by hand: how each kind of field
## is written. A field that libpg_query leaves out comes back empty, and
## [fields] drops it. `tools/actions.roc` appends this to the generated
## writers.

stmts_json : List(Node) -> Str
stmts_json = |raw| {
	items = raw.map(|s| braced(body(s)))
	"[${Str.join_with(items, ",")}]"
}

braced : Str -> Str
braced = |text| "{${text}}"

fields : List(Str) -> Str
fields = |parts| Str.join_with(parts.keep_if(|p| !p.is_empty()), ",")

## NULL, which is also what an empty list is in C.
is_nothing : Node -> Bool
is_nothing = |n|
	match n {
		Null => Bool.True
		NodeList(items) => items.is_empty()
		_ => Bool.False
	}

elements : List(Node) -> Str
elements = |items| {
	parts = items.map(|x| if is_nothing(x) "{}" else node_json(x))
	"[${Str.join_with(parts, ",")}]"
}

int_field : Str, I64 -> Str
int_field = |key, v| if v != 0 "\"${key}\":${v.to_str()}" else ""

uint_field : Str, I64 -> Str
uint_field = |key, v| {
	unsigned = if v < 0 v + 4294967296 else v
	if v != 0 "\"${key}\":${unsigned.to_str()}" else ""
}

char_field : Str, I64 -> Str
char_field = |key, v| {
	c = Str.from_utf8_lossy([v.to_u8_wrap()])
	if v != 0 "\"${key}\":\"${c}\"" else ""
}

bool_field : Str, Bool -> Str
bool_field = |key, v| if v "\"${key}\":true" else ""

enum_field : Str, Str -> Str
enum_field = |key, name| "\"${key}\":\"${name}\""

text_field : Str, Node.Text -> Str
text_field = |key, t|
	match t {
		Ok(s) => if s.is_empty() "" else "\"${key}\":${token(t)}"
		Err(Null) => ""
	}

list_field : Str, List(Node) -> Str
list_field = |key, items| if items.is_empty() "" else "\"${key}\":${elements(items)}"

node_field : Str, Node -> Str
node_field = |key, n| if is_nothing(n) "" else "\"${key}\":${node_json(n)}"

specific_ptr_field : Str, Node -> Str
specific_ptr_field = |key, n| if is_nothing(n) "" else "\"${key}\":{${body(n)}}"

specific_field : Str, Node -> Str
specific_field = |key, n| "\"${key}\":{${body(n)}}"

## The value of an `A_Const` that is not NULL.
a_const_value : Node -> Str
a_const_value = |v|
	match v {
		Integer(x) => "\"ival\":{${json_integer(x)}}"
		Float(x) => "\"fval\":{${json_float(x)}}"
		Boolean(x) => {
			inner = if x.boolval "\"boolval\":true" else ""
			"\"boolval\":{${inner}}"
		}
		String(x) => "\"sval\":{${json_string(x)}}"
		BitString(x) => "\"bsval\":{${json_bit_string(x)}}"
		_ => "\"val\":<${Node.tag(v)}>"
	}

## A string as JSON, escaped as libpg_query's `_outToken` does, which
## also escapes `<` and `>`.
token : Node.Text -> Str
token = |t|
	match t {
		Err(Null) => "null"
		Ok(s) => {
			var $out = ['"']
			for b in s.to_utf8() {
				$out =
					if b == 8 {
						$out.concat(['\\', 'b'])
					} else if b == 12 {
						$out.concat(['\\', 'f'])
					} else if b == '\n' {
						$out.concat(['\\', 'n'])
					} else if b == '\r' {
						$out.concat(['\\', 'r'])
					} else if b == '\t' {
						$out.concat(['\\', 't'])
					} else if b == '"' {
						$out.concat(['\\', '"'])
					} else if b == '\\' {
						$out.concat(['\\', '\\'])
					} else if b < ' ' or b == '<' or b == '>' {
						$out.concat(['\\', 'u', '0', '0', hex(b // 16), hex(b % 16)])
					} else {
						$out.append(b)
					}
			}
			Str.from_utf8_lossy($out.append('"'))
		}
	}

hex : U8 -> U8
hex = |d| if d < 10 '0' + d else 'a' + d - 10

## libpg_query's name for a `SelectStmt`'s `limitOption`: its own
## `LIMIT_OPTION_DEFAULT` when there is no limit clause, which is when
## there is neither a count nor an offset.
limit_option : Node.SelectStmt -> Str
limit_option = |r|
	if r.limit_option == 0 and is_nothing(r.limit_count) and is_nothing(r.limit_offset) {
		"LIMIT_OPTION_DEFAULT"
	} else {
		enum_limit_option(r.limit_option)
	}
