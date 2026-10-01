import pg.Catalog
import "schema.sql" as schema_sql : Str

## The schema every query is checked against, read from `schema.sql`, a
## `pg_dump --schema-only` of the database.
Schema := [].{
	parsed : Catalog
	parsed = Catalog.from_schema(schema_sql)

	catalog : {} -> Catalog
	catalog = |{}| parsed
}
