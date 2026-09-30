## Decoders for the messages the Postgres server sends to the client.
## Internal to the package: `Client` reads these and hands apps its own
## types (`Client.ServerError`, `Client.ProtoErr`, `Client.TransactionStatus`),
## which are the same records and unions as the ones here.
##
## Written in direct style: each decoder takes the (already length-framed)
## message payload and returns a decoded value, threading the remaining bytes
## explicitly. See Bytes.take_* helpers.
import Bytes

ProtoBackend :: [].{
	KeyData : { process_id : I32, secret_key : I32 }

	Status : [Idle, TransactionBlock, FailedTransactionBlock]

	## A result column: its name, and the oid of its type.
	Column : { name : Str, type_oid : I32 }

	Error : {
		severity : Str,
		localized_severity : Str,
		code : Str,
		message : Str,
		detail : [NoField, Field(Str)],
		hint : [NoField, Field(Str)],
		position : [NoField, Field(Str)],
		ewhere : [NoField, Field(Str)],
		schema_name : [NoField, Field(Str)],
		table_name : [NoField, Field(Str)],
		column_name : [NoField, Field(Str)],
		data_type_name : [NoField, Field(Str)],
		constraint_name : [NoField, Field(Str)],
		file : [NoField, Field(Str)],
		line : [NoField, Field(Str)],
		routine : [NoField, Field(Str)],
	}

	## The ways a reply can fail to decode or fail to fit the conversation
	## (`UnexpectedMsg`, raised by `Client`). The payload of `PgProtoErr`.
	ProtoErr : [BadUtf8, InvalidMessageLength(I32), TerminatorNotFound, UnexpectedEnd, UnexpectedMsg(Str), UnrecognizedBackendMessage(U8), UnrecognizedBackendStatus(U8)]

	Message : [
		AuthOk,
		AuthCleartextPassword,
		AuthMd5Password(List(U8)),
		AuthSasl(List(Str)),
		AuthSaslContinue(List(U8)),
		AuthSaslFinal(List(U8)),
		AuthUnsupported(I32),
		ParameterStatus({ name : Str, value : Str }),
		BackendKeyData(KeyData),
		ReadyForQuery(Status),
		ErrorResponse(ProtoBackend.Error),
		NoticeResponse,
		ParseComplete,
		BindComplete,
		NoData,
		## The result columns. Every column arrives in text format, so the
		## rest of what the server sends about them goes unused.
		RowDescription(List(Column)),
		ParameterDescription,
		DataRow(List([Null, Present(List(U8))])),
		CommandComplete(Str),
		EmptyQueryResponse,
		CloseComplete,
	]

	## Parse the 5-byte message header: tag byte plus payload length.
	header : List(U8) -> Try({ msg_type : U8, len : U64 }, ProtoBackend.ProtoErr)
	header = |bytes| {
		{ val: msg_type, rest } = Bytes.take_u8(bytes)?
		{ val: len, rest: _ } = Bytes.take_i32(rest)?
		# The length includes its own four bytes, so anything smaller is
		# corrupt and would otherwise underflow into a huge read.
		if len < 4 {
			Err(InvalidMessageLength(len))
		} else {
			Ok({ msg_type, len: (len - 4).to_u64_wrap() })
		}
	}

	## Parse a message payload given its header tag byte.
	message : U8, List(U8) -> Try(ProtoBackend.Message, ProtoBackend.ProtoErr)
	message = |msg_type, payload|
		match msg_type {
			'R' => auth_request(payload)
			'S' => param_status(payload)
			'K' => backend_key_data(payload)
			'Z' => ready_for_query(payload)
			'E' => error_response(payload)
			'1' => Ok(ParseComplete)
			'2' => Ok(BindComplete)
			'N' => Ok(NoticeResponse)
			'n' => Ok(NoData)
			'T' => row_description(payload)
			't' => Ok(ParameterDescription)
			'D' => data_row(payload)
			'C' => command_complete(payload)
			'I' => Ok(EmptyQueryResponse)
			'3' => Ok(CloseComplete)
			other => Err(UnrecognizedBackendMessage(other))
		}
}

auth_request : List(U8) -> Try(ProtoBackend.Message, ProtoBackend.ProtoErr)
auth_request = |payload| {
	{ val: auth_type, rest } = Bytes.take_i32(payload)?
	match auth_type {
		0 => Ok(AuthOk)
		3 => Ok(AuthCleartextPassword)
		5 =>
			# The four-byte salt of the md5 challenge.
			if rest.len() == 4 Ok(AuthMd5Password(rest)) else Err(UnexpectedEnd)
		10 => Ok(AuthSasl(sasl_mechanisms(rest, [])?))
		11 => Ok(AuthSaslContinue(rest))
		12 => Ok(AuthSaslFinal(rest))
		# Carry the code so an auth type this client does not speak is
		# named in the resulting UnsupportedAuth error.
		other => Ok(AuthUnsupported(other))
	}
}

## The SASL mechanisms a server offers: C strings, ended by an empty one.
sasl_mechanisms : List(U8), List(Str) -> Try(List(Str), ProtoBackend.ProtoErr)
sasl_mechanisms = |bytes, found|
	match bytes {
		[0, ..] => Ok(found)
		_ => {
			{ val, rest } = Bytes.take_c_str(bytes)?
			sasl_mechanisms(rest, found.append(val))
		}
	}

param_status : List(U8) -> Try(ProtoBackend.Message, ProtoBackend.ProtoErr)
param_status = |payload| {
	{ val: name, rest } = Bytes.take_c_str(payload)?
	{ val: value, rest: _ } = Bytes.take_c_str(rest)?
	Ok(ParameterStatus({ name, value }))
}

backend_key_data : List(U8) -> Try(ProtoBackend.Message, ProtoBackend.ProtoErr)
backend_key_data = |payload| {
	{ val: process_id, rest } = Bytes.take_i32(payload)?
	{ val: secret_key, rest: _ } = Bytes.take_i32(rest)?
	Ok(BackendKeyData({ process_id, secret_key }))
}

ready_for_query : List(U8) -> Try(ProtoBackend.Message, ProtoBackend.ProtoErr)
ready_for_query = |payload| {
	{ val: status, rest: _ } = Bytes.take_u8(payload)?
	match status {
		'I' => Ok(ReadyForQuery(Idle))
		'T' => Ok(ReadyForQuery(TransactionBlock))
		'E' => Ok(ReadyForQuery(FailedTransactionBlock))
		other => Err(UnrecognizedBackendStatus(other))
	}
}

## Error/notice fields arrive as (tag byte, c-string) pairs, terminated by 0.
read_str_fields : List(U8), List({ field_id : U8, value : Str }) -> Try(List({ field_id : U8, value : Str }), ProtoBackend.ProtoErr)
read_str_fields = |bytes, collected| {
	{ val: field_id, rest } = Bytes.take_u8(bytes)?
	if field_id == 0 {
		Ok(collected)
	} else {
		{ val: value, rest: rest2 } = Bytes.take_c_str(rest)?
		read_str_fields(rest2, collected.append({ field_id, value }))
	}
}

find_field : List({ field_id : U8, value : Str }), U8 -> [NoField, Field(Str)]
find_field = |fields, wanted|
	match fields.find_first(|f| f.field_id == wanted) {
		Ok(f) => Field(f.value)
		Err(_) => NoField
	}

error_response : List(U8) -> Try(ProtoBackend.Message, ProtoBackend.ProtoErr)
error_response = |payload| {
	fields = read_str_fields(payload, [])?

	localized_severity = 
		match find_field(fields, 'S') {
			Field(v) => v
			NoField => ""
		}
	# 'V' is the severity in English whatever lc_messages says, sent since
	# PostgreSQL 9.6. Older servers only send the localized one.
	severity =
		match find_field(fields, 'V') {
			Field(v) => v
			NoField => localized_severity
		}
	code = 
		match find_field(fields, 'C') {
			Field(v) => v
			NoField => ""
		}
	msg = 
		match find_field(fields, 'M') {
			Field(v) => v
			NoField => ""
		}

	Ok(
		ErrorResponse({
			severity,
			localized_severity,
			code,
			message: msg,
			detail: find_field(fields, 'D'),
			hint: find_field(fields, 'H'),
			position: find_field(fields, 'P'),
			ewhere: find_field(fields, 'W'),
			schema_name: find_field(fields, 's'),
			table_name: find_field(fields, 't'),
			column_name: find_field(fields, 'c'),
			data_type_name: find_field(fields, 'd'),
			constraint_name: find_field(fields, 'n'),
			file: find_field(fields, 'F'),
			line: find_field(fields, 'L'),
			routine: find_field(fields, 'R'),
		}),
	)
}

row_description : List(U8) -> Try(ProtoBackend.Message, ProtoBackend.ProtoErr)
row_description = |payload| {
	{ val: field_count, rest } = Bytes.take_i16(payload)?
	read_row_fields(rest, field_count.to_u64_wrap(), [])
}

read_row_fields : List(U8), U64, List(ProtoBackend.Column) -> Try(ProtoBackend.Message, ProtoBackend.ProtoErr)
read_row_fields = |bytes, remaining, collected|
	if remaining == 0 {
		Ok(RowDescription(collected))
	} else {
		{ val: name, rest: r1 } = Bytes.take_c_str(bytes)?
		# Unused: table oid (i32) and attribute number (i16) before the type
		# oid, type size (i16), type modifier (i32) and format code (i16) after.
		{ val: _, rest: r2 } = Bytes.take(r1, 6)?
		{ val: type_oid, rest: r3 } = Bytes.take_i32(r2)?
		{ val: _, rest: r4 } = Bytes.take(r3, 8)?
		read_row_fields(r4, remaining - 1, collected.append({ name, type_oid }))
	}

data_row : List(U8) -> Try(ProtoBackend.Message, ProtoBackend.ProtoErr)
data_row = |payload| {
	{ val: column_count, rest } = Bytes.take_i16(payload)?
	read_columns(rest, column_count.to_u64_wrap(), [])
}

read_columns : List(U8), U64, List([Null, Present(List(U8))]) -> Try(ProtoBackend.Message, ProtoBackend.ProtoErr)
read_columns = |bytes, remaining, collected|
	if remaining == 0 {
		Ok(DataRow(collected))
	} else {
		{ val: value_len, rest } = Bytes.take_i32(bytes)?
		# A negative length means the value is NULL
		if value_len < 0 {
			read_columns(rest, remaining - 1, collected.append(Null))
		} else {
			{ val: bytes_val, rest: rest2 } = Bytes.take(rest, value_len.to_u64_wrap())?
			read_columns(rest2, remaining - 1, collected.append(Present(bytes_val)))
		}
	}

command_complete : List(U8) -> Try(ProtoBackend.Message, ProtoBackend.ProtoErr)
command_complete = |payload| {
	{ val, rest: _ } = Bytes.take_c_str(payload)?
	Ok(CommandComplete(val))
}

# Header: tag byte plus i32 length, which includes itself but not the tag.
expect ProtoBackend.header([82, 0, 0, 0, 8]) == Ok({ msg_type: 82, len: 4 })
expect ProtoBackend.header([82, 0, 0, 0, 3]) == Err(InvalidMessageLength(3))

# 'R' with an auth type this client does not speak keeps the code around.
expect ProtoBackend.message('R', [0, 0, 0, 7]) == Ok(AuthUnsupported(7))

# md5 carries its four-byte salt, and a salt of another length is refused.
expect ProtoBackend.message('R', [0, 0, 0, 5, 1, 2, 3, 4]) == Ok(AuthMd5Password([1, 2, 3, 4]))
expect ProtoBackend.message('R', [0, 0, 0, 5, 1, 2, 3]) == Err(UnexpectedEnd)

# SASL lists its mechanisms as C strings ended by an empty one.
expect ProtoBackend.message('R', [0, 0, 0, 10].concat(Str.to_utf8("SCRAM-SHA-256-PLUS")).concat([0]).concat(Str.to_utf8("SCRAM-SHA-256")).concat([0, 0])) == Ok(AuthSasl(["SCRAM-SHA-256-PLUS", "SCRAM-SHA-256"]))
expect ProtoBackend.message('R', [0, 0, 0, 10, 0]) == Ok(AuthSasl([]))
expect ProtoBackend.message('R', [0, 0, 0, 10, 65, 66]) == Err(TerminatorNotFound)
expect ProtoBackend.message('R', [0, 0, 0, 11, 114, 61]) == Ok(AuthSaslContinue([114, 61]))
expect ProtoBackend.message('R', [0, 0, 0, 12, 118, 61]) == Ok(AuthSaslFinal([118, 61]))

# 'Z' payloads carry the transaction status.
expect ProtoBackend.message('Z', ['I']) == Ok(ReadyForQuery(Idle))
expect ProtoBackend.message('Z', ['E']) == Ok(ReadyForQuery(FailedTransactionBlock))

# 'K' carries the backend key as two big-endian i32s.
expect ProtoBackend.message('K', [0, 0, 0, 5, 0, 0, 0, 9]) == Ok(BackendKeyData({ process_id: 5, secret_key: 9 }))

# 'D' carries column values with i32 lengths, -1 meaning NULL.
expect
	ProtoBackend.message('D', [0, 2, 255, 255, 255, 255, 0, 0, 0, 2, 104, 105])
		== Ok(DataRow([Null, Present([104, 105])]))

# 'T' carries each column's name, then 18 bytes of details, of which bytes
# 6 to 9 are the type oid.
column_bytes = |name, oid| Str.to_utf8(name).concat([0, 9, 9, 9, 9, 9, 9]).concat(Bytes.i32(oid)).concat(List.repeat(9, 8))

expect
	ProtoBackend.message('T', [0, 2].concat(column_bytes("a", 23)).concat(column_bytes("b", 25)))
		== Ok(RowDescription([{ name: "a", type_oid: 23 }, { name: "b", type_oid: 25 }]))

# 'E' reads the English severity from 'V', and falls back to the localized
# one from 'S' for a server older than 9.6.
severity_of = |fields|
	match ProtoBackend.message('E', fields.concat([0])) {
		Ok(ErrorResponse(error)) => error.severity
		_ => "not an error"
	}

expect severity_of(Str.to_utf8("SFATAL").concat([0]).concat(Str.to_utf8("VFATAL")).concat([0])) == "FATAL"
expect severity_of(Str.to_utf8("SSCHWER").concat([0]).concat(Str.to_utf8("VFATAL")).concat([0])) == "FATAL"
expect severity_of(Str.to_utf8("SERROR").concat([0])) == "ERROR"
