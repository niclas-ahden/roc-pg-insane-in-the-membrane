## Encoders for the messages the client sends to the Postgres server.
## https://www.postgresql.org/docs/current/protocol-message-formats.html
import Bytes
import md5.Md5

ProtoFrontend :: [].{
	FormatCode : [Text, Binary]

	## `params` are extra run-time parameters for the session, such as
	## `("application_name", "my_app")`. The server treats them as the
	## session defaults, so they are what `reset all` goes back to.
	##
	## They go first and the package's own keys last. The server keeps the
	## last value of a key, so `client_encoding`, `user` and `database`
	## always hold, whatever `params` holds.
	startup : { user : Str, database : Str, params : List((Str, Str)) } -> List(U8)
	startup = |{ user, database, params }|
		prepend_length(
			Bytes.sequence([
				# Protocol version 3.0
				Bytes.i16(3),
				Bytes.i16(0),
				Bytes.null_terminate(
					Bytes.sequence(
						params.map(|(key, value)| startup_param(key, value)).concat([
							startup_param("client_encoding", "UTF8"),
							startup_param("user", user),
							startup_param("database", database),
						]),
					),
				),
			]),
		)

	password_message : Str -> List(U8)
	password_message = |pwd| message('p', [Bytes.c_str(pwd)])

	## The answer to an md5 challenge: `md5` and the hex of
	## md5(hex(md5(password ++ user)) ++ salt), as Postgres computes it.
	md5_password_message : { user : Str, password : Str, salt : List(U8) } -> List(U8)
	md5_password_message = |{ user, password, salt }| {
		inner = Md5.hash(password.to_utf8().concat(user.to_utf8())).to_hex()
		outer = Md5.hash(inner.to_utf8().concat(salt)).to_hex()
		password_message("md5${outer}")
	}

	## The first SASL message: the chosen mechanism and the client-first
	## message.
	sasl_initial_response : { mechanism : Str, data : Str } -> List(U8)
	sasl_initial_response = |{ mechanism, data }| {
		bytes = data.to_utf8()
		message('p', [Bytes.c_str(mechanism), Bytes.i32(bytes.len().to_i32_wrap()), bytes])
	}

	## A later SASL message, like SCRAM's client-final message.
	sasl_response : Str -> List(U8)
	sasl_response = |data| message('p', [data.to_utf8()])

	terminate : List(U8)
	terminate = message('X', [])

	parse : { sql : Str, name : Str } -> List(U8)
	parse = |{ sql, name }|
		message(
			'P',
			[
				Bytes.c_str(name),
				Bytes.c_str(sql),
				# no pre-specified parameter type oids
				Bytes.i16(0),
			],
		)

	bind :
		{
			prepared_statement : Str,
			format_codes : List(FormatCode),
			param_values : List([Null, Value(List(U8))]),
		} -> List(U8)
	bind = |{ prepared_statement, format_codes, param_values }|
		message(
			'B',
			[
				# portal name (unnamed)
				Bytes.c_str(""),
				Bytes.c_str(prepared_statement),
				array(format_codes.map(|code| format_code(code))),
				array(
					param_values.map(
						|value|
							match value {
								Null => Bytes.i32(-1)
								Value(b) => length_prefixed(b)
							},
					),
				),
				# no column format codes: everything as text
				Bytes.i16(0),
			],
		)

	describe_portal : {} -> List(U8)
	describe_portal = |{}| message('D', [Bytes.u8('P'), Bytes.c_str("")])

	describe_statement : { name : Str } -> List(U8)
	describe_statement = |{ name }| message('D', [Bytes.u8('S'), Bytes.c_str(name)])

	## Close (deallocate) a named prepared statement. Closing a name that was
	## never prepared is not an error, which makes re-preparing idempotent.
	close_statement : { name : Str } -> List(U8)
	close_statement = |{ name }| message('C', [Bytes.u8('S'), Bytes.c_str(name)])

	## Run the unnamed portal to the end. The zero is the most rows to
	## return, which the protocol reads as no limit.
	execute : List(U8)
	execute = message('E', [Bytes.c_str(""), Bytes.i32(0)])

	sync : List(U8)
	sync = message('S', [])

	## A simple query: one message holding any number of `;` separated
	## statements, without bindings. The server answers each statement in
	## turn and ends with a single ReadyForQuery.
	query : Str -> List(U8)
	query = |sql| message('Q', [Bytes.c_str(sql)])
}

startup_param : Str, Str -> List(U8)
startup_param = |key, value|
	Bytes.sequence([Bytes.c_str(key), Bytes.c_str(value)])

format_code : [Text, Binary] -> List(U8)
format_code = |code|
	match code {
		Text => Bytes.i16(0)
		Binary => Bytes.i16(1)
	}

## An i16 count followed by the already-encoded items.
array : List(List(U8)) -> List(U8)
array = |encoded_items|
	Bytes.sequence([
		Bytes.i16(encoded_items.len().to_i16_wrap()),
		Bytes.sequence(encoded_items),
	])

length_prefixed : List(U8) -> List(U8)
length_prefixed = |value|
	Bytes.sequence([Bytes.i32(value.len().to_i32_wrap()), value])

message : U8, List(List(U8)) -> List(U8)
message = |msg_type, content|
	Bytes.sequence([Bytes.u8(msg_type), prepend_length(Bytes.sequence(content))])

prepend_length : List(U8) -> List(U8)
prepend_length = |msg|
	Bytes.i32((msg.len() + 4).to_i32_wrap()).concat(msg)

# 'S' plus a length of 4 (the length includes itself).
expect ProtoFrontend.sync == [83, 0, 0, 0, 4]
expect ProtoFrontend.terminate == [88, 0, 0, 0, 4]

# 'p', length, then the password as a c string.
expect ProtoFrontend.password_message("abc") == [112, 0, 0, 0, 8, 97, 98, 99, 0]

# md5 for user postgres, password secret and salt 1 2 3 4, as coreutils md5sum
# computes it: md5(md5("secretpostgres") hex ++ salt).
expect ProtoFrontend.md5_password_message({ user: "postgres", password: "secret", salt: [1, 2, 3, 4] }) == ProtoFrontend.password_message("md5bb41a296aab6baccb36ff243a562abff")

# The mechanism as a C string, the length of the data, then the data.
expect ProtoFrontend.sasl_initial_response({ mechanism: "M", data: "ab" }) == [112, 0, 0, 0, 12, 77, 0, 0, 0, 0, 2, 97, 98]
expect ProtoFrontend.sasl_response("ab") == [112, 0, 0, 0, 6, 97, 98]

# Startup: length, protocol 3.0, then null-terminated key/value params.
expect
	ProtoFrontend.startup({ user: "u", database: "d", params: [] })
		== Bytes.sequence([
			[0, 0, 0, 48, 0, 3, 0, 0],
			Bytes.c_str("client_encoding"),
			Bytes.c_str("UTF8"),
			Bytes.c_str("user"),
			Bytes.c_str("u"),
			Bytes.c_str("database"),
			Bytes.c_str("d"),
			[0],
		])

# 'Q', the length (itself plus the c-string), then the sql and its terminator.
expect ProtoFrontend.query("ab") == [81, 0, 0, 0, 7, 97, 98, 0]

# Extra startup parameters go right after the protocol version, and the
# package's own keys last, so that they win over a key of the same name.
expect {
	bare = ProtoFrontend.startup({ user: "u", database: "d", params: [] })
	extra = ProtoFrontend.startup({ user: "u", database: "d", params: [("user", "b")] })
	# "user\0b\0" is seven more bytes.
	extra.len() == bare.len() + 7 and extra.drop_first(8).starts_with(Bytes.c_str("user").concat(Bytes.c_str("b"))) and extra.ends_with(Bytes.c_str("user").concat(Bytes.c_str("u")).concat(Bytes.c_str("database")).concat(Bytes.c_str("d")).append(0))
}
