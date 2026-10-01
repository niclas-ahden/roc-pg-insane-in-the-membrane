## Turns command line arguments into numbers. A malformed number becomes 0,
## which is good enough for an example.
Args := [].{
	i32 : Str -> I32
	i32 = |text| I32.from_str(text) ?? 0

	i64 : Str -> I64
	i64 = |text| I64.from_str(text) ?? 0

	dec : Str -> Dec
	dec = |text| Dec.from_str(text) ?? 0

	f64 : Str -> F64
	f64 = |text| F64.from_str(text) ?? 0
}
