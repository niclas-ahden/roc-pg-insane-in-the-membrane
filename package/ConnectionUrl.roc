## Connection settings from a PostgreSQL connection URL:
##
## ```
## postgresql://user:password@localhost:5432/app
## ```
##
## [Client.connect_url!] connects with one.
##
## The syntax is parsed by
## [roc-database-url](https://github.com/niclas-ahden/roc-database-url),
## which also percent-decodes the parts. What the parts mean for a
## connection is decided here, as in
## [libpq](https://www.postgresql.org/docs/current/libpq.html):
##
## - The port defaults to 5432, and the database to the user's name.
## - `sslmode`: this package has no TLS yet, since the platforms it runs on
##   offer none (see [Client.connect!]), so it connects in plaintext
##   for `disable`, and for `allow` and `prefer` (the default), which settle
##   for plaintext. `require`, `verify-ca` and `verify-full` demand TLS, and
##   fail with `UnsupportedSslMode(mode)` rather than connect without it.
## - `application_name`, and the `-c name=value` settings of `options`, are
##   sent as the session's run-time parameters.
## - Any other option fails with `UnsupportedOption(name)`, so a setting a
##   URL means to make, like `sslrootcert`, is never ignored.
import db.DatabaseUrl

ConnectionUrl :: [].{
	## What a URL says about a connection.
	Settings : {
		host : Str,
		port : U16,
		user : Str,
		database : Str,
		auth : [NoAuth, Password(Str)],
		params : List((Str, Str)),
	}

	## Why a URL was refused. `InvalidUrl(reason)` is a URL that cannot be
	## parsed, `NotPostgres(protocol)` a URL for another database, and
	## `InvalidOptions(options)` an `options` value that is not a list of
	## `-c name=value` settings.
	##
	## Apps log these errors, so `InvalidUrl` never repeats any part of the
	## URL. A password with an unescaped `/`, `?` or `#` makes the rest of
	## the URL read wrong, and the start of the password would otherwise
	## show up in the error as the port.
	ParseErr : [InvalidUrl(Str), NotPostgres(Str), MissingHost, MissingUser, UnsupportedSslMode(Str), UnsupportedOption(Str), InvalidOptions(Str)]

	## Parse a `postgresql://` or `postgres://` URL. See the module
	## documentation for what each part means.
	parse : Str -> Try(ConnectionUrl.Settings, ConnectionUrl.ParseErr)
	parse = |url| {
		partial =
			match DatabaseUrl.parse_partial(url) {
				Ok(parsed) => parsed
				Err(InvalidPort(_)) => return Err(InvalidUrl("the port is not a number. A password with `/`, `?` or `#` in it must be percent-encoded"))
				Err(MissingProtocol) => return Err(InvalidUrl("it has no protocol, such as postgresql://"))
				Err(RelativeUrl) => return Err(InvalidUrl("it is not an absolute URL"))
			}
		config =
			match partial {
				PostgreSQL(found) => found
				MySQL(found) => return Err(NotPostgres(found.protocol))
				Other(found) => return Err(NotPostgres(found.protocol))
				SQLite(_) => return Err(NotPostgres("sqlite"))
			}
		host =
			match config.host {
				Host(name) => name
				NoHost => return Err(MissingHost)
			}
		user =
			match config.user {
				User(name) => name
				NoUser => return Err(MissingUser)
			}
		options = config.options
		check_ssl_mode(options.get("sslmode"))?
		params = session_params(options)?
		Ok({
			host,
			port:
				match config.port {
					Port(number) => number
					NoPort => 5432
				},
			user,
			database:
				match config.database {
					Database(name) => name
					NoDatabase => user
				},
			auth:
				match config.auth {
					Password(password) => Password(password)
					NoPassword => NoAuth
				},
			params,
		})
	}
}

## Whether a plaintext connection is what an `sslmode` allows.
check_ssl_mode : Try(Str, [KeyNotFound]) -> Try({}, ConnectionUrl.ParseErr)
check_ssl_mode = |mode|
	match mode {
		Err(KeyNotFound) => Ok({})
		Ok("disable") | Ok("allow") | Ok("prefer") => Ok({})
		Ok(other) => Err(UnsupportedSslMode(other))
	}

## The run-time parameters a URL's options ask for: `application_name`, and
## each `-c name=value` of `options`. Any other option is refused.
session_params : Dict(Str, Str) -> Try(List((Str, Str)), ConnectionUrl.ParseErr)
session_params = |options| {
	known = ["sslmode", "application_name", "options"]
	unknown = options.keys().drop_if(|key| known.contains(key))
	match unknown.first() {
		Ok(key) => Err(UnsupportedOption(key))
		Err(_) => {
			application_name =
				match options.get("application_name") {
					Ok(name) => [("application_name", name)]
					Err(KeyNotFound) => []
				}
			settings =
				match options.get("options") {
					Ok(text) => command_line_settings(text.split_on(" ").drop_if(|token| token == ""), [], text)?
					Err(KeyNotFound) => []
				}
			Ok(application_name.concat(settings))
		}
	}
}

## The settings of an `options` value: `-c name=value`, `-cname=value` or
## `--name=value`, separated by spaces.
command_line_settings : List(Str), List((Str, Str)), Str -> Try(List((Str, Str)), ConnectionUrl.ParseErr)
command_line_settings = |tokens, found, text|
	match tokens {
		[] => Ok(found)
		["-c", setting, .. as rest] => command_line_settings(rest, found.append(name_value(setting, text)?), text)
		[token, .. as rest] =>
			if token.starts_with("--") {
				command_line_settings(rest, found.append(name_value(token.drop_prefix("--"), text)?), text)
			} else if token.starts_with("-c") and token != "-c" {
				command_line_settings(rest, found.append(name_value(token.drop_prefix("-c"), text)?), text)
			} else {
				Err(InvalidOptions(text))
			}
	}

name_value : Str, Str -> Try((Str, Str), ConnectionUrl.ParseErr)
name_value = |setting, text|
	match setting.split_first("=") {
		Ok({ before, after }) if before != "" => Ok((before, after))
		_ => Err(InvalidOptions(text))
	}

expect
	ConnectionUrl.parse("postgresql://app:p%40ss@db.example.com:6543/shop")
	== Ok({ host: "db.example.com", port: 6543, user: "app", database: "shop", auth: Password("p@ss"), params: [] })

# libpq's defaults: port 5432, the database named after the user.
expect
	ConnectionUrl.parse("postgres://app@localhost")
	== Ok({ host: "localhost", port: 5432, user: "app", database: "app", auth: NoAuth, params: [] })

# Modes that settle for plaintext.
expect ConnectionUrl.parse("postgres://app@db/shop?sslmode=disable").is_ok()
expect ConnectionUrl.parse("postgres://app@db/shop?sslmode=allow").is_ok()
expect ConnectionUrl.parse("postgres://app@db/shop?sslmode=prefer").is_ok()

# Modes that demand TLS, which this package does not speak.
expect ConnectionUrl.parse("postgres://app@db/shop?sslmode=require") == Err(UnsupportedSslMode("require"))
expect ConnectionUrl.parse("postgres://app@db/shop?sslmode=verify-ca") == Err(UnsupportedSslMode("verify-ca"))
expect ConnectionUrl.parse("postgres://app@db/shop?sslmode=verify-full") == Err(UnsupportedSslMode("verify-full"))

expect
	ConnectionUrl.parse("postgres://app@db/shop?application_name=web&options=-c%20statement_timeout%3D5000%20--search_path%3Dapp")
	.map_ok(|s| s.params)
	== Ok([("application_name", "web"), ("statement_timeout", "5000"), ("search_path", "app")])

expect ConnectionUrl.parse("postgres://app@db/shop?options=-cwork_mem%3D64MB").map_ok(|s| s.params) == Ok([("work_mem", "64MB")])
expect ConnectionUrl.parse("postgres://app@db/shop?options=nonsense") == Err(InvalidOptions("nonsense"))

# An option this package does not act on is refused, never ignored.
expect ConnectionUrl.parse("postgres://app@db/shop?sslrootcert=%2Fca.pem") == Err(UnsupportedOption("sslrootcert"))

expect ConnectionUrl.parse("mysql://app@db:3306/shop") == Err(NotPostgres("mysql"))
expect ConnectionUrl.parse("postgres:///shop") == Err(MissingHost)
expect ConnectionUrl.parse("postgres://db/shop") == Err(MissingUser)

# A password with an unescaped `/`, `?` or `#` ends the authority early, so
# its start reads as the port, which the error must not repeat. A start
# that is a valid port leaves the user missing instead. An unescaped `@` is
# fine, the last one ends the password.
leaks_hunter = |url|
	match ConnectionUrl.parse(url) {
		Err(err) => Str.inspect(err).contains("hunter")
		Ok(_) => Bool.True
	}

expect !leaks_hunter("postgresql://app:hunter/2@db/shop")
expect !leaks_hunter("postgresql://app:hunter#2@db/shop")
expect !leaks_hunter("postgresql://app:hunter?2@db/shop")
expect ConnectionUrl.parse("postgresql://app:123?hunter@db/shop") == Err(MissingUser)
expect ConnectionUrl.parse("postgresql://app:hunter@2@db/shop").map_ok(|s| s.auth) == Ok(Password("hunter@2"))
