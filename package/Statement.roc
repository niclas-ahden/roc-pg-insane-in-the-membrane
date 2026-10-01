## A SQL command to run: the SQL (or a prepared statement) plus its `$n`
## parameters.
##
## ```
## stmt = Statement.new_unchecked("select * from users where id = $1").bind([Param.u64(user_id)])
## result = client.command!(stmt)?
## ```
##
## A `Statement` carries no decode function. Decode the [PgResult] with
## `PgResult.decode` after running it. `client.query_unchecked!` does both.
##
## Its SQL is not checked when you build, like that of every `_unchecked`
## function.
import Param
import Prepared

Statement := {
	kind : Statement.Kind,
	params : List(Param.Param),
}.{

	## Plain SQL, parsed as an unnamed statement every time it runs, or a
	## statement prepared with `Client.prepare_unchecked!`. A prepared
	## statement only exists on the connection it was prepared on, so run on a
	## different
	## connection, `Client.command!` falls back to parsing its SQL as an
	## unnamed statement instead of failing with "prepared statement does not
	## exist".
	Kind : [Sql(Str), Prepared(Prepared.Prepared)]

	## A statement from a SQL string, which is not checked when you build. Use
	## `$1`, `$2`, ... placeholders for parameters and supply them with
	## [Statement.bind].
	new_unchecked : Str -> Statement
	new_unchecked = |sql| { kind: Sql(sql), params: [] }

	## Supply the parameters for the statement's `$n` placeholders.
	bind : Statement, List(Param.Param) -> Statement
	bind = |stmt, params| { ..stmt, params }
}
