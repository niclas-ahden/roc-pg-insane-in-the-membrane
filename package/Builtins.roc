# Derived from PostgreSQL 18.6, src/include/catalog: pg_type.dat,
# pg_proc.dat, pg_operator.dat and pg_cast.dat.
#
# PostgreSQL Database Management System
# (also known as Postgres, formerly known as Postgres95)
#
# Portions Copyright (c) 1996-2026, PostgreSQL Global Development Group
#
# Portions Copyright (c) 1994, The Regents of the University of California
#
# Permission to use, copy, modify, and distribute this software and its
# documentation for any purpose, without fee, and without a written agreement
# is hereby granted, provided that the above copyright notice and this
# paragraph and the following two paragraphs appear in all copies.
#
# IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
# DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING
# LOST PROFITS, ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS
# DOCUMENTATION, EVEN IF THE UNIVERSITY OF CALIFORNIA HAS BEEN ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
# THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
# INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
# ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATIONS TO
# PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
#

## The types, functions, operators and casts of Postgres 18.6's
## catalog. Types are spelled as `pg_dump` spells column types. Each table
## is text, one entry per line, fields split by tabs, lines sorted by their
## first field. Written by `tools/builtins.roc`, do not edit.
##
## - [Builtins.types]: name, category (`typcategory`), `p` when preferred.
##   Arrays are not listed: `x[]` is in category `A`.
## - [Builtins.functions]: name, argument types split by commas, result
##   type, then flags: `s` strict, `a` aggregate, `w` window, `r` returns a
##   set, `v` the last argument is variadic, `d` and a count: that many
##   trailing arguments have defaults. Last, the columns of a function with
##   several output parameters, `name:type` split by `;`.
## - [Builtins.operators]: name, left type (empty for a prefix operator),
##   right type, result type, then `s` when strict.
## - [Builtins.casts]: source type, target type, then `i` for a cast that
##   applies implicitly, `a` for one that applies only on assignment.
Builtins :: [].{
	types : List(U8)
	types = types_text.to_utf8()

	functions : List(U8)
	functions = functions_text.to_utf8()

	operators : List(U8)
	operators = operators_text.to_utf8()

	casts : List(U8)
	casts = casts_text.to_utf8()
}

types_text : Str
types_text =
	\\aclitem	U	
	\\any	P	
	\\anyarray	P	
	\\anycompatible	P	
	\\anycompatiblearray	P	
	\\anycompatiblemultirange	P	
	\\anycompatiblenonarray	P	
	\\anycompatiblerange	P	
	\\anyelement	P	
	\\anyenum	P	
	\\anymultirange	P	
	\\anynonarray	P	
	\\anyrange	P	
	\\bigint	N	
	\\bit	V	
	\\bit varying	V	p
	\\boolean	B	p
	\\box	G	
	\\bytea	U	
	\\char	Z	
	\\character	S	
	\\character varying	S	
	\\cid	U	
	\\cidr	I	
	\\circle	G	
	\\date	D	
	\\datemultirange	R	
	\\daterange	R	
	\\double precision	N	p
	\\gtsvector	U	
	\\inet	I	p
	\\int2vector	A	
	\\int4multirange	R	
	\\int4range	R	
	\\int8multirange	R	
	\\int8range	R	
	\\integer	N	
	\\interval	T	p
	\\json	U	
	\\jsonb	U	
	\\jsonpath	U	
	\\line	G	
	\\lseg	G	
	\\macaddr	U	
	\\macaddr8	U	
	\\money	N	
	\\name	S	
	\\numeric	N	
	\\nummultirange	R	
	\\numrange	R	
	\\oid	N	p
	\\oidvector	A	
	\\path	G	
	\\pg_attribute	C	
	\\pg_brin_bloom_summary	Z	
	\\pg_brin_minmax_multi_summary	Z	
	\\pg_class	C	
	\\pg_dependencies	Z	
	\\pg_lsn	U	
	\\pg_mcv_list	Z	
	\\pg_ndistinct	Z	
	\\pg_node_tree	Z	
	\\pg_proc	C	
	\\pg_snapshot	U	
	\\pg_type	C	
	\\point	G	
	\\polygon	G	
	\\real	N	
	\\record	P	
	\\record[]	P	
	\\refcursor	U	
	\\regclass	N	
	\\regcollation	N	
	\\regconfig	N	
	\\regdictionary	N	
	\\regnamespace	N	
	\\regoper	N	
	\\regoperator	N	
	\\regproc	N	
	\\regprocedure	N	
	\\regrole	N	
	\\regtype	N	
	\\smallint	N	
	\\text	S	p
	\\tid	U	
	\\time with time zone	D	
	\\time without time zone	D	
	\\timestamp with time zone	D	p
	\\timestamp without time zone	D	
	\\tsmultirange	R	
	\\tsquery	U	
	\\tsrange	R	
	\\tstzmultirange	R	
	\\tstzrange	R	
	\\tsvector	U	
	\\txid_snapshot	U	
	\\unknown	X	
	\\uuid	U	
	\\void	P	
	\\xid	U	
	\\xid8	U	
	\\xml	U	

functions_text : Str
functions_text =
	\\abbrev	cidr	text	s	
	\\abbrev	inet	text	s	
	\\abs	bigint	bigint	s	
	\\abs	double precision	double precision	s	
	\\abs	integer	integer	s	
	\\abs	numeric	numeric	s	
	\\abs	real	real	s	
	\\abs	smallint	smallint	s	
	\\aclcontains	aclitem[],aclitem	boolean	s	
	\\acldefault	char,oid	aclitem[]	s	
	\\aclexplode	aclitem[]	record	sr	grantor:oid;grantee:oid;privilege_type:text;is_grantable:boolean
	\\aclinsert	aclitem[],aclitem	aclitem[]	s	
	\\aclitemeq	aclitem,aclitem	boolean	s	
	\\aclremove	aclitem[],aclitem	aclitem[]	s	
	\\acos	double precision	double precision	s	
	\\acosd	double precision	double precision	s	
	\\acosh	double precision	double precision	s	
	\\age	timestamp with time zone	interval	s	
	\\age	timestamp with time zone,timestamp with time zone	interval	s	
	\\age	timestamp without time zone	interval	s	
	\\age	timestamp without time zone,timestamp without time zone	interval	s	
	\\age	xid	integer	s	
	\\amvalidate	oid	boolean	s	
	\\any_value	anyelement	anyelement	a	
	\\any_value_transfn	anyelement,anyelement	anyelement	s	
	\\anyarray_send	anyarray	bytea	s	
	\\anycompatiblearray_send	anycompatiblearray	bytea	s	
	\\anytextcat	anynonarray,text	text	s	
	\\area	box	double precision	s	
	\\area	circle	double precision	s	
	\\area	path	double precision	s	
	\\array_agg	anyarray	anyarray	a	
	\\array_agg	anynonarray	anyarray	a	
	\\array_append	anycompatiblearray,anycompatible	anycompatiblearray		
	\\array_cat	anycompatiblearray,anycompatiblearray	anycompatiblearray		
	\\array_dims	anyarray	text	s	
	\\array_eq	anyarray,anyarray	boolean	s	
	\\array_fill	anyelement,integer[]	anyarray		
	\\array_fill	anyelement,integer[],integer[]	anyarray		
	\\array_ge	anyarray,anyarray	boolean	s	
	\\array_gt	anyarray,anyarray	boolean	s	
	\\array_larger	anyarray,anyarray	anyarray	s	
	\\array_le	anyarray,anyarray	boolean	s	
	\\array_length	anyarray,integer	integer	s	
	\\array_lower	anyarray,integer	integer	s	
	\\array_lt	anyarray,anyarray	boolean	s	
	\\array_ndims	anyarray	integer	s	
	\\array_ne	anyarray,anyarray	boolean	s	
	\\array_position	anycompatiblearray,anycompatible	integer		
	\\array_position	anycompatiblearray,anycompatible,integer	integer		
	\\array_positions	anycompatiblearray,anycompatible	integer[]		
	\\array_prepend	anycompatible,anycompatiblearray	anycompatiblearray		
	\\array_remove	anycompatiblearray,anycompatible	anycompatiblearray		
	\\array_replace	anycompatiblearray,anycompatible,anycompatible	anycompatiblearray		
	\\array_reverse	anyarray	anyarray	s	
	\\array_sample	anyarray,integer	anyarray	s	
	\\array_send	anyarray	bytea	s	
	\\array_shuffle	anyarray	anyarray	s	
	\\array_smaller	anyarray,anyarray	anyarray	s	
	\\array_sort	anyarray	anyarray	s	
	\\array_sort	anyarray,boolean	anyarray	s	
	\\array_sort	anyarray,boolean,boolean	anyarray	s	
	\\array_to_json	anyarray	json	s	
	\\array_to_json	anyarray,boolean	json	s	
	\\array_to_string	anyarray,text	text	s	
	\\array_to_string	anyarray,text,text	text		
	\\array_to_tsvector	text[]	tsvector	s	
	\\array_upper	anyarray,integer	integer	s	
	\\arraycontained	anyarray,anyarray	boolean	s	
	\\arraycontains	anyarray,anyarray	boolean	s	
	\\arrayoverlap	anyarray,anyarray	boolean	s	
	\\ascii	text	integer	s	
	\\asin	double precision	double precision	s	
	\\asind	double precision	double precision	s	
	\\asinh	double precision	double precision	s	
	\\atan	double precision	double precision	s	
	\\atan2	double precision,double precision	double precision	s	
	\\atan2d	double precision,double precision	double precision	s	
	\\atand	double precision	double precision	s	
	\\atanh	double precision	double precision	s	
	\\avg	bigint	numeric	a	
	\\avg	double precision	double precision	a	
	\\avg	integer	numeric	a	
	\\avg	interval	interval	a	
	\\avg	numeric	numeric	a	
	\\avg	real	double precision	a	
	\\avg	smallint	numeric	a	
	\\binary_upgrade_add_sub_rel_state	text,oid,char,pg_lsn	void		
	\\binary_upgrade_create_empty_extension	text,text,boolean,text,oid[],text[],text[]	void		
	\\binary_upgrade_logical_slot_has_caught_up	name	boolean	s	
	\\binary_upgrade_replorigin_advance	text,pg_lsn	void		
	\\binary_upgrade_set_missing_value	oid,text,text	void	s	
	\\binary_upgrade_set_next_array_pg_type_oid	oid	void	s	
	\\binary_upgrade_set_next_heap_pg_class_oid	oid	void	s	
	\\binary_upgrade_set_next_heap_relfilenode	oid	void	s	
	\\binary_upgrade_set_next_index_pg_class_oid	oid	void	s	
	\\binary_upgrade_set_next_index_relfilenode	oid	void	s	
	\\binary_upgrade_set_next_multirange_array_pg_type_oid	oid	void	s	
	\\binary_upgrade_set_next_multirange_pg_type_oid	oid	void	s	
	\\binary_upgrade_set_next_pg_authid_oid	oid	void	s	
	\\binary_upgrade_set_next_pg_enum_oid	oid	void	s	
	\\binary_upgrade_set_next_pg_tablespace_oid	oid	void	s	
	\\binary_upgrade_set_next_pg_type_oid	oid	void	s	
	\\binary_upgrade_set_next_toast_pg_class_oid	oid	void	s	
	\\binary_upgrade_set_next_toast_relfilenode	oid	void	s	
	\\binary_upgrade_set_record_init_privs	boolean	void	s	
	\\bit	bigint,integer	bit	s	
	\\bit	bit,integer,boolean	bit	s	
	\\bit	integer,integer	bit	s	
	\\bit_and	bigint	bigint	a	
	\\bit_and	bit	bit	a	
	\\bit_and	integer	integer	a	
	\\bit_and	smallint	smallint	a	
	\\bit_count	bit	bigint	s	
	\\bit_count	bytea	bigint	s	
	\\bit_length	bit	integer	s	
	\\bit_length	bytea	integer	s	
	\\bit_length	text	integer	s	
	\\bit_or	bigint	bigint	a	
	\\bit_or	bit	bit	a	
	\\bit_or	integer	integer	a	
	\\bit_or	smallint	smallint	a	
	\\bit_send	bit	bytea	s	
	\\bit_xor	bigint	bigint	a	
	\\bit_xor	bit	bit	a	
	\\bit_xor	integer	integer	a	
	\\bit_xor	smallint	smallint	a	
	\\bitand	bit,bit	bit	s	
	\\bitcat	bit varying,bit varying	bit varying	s	
	\\bitcmp	bit,bit	integer	s	
	\\biteq	bit,bit	boolean	s	
	\\bitge	bit,bit	boolean	s	
	\\bitgt	bit,bit	boolean	s	
	\\bitle	bit,bit	boolean	s	
	\\bitlt	bit,bit	boolean	s	
	\\bitne	bit,bit	boolean	s	
	\\bitnot	bit	bit	s	
	\\bitor	bit,bit	bit	s	
	\\bitshiftleft	bit,integer	bit	s	
	\\bitshiftright	bit,integer	bit	s	
	\\bittypmodin	cstring[]	integer	s	
	\\bitxor	bit,bit	bit	s	
	\\bool	integer	boolean	s	
	\\bool	jsonb	boolean	s	
	\\bool_and	boolean	boolean	a	
	\\bool_or	boolean	boolean	a	
	\\booland_statefunc	boolean,boolean	boolean	s	
	\\booleq	boolean,boolean	boolean	s	
	\\boolge	boolean,boolean	boolean	s	
	\\boolgt	boolean,boolean	boolean	s	
	\\boolle	boolean,boolean	boolean	s	
	\\boollt	boolean,boolean	boolean	s	
	\\boolne	boolean,boolean	boolean	s	
	\\boolor_statefunc	boolean,boolean	boolean	s	
	\\boolsend	boolean	bytea	s	
	\\bound_box	box,box	box	s	
	\\box	circle	box	s	
	\\box	point	box	s	
	\\box	point,point	box	s	
	\\box	polygon	box	s	
	\\box_above	box,box	boolean	s	
	\\box_above_eq	box,box	boolean	s	
	\\box_add	box,point	box	s	
	\\box_below	box,box	boolean	s	
	\\box_below_eq	box,box	boolean	s	
	\\box_center	box	point	s	
	\\box_contain	box,box	boolean	s	
	\\box_contain_pt	box,point	boolean	s	
	\\box_contained	box,box	boolean	s	
	\\box_distance	box,box	double precision	s	
	\\box_div	box,point	box	s	
	\\box_eq	box,box	boolean	s	
	\\box_ge	box,box	boolean	s	
	\\box_gt	box,box	boolean	s	
	\\box_intersect	box,box	box	s	
	\\box_le	box,box	boolean	s	
	\\box_left	box,box	boolean	s	
	\\box_lt	box,box	boolean	s	
	\\box_mul	box,point	box	s	
	\\box_overabove	box,box	boolean	s	
	\\box_overbelow	box,box	boolean	s	
	\\box_overlap	box,box	boolean	s	
	\\box_overleft	box,box	boolean	s	
	\\box_overright	box,box	boolean	s	
	\\box_right	box,box	boolean	s	
	\\box_same	box,box	boolean	s	
	\\box_send	box	bytea	s	
	\\box_sub	box,point	box	s	
	\\bpchar	char	character	s	
	\\bpchar	character,integer,boolean	character	s	
	\\bpchar	name	character	s	
	\\bpchar_larger	character,character	character	s	
	\\bpchar_pattern_ge	character,character	boolean	s	
	\\bpchar_pattern_gt	character,character	boolean	s	
	\\bpchar_pattern_le	character,character	boolean	s	
	\\bpchar_pattern_lt	character,character	boolean	s	
	\\bpchar_smaller	character,character	character	s	
	\\bpcharcmp	character,character	integer	s	
	\\bpchareq	character,character	boolean	s	
	\\bpcharge	character,character	boolean	s	
	\\bpchargt	character,character	boolean	s	
	\\bpchariclike	character,text	boolean	s	
	\\bpcharicnlike	character,text	boolean	s	
	\\bpcharicregexeq	character,text	boolean	s	
	\\bpcharicregexne	character,text	boolean	s	
	\\bpcharle	character,character	boolean	s	
	\\bpcharlike	character,text	boolean	s	
	\\bpcharlt	character,character	boolean	s	
	\\bpcharne	character,character	boolean	s	
	\\bpcharnlike	character,text	boolean	s	
	\\bpcharregexeq	character,text	boolean	s	
	\\bpcharregexne	character,text	boolean	s	
	\\bpcharsend	character	bytea	s	
	\\bpchartypmodin	cstring[]	integer	s	
	\\brin_bloom_summary_send	pg_brin_bloom_summary	bytea	s	
	\\brin_desummarize_range	regclass,bigint	void	s	
	\\brin_minmax_multi_summary_send	pg_brin_minmax_multi_summary	bytea	s	
	\\brin_summarize_new_values	regclass	integer	s	
	\\brin_summarize_range	regclass,bigint	integer	s	
	\\broadcast	inet	inet	s	
	\\btarraycmp	anyarray,anyarray	integer	s	
	\\btboolcmp	boolean,boolean	integer	s	
	\\btbpchar_pattern_cmp	character,character	integer	s	
	\\btcharcmp	char,char	integer	s	
	\\btequalimage	oid	boolean	s	
	\\btfloat48cmp	real,double precision	integer	s	
	\\btfloat4cmp	real,real	integer	s	
	\\btfloat84cmp	double precision,real	integer	s	
	\\btfloat8cmp	double precision,double precision	integer	s	
	\\btint24cmp	smallint,integer	integer	s	
	\\btint28cmp	smallint,bigint	integer	s	
	\\btint2cmp	smallint,smallint	integer	s	
	\\btint42cmp	integer,smallint	integer	s	
	\\btint48cmp	integer,bigint	integer	s	
	\\btint4cmp	integer,integer	integer	s	
	\\btint82cmp	bigint,smallint	integer	s	
	\\btint84cmp	bigint,integer	integer	s	
	\\btint8cmp	bigint,bigint	integer	s	
	\\btnamecmp	name,name	integer	s	
	\\btnametextcmp	name,text	integer	s	
	\\btoidcmp	oid,oid	integer	s	
	\\btoidvectorcmp	oidvector,oidvector	integer	s	
	\\btrecordcmp	record,record	integer	s	
	\\btrecordimagecmp	record,record	integer	s	
	\\btrim	bytea,bytea	bytea	s	
	\\btrim	text	text	s	
	\\btrim	text,text	text	s	
	\\bttext_pattern_cmp	text,text	integer	s	
	\\bttextcmp	text,text	integer	s	
	\\bttextnamecmp	text,name	integer	s	
	\\bttidcmp	tid,tid	integer	s	
	\\btvarstrequalimage	oid	boolean	s	
	\\bytea	bigint	bytea	s	
	\\bytea	integer	bytea	s	
	\\bytea	smallint	bytea	s	
	\\bytea_larger	bytea,bytea	bytea	s	
	\\bytea_smaller	bytea,bytea	bytea	s	
	\\byteacat	bytea,bytea	bytea	s	
	\\byteacmp	bytea,bytea	integer	s	
	\\byteaeq	bytea,bytea	boolean	s	
	\\byteage	bytea,bytea	boolean	s	
	\\byteagt	bytea,bytea	boolean	s	
	\\byteale	bytea,bytea	boolean	s	
	\\bytealike	bytea,bytea	boolean	s	
	\\bytealt	bytea,bytea	boolean	s	
	\\byteane	bytea,bytea	boolean	s	
	\\byteanlike	bytea,bytea	boolean	s	
	\\byteasend	bytea	bytea	s	
	\\cardinality	anyarray	integer	s	
	\\casefold	text	text	s	
	\\cash_cmp	money,money	integer	s	
	\\cash_div_cash	money,money	double precision	s	
	\\cash_div_flt4	money,real	money	s	
	\\cash_div_flt8	money,double precision	money	s	
	\\cash_div_int2	money,smallint	money	s	
	\\cash_div_int4	money,integer	money	s	
	\\cash_div_int8	money,bigint	money	s	
	\\cash_eq	money,money	boolean	s	
	\\cash_ge	money,money	boolean	s	
	\\cash_gt	money,money	boolean	s	
	\\cash_le	money,money	boolean	s	
	\\cash_lt	money,money	boolean	s	
	\\cash_mi	money,money	money	s	
	\\cash_mul_flt4	money,real	money	s	
	\\cash_mul_flt8	money,double precision	money	s	
	\\cash_mul_int2	money,smallint	money	s	
	\\cash_mul_int4	money,integer	money	s	
	\\cash_mul_int8	money,bigint	money	s	
	\\cash_ne	money,money	boolean	s	
	\\cash_pl	money,money	money	s	
	\\cash_send	money	bytea	s	
	\\cash_words	money	text	s	
	\\cashlarger	money,money	money	s	
	\\cashsmaller	money,money	money	s	
	\\cbrt	double precision	double precision	s	
	\\ceil	double precision	double precision	s	
	\\ceil	numeric	numeric	s	
	\\ceiling	double precision	double precision	s	
	\\ceiling	numeric	numeric	s	
	\\center	box	point	s	
	\\center	circle	point	s	
	\\char	integer	char	s	
	\\char	text	char	s	
	\\char_length	character	integer	s	
	\\char_length	text	integer	s	
	\\character_length	character	integer	s	
	\\character_length	text	integer	s	
	\\chareq	char,char	boolean	s	
	\\charge	char,char	boolean	s	
	\\chargt	char,char	boolean	s	
	\\charle	char,char	boolean	s	
	\\charlt	char,char	boolean	s	
	\\charne	char,char	boolean	s	
	\\charsend	char	bytea	s	
	\\chr	integer	text	s	
	\\cideq	cid,cid	boolean	s	
	\\cidr	inet	cidr	s	
	\\cidr_send	cidr	bytea	s	
	\\cidsend	cid	bytea	s	
	\\circle	box	circle	s	
	\\circle	point,double precision	circle	s	
	\\circle	polygon	circle	s	
	\\circle_above	circle,circle	boolean	s	
	\\circle_add_pt	circle,point	circle	s	
	\\circle_below	circle,circle	boolean	s	
	\\circle_center	circle	point	s	
	\\circle_contain	circle,circle	boolean	s	
	\\circle_contain_pt	circle,point	boolean	s	
	\\circle_contained	circle,circle	boolean	s	
	\\circle_distance	circle,circle	double precision	s	
	\\circle_div_pt	circle,point	circle	s	
	\\circle_eq	circle,circle	boolean	s	
	\\circle_ge	circle,circle	boolean	s	
	\\circle_gt	circle,circle	boolean	s	
	\\circle_le	circle,circle	boolean	s	
	\\circle_left	circle,circle	boolean	s	
	\\circle_lt	circle,circle	boolean	s	
	\\circle_mul_pt	circle,point	circle	s	
	\\circle_ne	circle,circle	boolean	s	
	\\circle_overabove	circle,circle	boolean	s	
	\\circle_overbelow	circle,circle	boolean	s	
	\\circle_overlap	circle,circle	boolean	s	
	\\circle_overleft	circle,circle	boolean	s	
	\\circle_overright	circle,circle	boolean	s	
	\\circle_right	circle,circle	boolean	s	
	\\circle_same	circle,circle	boolean	s	
	\\circle_send	circle	bytea	s	
	\\circle_sub_pt	circle,point	circle	s	
	\\clock_timestamp		timestamp with time zone	s	
	\\close_ls	line,lseg	point	s	
	\\close_lseg	lseg,lseg	point	s	
	\\close_pb	point,box	point	s	
	\\close_pl	point,line	point	s	
	\\close_ps	point,lseg	point	s	
	\\close_sb	lseg,box	point	s	
	\\col_description	oid,integer	text	s	
	\\concat	any	text	v	
	\\concat_ws	text,any	text	v	
	\\convert	bytea,name,name	bytea	s	
	\\convert_from	bytea,name	text	s	
	\\convert_to	text,name	bytea	s	
	\\corr	double precision,double precision	double precision	a	
	\\cos	double precision	double precision	s	
	\\cosd	double precision	double precision	s	
	\\cosh	double precision	double precision	s	
	\\cot	double precision	double precision	s	
	\\cotd	double precision	double precision	s	
	\\count		bigint	a	
	\\count	any	bigint	a	
	\\covar_pop	double precision,double precision	double precision	a	
	\\covar_samp	double precision,double precision	double precision	a	
	\\crc32	bytea	bigint	s	
	\\crc32c	bytea	bigint	s	
	\\cume_dist		double precision	w	
	\\cume_dist	any	double precision	av	
	\\current_database		name	s	
	\\current_query		text		
	\\current_schema		name	s	
	\\current_schemas	boolean	name[]	s	
	\\current_setting	text	text	s	
	\\current_setting	text,boolean	text	s	
	\\current_user		name	s	
	\\currtid2	text,tid	tid	s	
	\\currval	regclass	bigint	s	
	\\cursor_to_xml	refcursor,integer,boolean,boolean,text	xml	s	
	\\cursor_to_xmlschema	refcursor,boolean,boolean,text	xml	s	
	\\database_to_xml	boolean,boolean,text	xml	s	
	\\database_to_xml_and_xmlschema	boolean,boolean,text	xml	s	
	\\database_to_xmlschema	boolean,boolean,text	xml	s	
	\\date	timestamp with time zone	date	s	
	\\date	timestamp without time zone	date	s	
	\\date_add	timestamp with time zone,interval	timestamp with time zone	s	
	\\date_add	timestamp with time zone,interval,text	timestamp with time zone	s	
	\\date_bin	interval,timestamp with time zone,timestamp with time zone	timestamp with time zone	s	
	\\date_bin	interval,timestamp without time zone,timestamp without time zone	timestamp without time zone	s	
	\\date_cmp	date,date	integer	s	
	\\date_cmp_timestamp	date,timestamp without time zone	integer	s	
	\\date_cmp_timestamptz	date,timestamp with time zone	integer	s	
	\\date_eq	date,date	boolean	s	
	\\date_eq_timestamp	date,timestamp without time zone	boolean	s	
	\\date_eq_timestamptz	date,timestamp with time zone	boolean	s	
	\\date_ge	date,date	boolean	s	
	\\date_ge_timestamp	date,timestamp without time zone	boolean	s	
	\\date_ge_timestamptz	date,timestamp with time zone	boolean	s	
	\\date_gt	date,date	boolean	s	
	\\date_gt_timestamp	date,timestamp without time zone	boolean	s	
	\\date_gt_timestamptz	date,timestamp with time zone	boolean	s	
	\\date_larger	date,date	date	s	
	\\date_le	date,date	boolean	s	
	\\date_le_timestamp	date,timestamp without time zone	boolean	s	
	\\date_le_timestamptz	date,timestamp with time zone	boolean	s	
	\\date_lt	date,date	boolean	s	
	\\date_lt_timestamp	date,timestamp without time zone	boolean	s	
	\\date_lt_timestamptz	date,timestamp with time zone	boolean	s	
	\\date_mi	date,date	integer	s	
	\\date_mi_interval	date,interval	timestamp without time zone	s	
	\\date_mii	date,integer	date	s	
	\\date_ne	date,date	boolean	s	
	\\date_ne_timestamp	date,timestamp without time zone	boolean	s	
	\\date_ne_timestamptz	date,timestamp with time zone	boolean	s	
	\\date_part	text,date	double precision	s	
	\\date_part	text,interval	double precision	s	
	\\date_part	text,time with time zone	double precision	s	
	\\date_part	text,time without time zone	double precision	s	
	\\date_part	text,timestamp with time zone	double precision	s	
	\\date_part	text,timestamp without time zone	double precision	s	
	\\date_pl_interval	date,interval	timestamp without time zone	s	
	\\date_pli	date,integer	date	s	
	\\date_send	date	bytea	s	
	\\date_smaller	date,date	date	s	
	\\date_subtract	timestamp with time zone,interval	timestamp with time zone	s	
	\\date_subtract	timestamp with time zone,interval,text	timestamp with time zone	s	
	\\date_trunc	text,interval	interval	s	
	\\date_trunc	text,timestamp with time zone	timestamp with time zone	s	
	\\date_trunc	text,timestamp with time zone,text	timestamp with time zone	s	
	\\date_trunc	text,timestamp without time zone	timestamp without time zone	s	
	\\datemultirange		datemultirange	s	
	\\datemultirange	daterange	datemultirange	s	
	\\datemultirange	daterange[]	datemultirange	sv	
	\\daterange	date,date	daterange		
	\\daterange	date,date,text	daterange		
	\\daterange_canonical	daterange	daterange	s	
	\\daterange_subdiff	date,date	double precision	s	
	\\datetime_pl	date,time without time zone	timestamp without time zone	s	
	\\datetimetz_pl	date,time with time zone	timestamp with time zone	s	
	\\dcbrt	double precision	double precision	s	
	\\decode	text,text	bytea	s	
	\\degrees	double precision	double precision	s	
	\\dense_rank		bigint	w	
	\\dense_rank	any	bigint	av	
	\\dexp	double precision	double precision	s	
	\\diagonal	box	lseg	s	
	\\diameter	circle	double precision	s	
	\\dist_bp	box,point	double precision	s	
	\\dist_bs	box,lseg	double precision	s	
	\\dist_cpoint	circle,point	double precision	s	
	\\dist_cpoly	circle,polygon	double precision	s	
	\\dist_lp	line,point	double precision	s	
	\\dist_ls	line,lseg	double precision	s	
	\\dist_pathp	path,point	double precision	s	
	\\dist_pb	point,box	double precision	s	
	\\dist_pc	point,circle	double precision	s	
	\\dist_pl	point,line	double precision	s	
	\\dist_polyc	polygon,circle	double precision	s	
	\\dist_polyp	polygon,point	double precision	s	
	\\dist_ppath	point,path	double precision	s	
	\\dist_ppoly	point,polygon	double precision	s	
	\\dist_ps	point,lseg	double precision	s	
	\\dist_sb	lseg,box	double precision	s	
	\\dist_sl	lseg,line	double precision	s	
	\\dist_sp	lseg,point	double precision	s	
	\\div	numeric,numeric	numeric	s	
	\\dlog1	double precision	double precision	s	
	\\dlog10	double precision	double precision	s	
	\\dpow	double precision,double precision	double precision	s	
	\\dround	double precision	double precision	s	
	\\dsqrt	double precision	double precision	s	
	\\dtrunc	double precision	double precision	s	
	\\elem_contained_by_multirange	anyelement,anymultirange	boolean	s	
	\\elem_contained_by_range	anyelement,anyrange	boolean	s	
	\\encode	bytea,text	text	s	
	\\enum_cmp	anyenum,anyenum	integer	s	
	\\enum_eq	anyenum,anyenum	boolean	s	
	\\enum_first	anyenum	anyenum		
	\\enum_ge	anyenum,anyenum	boolean	s	
	\\enum_gt	anyenum,anyenum	boolean	s	
	\\enum_larger	anyenum,anyenum	anyenum	s	
	\\enum_last	anyenum	anyenum		
	\\enum_le	anyenum,anyenum	boolean	s	
	\\enum_lt	anyenum,anyenum	boolean	s	
	\\enum_ne	anyenum,anyenum	boolean	s	
	\\enum_range	anyenum	anyarray		
	\\enum_range	anyenum,anyenum	anyarray		
	\\enum_send	anyenum	bytea	s	
	\\enum_smaller	anyenum,anyenum	anyenum	s	
	\\erf	double precision	double precision	s	
	\\erfc	double precision	double precision	s	
	\\every	boolean	boolean	a	
	\\exp	double precision	double precision	s	
	\\exp	numeric	numeric	s	
	\\extract	text,date	numeric	s	
	\\extract	text,interval	numeric	s	
	\\extract	text,time with time zone	numeric	s	
	\\extract	text,time without time zone	numeric	s	
	\\extract	text,timestamp with time zone	numeric	s	
	\\extract	text,timestamp without time zone	numeric	s	
	\\factorial	bigint	numeric	s	
	\\family	inet	integer	s	
	\\first_value	anyelement	anyelement	sw	
	\\float4	bigint	real	s	
	\\float4	double precision	real	s	
	\\float4	integer	real	s	
	\\float4	jsonb	real	s	
	\\float4	numeric	real	s	
	\\float4	smallint	real	s	
	\\float48div	real,double precision	double precision	s	
	\\float48eq	real,double precision	boolean	s	
	\\float48ge	real,double precision	boolean	s	
	\\float48gt	real,double precision	boolean	s	
	\\float48le	real,double precision	boolean	s	
	\\float48lt	real,double precision	boolean	s	
	\\float48mi	real,double precision	double precision	s	
	\\float48mul	real,double precision	double precision	s	
	\\float48ne	real,double precision	boolean	s	
	\\float48pl	real,double precision	double precision	s	
	\\float4_accum	double precision[],real	double precision[]	s	
	\\float4abs	real	real	s	
	\\float4div	real,real	real	s	
	\\float4eq	real,real	boolean	s	
	\\float4ge	real,real	boolean	s	
	\\float4gt	real,real	boolean	s	
	\\float4larger	real,real	real	s	
	\\float4le	real,real	boolean	s	
	\\float4lt	real,real	boolean	s	
	\\float4mi	real,real	real	s	
	\\float4mul	real,real	real	s	
	\\float4ne	real,real	boolean	s	
	\\float4pl	real,real	real	s	
	\\float4send	real	bytea	s	
	\\float4smaller	real,real	real	s	
	\\float4um	real	real	s	
	\\float4up	real	real	s	
	\\float8	bigint	double precision	s	
	\\float8	integer	double precision	s	
	\\float8	jsonb	double precision	s	
	\\float8	numeric	double precision	s	
	\\float8	real	double precision	s	
	\\float8	smallint	double precision	s	
	\\float84div	double precision,real	double precision	s	
	\\float84eq	double precision,real	boolean	s	
	\\float84ge	double precision,real	boolean	s	
	\\float84gt	double precision,real	boolean	s	
	\\float84le	double precision,real	boolean	s	
	\\float84lt	double precision,real	boolean	s	
	\\float84mi	double precision,real	double precision	s	
	\\float84mul	double precision,real	double precision	s	
	\\float84ne	double precision,real	boolean	s	
	\\float84pl	double precision,real	double precision	s	
	\\float8_accum	double precision[],double precision	double precision[]	s	
	\\float8_avg	double precision[]	double precision	s	
	\\float8_combine	double precision[],double precision[]	double precision[]	s	
	\\float8_corr	double precision[]	double precision	s	
	\\float8_covar_pop	double precision[]	double precision	s	
	\\float8_covar_samp	double precision[]	double precision	s	
	\\float8_regr_accum	double precision[],double precision,double precision	double precision[]	s	
	\\float8_regr_avgx	double precision[]	double precision	s	
	\\float8_regr_avgy	double precision[]	double precision	s	
	\\float8_regr_combine	double precision[],double precision[]	double precision[]	s	
	\\float8_regr_intercept	double precision[]	double precision	s	
	\\float8_regr_r2	double precision[]	double precision	s	
	\\float8_regr_slope	double precision[]	double precision	s	
	\\float8_regr_sxx	double precision[]	double precision	s	
	\\float8_regr_sxy	double precision[]	double precision	s	
	\\float8_regr_syy	double precision[]	double precision	s	
	\\float8_stddev_pop	double precision[]	double precision	s	
	\\float8_stddev_samp	double precision[]	double precision	s	
	\\float8_var_pop	double precision[]	double precision	s	
	\\float8_var_samp	double precision[]	double precision	s	
	\\float8abs	double precision	double precision	s	
	\\float8div	double precision,double precision	double precision	s	
	\\float8eq	double precision,double precision	boolean	s	
	\\float8ge	double precision,double precision	boolean	s	
	\\float8gt	double precision,double precision	boolean	s	
	\\float8larger	double precision,double precision	double precision	s	
	\\float8le	double precision,double precision	boolean	s	
	\\float8lt	double precision,double precision	boolean	s	
	\\float8mi	double precision,double precision	double precision	s	
	\\float8mul	double precision,double precision	double precision	s	
	\\float8ne	double precision,double precision	boolean	s	
	\\float8pl	double precision,double precision	double precision	s	
	\\float8send	double precision	bytea	s	
	\\float8smaller	double precision,double precision	double precision	s	
	\\float8um	double precision	double precision	s	
	\\float8up	double precision	double precision	s	
	\\floor	double precision	double precision	s	
	\\floor	numeric	numeric	s	
	\\flt4_mul_cash	real,money	money	s	
	\\flt8_mul_cash	double precision,money	money	s	
	\\fmgr_c_validator	oid	void	s	
	\\fmgr_internal_validator	oid	void	s	
	\\fmgr_sql_validator	oid	void	s	
	\\format	text	text		
	\\format	text,any	text	v	
	\\format_type	oid,integer	text		
	\\gamma	double precision	double precision	s	
	\\gcd	bigint,bigint	bigint	s	
	\\gcd	integer,integer	integer	s	
	\\gcd	numeric,numeric	numeric	s	
	\\gen_random_uuid		uuid	s	
	\\generate_series	bigint,bigint	bigint	sr	
	\\generate_series	bigint,bigint,bigint	bigint	sr	
	\\generate_series	integer,integer	integer	sr	
	\\generate_series	integer,integer,integer	integer	sr	
	\\generate_series	numeric,numeric	numeric	sr	
	\\generate_series	numeric,numeric,numeric	numeric	sr	
	\\generate_series	timestamp with time zone,timestamp with time zone,interval	timestamp with time zone	sr	
	\\generate_series	timestamp with time zone,timestamp with time zone,interval,text	timestamp with time zone	sr	
	\\generate_series	timestamp without time zone,timestamp without time zone,interval	timestamp without time zone	sr	
	\\generate_subscripts	anyarray,integer	integer	sr	
	\\generate_subscripts	anyarray,integer,boolean	integer	sr	
	\\get_bit	bit,integer	integer	s	
	\\get_bit	bytea,bigint	integer	s	
	\\get_byte	bytea,integer	integer	s	
	\\get_current_ts_config		regconfig	s	
	\\getdatabaseencoding		name	s	
	\\getpgusername		name	s	
	\\gin_clean_pending_list	regclass	bigint	s	
	\\gin_cmp_tslexeme	text,text	integer	s	
	\\gin_compare_jsonb	text,text	integer	s	
	\\gist_translate_cmptype_common	integer	smallint	s	
	\\has_any_column_privilege	name,oid,text	boolean	s	
	\\has_any_column_privilege	name,text,text	boolean	s	
	\\has_any_column_privilege	oid,oid,text	boolean	s	
	\\has_any_column_privilege	oid,text	boolean	s	
	\\has_any_column_privilege	oid,text,text	boolean	s	
	\\has_any_column_privilege	text,text	boolean	s	
	\\has_column_privilege	name,oid,smallint,text	boolean	s	
	\\has_column_privilege	name,oid,text,text	boolean	s	
	\\has_column_privilege	name,text,smallint,text	boolean	s	
	\\has_column_privilege	name,text,text,text	boolean	s	
	\\has_column_privilege	oid,oid,smallint,text	boolean	s	
	\\has_column_privilege	oid,oid,text,text	boolean	s	
	\\has_column_privilege	oid,smallint,text	boolean	s	
	\\has_column_privilege	oid,text,smallint,text	boolean	s	
	\\has_column_privilege	oid,text,text	boolean	s	
	\\has_column_privilege	oid,text,text,text	boolean	s	
	\\has_column_privilege	text,smallint,text	boolean	s	
	\\has_column_privilege	text,text,text	boolean	s	
	\\has_database_privilege	name,oid,text	boolean	s	
	\\has_database_privilege	name,text,text	boolean	s	
	\\has_database_privilege	oid,oid,text	boolean	s	
	\\has_database_privilege	oid,text	boolean	s	
	\\has_database_privilege	oid,text,text	boolean	s	
	\\has_database_privilege	text,text	boolean	s	
	\\has_foreign_data_wrapper_privilege	name,oid,text	boolean	s	
	\\has_foreign_data_wrapper_privilege	name,text,text	boolean	s	
	\\has_foreign_data_wrapper_privilege	oid,oid,text	boolean	s	
	\\has_foreign_data_wrapper_privilege	oid,text	boolean	s	
	\\has_foreign_data_wrapper_privilege	oid,text,text	boolean	s	
	\\has_foreign_data_wrapper_privilege	text,text	boolean	s	
	\\has_function_privilege	name,oid,text	boolean	s	
	\\has_function_privilege	name,text,text	boolean	s	
	\\has_function_privilege	oid,oid,text	boolean	s	
	\\has_function_privilege	oid,text	boolean	s	
	\\has_function_privilege	oid,text,text	boolean	s	
	\\has_function_privilege	text,text	boolean	s	
	\\has_language_privilege	name,oid,text	boolean	s	
	\\has_language_privilege	name,text,text	boolean	s	
	\\has_language_privilege	oid,oid,text	boolean	s	
	\\has_language_privilege	oid,text	boolean	s	
	\\has_language_privilege	oid,text,text	boolean	s	
	\\has_language_privilege	text,text	boolean	s	
	\\has_largeobject_privilege	name,oid,text	boolean	s	
	\\has_largeobject_privilege	oid,oid,text	boolean	s	
	\\has_largeobject_privilege	oid,text	boolean	s	
	\\has_parameter_privilege	name,text,text	boolean	s	
	\\has_parameter_privilege	oid,text,text	boolean	s	
	\\has_parameter_privilege	text,text	boolean	s	
	\\has_schema_privilege	name,oid,text	boolean	s	
	\\has_schema_privilege	name,text,text	boolean	s	
	\\has_schema_privilege	oid,oid,text	boolean	s	
	\\has_schema_privilege	oid,text	boolean	s	
	\\has_schema_privilege	oid,text,text	boolean	s	
	\\has_schema_privilege	text,text	boolean	s	
	\\has_sequence_privilege	name,oid,text	boolean	s	
	\\has_sequence_privilege	name,text,text	boolean	s	
	\\has_sequence_privilege	oid,oid,text	boolean	s	
	\\has_sequence_privilege	oid,text	boolean	s	
	\\has_sequence_privilege	oid,text,text	boolean	s	
	\\has_sequence_privilege	text,text	boolean	s	
	\\has_server_privilege	name,oid,text	boolean	s	
	\\has_server_privilege	name,text,text	boolean	s	
	\\has_server_privilege	oid,oid,text	boolean	s	
	\\has_server_privilege	oid,text	boolean	s	
	\\has_server_privilege	oid,text,text	boolean	s	
	\\has_server_privilege	text,text	boolean	s	
	\\has_table_privilege	name,oid,text	boolean	s	
	\\has_table_privilege	name,text,text	boolean	s	
	\\has_table_privilege	oid,oid,text	boolean	s	
	\\has_table_privilege	oid,text	boolean	s	
	\\has_table_privilege	oid,text,text	boolean	s	
	\\has_table_privilege	text,text	boolean	s	
	\\has_tablespace_privilege	name,oid,text	boolean	s	
	\\has_tablespace_privilege	name,text,text	boolean	s	
	\\has_tablespace_privilege	oid,oid,text	boolean	s	
	\\has_tablespace_privilege	oid,text	boolean	s	
	\\has_tablespace_privilege	oid,text,text	boolean	s	
	\\has_tablespace_privilege	text,text	boolean	s	
	\\has_type_privilege	name,oid,text	boolean	s	
	\\has_type_privilege	name,text,text	boolean	s	
	\\has_type_privilege	oid,oid,text	boolean	s	
	\\has_type_privilege	oid,text	boolean	s	
	\\has_type_privilege	oid,text,text	boolean	s	
	\\has_type_privilege	text,text	boolean	s	
	\\hash_aclitem	aclitem	integer	s	
	\\hash_aclitem_extended	aclitem,bigint	bigint	s	
	\\hash_array	anyarray	integer	s	
	\\hash_array_extended	anyarray,bigint	bigint	s	
	\\hash_multirange	anymultirange	integer	s	
	\\hash_multirange_extended	anymultirange,bigint	bigint	s	
	\\hash_numeric	numeric	integer	s	
	\\hash_numeric_extended	numeric,bigint	bigint	s	
	\\hash_range	anyrange	integer	s	
	\\hash_range_extended	anyrange,bigint	bigint	s	
	\\hash_record	record	integer	s	
	\\hash_record_extended	record,bigint	bigint	s	
	\\hashbool	boolean	integer	s	
	\\hashboolextended	boolean,bigint	bigint	s	
	\\hashbpchar	character	integer	s	
	\\hashbpcharextended	character,bigint	bigint	s	
	\\hashbytea	bytea	integer	s	
	\\hashbyteaextended	bytea,bigint	bigint	s	
	\\hashchar	char	integer	s	
	\\hashcharextended	char,bigint	bigint	s	
	\\hashcid	cid	integer	s	
	\\hashcidextended	cid,bigint	bigint	s	
	\\hashdate	date	integer	s	
	\\hashdateextended	date,bigint	bigint	s	
	\\hashenum	anyenum	integer	s	
	\\hashenumextended	anyenum,bigint	bigint	s	
	\\hashfloat4	real	integer	s	
	\\hashfloat4extended	real,bigint	bigint	s	
	\\hashfloat8	double precision	integer	s	
	\\hashfloat8extended	double precision,bigint	bigint	s	
	\\hashinet	inet	integer	s	
	\\hashinetextended	inet,bigint	bigint	s	
	\\hashint2	smallint	integer	s	
	\\hashint2extended	smallint,bigint	bigint	s	
	\\hashint4	integer	integer	s	
	\\hashint4extended	integer,bigint	bigint	s	
	\\hashint8	bigint	integer	s	
	\\hashint8extended	bigint,bigint	bigint	s	
	\\hashmacaddr	macaddr	integer	s	
	\\hashmacaddr8	macaddr8	integer	s	
	\\hashmacaddr8extended	macaddr8,bigint	bigint	s	
	\\hashmacaddrextended	macaddr,bigint	bigint	s	
	\\hashname	name	integer	s	
	\\hashnameextended	name,bigint	bigint	s	
	\\hashoid	oid	integer	s	
	\\hashoidextended	oid,bigint	bigint	s	
	\\hashoidvector	oidvector	integer	s	
	\\hashoidvectorextended	oidvector,bigint	bigint	s	
	\\hashtext	text	integer	s	
	\\hashtextextended	text,bigint	bigint	s	
	\\hashtid	tid	integer	s	
	\\hashtidextended	tid,bigint	bigint	s	
	\\hashxid	xid	integer	s	
	\\hashxid8	xid8	integer	s	
	\\hashxid8extended	xid8,bigint	bigint	s	
	\\hashxidextended	xid,bigint	bigint	s	
	\\height	box	double precision	s	
	\\host	inet	text	s	
	\\hostmask	inet	inet	s	
	\\icu_unicode_version		text	s	
	\\in_range	bigint,bigint,bigint,boolean,boolean	boolean	s	
	\\in_range	date,date,interval,boolean,boolean	boolean	s	
	\\in_range	double precision,double precision,double precision,boolean,boolean	boolean	s	
	\\in_range	integer,integer,bigint,boolean,boolean	boolean	s	
	\\in_range	integer,integer,integer,boolean,boolean	boolean	s	
	\\in_range	integer,integer,smallint,boolean,boolean	boolean	s	
	\\in_range	interval,interval,interval,boolean,boolean	boolean	s	
	\\in_range	numeric,numeric,numeric,boolean,boolean	boolean	s	
	\\in_range	real,real,double precision,boolean,boolean	boolean	s	
	\\in_range	smallint,smallint,bigint,boolean,boolean	boolean	s	
	\\in_range	smallint,smallint,integer,boolean,boolean	boolean	s	
	\\in_range	smallint,smallint,smallint,boolean,boolean	boolean	s	
	\\in_range	time with time zone,time with time zone,interval,boolean,boolean	boolean	s	
	\\in_range	time without time zone,time without time zone,interval,boolean,boolean	boolean	s	
	\\in_range	timestamp with time zone,timestamp with time zone,interval,boolean,boolean	boolean	s	
	\\in_range	timestamp without time zone,timestamp without time zone,interval,boolean,boolean	boolean	s	
	\\inet_client_addr		inet		
	\\inet_client_port		integer		
	\\inet_merge	inet,inet	cidr	s	
	\\inet_same_family	inet,inet	boolean	s	
	\\inet_send	inet	bytea	s	
	\\inet_server_addr		inet		
	\\inet_server_port		integer		
	\\inetand	inet,inet	inet	s	
	\\inetmi	inet,inet	bigint	s	
	\\inetmi_int8	inet,bigint	inet	s	
	\\inetnot	inet	inet	s	
	\\inetor	inet,inet	inet	s	
	\\inetpl	inet,bigint	inet	s	
	\\initcap	text	text	s	
	\\int2	bigint	smallint	s	
	\\int2	bytea	smallint	s	
	\\int2	double precision	smallint	s	
	\\int2	integer	smallint	s	
	\\int2	jsonb	smallint	s	
	\\int2	numeric	smallint	s	
	\\int2	real	smallint	s	
	\\int24div	smallint,integer	integer	s	
	\\int24eq	smallint,integer	boolean	s	
	\\int24ge	smallint,integer	boolean	s	
	\\int24gt	smallint,integer	boolean	s	
	\\int24le	smallint,integer	boolean	s	
	\\int24lt	smallint,integer	boolean	s	
	\\int24mi	smallint,integer	integer	s	
	\\int24mul	smallint,integer	integer	s	
	\\int24ne	smallint,integer	boolean	s	
	\\int24pl	smallint,integer	integer	s	
	\\int28div	smallint,bigint	bigint	s	
	\\int28eq	smallint,bigint	boolean	s	
	\\int28ge	smallint,bigint	boolean	s	
	\\int28gt	smallint,bigint	boolean	s	
	\\int28le	smallint,bigint	boolean	s	
	\\int28lt	smallint,bigint	boolean	s	
	\\int28mi	smallint,bigint	bigint	s	
	\\int28mul	smallint,bigint	bigint	s	
	\\int28ne	smallint,bigint	boolean	s	
	\\int28pl	smallint,bigint	bigint	s	
	\\int2_avg_accum	bigint[],smallint	bigint[]	s	
	\\int2_avg_accum_inv	bigint[],smallint	bigint[]	s	
	\\int2_mul_cash	smallint,money	money	s	
	\\int2_sum	bigint,smallint	bigint		
	\\int2abs	smallint	smallint	s	
	\\int2and	smallint,smallint	smallint	s	
	\\int2div	smallint,smallint	smallint	s	
	\\int2eq	smallint,smallint	boolean	s	
	\\int2ge	smallint,smallint	boolean	s	
	\\int2gt	smallint,smallint	boolean	s	
	\\int2int4_sum	bigint[]	bigint	s	
	\\int2larger	smallint,smallint	smallint	s	
	\\int2le	smallint,smallint	boolean	s	
	\\int2lt	smallint,smallint	boolean	s	
	\\int2mi	smallint,smallint	smallint	s	
	\\int2mod	smallint,smallint	smallint	s	
	\\int2mul	smallint,smallint	smallint	s	
	\\int2ne	smallint,smallint	boolean	s	
	\\int2not	smallint	smallint	s	
	\\int2or	smallint,smallint	smallint	s	
	\\int2pl	smallint,smallint	smallint	s	
	\\int2send	smallint	bytea	s	
	\\int2shl	smallint,integer	smallint	s	
	\\int2shr	smallint,integer	smallint	s	
	\\int2smaller	smallint,smallint	smallint	s	
	\\int2um	smallint	smallint	s	
	\\int2up	smallint	smallint	s	
	\\int2vectorsend	int2vector	bytea	s	
	\\int2xor	smallint,smallint	smallint	s	
	\\int4	bigint	integer	s	
	\\int4	bit	integer	s	
	\\int4	boolean	integer	s	
	\\int4	bytea	integer	s	
	\\int4	char	integer	s	
	\\int4	double precision	integer	s	
	\\int4	jsonb	integer	s	
	\\int4	numeric	integer	s	
	\\int4	real	integer	s	
	\\int4	smallint	integer	s	
	\\int42div	integer,smallint	integer	s	
	\\int42eq	integer,smallint	boolean	s	
	\\int42ge	integer,smallint	boolean	s	
	\\int42gt	integer,smallint	boolean	s	
	\\int42le	integer,smallint	boolean	s	
	\\int42lt	integer,smallint	boolean	s	
	\\int42mi	integer,smallint	integer	s	
	\\int42mul	integer,smallint	integer	s	
	\\int42ne	integer,smallint	boolean	s	
	\\int42pl	integer,smallint	integer	s	
	\\int48div	integer,bigint	bigint	s	
	\\int48eq	integer,bigint	boolean	s	
	\\int48ge	integer,bigint	boolean	s	
	\\int48gt	integer,bigint	boolean	s	
	\\int48le	integer,bigint	boolean	s	
	\\int48lt	integer,bigint	boolean	s	
	\\int48mi	integer,bigint	bigint	s	
	\\int48mul	integer,bigint	bigint	s	
	\\int48ne	integer,bigint	boolean	s	
	\\int48pl	integer,bigint	bigint	s	
	\\int4_avg_accum	bigint[],integer	bigint[]	s	
	\\int4_avg_accum_inv	bigint[],integer	bigint[]	s	
	\\int4_avg_combine	bigint[],bigint[]	bigint[]	s	
	\\int4_mul_cash	integer,money	money	s	
	\\int4_sum	bigint,integer	bigint		
	\\int4abs	integer	integer	s	
	\\int4and	integer,integer	integer	s	
	\\int4div	integer,integer	integer	s	
	\\int4eq	integer,integer	boolean	s	
	\\int4ge	integer,integer	boolean	s	
	\\int4gt	integer,integer	boolean	s	
	\\int4inc	integer	integer	s	
	\\int4larger	integer,integer	integer	s	
	\\int4le	integer,integer	boolean	s	
	\\int4lt	integer,integer	boolean	s	
	\\int4mi	integer,integer	integer	s	
	\\int4mod	integer,integer	integer	s	
	\\int4mul	integer,integer	integer	s	
	\\int4multirange		int4multirange	s	
	\\int4multirange	int4range	int4multirange	s	
	\\int4multirange	int4range[]	int4multirange	sv	
	\\int4ne	integer,integer	boolean	s	
	\\int4not	integer	integer	s	
	\\int4or	integer,integer	integer	s	
	\\int4pl	integer,integer	integer	s	
	\\int4range	integer,integer	int4range		
	\\int4range	integer,integer,text	int4range		
	\\int4range_canonical	int4range	int4range	s	
	\\int4range_subdiff	integer,integer	double precision	s	
	\\int4send	integer	bytea	s	
	\\int4shl	integer,integer	integer	s	
	\\int4shr	integer,integer	integer	s	
	\\int4smaller	integer,integer	integer	s	
	\\int4um	integer	integer	s	
	\\int4up	integer	integer	s	
	\\int4xor	integer,integer	integer	s	
	\\int8	bit	bigint	s	
	\\int8	bytea	bigint	s	
	\\int8	double precision	bigint	s	
	\\int8	integer	bigint	s	
	\\int8	jsonb	bigint	s	
	\\int8	numeric	bigint	s	
	\\int8	oid	bigint	s	
	\\int8	real	bigint	s	
	\\int8	smallint	bigint	s	
	\\int82div	bigint,smallint	bigint	s	
	\\int82eq	bigint,smallint	boolean	s	
	\\int82ge	bigint,smallint	boolean	s	
	\\int82gt	bigint,smallint	boolean	s	
	\\int82le	bigint,smallint	boolean	s	
	\\int82lt	bigint,smallint	boolean	s	
	\\int82mi	bigint,smallint	bigint	s	
	\\int82mul	bigint,smallint	bigint	s	
	\\int82ne	bigint,smallint	boolean	s	
	\\int82pl	bigint,smallint	bigint	s	
	\\int84div	bigint,integer	bigint	s	
	\\int84eq	bigint,integer	boolean	s	
	\\int84ge	bigint,integer	boolean	s	
	\\int84gt	bigint,integer	boolean	s	
	\\int84le	bigint,integer	boolean	s	
	\\int84lt	bigint,integer	boolean	s	
	\\int84mi	bigint,integer	bigint	s	
	\\int84mul	bigint,integer	bigint	s	
	\\int84ne	bigint,integer	boolean	s	
	\\int84pl	bigint,integer	bigint	s	
	\\int8_avg	bigint[]	numeric	s	
	\\int8_mul_cash	bigint,money	money	s	
	\\int8_sum	numeric,bigint	numeric		
	\\int8abs	bigint	bigint	s	
	\\int8and	bigint,bigint	bigint	s	
	\\int8dec	bigint	bigint	s	
	\\int8dec_any	bigint,any	bigint	s	
	\\int8div	bigint,bigint	bigint	s	
	\\int8eq	bigint,bigint	boolean	s	
	\\int8ge	bigint,bigint	boolean	s	
	\\int8gt	bigint,bigint	boolean	s	
	\\int8inc	bigint	bigint	s	
	\\int8inc_any	bigint,any	bigint	s	
	\\int8inc_float8_float8	bigint,double precision,double precision	bigint	s	
	\\int8larger	bigint,bigint	bigint	s	
	\\int8le	bigint,bigint	boolean	s	
	\\int8lt	bigint,bigint	boolean	s	
	\\int8mi	bigint,bigint	bigint	s	
	\\int8mod	bigint,bigint	bigint	s	
	\\int8mul	bigint,bigint	bigint	s	
	\\int8multirange		int8multirange	s	
	\\int8multirange	int8range	int8multirange	s	
	\\int8multirange	int8range[]	int8multirange	sv	
	\\int8ne	bigint,bigint	boolean	s	
	\\int8not	bigint	bigint	s	
	\\int8or	bigint,bigint	bigint	s	
	\\int8pl	bigint,bigint	bigint	s	
	\\int8pl_inet	bigint,inet	inet	s	
	\\int8range	bigint,bigint	int8range		
	\\int8range	bigint,bigint,text	int8range		
	\\int8range_canonical	int8range	int8range	s	
	\\int8range_subdiff	bigint,bigint	double precision	s	
	\\int8send	bigint	bytea	s	
	\\int8shl	bigint,integer	bigint	s	
	\\int8shr	bigint,integer	bigint	s	
	\\int8smaller	bigint,bigint	bigint	s	
	\\int8um	bigint	bigint	s	
	\\int8up	bigint	bigint	s	
	\\int8xor	bigint,bigint	bigint	s	
	\\integer_pl_date	integer,date	date	s	
	\\inter_lb	line,box	boolean	s	
	\\inter_sb	lseg,box	boolean	s	
	\\inter_sl	lseg,line	boolean	s	
	\\interval	interval,integer	interval	s	
	\\interval	time without time zone	interval	s	
	\\interval_cmp	interval,interval	integer	s	
	\\interval_div	interval,double precision	interval	s	
	\\interval_eq	interval,interval	boolean	s	
	\\interval_ge	interval,interval	boolean	s	
	\\interval_gt	interval,interval	boolean	s	
	\\interval_hash	interval	integer	s	
	\\interval_hash_extended	interval,bigint	bigint	s	
	\\interval_larger	interval,interval	interval	s	
	\\interval_le	interval,interval	boolean	s	
	\\interval_lt	interval,interval	boolean	s	
	\\interval_mi	interval,interval	interval	s	
	\\interval_mul	interval,double precision	interval	s	
	\\interval_ne	interval,interval	boolean	s	
	\\interval_pl	interval,interval	interval	s	
	\\interval_pl_date	interval,date	timestamp without time zone	s	
	\\interval_pl_time	interval,time without time zone	time without time zone	s	
	\\interval_pl_timestamp	interval,timestamp without time zone	timestamp without time zone	s	
	\\interval_pl_timestamptz	interval,timestamp with time zone	timestamp with time zone	s	
	\\interval_pl_timetz	interval,time with time zone	time with time zone	s	
	\\interval_send	interval	bytea	s	
	\\interval_smaller	interval,interval	interval	s	
	\\interval_um	interval	interval	s	
	\\intervaltypmodin	cstring[]	integer	s	
	\\is_normalized	text,text	boolean	sd1	
	\\isclosed	path	boolean	s	
	\\isempty	anymultirange	boolean	s	
	\\isempty	anyrange	boolean	s	
	\\isfinite	date	boolean	s	
	\\isfinite	interval	boolean	s	
	\\isfinite	timestamp with time zone	boolean	s	
	\\isfinite	timestamp without time zone	boolean	s	
	\\ishorizontal	line	boolean	s	
	\\ishorizontal	lseg	boolean	s	
	\\ishorizontal	point,point	boolean	s	
	\\isopen	path	boolean	s	
	\\isparallel	line,line	boolean	s	
	\\isparallel	lseg,lseg	boolean	s	
	\\isperp	line,line	boolean	s	
	\\isperp	lseg,lseg	boolean	s	
	\\isvertical	line	boolean	s	
	\\isvertical	lseg	boolean	s	
	\\isvertical	point,point	boolean	s	
	\\json_agg	anyelement	json	a	
	\\json_agg_strict	anyelement	json	a	
	\\json_array_element	json,integer	json	s	
	\\json_array_element_text	json,integer	text	s	
	\\json_array_elements	json	json	sr	
	\\json_array_elements_text	json	text	sr	
	\\json_array_length	json	integer	s	
	\\json_build_array		json		
	\\json_build_array	any	json	v	
	\\json_build_object		json		
	\\json_build_object	any	json	v	
	\\json_each	json	record	sr	key:text;value:json
	\\json_each_text	json	record	sr	key:text;value:text
	\\json_extract_path	json,text[]	json	sv	
	\\json_extract_path_text	json,text[]	text	sv	
	\\json_object	text[]	json	s	
	\\json_object	text[],text[]	json	s	
	\\json_object_agg	any,any	json	a	
	\\json_object_agg_strict	any,any	json	a	
	\\json_object_agg_unique	any,any	json	a	
	\\json_object_agg_unique_strict	any,any	json	a	
	\\json_object_field	json,text	json	s	
	\\json_object_field_text	json,text	text	s	
	\\json_object_keys	json	text	sr	
	\\json_populate_record	anyelement,json,boolean	anyelement	d1	
	\\json_populate_recordset	anyelement,json,boolean	anyelement	rd1	
	\\json_send	json	bytea	s	
	\\json_strip_nulls	json,boolean	json	sd1	
	\\json_to_record	json	record	s	
	\\json_to_recordset	json	record	r	
	\\json_to_tsvector	json,jsonb	tsvector	s	
	\\json_to_tsvector	regconfig,json,jsonb	tsvector	s	
	\\json_typeof	json	text	s	
	\\jsonb_agg	anyelement	jsonb	a	
	\\jsonb_agg_strict	anyelement	jsonb	a	
	\\jsonb_array_element	jsonb,integer	jsonb	s	
	\\jsonb_array_element_text	jsonb,integer	text	s	
	\\jsonb_array_elements	jsonb	jsonb	sr	
	\\jsonb_array_elements_text	jsonb	text	sr	
	\\jsonb_array_length	jsonb	integer	s	
	\\jsonb_build_array		jsonb		
	\\jsonb_build_array	any	jsonb	v	
	\\jsonb_build_object		jsonb		
	\\jsonb_build_object	any	jsonb	v	
	\\jsonb_cmp	jsonb,jsonb	integer	s	
	\\jsonb_concat	jsonb,jsonb	jsonb	s	
	\\jsonb_contained	jsonb,jsonb	boolean	s	
	\\jsonb_contains	jsonb,jsonb	boolean	s	
	\\jsonb_delete	jsonb,integer	jsonb	s	
	\\jsonb_delete	jsonb,text	jsonb	s	
	\\jsonb_delete	jsonb,text[]	jsonb	sv	
	\\jsonb_delete_path	jsonb,text[]	jsonb	s	
	\\jsonb_each	jsonb	record	sr	key:text;value:jsonb
	\\jsonb_each_text	jsonb	record	sr	key:text;value:text
	\\jsonb_eq	jsonb,jsonb	boolean	s	
	\\jsonb_exists	jsonb,text	boolean	s	
	\\jsonb_exists_all	jsonb,text[]	boolean	s	
	\\jsonb_exists_any	jsonb,text[]	boolean	s	
	\\jsonb_extract_path	jsonb,text[]	jsonb	sv	
	\\jsonb_extract_path_text	jsonb,text[]	text	sv	
	\\jsonb_ge	jsonb,jsonb	boolean	s	
	\\jsonb_gt	jsonb,jsonb	boolean	s	
	\\jsonb_hash	jsonb	integer	s	
	\\jsonb_hash_extended	jsonb,bigint	bigint	s	
	\\jsonb_insert	jsonb,text[],jsonb,boolean	jsonb	sd1	
	\\jsonb_le	jsonb,jsonb	boolean	s	
	\\jsonb_lt	jsonb,jsonb	boolean	s	
	\\jsonb_ne	jsonb,jsonb	boolean	s	
	\\jsonb_object	text[]	jsonb	s	
	\\jsonb_object	text[],text[]	jsonb	s	
	\\jsonb_object_agg	any,any	jsonb	a	
	\\jsonb_object_agg_strict	any,any	jsonb	a	
	\\jsonb_object_agg_unique	any,any	jsonb	a	
	\\jsonb_object_agg_unique_strict	any,any	jsonb	a	
	\\jsonb_object_field	jsonb,text	jsonb	s	
	\\jsonb_object_field_text	jsonb,text	text	s	
	\\jsonb_object_keys	jsonb	text	sr	
	\\jsonb_path_exists	jsonb,jsonpath,jsonb,boolean	boolean	sd2	
	\\jsonb_path_exists_opr	jsonb,jsonpath	boolean	s	
	\\jsonb_path_exists_tz	jsonb,jsonpath,jsonb,boolean	boolean	sd2	
	\\jsonb_path_match	jsonb,jsonpath,jsonb,boolean	boolean	sd2	
	\\jsonb_path_match_opr	jsonb,jsonpath	boolean	s	
	\\jsonb_path_match_tz	jsonb,jsonpath,jsonb,boolean	boolean	sd2	
	\\jsonb_path_query	jsonb,jsonpath,jsonb,boolean	jsonb	srd2	
	\\jsonb_path_query_array	jsonb,jsonpath,jsonb,boolean	jsonb	sd2	
	\\jsonb_path_query_array_tz	jsonb,jsonpath,jsonb,boolean	jsonb	sd2	
	\\jsonb_path_query_first	jsonb,jsonpath,jsonb,boolean	jsonb	sd2	
	\\jsonb_path_query_first_tz	jsonb,jsonpath,jsonb,boolean	jsonb	sd2	
	\\jsonb_path_query_tz	jsonb,jsonpath,jsonb,boolean	jsonb	srd2	
	\\jsonb_populate_record	anyelement,jsonb	anyelement		
	\\jsonb_populate_record_valid	anyelement,jsonb	boolean		
	\\jsonb_populate_recordset	anyelement,jsonb	anyelement	r	
	\\jsonb_pretty	jsonb	text	s	
	\\jsonb_send	jsonb	bytea	s	
	\\jsonb_set	jsonb,text[],jsonb,boolean	jsonb	sd1	
	\\jsonb_set_lax	jsonb,text[],jsonb,boolean,text	jsonb	d2	
	\\jsonb_strip_nulls	jsonb,boolean	jsonb	sd1	
	\\jsonb_to_record	jsonb	record	s	
	\\jsonb_to_recordset	jsonb	record	r	
	\\jsonb_to_tsvector	jsonb,jsonb	tsvector	s	
	\\jsonb_to_tsvector	regconfig,jsonb,jsonb	tsvector	s	
	\\jsonb_typeof	jsonb	text	s	
	\\jsonpath_send	jsonpath	bytea	s	
	\\justify_days	interval	interval	s	
	\\justify_hours	interval	interval	s	
	\\justify_interval	interval	interval	s	
	\\lag	anycompatible,integer,anycompatible	anycompatible	sw	
	\\lag	anyelement	anyelement	sw	
	\\lag	anyelement,integer	anyelement	sw	
	\\last_value	anyelement	anyelement	sw	
	\\lastval		bigint	s	
	\\lcm	bigint,bigint	bigint	s	
	\\lcm	integer,integer	integer	s	
	\\lcm	numeric,numeric	numeric	s	
	\\lead	anycompatible,integer,anycompatible	anycompatible	sw	
	\\lead	anyelement	anyelement	sw	
	\\lead	anyelement,integer	anyelement	sw	
	\\left	text,integer	text	s	
	\\length	bit	integer	s	
	\\length	bytea	integer	s	
	\\length	bytea,name	integer	s	
	\\length	character	integer	s	
	\\length	lseg	double precision	s	
	\\length	path	double precision	s	
	\\length	text	integer	s	
	\\length	tsvector	integer	s	
	\\lgamma	double precision	double precision	s	
	\\like	bytea,bytea	boolean	s	
	\\like	name,text	boolean	s	
	\\like	text,text	boolean	s	
	\\like_escape	bytea,bytea	bytea	s	
	\\like_escape	text,text	text	s	
	\\line	point,point	line	s	
	\\line_distance	line,line	double precision	s	
	\\line_eq	line,line	boolean	s	
	\\line_horizontal	line	boolean	s	
	\\line_interpt	line,line	point	s	
	\\line_intersect	line,line	boolean	s	
	\\line_parallel	line,line	boolean	s	
	\\line_perp	line,line	boolean	s	
	\\line_send	line	bytea	s	
	\\line_vertical	line	boolean	s	
	\\ln	double precision	double precision	s	
	\\ln	numeric	numeric	s	
	\\lo_close	integer	integer	s	
	\\lo_creat	integer	oid	s	
	\\lo_create	oid	oid	s	
	\\lo_export	oid,text	integer	s	
	\\lo_from_bytea	oid,bytea	oid	s	
	\\lo_get	oid	bytea	s	
	\\lo_get	oid,bigint,integer	bytea	s	
	\\lo_import	text	oid	s	
	\\lo_import	text,oid	oid	s	
	\\lo_lseek	integer,integer,integer	integer	s	
	\\lo_lseek64	integer,bigint,integer	bigint	s	
	\\lo_open	oid,integer	integer	s	
	\\lo_put	oid,bigint,bytea	void	s	
	\\lo_tell	integer	integer	s	
	\\lo_tell64	integer	bigint	s	
	\\lo_truncate	integer,integer	integer	s	
	\\lo_truncate64	integer,bigint	integer	s	
	\\lo_unlink	oid	integer	s	
	\\log	double precision	double precision	s	
	\\log	numeric	numeric	s	
	\\log	numeric,numeric	numeric	s	
	\\log10	double precision	double precision	s	
	\\log10	numeric	numeric	s	
	\\loread	integer,integer	bytea	s	
	\\lower	anymultirange	anyelement	s	
	\\lower	anyrange	anyelement	s	
	\\lower	text	text	s	
	\\lower_inc	anymultirange	boolean	s	
	\\lower_inc	anyrange	boolean	s	
	\\lower_inf	anymultirange	boolean	s	
	\\lower_inf	anyrange	boolean	s	
	\\lowrite	integer,bytea	integer	s	
	\\lpad	text,integer	text	s	
	\\lpad	text,integer,text	text	s	
	\\lseg	box	lseg	s	
	\\lseg	point,point	lseg	s	
	\\lseg_center	lseg	point	s	
	\\lseg_distance	lseg,lseg	double precision	s	
	\\lseg_eq	lseg,lseg	boolean	s	
	\\lseg_ge	lseg,lseg	boolean	s	
	\\lseg_gt	lseg,lseg	boolean	s	
	\\lseg_horizontal	lseg	boolean	s	
	\\lseg_interpt	lseg,lseg	point	s	
	\\lseg_intersect	lseg,lseg	boolean	s	
	\\lseg_le	lseg,lseg	boolean	s	
	\\lseg_length	lseg	double precision	s	
	\\lseg_lt	lseg,lseg	boolean	s	
	\\lseg_ne	lseg,lseg	boolean	s	
	\\lseg_parallel	lseg,lseg	boolean	s	
	\\lseg_perp	lseg,lseg	boolean	s	
	\\lseg_send	lseg	bytea	s	
	\\lseg_vertical	lseg	boolean	s	
	\\ltrim	bytea,bytea	bytea	s	
	\\ltrim	text	text	s	
	\\ltrim	text,text	text	s	
	\\macaddr	macaddr8	macaddr	s	
	\\macaddr8	macaddr	macaddr8	s	
	\\macaddr8_and	macaddr8,macaddr8	macaddr8	s	
	\\macaddr8_cmp	macaddr8,macaddr8	integer	s	
	\\macaddr8_eq	macaddr8,macaddr8	boolean	s	
	\\macaddr8_ge	macaddr8,macaddr8	boolean	s	
	\\macaddr8_gt	macaddr8,macaddr8	boolean	s	
	\\macaddr8_le	macaddr8,macaddr8	boolean	s	
	\\macaddr8_lt	macaddr8,macaddr8	boolean	s	
	\\macaddr8_ne	macaddr8,macaddr8	boolean	s	
	\\macaddr8_not	macaddr8	macaddr8	s	
	\\macaddr8_or	macaddr8,macaddr8	macaddr8	s	
	\\macaddr8_send	macaddr8	bytea	s	
	\\macaddr8_set7bit	macaddr8	macaddr8	s	
	\\macaddr_and	macaddr,macaddr	macaddr	s	
	\\macaddr_cmp	macaddr,macaddr	integer	s	
	\\macaddr_eq	macaddr,macaddr	boolean	s	
	\\macaddr_ge	macaddr,macaddr	boolean	s	
	\\macaddr_gt	macaddr,macaddr	boolean	s	
	\\macaddr_le	macaddr,macaddr	boolean	s	
	\\macaddr_lt	macaddr,macaddr	boolean	s	
	\\macaddr_ne	macaddr,macaddr	boolean	s	
	\\macaddr_not	macaddr	macaddr	s	
	\\macaddr_or	macaddr,macaddr	macaddr	s	
	\\macaddr_send	macaddr	bytea	s	
	\\make_date	integer,integer,integer	date	s	
	\\make_interval	integer,integer,integer,integer,integer,integer,double precision	interval	sd7	
	\\make_time	integer,integer,double precision	time without time zone	s	
	\\make_timestamp	integer,integer,integer,integer,integer,double precision	timestamp without time zone	s	
	\\make_timestamptz	integer,integer,integer,integer,integer,double precision	timestamp with time zone	s	
	\\make_timestamptz	integer,integer,integer,integer,integer,double precision,text	timestamp with time zone	s	
	\\makeaclitem	oid,oid,text,boolean	aclitem	s	
	\\masklen	inet	integer	s	
	\\max	anyarray	anyarray	a	
	\\max	anyenum	anyenum	a	
	\\max	bigint	bigint	a	
	\\max	bytea	bytea	a	
	\\max	character	character	a	
	\\max	date	date	a	
	\\max	double precision	double precision	a	
	\\max	inet	inet	a	
	\\max	integer	integer	a	
	\\max	interval	interval	a	
	\\max	money	money	a	
	\\max	numeric	numeric	a	
	\\max	oid	oid	a	
	\\max	pg_lsn	pg_lsn	a	
	\\max	real	real	a	
	\\max	record	record	a	
	\\max	smallint	smallint	a	
	\\max	text	text	a	
	\\max	tid	tid	a	
	\\max	time with time zone	time with time zone	a	
	\\max	time without time zone	time without time zone	a	
	\\max	timestamp with time zone	timestamp with time zone	a	
	\\max	timestamp without time zone	timestamp without time zone	a	
	\\max	xid8	xid8	a	
	\\md5	bytea	text	s	
	\\md5	text	text	s	
	\\min	anyarray	anyarray	a	
	\\min	anyenum	anyenum	a	
	\\min	bigint	bigint	a	
	\\min	bytea	bytea	a	
	\\min	character	character	a	
	\\min	date	date	a	
	\\min	double precision	double precision	a	
	\\min	inet	inet	a	
	\\min	integer	integer	a	
	\\min	interval	interval	a	
	\\min	money	money	a	
	\\min	numeric	numeric	a	
	\\min	oid	oid	a	
	\\min	pg_lsn	pg_lsn	a	
	\\min	real	real	a	
	\\min	record	record	a	
	\\min	smallint	smallint	a	
	\\min	text	text	a	
	\\min	tid	tid	a	
	\\min	time with time zone	time with time zone	a	
	\\min	time without time zone	time without time zone	a	
	\\min	timestamp with time zone	timestamp with time zone	a	
	\\min	timestamp without time zone	timestamp without time zone	a	
	\\min	xid8	xid8	a	
	\\min_scale	numeric	integer	s	
	\\mod	bigint,bigint	bigint	s	
	\\mod	integer,integer	integer	s	
	\\mod	numeric,numeric	numeric	s	
	\\mod	smallint,smallint	smallint	s	
	\\mode	anyelement	anyelement	a	
	\\money	bigint	money	s	
	\\money	integer	money	s	
	\\money	numeric	money	s	
	\\mul_d_interval	double precision,interval	interval	s	
	\\multirange	anyrange	anymultirange	s	
	\\multirange_adjacent_multirange	anymultirange,anymultirange	boolean	s	
	\\multirange_adjacent_range	anymultirange,anyrange	boolean	s	
	\\multirange_after_multirange	anymultirange,anymultirange	boolean	s	
	\\multirange_after_range	anymultirange,anyrange	boolean	s	
	\\multirange_before_multirange	anymultirange,anymultirange	boolean	s	
	\\multirange_before_range	anymultirange,anyrange	boolean	s	
	\\multirange_cmp	anymultirange,anymultirange	integer	s	
	\\multirange_contained_by_multirange	anymultirange,anymultirange	boolean	s	
	\\multirange_contained_by_range	anymultirange,anyrange	boolean	s	
	\\multirange_contains_elem	anymultirange,anyelement	boolean	s	
	\\multirange_contains_multirange	anymultirange,anymultirange	boolean	s	
	\\multirange_contains_range	anymultirange,anyrange	boolean	s	
	\\multirange_eq	anymultirange,anymultirange	boolean	s	
	\\multirange_ge	anymultirange,anymultirange	boolean	s	
	\\multirange_gt	anymultirange,anymultirange	boolean	s	
	\\multirange_intersect	anymultirange,anymultirange	anymultirange	s	
	\\multirange_intersect_agg_transfn	anymultirange,anymultirange	anymultirange	s	
	\\multirange_le	anymultirange,anymultirange	boolean	s	
	\\multirange_lt	anymultirange,anymultirange	boolean	s	
	\\multirange_minus	anymultirange,anymultirange	anymultirange	s	
	\\multirange_ne	anymultirange,anymultirange	boolean	s	
	\\multirange_overlaps_multirange	anymultirange,anymultirange	boolean	s	
	\\multirange_overlaps_range	anymultirange,anyrange	boolean	s	
	\\multirange_overleft_multirange	anymultirange,anymultirange	boolean	s	
	\\multirange_overleft_range	anymultirange,anyrange	boolean	s	
	\\multirange_overright_multirange	anymultirange,anymultirange	boolean	s	
	\\multirange_overright_range	anymultirange,anyrange	boolean	s	
	\\multirange_send	anymultirange	bytea	s	
	\\multirange_union	anymultirange,anymultirange	anymultirange	s	
	\\mxid_age	xid	integer	s	
	\\name	character	name	s	
	\\name	character varying	name	s	
	\\name	text	name	s	
	\\nameconcatoid	name,oid	name	s	
	\\nameeq	name,name	boolean	s	
	\\nameeqtext	name,text	boolean	s	
	\\namege	name,name	boolean	s	
	\\namegetext	name,text	boolean	s	
	\\namegt	name,name	boolean	s	
	\\namegttext	name,text	boolean	s	
	\\nameiclike	name,text	boolean	s	
	\\nameicnlike	name,text	boolean	s	
	\\nameicregexeq	name,text	boolean	s	
	\\nameicregexne	name,text	boolean	s	
	\\namele	name,name	boolean	s	
	\\nameletext	name,text	boolean	s	
	\\namelike	name,text	boolean	s	
	\\namelt	name,name	boolean	s	
	\\namelttext	name,text	boolean	s	
	\\namene	name,name	boolean	s	
	\\namenetext	name,text	boolean	s	
	\\namenlike	name,text	boolean	s	
	\\nameregexeq	name,text	boolean	s	
	\\nameregexne	name,text	boolean	s	
	\\namesend	name	bytea	s	
	\\netmask	inet	inet	s	
	\\network	inet	cidr	s	
	\\network_cmp	inet,inet	integer	s	
	\\network_eq	inet,inet	boolean	s	
	\\network_ge	inet,inet	boolean	s	
	\\network_gt	inet,inet	boolean	s	
	\\network_larger	inet,inet	inet	s	
	\\network_le	inet,inet	boolean	s	
	\\network_lt	inet,inet	boolean	s	
	\\network_ne	inet,inet	boolean	s	
	\\network_overlap	inet,inet	boolean	s	
	\\network_smaller	inet,inet	inet	s	
	\\network_sub	inet,inet	boolean	s	
	\\network_subeq	inet,inet	boolean	s	
	\\network_sup	inet,inet	boolean	s	
	\\network_supeq	inet,inet	boolean	s	
	\\nextval	regclass	bigint	s	
	\\normalize	text,text	text	sd1	
	\\notlike	bytea,bytea	boolean	s	
	\\notlike	name,text	boolean	s	
	\\notlike	text,text	boolean	s	
	\\now		timestamp with time zone	s	
	\\npoints	path	integer	s	
	\\npoints	polygon	integer	s	
	\\nth_value	anyelement,integer	anyelement	sw	
	\\ntile	integer	integer	sw	
	\\num_nonnulls	any	integer	v	
	\\num_nulls	any	integer	v	
	\\numeric	bigint	numeric	s	
	\\numeric	double precision	numeric	s	
	\\numeric	integer	numeric	s	
	\\numeric	jsonb	numeric	s	
	\\numeric	money	numeric	s	
	\\numeric	numeric,integer	numeric	s	
	\\numeric	real	numeric	s	
	\\numeric	smallint	numeric	s	
	\\numeric_abs	numeric	numeric	s	
	\\numeric_add	numeric,numeric	numeric	s	
	\\numeric_cmp	numeric,numeric	integer	s	
	\\numeric_div	numeric,numeric	numeric	s	
	\\numeric_div_trunc	numeric,numeric	numeric	s	
	\\numeric_eq	numeric,numeric	boolean	s	
	\\numeric_exp	numeric	numeric	s	
	\\numeric_ge	numeric,numeric	boolean	s	
	\\numeric_gt	numeric,numeric	boolean	s	
	\\numeric_inc	numeric	numeric	s	
	\\numeric_larger	numeric,numeric	numeric	s	
	\\numeric_le	numeric,numeric	boolean	s	
	\\numeric_ln	numeric	numeric	s	
	\\numeric_log	numeric,numeric	numeric	s	
	\\numeric_lt	numeric,numeric	boolean	s	
	\\numeric_mod	numeric,numeric	numeric	s	
	\\numeric_mul	numeric,numeric	numeric	s	
	\\numeric_ne	numeric,numeric	boolean	s	
	\\numeric_pl_pg_lsn	numeric,pg_lsn	pg_lsn	s	
	\\numeric_power	numeric,numeric	numeric	s	
	\\numeric_send	numeric	bytea	s	
	\\numeric_smaller	numeric,numeric	numeric	s	
	\\numeric_sqrt	numeric	numeric	s	
	\\numeric_sub	numeric,numeric	numeric	s	
	\\numeric_uminus	numeric	numeric	s	
	\\numeric_uplus	numeric	numeric	s	
	\\numerictypmodin	cstring[]	integer	s	
	\\nummultirange		nummultirange	s	
	\\nummultirange	numrange	nummultirange	s	
	\\nummultirange	numrange[]	nummultirange	sv	
	\\numnode	tsquery	integer	s	
	\\numrange	numeric,numeric	numrange		
	\\numrange	numeric,numeric,text	numrange		
	\\numrange_subdiff	numeric,numeric	double precision	s	
	\\obj_description	oid	text	s	
	\\obj_description	oid,name	text	s	
	\\octet_length	bit	integer	s	
	\\octet_length	bytea	integer	s	
	\\octet_length	character	integer	s	
	\\octet_length	text	integer	s	
	\\oid	bigint	oid	s	
	\\oideq	oid,oid	boolean	s	
	\\oidge	oid,oid	boolean	s	
	\\oidgt	oid,oid	boolean	s	
	\\oidlarger	oid,oid	oid	s	
	\\oidle	oid,oid	boolean	s	
	\\oidlt	oid,oid	boolean	s	
	\\oidne	oid,oid	boolean	s	
	\\oidsend	oid	bytea	s	
	\\oidsmaller	oid,oid	oid	s	
	\\oidvectoreq	oidvector,oidvector	boolean	s	
	\\oidvectorge	oidvector,oidvector	boolean	s	
	\\oidvectorgt	oidvector,oidvector	boolean	s	
	\\oidvectorle	oidvector,oidvector	boolean	s	
	\\oidvectorlt	oidvector,oidvector	boolean	s	
	\\oidvectorne	oidvector,oidvector	boolean	s	
	\\oidvectorsend	oidvector	bytea	s	
	\\oidvectortypes	oidvector	text	s	
	\\on_pb	point,box	boolean	s	
	\\on_pl	point,line	boolean	s	
	\\on_ppath	point,path	boolean	s	
	\\on_ps	point,lseg	boolean	s	
	\\on_sb	lseg,box	boolean	s	
	\\on_sl	lseg,line	boolean	s	
	\\overlaps	time with time zone,time with time zone,time with time zone,time with time zone	boolean		
	\\overlaps	time without time zone,interval,time without time zone,interval	boolean		
	\\overlaps	time without time zone,interval,time without time zone,time without time zone	boolean		
	\\overlaps	time without time zone,time without time zone,time without time zone,interval	boolean		
	\\overlaps	time without time zone,time without time zone,time without time zone,time without time zone	boolean		
	\\overlaps	timestamp with time zone,interval,timestamp with time zone,interval	boolean		
	\\overlaps	timestamp with time zone,interval,timestamp with time zone,timestamp with time zone	boolean		
	\\overlaps	timestamp with time zone,timestamp with time zone,timestamp with time zone,interval	boolean		
	\\overlaps	timestamp with time zone,timestamp with time zone,timestamp with time zone,timestamp with time zone	boolean		
	\\overlaps	timestamp without time zone,interval,timestamp without time zone,interval	boolean		
	\\overlaps	timestamp without time zone,interval,timestamp without time zone,timestamp without time zone	boolean		
	\\overlaps	timestamp without time zone,timestamp without time zone,timestamp without time zone,interval	boolean		
	\\overlaps	timestamp without time zone,timestamp without time zone,timestamp without time zone,timestamp without time zone	boolean		
	\\overlay	bit,bit,integer	bit	s	
	\\overlay	bit,bit,integer,integer	bit	s	
	\\overlay	bytea,bytea,integer	bytea	s	
	\\overlay	bytea,bytea,integer,integer	bytea	s	
	\\overlay	text,text,integer	text	s	
	\\overlay	text,text,integer,integer	text	s	
	\\parse_ident	text,boolean	text[]	sd1	
	\\path	polygon	path	s	
	\\path_add	path,path	path	s	
	\\path_add_pt	path,point	path	s	
	\\path_contain_pt	path,point	boolean	s	
	\\path_distance	path,path	double precision	s	
	\\path_div_pt	path,point	path	s	
	\\path_inter	path,path	boolean	s	
	\\path_length	path	double precision	s	
	\\path_mul_pt	path,point	path	s	
	\\path_n_eq	path,path	boolean	s	
	\\path_n_ge	path,path	boolean	s	
	\\path_n_gt	path,path	boolean	s	
	\\path_n_le	path,path	boolean	s	
	\\path_n_lt	path,path	boolean	s	
	\\path_npoints	path	integer	s	
	\\path_send	path	bytea	s	
	\\path_sub_pt	path,point	path	s	
	\\pclose	path	path	s	
	\\percent_rank		double precision	w	
	\\percent_rank	any	double precision	av	
	\\percentile_cont	double precision,double precision	double precision	a	
	\\percentile_cont	double precision,interval	interval	a	
	\\percentile_cont	double precision[],double precision	double precision[]	a	
	\\percentile_cont	double precision[],interval	interval[]	a	
	\\percentile_disc	double precision,anyelement	anyelement	a	
	\\percentile_disc	double precision[],anyelement	anyarray	a	
	\\pg_advisory_lock	bigint	void	s	
	\\pg_advisory_lock	integer,integer	void	s	
	\\pg_advisory_lock_shared	bigint	void	s	
	\\pg_advisory_lock_shared	integer,integer	void	s	
	\\pg_advisory_unlock	bigint	boolean	s	
	\\pg_advisory_unlock	integer,integer	boolean	s	
	\\pg_advisory_unlock_all		void	s	
	\\pg_advisory_unlock_shared	bigint	boolean	s	
	\\pg_advisory_unlock_shared	integer,integer	boolean	s	
	\\pg_advisory_xact_lock	bigint	void	s	
	\\pg_advisory_xact_lock	integer,integer	void	s	
	\\pg_advisory_xact_lock_shared	bigint	void	s	
	\\pg_advisory_xact_lock_shared	integer,integer	void	s	
	\\pg_available_extension_versions		record	sr	name:name;version:text;superuser:boolean;trusted:boolean;relocatable:boolean;schema:name;requires:name[];comment:text
	\\pg_available_extensions		record	sr	name:name;default_version:text;comment:text
	\\pg_available_wal_summaries		record	sr	tli:bigint;start_lsn:pg_lsn;end_lsn:pg_lsn
	\\pg_backend_pid		integer	s	
	\\pg_backup_start	text,boolean	pg_lsn	sd1	
	\\pg_backup_stop	boolean	record	sd1	lsn:pg_lsn;labelfile:text;spcmapfile:text
	\\pg_basetype	regtype	regtype	s	
	\\pg_blocking_pids	integer	integer[]	s	
	\\pg_cancel_backend	integer	boolean	s	
	\\pg_char_to_encoding	name	integer	s	
	\\pg_clear_attribute_stats	text,text,text,boolean	void		
	\\pg_clear_relation_stats	text,text	void		
	\\pg_client_encoding		name	s	
	\\pg_collation_actual_version	oid	text	s	
	\\pg_collation_for	any	text		
	\\pg_collation_is_visible	oid	boolean	s	
	\\pg_column_compression	any	text	s	
	\\pg_column_is_updatable	regclass,smallint,boolean	boolean	s	
	\\pg_column_size	any	integer	s	
	\\pg_column_toast_chunk_id	any	oid	s	
	\\pg_conf_load_time		timestamp with time zone	s	
	\\pg_config		record	sr	name:text;setting:text
	\\pg_control_checkpoint		record	s	checkpoint_lsn:pg_lsn;redo_lsn:pg_lsn;redo_wal_file:text;timeline_id:integer;prev_timeline_id:integer;full_page_writes:boolean;next_xid:text;next_oid:oid;next_multixact_id:xid;next_multi_offset:xid;oldest_xid:xid;oldest_xid_dbid:oid;oldest_active_xid:xid;oldest_multi_xid:xid;oldest_multi_dbid:oid;oldest_commit_ts_xid:xid;newest_commit_ts_xid:xid;checkpoint_time:timestamp with time zone
	\\pg_control_init		record	s	max_data_alignment:integer;database_block_size:integer;blocks_per_segment:integer;wal_block_size:integer;bytes_per_wal_segment:integer;max_identifier_length:integer;max_index_columns:integer;max_toast_chunk_size:integer;large_object_chunk_size:integer;float8_pass_by_value:boolean;data_page_checksum_version:integer;default_char_signedness:boolean
	\\pg_control_recovery		record	s	min_recovery_end_lsn:pg_lsn;min_recovery_end_timeline:integer;backup_start_lsn:pg_lsn;backup_end_lsn:pg_lsn;end_of_backup_record_required:boolean
	\\pg_control_system		record	s	pg_control_version:integer;catalog_version_no:integer;system_identifier:bigint;pg_control_last_modified:timestamp with time zone
	\\pg_conversion_is_visible	oid	boolean	s	
	\\pg_copy_logical_replication_slot	name,name	record	s	slot_name:name;lsn:pg_lsn
	\\pg_copy_logical_replication_slot	name,name,boolean	record	s	slot_name:name;lsn:pg_lsn
	\\pg_copy_logical_replication_slot	name,name,boolean,name	record	s	slot_name:name;lsn:pg_lsn
	\\pg_copy_physical_replication_slot	name,name	record	s	slot_name:name;lsn:pg_lsn
	\\pg_copy_physical_replication_slot	name,name,boolean	record	s	slot_name:name;lsn:pg_lsn
	\\pg_create_logical_replication_slot	name,name,boolean,boolean,boolean	record	sd3	slot_name:name;lsn:pg_lsn
	\\pg_create_physical_replication_slot	name,boolean,boolean	record	sd2	slot_name:name;lsn:pg_lsn
	\\pg_create_restore_point	text	pg_lsn	s	
	\\pg_current_logfile		text		
	\\pg_current_logfile	text	text		
	\\pg_current_snapshot		pg_snapshot	s	
	\\pg_current_wal_flush_lsn		pg_lsn	s	
	\\pg_current_wal_insert_lsn		pg_lsn	s	
	\\pg_current_wal_lsn		pg_lsn	s	
	\\pg_current_xact_id		xid8	s	
	\\pg_current_xact_id_if_assigned		xid8	s	
	\\pg_cursor		record	sr	name:text;statement:text;is_holdable:boolean;is_binary:boolean;is_scrollable:boolean;creation_time:timestamp with time zone
	\\pg_database_collation_actual_version	oid	text	s	
	\\pg_database_size	name	bigint	s	
	\\pg_database_size	oid	bigint	s	
	\\pg_dependencies_send	pg_dependencies	bytea	s	
	\\pg_describe_object	oid,oid,integer	text	s	
	\\pg_drop_replication_slot	name	void	s	
	\\pg_encoding_max_length	integer	integer	s	
	\\pg_encoding_to_char	integer	name	s	
	\\pg_event_trigger_ddl_commands		record	sr	classid:oid; objid:oid; objsubid:integer; command_tag:text; object_type:text; schema_name:text; object_identity:text; in_extension:boolean; command:pg_ddl_command
	\\pg_event_trigger_dropped_objects		record	sr	classid:oid; objid:oid; objsubid:integer; original:boolean; normal:boolean; is_temporary:boolean; object_type:text; schema_name:text; object_name:text; object_identity:text; address_names:text[]; address_args:text[]
	\\pg_event_trigger_table_rewrite_oid		oid	s	
	\\pg_event_trigger_table_rewrite_reason		integer	s	
	\\pg_export_snapshot		text	s	
	\\pg_extension_config_dump	regclass,text	void	s	
	\\pg_extension_update_paths	name	record	sr	source:text;target:text;path:text
	\\pg_filenode_relation	oid,oid	regclass	s	
	\\pg_function_is_visible	oid	boolean	s	
	\\pg_get_acl	oid,oid,integer	aclitem[]	s	
	\\pg_get_aios		record	sr	pid:integer;io_id:integer;io_generation:bigint;state:text;operation:text;off:bigint;length:bigint;target:text;handle_data_len:smallint;raw_result:integer;result:text;target_desc:text;f_sync:boolean;f_localmem:boolean;f_buffered:boolean
	\\pg_get_backend_memory_contexts		record	sr	name:text; ident:text; type:text; level:integer; path:integer[]; total_bytes:bigint; total_nblocks:bigint; free_bytes:bigint; free_chunks:bigint; used_bytes:bigint
	\\pg_get_catalog_foreign_keys		record	sr	fktable:regclass;fkcols:text[];pktable:regclass;pkcols:text[];is_array:boolean;is_opt:boolean
	\\pg_get_constraintdef	oid	text	s	
	\\pg_get_constraintdef	oid,boolean	text	s	
	\\pg_get_expr	pg_node_tree,oid	text	s	
	\\pg_get_expr	pg_node_tree,oid,boolean	text	s	
	\\pg_get_function_arg_default	oid,integer	text	s	
	\\pg_get_function_arguments	oid	text	s	
	\\pg_get_function_identity_arguments	oid	text	s	
	\\pg_get_function_result	oid	text	s	
	\\pg_get_function_sqlbody	oid	text	s	
	\\pg_get_functiondef	oid	text	s	
	\\pg_get_indexdef	oid	text	s	
	\\pg_get_indexdef	oid,integer,boolean	text	s	
	\\pg_get_keywords		record	sr	word:text;catcode:char;barelabel:boolean;catdesc:text;baredesc:text
	\\pg_get_loaded_modules		record	sr	module_name:text;version:text;file_name:text
	\\pg_get_multixact_members	xid	record	sr	xid:xid;mode:text
	\\pg_get_object_address	text,text[],text[]	record	s	classid:oid;objid:oid;objsubid:integer
	\\pg_get_partition_constraintdef	oid	text	s	
	\\pg_get_partkeydef	oid	text	s	
	\\pg_get_publication_tables	text[]	record	srv	pubid:oid;relid:oid;attrs:int2vector;qual:pg_node_tree
	\\pg_get_replica_identity_index	regclass	regclass	s	
	\\pg_get_replication_slots		record	r	slot_name:name;plugin:name;slot_type:text;datoid:oid;temporary:boolean;active:boolean;active_pid:integer;xmin:xid;catalog_xmin:xid;restart_lsn:pg_lsn;confirmed_flush_lsn:pg_lsn;wal_status:text;safe_wal_size:bigint;two_phase:boolean;two_phase_at:pg_lsn;inactive_since:timestamp with time zone;conflicting:boolean;invalidation_reason:text;failover:boolean;synced:boolean
	\\pg_get_ruledef	oid	text	s	
	\\pg_get_ruledef	oid,boolean	text	s	
	\\pg_get_sequence_data	regclass	record	s	last_value:bigint;is_called:boolean
	\\pg_get_serial_sequence	text,text	text	s	
	\\pg_get_shmem_allocations		record	sr	name:text;off:bigint;size:bigint;allocated_size:bigint
	\\pg_get_shmem_allocations_numa		record	sr	name:text;numa_node:integer;size:bigint
	\\pg_get_statisticsobjdef	oid	text	s	
	\\pg_get_statisticsobjdef_columns	oid	text	s	
	\\pg_get_statisticsobjdef_expressions	oid	text[]	s	
	\\pg_get_triggerdef	oid	text	s	
	\\pg_get_triggerdef	oid,boolean	text	s	
	\\pg_get_userbyid	oid	name	s	
	\\pg_get_viewdef	oid	text	s	
	\\pg_get_viewdef	oid,boolean	text	s	
	\\pg_get_viewdef	oid,integer	text	s	
	\\pg_get_viewdef	text	text	s	
	\\pg_get_viewdef	text,boolean	text	s	
	\\pg_get_wait_events		record	sr	type:text;name:text;description:text
	\\pg_get_wal_replay_pause_state		text	s	
	\\pg_get_wal_resource_managers		record	sr	rm_id:integer; rm_name:text; rm_builtin:boolean
	\\pg_get_wal_summarizer_state		record	s	summarized_tli:bigint;summarized_lsn:pg_lsn;pending_lsn:pg_lsn;summarizer_pid:integer
	\\pg_has_role	name,name,text	boolean	s	
	\\pg_has_role	name,oid,text	boolean	s	
	\\pg_has_role	name,text	boolean	s	
	\\pg_has_role	oid,name,text	boolean	s	
	\\pg_has_role	oid,oid,text	boolean	s	
	\\pg_has_role	oid,text	boolean	s	
	\\pg_hba_file_rules		record	sr	rule_number:integer;file_name:text;line_number:integer;type:text;database:text[];user_name:text[];address:text;netmask:text;auth_method:text;options:text[];error:text
	\\pg_ident_file_mappings		record	sr	map_number:integer;file_name:text;line_number:integer;map_name:text;sys_name:text;pg_username:text;error:text
	\\pg_identify_object	oid,oid,integer	record	s	type:text;schema:text;name:text;identity:text
	\\pg_identify_object_as_address	oid,oid,integer	record	s	type:text;object_names:text[];object_args:text[]
	\\pg_import_system_collations	regnamespace	integer	s	
	\\pg_index_column_has_property	regclass,integer,text	boolean	s	
	\\pg_index_has_property	regclass,text	boolean	s	
	\\pg_indexam_has_property	oid,text	boolean	s	
	\\pg_indexam_progress_phasename	oid,bigint	text	s	
	\\pg_indexes_size	regclass	bigint	s	
	\\pg_input_error_info	text,text	record	s	message:text;detail:text;hint:text;sql_error_code:text
	\\pg_input_is_valid	text,text	boolean	s	
	\\pg_is_in_recovery		boolean	s	
	\\pg_is_other_temp_schema	oid	boolean	s	
	\\pg_is_wal_replay_paused		boolean	s	
	\\pg_isolation_test_session_is_blocked	integer,integer[]	boolean	s	
	\\pg_jit_available		boolean	s	
	\\pg_last_committed_xact		record	s	xid:xid;timestamp:timestamp with time zone;roident:oid
	\\pg_last_wal_receive_lsn		pg_lsn	s	
	\\pg_last_wal_replay_lsn		pg_lsn	s	
	\\pg_last_xact_replay_timestamp		timestamp with time zone	s	
	\\pg_listening_channels		text	sr	
	\\pg_lock_status		record	sr	locktype:text;database:oid;relation:oid;page:integer;tuple:smallint;virtualxid:text;transactionid:xid;classid:oid;objid:oid;objsubid:smallint;virtualtransaction:text;pid:integer;mode:text;granted:boolean;fastpath:boolean;waitstart:timestamp with time zone
	\\pg_log_backend_memory_contexts	integer	boolean	s	
	\\pg_log_standby_snapshot		pg_lsn	s	
	\\pg_logical_emit_message	boolean,text,bytea,boolean	pg_lsn	sd1	
	\\pg_logical_emit_message	boolean,text,text,boolean	pg_lsn	sd1	
	\\pg_logical_slot_get_binary_changes	name,pg_lsn,integer,text[]	record	rvd1	lsn:pg_lsn;xid:xid;data:bytea
	\\pg_logical_slot_get_changes	name,pg_lsn,integer,text[]	record	rvd1	lsn:pg_lsn;xid:xid;data:text
	\\pg_logical_slot_peek_binary_changes	name,pg_lsn,integer,text[]	record	rvd1	lsn:pg_lsn;xid:xid;data:bytea
	\\pg_logical_slot_peek_changes	name,pg_lsn,integer,text[]	record	rvd1	lsn:pg_lsn;xid:xid;data:text
	\\pg_ls_archive_statusdir		record	sr	name:text;size:bigint;modification:timestamp with time zone
	\\pg_ls_dir	text	text	sr	
	\\pg_ls_dir	text,boolean,boolean	text	sr	
	\\pg_ls_logdir		record	sr	name:text;size:bigint;modification:timestamp with time zone
	\\pg_ls_logicalmapdir		record	sr	name:text;size:bigint;modification:timestamp with time zone
	\\pg_ls_logicalsnapdir		record	sr	name:text;size:bigint;modification:timestamp with time zone
	\\pg_ls_replslotdir	text	record	sr	name:text;size:bigint;modification:timestamp with time zone
	\\pg_ls_summariesdir		record	sr	name:text;size:bigint;modification:timestamp with time zone
	\\pg_ls_tmpdir		record	sr	name:text;size:bigint;modification:timestamp with time zone
	\\pg_ls_tmpdir	oid	record	sr	name:text;size:bigint;modification:timestamp with time zone
	\\pg_ls_waldir		record	sr	name:text;size:bigint;modification:timestamp with time zone
	\\pg_lsn	numeric	pg_lsn	s	
	\\pg_lsn_cmp	pg_lsn,pg_lsn	integer	s	
	\\pg_lsn_eq	pg_lsn,pg_lsn	boolean	s	
	\\pg_lsn_ge	pg_lsn,pg_lsn	boolean	s	
	\\pg_lsn_gt	pg_lsn,pg_lsn	boolean	s	
	\\pg_lsn_hash	pg_lsn	integer	s	
	\\pg_lsn_hash_extended	pg_lsn,bigint	bigint	s	
	\\pg_lsn_larger	pg_lsn,pg_lsn	pg_lsn	s	
	\\pg_lsn_le	pg_lsn,pg_lsn	boolean	s	
	\\pg_lsn_lt	pg_lsn,pg_lsn	boolean	s	
	\\pg_lsn_mi	pg_lsn,pg_lsn	numeric	s	
	\\pg_lsn_mii	pg_lsn,numeric	pg_lsn	s	
	\\pg_lsn_ne	pg_lsn,pg_lsn	boolean	s	
	\\pg_lsn_pli	pg_lsn,numeric	pg_lsn	s	
	\\pg_lsn_send	pg_lsn	bytea	s	
	\\pg_lsn_smaller	pg_lsn,pg_lsn	pg_lsn	s	
	\\pg_mcv_list_items	pg_mcv_list	record	sr	index:integer;values:text[];nulls:boolean[];frequency:double precision;base_frequency:double precision
	\\pg_mcv_list_send	pg_mcv_list	bytea	s	
	\\pg_my_temp_schema		oid	s	
	\\pg_ndistinct_send	pg_ndistinct	bytea	s	
	\\pg_nextoid	regclass,name,regclass	oid	s	
	\\pg_node_tree_send	pg_node_tree	bytea	s	
	\\pg_notification_queue_usage		double precision	s	
	\\pg_notify	text,text	void		
	\\pg_numa_available		boolean	s	
	\\pg_opclass_is_visible	oid	boolean	s	
	\\pg_operator_is_visible	oid	boolean	s	
	\\pg_opfamily_is_visible	oid	boolean	s	
	\\pg_options_to_table	text[]	record	sr	option_name:text;option_value:text
	\\pg_partition_ancestors	regclass	regclass	sr	
	\\pg_partition_root	regclass	regclass	s	
	\\pg_partition_tree	regclass	record	sr	relid:regclass;parentrelid:regclass;isleaf:boolean;level:integer
	\\pg_postmaster_start_time		timestamp with time zone	s	
	\\pg_prepared_statement		record	sr	name:text;statement:text;prepare_time:timestamp with time zone;parameter_types:regtype[];result_types:regtype[];from_sql:boolean;generic_plans:bigint;custom_plans:bigint
	\\pg_prepared_xact		record	sr	transaction:xid;gid:text;prepared:timestamp with time zone;ownerid:oid;dbid:oid
	\\pg_promote	boolean,integer	boolean	sd2	
	\\pg_read_binary_file	text	bytea	s	
	\\pg_read_binary_file	text,bigint,bigint	bytea	s	
	\\pg_read_binary_file	text,bigint,bigint,boolean	bytea	s	
	\\pg_read_binary_file	text,boolean	bytea	s	
	\\pg_read_file	text	text	s	
	\\pg_read_file	text,bigint,bigint	text	s	
	\\pg_read_file	text,bigint,bigint,boolean	text	s	
	\\pg_read_file	text,boolean	text	s	
	\\pg_relation_filenode	regclass	oid	s	
	\\pg_relation_filepath	regclass	text	s	
	\\pg_relation_is_publishable	regclass	boolean	s	
	\\pg_relation_is_updatable	regclass,boolean	integer	s	
	\\pg_relation_size	regclass	bigint	s	
	\\pg_relation_size	regclass,text	bigint	s	
	\\pg_reload_conf		boolean	s	
	\\pg_replication_origin_advance	text,pg_lsn	void	s	
	\\pg_replication_origin_create	text	oid	s	
	\\pg_replication_origin_drop	text	void	s	
	\\pg_replication_origin_oid	text	oid	s	
	\\pg_replication_origin_progress	text,boolean	pg_lsn	s	
	\\pg_replication_origin_session_is_setup		boolean	s	
	\\pg_replication_origin_session_progress	boolean	pg_lsn	s	
	\\pg_replication_origin_session_reset		void	s	
	\\pg_replication_origin_session_setup	text	void	s	
	\\pg_replication_origin_xact_reset		void	s	
	\\pg_replication_origin_xact_setup	pg_lsn,timestamp with time zone	void	s	
	\\pg_replication_slot_advance	name,pg_lsn	record	s	slot_name:name;end_lsn:pg_lsn
	\\pg_restore_attribute_stats	any	boolean	v	
	\\pg_restore_relation_stats	any	boolean	v	
	\\pg_rotate_logfile		boolean	s	
	\\pg_safe_snapshot_blocking_pids	integer	integer[]	s	
	\\pg_sequence_last_value	regclass	bigint	s	
	\\pg_sequence_parameters	oid	record	s	start_value:bigint;minimum_value:bigint;maximum_value:bigint;increment:bigint;cycle_option:boolean;cache_size:bigint;data_type:oid
	\\pg_settings_get_flags	text	text[]	s	
	\\pg_show_all_file_settings		record	sr	sourcefile:text;sourceline:integer;seqno:integer;name:text;setting:text;applied:boolean;error:text
	\\pg_show_all_settings		record	sr	name:text;setting:text;unit:text;category:text;short_desc:text;extra_desc:text;context:text;vartype:text;source:text;min_val:text;max_val:text;enumvals:text[];boot_val:text;reset_val:text;sourcefile:text;sourceline:integer;pending_restart:boolean
	\\pg_show_replication_origin_status		record	r	local_id:oid; external_id:text; remote_lsn:pg_lsn; local_lsn:pg_lsn
	\\pg_size_bytes	text	bigint	s	
	\\pg_size_pretty	bigint	text	s	
	\\pg_size_pretty	numeric	text	s	
	\\pg_sleep	double precision	void	s	
	\\pg_sleep_for	interval	void	s	
	\\pg_sleep_until	timestamp with time zone	void	s	
	\\pg_snapshot_send	pg_snapshot	bytea	s	
	\\pg_snapshot_xip	pg_snapshot	xid8	sr	
	\\pg_snapshot_xmax	pg_snapshot	xid8	s	
	\\pg_snapshot_xmin	pg_snapshot	xid8	s	
	\\pg_split_walfile_name	text	record	s	segment_number:numeric;timeline_id:bigint
	\\pg_stat_clear_snapshot		void		
	\\pg_stat_file	text	record	s	size:bigint;access:timestamp with time zone;modification:timestamp with time zone;change:timestamp with time zone;creation:timestamp with time zone;isdir:boolean
	\\pg_stat_file	text,boolean	record	s	size:bigint;access:timestamp with time zone;modification:timestamp with time zone;change:timestamp with time zone;creation:timestamp with time zone;isdir:boolean
	\\pg_stat_force_next_flush		void		
	\\pg_stat_get_activity	integer	record	r	datid:oid;pid:integer;usesysid:oid;application_name:text;state:text;query:text;wait_event_type:text;wait_event:text;xact_start:timestamp with time zone;query_start:timestamp with time zone;backend_start:timestamp with time zone;state_change:timestamp with time zone;client_addr:inet;client_hostname:text;client_port:integer;backend_xid:xid;backend_xmin:xid;backend_type:text;ssl:boolean;sslversion:text;sslcipher:text;sslbits:integer;ssl_client_dn:text;ssl_client_serial:numeric;ssl_issuer_dn:text;gss_auth:boolean;gss_princ:text;gss_enc:boolean;gss_delegation:boolean;leader_pid:integer;query_id:bigint
	\\pg_stat_get_analyze_count	oid	bigint	s	
	\\pg_stat_get_archiver		record		archived_count:bigint;last_archived_wal:text;last_archived_time:timestamp with time zone;failed_count:bigint;last_failed_wal:text;last_failed_time:timestamp with time zone;stats_reset:timestamp with time zone
	\\pg_stat_get_autoanalyze_count	oid	bigint	s	
	\\pg_stat_get_autovacuum_count	oid	bigint	s	
	\\pg_stat_get_backend_activity	integer	text	s	
	\\pg_stat_get_backend_activity_start	integer	timestamp with time zone	s	
	\\pg_stat_get_backend_client_addr	integer	inet	s	
	\\pg_stat_get_backend_client_port	integer	integer	s	
	\\pg_stat_get_backend_dbid	integer	oid	s	
	\\pg_stat_get_backend_idset		integer	sr	
	\\pg_stat_get_backend_io	integer	record	sr	backend_type:text;object:text;context:text;reads:bigint;read_bytes:numeric;read_time:double precision;writes:bigint;write_bytes:numeric;write_time:double precision;writebacks:bigint;writeback_time:double precision;extends:bigint;extend_bytes:numeric;extend_time:double precision;hits:bigint;evictions:bigint;reuses:bigint;fsyncs:bigint;fsync_time:double precision;stats_reset:timestamp with time zone
	\\pg_stat_get_backend_pid	integer	integer	s	
	\\pg_stat_get_backend_start	integer	timestamp with time zone	s	
	\\pg_stat_get_backend_subxact	integer	record	s	subxact_count:integer;subxact_overflowed:boolean
	\\pg_stat_get_backend_userid	integer	oid	s	
	\\pg_stat_get_backend_wait_event	integer	text	s	
	\\pg_stat_get_backend_wait_event_type	integer	text	s	
	\\pg_stat_get_backend_wal	integer	record	s	wal_records:bigint;wal_fpi:bigint;wal_bytes:numeric;wal_buffers_full:bigint;stats_reset:timestamp with time zone
	\\pg_stat_get_backend_xact_start	integer	timestamp with time zone	s	
	\\pg_stat_get_bgwriter_buf_written_clean		bigint	s	
	\\pg_stat_get_bgwriter_maxwritten_clean		bigint	s	
	\\pg_stat_get_bgwriter_stat_reset_time		timestamp with time zone	s	
	\\pg_stat_get_blocks_fetched	oid	bigint	s	
	\\pg_stat_get_blocks_hit	oid	bigint	s	
	\\pg_stat_get_buf_alloc		bigint	s	
	\\pg_stat_get_checkpointer_buffers_written		bigint	s	
	\\pg_stat_get_checkpointer_num_performed		bigint	s	
	\\pg_stat_get_checkpointer_num_requested		bigint	s	
	\\pg_stat_get_checkpointer_num_timed		bigint	s	
	\\pg_stat_get_checkpointer_restartpoints_performed		bigint	s	
	\\pg_stat_get_checkpointer_restartpoints_requested		bigint	s	
	\\pg_stat_get_checkpointer_restartpoints_timed		bigint	s	
	\\pg_stat_get_checkpointer_slru_written		bigint	s	
	\\pg_stat_get_checkpointer_stat_reset_time		timestamp with time zone	s	
	\\pg_stat_get_checkpointer_sync_time		double precision	s	
	\\pg_stat_get_checkpointer_write_time		double precision	s	
	\\pg_stat_get_db_active_time	oid	double precision	s	
	\\pg_stat_get_db_blk_read_time	oid	double precision	s	
	\\pg_stat_get_db_blk_write_time	oid	double precision	s	
	\\pg_stat_get_db_blocks_fetched	oid	bigint	s	
	\\pg_stat_get_db_blocks_hit	oid	bigint	s	
	\\pg_stat_get_db_checksum_failures	oid	bigint	s	
	\\pg_stat_get_db_checksum_last_failure	oid	timestamp with time zone	s	
	\\pg_stat_get_db_conflict_all	oid	bigint	s	
	\\pg_stat_get_db_conflict_bufferpin	oid	bigint	s	
	\\pg_stat_get_db_conflict_lock	oid	bigint	s	
	\\pg_stat_get_db_conflict_logicalslot	oid	bigint	s	
	\\pg_stat_get_db_conflict_snapshot	oid	bigint	s	
	\\pg_stat_get_db_conflict_startup_deadlock	oid	bigint	s	
	\\pg_stat_get_db_conflict_tablespace	oid	bigint	s	
	\\pg_stat_get_db_deadlocks	oid	bigint	s	
	\\pg_stat_get_db_idle_in_transaction_time	oid	double precision	s	
	\\pg_stat_get_db_numbackends	oid	integer	s	
	\\pg_stat_get_db_parallel_workers_launched	oid	bigint	s	
	\\pg_stat_get_db_parallel_workers_to_launch	oid	bigint	s	
	\\pg_stat_get_db_session_time	oid	double precision	s	
	\\pg_stat_get_db_sessions	oid	bigint	s	
	\\pg_stat_get_db_sessions_abandoned	oid	bigint	s	
	\\pg_stat_get_db_sessions_fatal	oid	bigint	s	
	\\pg_stat_get_db_sessions_killed	oid	bigint	s	
	\\pg_stat_get_db_stat_reset_time	oid	timestamp with time zone	s	
	\\pg_stat_get_db_temp_bytes	oid	bigint	s	
	\\pg_stat_get_db_temp_files	oid	bigint	s	
	\\pg_stat_get_db_tuples_deleted	oid	bigint	s	
	\\pg_stat_get_db_tuples_fetched	oid	bigint	s	
	\\pg_stat_get_db_tuples_inserted	oid	bigint	s	
	\\pg_stat_get_db_tuples_returned	oid	bigint	s	
	\\pg_stat_get_db_tuples_updated	oid	bigint	s	
	\\pg_stat_get_db_xact_commit	oid	bigint	s	
	\\pg_stat_get_db_xact_rollback	oid	bigint	s	
	\\pg_stat_get_dead_tuples	oid	bigint	s	
	\\pg_stat_get_function_calls	oid	bigint	s	
	\\pg_stat_get_function_self_time	oid	double precision	s	
	\\pg_stat_get_function_total_time	oid	double precision	s	
	\\pg_stat_get_ins_since_vacuum	oid	bigint	s	
	\\pg_stat_get_io		record	sr	backend_type:text;object:text;context:text;reads:bigint;read_bytes:numeric;read_time:double precision;writes:bigint;write_bytes:numeric;write_time:double precision;writebacks:bigint;writeback_time:double precision;extends:bigint;extend_bytes:numeric;extend_time:double precision;hits:bigint;evictions:bigint;reuses:bigint;fsyncs:bigint;fsync_time:double precision;stats_reset:timestamp with time zone
	\\pg_stat_get_last_analyze_time	oid	timestamp with time zone	s	
	\\pg_stat_get_last_autoanalyze_time	oid	timestamp with time zone	s	
	\\pg_stat_get_last_autovacuum_time	oid	timestamp with time zone	s	
	\\pg_stat_get_last_vacuum_time	oid	timestamp with time zone	s	
	\\pg_stat_get_lastscan	oid	timestamp with time zone	s	
	\\pg_stat_get_live_tuples	oid	bigint	s	
	\\pg_stat_get_mod_since_analyze	oid	bigint	s	
	\\pg_stat_get_numscans	oid	bigint	s	
	\\pg_stat_get_progress_info	text	record	sr	pid:integer;datid:oid;relid:oid;param1:bigint;param2:bigint;param3:bigint;param4:bigint;param5:bigint;param6:bigint;param7:bigint;param8:bigint;param9:bigint;param10:bigint;param11:bigint;param12:bigint;param13:bigint;param14:bigint;param15:bigint;param16:bigint;param17:bigint;param18:bigint;param19:bigint;param20:bigint
	\\pg_stat_get_recovery_prefetch		record	sr	stats_reset:timestamp with time zone;prefetch:bigint;hit:bigint;skip_init:bigint;skip_new:bigint;skip_fpw:bigint;skip_rep:bigint;wal_distance:integer;block_distance:integer;io_depth:integer
	\\pg_stat_get_replication_slot	text	record	s	slot_name:text;spill_txns:bigint;spill_count:bigint;spill_bytes:bigint;stream_txns:bigint;stream_count:bigint;stream_bytes:bigint;total_txns:bigint;total_bytes:bigint;stats_reset:timestamp with time zone
	\\pg_stat_get_slru		record	r	name:text;blks_zeroed:bigint;blks_hit:bigint;blks_read:bigint;blks_written:bigint;blks_exists:bigint;flushes:bigint;truncates:bigint;stats_reset:timestamp with time zone
	\\pg_stat_get_snapshot_timestamp		timestamp with time zone	s	
	\\pg_stat_get_subscription	oid	record	r	subid:oid;relid:oid;pid:integer;leader_pid:integer;received_lsn:pg_lsn;last_msg_send_time:timestamp with time zone;last_msg_receipt_time:timestamp with time zone;latest_end_lsn:pg_lsn;latest_end_time:timestamp with time zone;worker_type:text
	\\pg_stat_get_subscription_stats	oid	record	s	subid:oid;apply_error_count:bigint;sync_error_count:bigint;confl_insert_exists:bigint;confl_update_origin_differs:bigint;confl_update_exists:bigint;confl_update_missing:bigint;confl_delete_origin_differs:bigint;confl_delete_missing:bigint;confl_multiple_unique_conflicts:bigint;stats_reset:timestamp with time zone
	\\pg_stat_get_total_analyze_time	oid	double precision	s	
	\\pg_stat_get_total_autoanalyze_time	oid	double precision	s	
	\\pg_stat_get_total_autovacuum_time	oid	double precision	s	
	\\pg_stat_get_total_vacuum_time	oid	double precision	s	
	\\pg_stat_get_tuples_deleted	oid	bigint	s	
	\\pg_stat_get_tuples_fetched	oid	bigint	s	
	\\pg_stat_get_tuples_hot_updated	oid	bigint	s	
	\\pg_stat_get_tuples_inserted	oid	bigint	s	
	\\pg_stat_get_tuples_newpage_updated	oid	bigint	s	
	\\pg_stat_get_tuples_returned	oid	bigint	s	
	\\pg_stat_get_tuples_updated	oid	bigint	s	
	\\pg_stat_get_vacuum_count	oid	bigint	s	
	\\pg_stat_get_wal		record		wal_records:bigint;wal_fpi:bigint;wal_bytes:numeric;wal_buffers_full:bigint;stats_reset:timestamp with time zone
	\\pg_stat_get_wal_receiver		record		pid:integer;status:text;receive_start_lsn:pg_lsn;receive_start_tli:integer;written_lsn:pg_lsn;flushed_lsn:pg_lsn;received_tli:integer;last_msg_send_time:timestamp with time zone;last_msg_receipt_time:timestamp with time zone;latest_end_lsn:pg_lsn;latest_end_time:timestamp with time zone;slot_name:text;sender_host:text;sender_port:integer;conninfo:text
	\\pg_stat_get_wal_senders		record	r	pid:integer;state:text;sent_lsn:pg_lsn;write_lsn:pg_lsn;flush_lsn:pg_lsn;replay_lsn:pg_lsn;write_lag:interval;flush_lag:interval;replay_lag:interval;sync_priority:integer;sync_state:text;reply_time:timestamp with time zone
	\\pg_stat_get_xact_blocks_fetched	oid	bigint	s	
	\\pg_stat_get_xact_blocks_hit	oid	bigint	s	
	\\pg_stat_get_xact_function_calls	oid	bigint	s	
	\\pg_stat_get_xact_function_self_time	oid	double precision	s	
	\\pg_stat_get_xact_function_total_time	oid	double precision	s	
	\\pg_stat_get_xact_numscans	oid	bigint	s	
	\\pg_stat_get_xact_tuples_deleted	oid	bigint	s	
	\\pg_stat_get_xact_tuples_fetched	oid	bigint	s	
	\\pg_stat_get_xact_tuples_hot_updated	oid	bigint	s	
	\\pg_stat_get_xact_tuples_inserted	oid	bigint	s	
	\\pg_stat_get_xact_tuples_newpage_updated	oid	bigint	s	
	\\pg_stat_get_xact_tuples_returned	oid	bigint	s	
	\\pg_stat_get_xact_tuples_updated	oid	bigint	s	
	\\pg_stat_have_stats	text,oid,bigint	boolean	s	
	\\pg_stat_reset		void		
	\\pg_stat_reset_backend_stats	integer	void	s	
	\\pg_stat_reset_replication_slot	text	void		
	\\pg_stat_reset_shared	text	void	d1	
	\\pg_stat_reset_single_function_counters	oid	void	s	
	\\pg_stat_reset_single_table_counters	oid	void	s	
	\\pg_stat_reset_slru	text	void	d1	
	\\pg_stat_reset_subscription_stats	oid	void		
	\\pg_statistics_obj_is_visible	oid	boolean	s	
	\\pg_stop_making_pinned_objects		void	s	
	\\pg_switch_wal		pg_lsn	s	
	\\pg_sync_replication_slots		void	s	
	\\pg_table_is_visible	oid	boolean	s	
	\\pg_table_size	regclass	bigint	s	
	\\pg_tablespace_databases	oid	oid	sr	
	\\pg_tablespace_location	oid	text	s	
	\\pg_tablespace_size	name	bigint	s	
	\\pg_tablespace_size	oid	bigint	s	
	\\pg_terminate_backend	integer,bigint	boolean	sd1	
	\\pg_timezone_abbrevs_abbrevs		record	sr	abbrev:text;utc_offset:interval;is_dst:boolean
	\\pg_timezone_abbrevs_zone		record	sr	abbrev:text;utc_offset:interval;is_dst:boolean
	\\pg_timezone_names		record	sr	name:text;abbrev:text;utc_offset:interval;is_dst:boolean
	\\pg_total_relation_size	regclass	bigint	s	
	\\pg_trigger_depth		integer	s	
	\\pg_try_advisory_lock	bigint	boolean	s	
	\\pg_try_advisory_lock	integer,integer	boolean	s	
	\\pg_try_advisory_lock_shared	bigint	boolean	s	
	\\pg_try_advisory_lock_shared	integer,integer	boolean	s	
	\\pg_try_advisory_xact_lock	bigint	boolean	s	
	\\pg_try_advisory_xact_lock	integer,integer	boolean	s	
	\\pg_try_advisory_xact_lock_shared	bigint	boolean	s	
	\\pg_try_advisory_xact_lock_shared	integer,integer	boolean	s	
	\\pg_ts_config_is_visible	oid	boolean	s	
	\\pg_ts_dict_is_visible	oid	boolean	s	
	\\pg_ts_parser_is_visible	oid	boolean	s	
	\\pg_ts_template_is_visible	oid	boolean	s	
	\\pg_type_is_visible	oid	boolean	s	
	\\pg_typeof	any	regtype		
	\\pg_visible_in_snapshot	xid8,pg_snapshot	boolean	s	
	\\pg_wal_lsn_diff	pg_lsn,pg_lsn	numeric	s	
	\\pg_wal_replay_pause		void	s	
	\\pg_wal_replay_resume		void	s	
	\\pg_wal_summary_contents	bigint,pg_lsn,pg_lsn	record	sr	relfilenode:oid;reltablespace:oid;reldatabase:oid;relforknumber:smallint;relblocknumber:bigint;is_limit_block:boolean
	\\pg_walfile_name	pg_lsn	text	s	
	\\pg_walfile_name_offset	pg_lsn	record	s	file_name:text;file_offset:integer
	\\pg_xact_commit_timestamp	xid	timestamp with time zone	s	
	\\pg_xact_commit_timestamp_origin	xid	record	s	timestamp:timestamp with time zone;roident:oid
	\\pg_xact_status	xid8	text	s	
	\\phraseto_tsquery	regconfig,text	tsquery	s	
	\\phraseto_tsquery	text	tsquery	s	
	\\pi		double precision	s	
	\\plainto_tsquery	regconfig,text	tsquery	s	
	\\plainto_tsquery	text	tsquery	s	
	\\point	box	point	s	
	\\point	circle	point	s	
	\\point	double precision,double precision	point	s	
	\\point	lseg	point	s	
	\\point	polygon	point	s	
	\\point_above	point,point	boolean	s	
	\\point_add	point,point	point	s	
	\\point_below	point,point	boolean	s	
	\\point_distance	point,point	double precision	s	
	\\point_div	point,point	point	s	
	\\point_eq	point,point	boolean	s	
	\\point_horiz	point,point	boolean	s	
	\\point_left	point,point	boolean	s	
	\\point_mul	point,point	point	s	
	\\point_ne	point,point	boolean	s	
	\\point_right	point,point	boolean	s	
	\\point_send	point	bytea	s	
	\\point_sub	point,point	point	s	
	\\point_vert	point,point	boolean	s	
	\\poly_above	polygon,polygon	boolean	s	
	\\poly_below	polygon,polygon	boolean	s	
	\\poly_center	polygon	point	s	
	\\poly_contain	polygon,polygon	boolean	s	
	\\poly_contain_pt	polygon,point	boolean	s	
	\\poly_contained	polygon,polygon	boolean	s	
	\\poly_distance	polygon,polygon	double precision	s	
	\\poly_left	polygon,polygon	boolean	s	
	\\poly_npoints	polygon	integer	s	
	\\poly_overabove	polygon,polygon	boolean	s	
	\\poly_overbelow	polygon,polygon	boolean	s	
	\\poly_overlap	polygon,polygon	boolean	s	
	\\poly_overleft	polygon,polygon	boolean	s	
	\\poly_overright	polygon,polygon	boolean	s	
	\\poly_right	polygon,polygon	boolean	s	
	\\poly_same	polygon,polygon	boolean	s	
	\\poly_send	polygon	bytea	s	
	\\polygon	box	polygon	s	
	\\polygon	circle	polygon	s	
	\\polygon	integer,circle	polygon	s	
	\\polygon	path	polygon	s	
	\\popen	path	path	s	
	\\position	bit,bit	integer	s	
	\\position	bytea,bytea	integer	s	
	\\position	text,text	integer	s	
	\\postgresql_fdw_validator	text[],oid	boolean	s	
	\\pow	double precision,double precision	double precision	s	
	\\pow	numeric,numeric	numeric	s	
	\\power	double precision,double precision	double precision	s	
	\\power	numeric,numeric	numeric	s	
	\\pt_contained_circle	point,circle	boolean	s	
	\\pt_contained_poly	point,polygon	boolean	s	
	\\query_to_xml	text,boolean,boolean,text	xml	s	
	\\query_to_xml_and_xmlschema	text,boolean,boolean,text	xml	s	
	\\query_to_xmlschema	text,boolean,boolean,text	xml	s	
	\\querytree	tsquery	text	s	
	\\quote_ident	text	text	s	
	\\quote_literal	anyelement	text	s	
	\\quote_literal	text	text	s	
	\\quote_nullable	anyelement	text		
	\\quote_nullable	text	text		
	\\radians	double precision	double precision	s	
	\\radius	circle	double precision	s	
	\\random		double precision	s	
	\\random	bigint,bigint	bigint	s	
	\\random	integer,integer	integer	s	
	\\random	numeric,numeric	numeric	s	
	\\random_normal	double precision,double precision	double precision	sd2	
	\\range_adjacent	anyrange,anyrange	boolean	s	
	\\range_adjacent_multirange	anyrange,anymultirange	boolean	s	
	\\range_after	anyrange,anyrange	boolean	s	
	\\range_after_multirange	anyrange,anymultirange	boolean	s	
	\\range_agg	anymultirange	anymultirange	a	
	\\range_agg	anyrange	anymultirange	a	
	\\range_before	anyrange,anyrange	boolean	s	
	\\range_before_multirange	anyrange,anymultirange	boolean	s	
	\\range_cmp	anyrange,anyrange	integer	s	
	\\range_contained_by	anyrange,anyrange	boolean	s	
	\\range_contained_by_multirange	anyrange,anymultirange	boolean	s	
	\\range_contains	anyrange,anyrange	boolean	s	
	\\range_contains_elem	anyrange,anyelement	boolean	s	
	\\range_contains_multirange	anyrange,anymultirange	boolean	s	
	\\range_eq	anyrange,anyrange	boolean	s	
	\\range_ge	anyrange,anyrange	boolean	s	
	\\range_gt	anyrange,anyrange	boolean	s	
	\\range_intersect	anyrange,anyrange	anyrange	s	
	\\range_intersect_agg	anymultirange	anymultirange	a	
	\\range_intersect_agg	anyrange	anyrange	a	
	\\range_intersect_agg_transfn	anyrange,anyrange	anyrange	s	
	\\range_le	anyrange,anyrange	boolean	s	
	\\range_lt	anyrange,anyrange	boolean	s	
	\\range_merge	anymultirange	anyrange	s	
	\\range_merge	anyrange,anyrange	anyrange	s	
	\\range_minus	anyrange,anyrange	anyrange	s	
	\\range_ne	anyrange,anyrange	boolean	s	
	\\range_overlaps	anyrange,anyrange	boolean	s	
	\\range_overlaps_multirange	anyrange,anymultirange	boolean	s	
	\\range_overleft	anyrange,anyrange	boolean	s	
	\\range_overleft_multirange	anyrange,anymultirange	boolean	s	
	\\range_overright	anyrange,anyrange	boolean	s	
	\\range_overright_multirange	anyrange,anymultirange	boolean	s	
	\\range_send	anyrange	bytea	s	
	\\range_union	anyrange,anyrange	anyrange	s	
	\\rank		bigint	w	
	\\rank	any	bigint	av	
	\\record_eq	record,record	boolean	s	
	\\record_ge	record,record	boolean	s	
	\\record_gt	record,record	boolean	s	
	\\record_image_eq	record,record	boolean	s	
	\\record_image_ge	record,record	boolean	s	
	\\record_image_gt	record,record	boolean	s	
	\\record_image_le	record,record	boolean	s	
	\\record_image_lt	record,record	boolean	s	
	\\record_image_ne	record,record	boolean	s	
	\\record_larger	record,record	record	s	
	\\record_le	record,record	boolean	s	
	\\record_lt	record,record	boolean	s	
	\\record_ne	record,record	boolean	s	
	\\record_send	record	bytea	s	
	\\record_smaller	record,record	record	s	
	\\regclass	text	regclass	s	
	\\regclasssend	regclass	bytea	s	
	\\regcollationsend	regcollation	bytea	s	
	\\regconfigsend	regconfig	bytea	s	
	\\regdictionarysend	regdictionary	bytea	s	
	\\regexp_count	text,text	integer	s	
	\\regexp_count	text,text,integer	integer	s	
	\\regexp_count	text,text,integer,text	integer	s	
	\\regexp_instr	text,text	integer	s	
	\\regexp_instr	text,text,integer	integer	s	
	\\regexp_instr	text,text,integer,integer	integer	s	
	\\regexp_instr	text,text,integer,integer,integer	integer	s	
	\\regexp_instr	text,text,integer,integer,integer,text	integer	s	
	\\regexp_instr	text,text,integer,integer,integer,text,integer	integer	s	
	\\regexp_like	text,text	boolean	s	
	\\regexp_like	text,text,text	boolean	s	
	\\regexp_match	text,text	text[]	s	
	\\regexp_match	text,text,text	text[]	s	
	\\regexp_matches	text,text	text[]	sr	
	\\regexp_matches	text,text,text	text[]	sr	
	\\regexp_replace	text,text,text	text	s	
	\\regexp_replace	text,text,text,integer	text	s	
	\\regexp_replace	text,text,text,integer,integer	text	s	
	\\regexp_replace	text,text,text,integer,integer,text	text	s	
	\\regexp_replace	text,text,text,text	text	s	
	\\regexp_split_to_array	text,text	text[]	s	
	\\regexp_split_to_array	text,text,text	text[]	s	
	\\regexp_split_to_table	text,text	text	sr	
	\\regexp_split_to_table	text,text,text	text	sr	
	\\regexp_substr	text,text	text	s	
	\\regexp_substr	text,text,integer	text	s	
	\\regexp_substr	text,text,integer,integer	text	s	
	\\regexp_substr	text,text,integer,integer,text	text	s	
	\\regexp_substr	text,text,integer,integer,text,integer	text	s	
	\\regnamespacesend	regnamespace	bytea	s	
	\\regoperatorsend	regoperator	bytea	s	
	\\regopersend	regoper	bytea	s	
	\\regproceduresend	regprocedure	bytea	s	
	\\regprocsend	regproc	bytea	s	
	\\regr_avgx	double precision,double precision	double precision	a	
	\\regr_avgy	double precision,double precision	double precision	a	
	\\regr_count	double precision,double precision	bigint	a	
	\\regr_intercept	double precision,double precision	double precision	a	
	\\regr_r2	double precision,double precision	double precision	a	
	\\regr_slope	double precision,double precision	double precision	a	
	\\regr_sxx	double precision,double precision	double precision	a	
	\\regr_sxy	double precision,double precision	double precision	a	
	\\regr_syy	double precision,double precision	double precision	a	
	\\regrolesend	regrole	bytea	s	
	\\regtypesend	regtype	bytea	s	
	\\repeat	text,integer	text	s	
	\\replace	text,text,text	text	s	
	\\reverse	bytea	bytea	s	
	\\reverse	text	text	s	
	\\right	text,integer	text	s	
	\\round	double precision	double precision	s	
	\\round	numeric	numeric	s	
	\\round	numeric,integer	numeric	s	
	\\row_number		bigint	w	
	\\row_security_active	oid	boolean	s	
	\\row_security_active	text	boolean	s	
	\\row_to_json	record	json	s	
	\\row_to_json	record,boolean	json	s	
	\\rpad	text,integer	text	s	
	\\rpad	text,integer,text	text	s	
	\\rtrim	bytea,bytea	bytea	s	
	\\rtrim	text	text	s	
	\\rtrim	text,text	text	s	
	\\satisfies_hash_partition	oid,integer,integer,any	boolean	v	
	\\scale	numeric	integer	s	
	\\schema_to_xml	name,boolean,boolean,text	xml	s	
	\\schema_to_xml_and_xmlschema	name,boolean,boolean,text	xml	s	
	\\schema_to_xmlschema	name,boolean,boolean,text	xml	s	
	\\session_user		name	s	
	\\set_bit	bit,integer,integer	bit	s	
	\\set_bit	bytea,bigint,integer	bytea	s	
	\\set_byte	bytea,integer,integer	bytea	s	
	\\set_config	text,text,boolean	text		
	\\set_masklen	cidr,integer	cidr	s	
	\\set_masklen	inet,integer	inet	s	
	\\setseed	double precision	void	s	
	\\setval	regclass,bigint	bigint	s	
	\\setval	regclass,bigint,boolean	bigint	s	
	\\setweight	tsvector,char	tsvector	s	
	\\setweight	tsvector,char,text[]	tsvector	s	
	\\sha224	bytea	bytea	s	
	\\sha256	bytea	bytea	s	
	\\sha384	bytea	bytea	s	
	\\sha512	bytea	bytea	s	
	\\shobj_description	oid,name	text	s	
	\\sign	double precision	double precision	s	
	\\sign	numeric	numeric	s	
	\\similar_escape	text,text	text		
	\\similar_to_escape	text	text	s	
	\\similar_to_escape	text,text	text	s	
	\\sin	double precision	double precision	s	
	\\sind	double precision	double precision	s	
	\\sinh	double precision	double precision	s	
	\\slope	point,point	double precision	s	
	\\spg_poly_quad_compress	polygon	box	s	
	\\split_part	text,text,integer	text	s	
	\\sqrt	double precision	double precision	s	
	\\sqrt	numeric	numeric	s	
	\\starts_with	text,text	boolean	s	
	\\statement_timestamp		timestamp with time zone	s	
	\\stddev	bigint	numeric	a	
	\\stddev	double precision	double precision	a	
	\\stddev	integer	numeric	a	
	\\stddev	numeric	numeric	a	
	\\stddev	real	double precision	a	
	\\stddev	smallint	numeric	a	
	\\stddev_pop	bigint	numeric	a	
	\\stddev_pop	double precision	double precision	a	
	\\stddev_pop	integer	numeric	a	
	\\stddev_pop	numeric	numeric	a	
	\\stddev_pop	real	double precision	a	
	\\stddev_pop	smallint	numeric	a	
	\\stddev_samp	bigint	numeric	a	
	\\stddev_samp	double precision	double precision	a	
	\\stddev_samp	integer	numeric	a	
	\\stddev_samp	numeric	numeric	a	
	\\stddev_samp	real	double precision	a	
	\\stddev_samp	smallint	numeric	a	
	\\string_agg	bytea,bytea	bytea	a	
	\\string_agg	text,text	text	a	
	\\string_to_array	text,text	text[]		
	\\string_to_array	text,text,text	text[]		
	\\string_to_table	text,text	text	r	
	\\string_to_table	text,text,text	text	r	
	\\strip	tsvector	tsvector	s	
	\\strpos	text,text	integer	s	
	\\substr	bytea,integer	bytea	s	
	\\substr	bytea,integer,integer	bytea	s	
	\\substr	text,integer	text	s	
	\\substr	text,integer,integer	text	s	
	\\substring	bit,integer	bit	s	
	\\substring	bit,integer,integer	bit	s	
	\\substring	bytea,integer	bytea	s	
	\\substring	bytea,integer,integer	bytea	s	
	\\substring	text,integer	text	s	
	\\substring	text,integer,integer	text	s	
	\\substring	text,text	text	s	
	\\substring	text,text,text	text	s	
	\\sum	bigint	numeric	a	
	\\sum	double precision	double precision	a	
	\\sum	integer	bigint	a	
	\\sum	interval	interval	a	
	\\sum	money	money	a	
	\\sum	numeric	numeric	a	
	\\sum	real	real	a	
	\\sum	smallint	bigint	a	
	\\system_user		text	s	
	\\table_to_xml	regclass,boolean,boolean,text	xml	s	
	\\table_to_xml_and_xmlschema	regclass,boolean,boolean,text	xml	s	
	\\table_to_xmlschema	regclass,boolean,boolean,text	xml	s	
	\\tan	double precision	double precision	s	
	\\tand	double precision	double precision	s	
	\\tanh	double precision	double precision	s	
	\\text	boolean	text	s	
	\\text	char	text	s	
	\\text	character	text	s	
	\\text	inet	text	s	
	\\text	name	text	s	
	\\text	xml	text	s	
	\\text_ge	text,text	boolean	s	
	\\text_gt	text,text	boolean	s	
	\\text_larger	text,text	text	s	
	\\text_le	text,text	boolean	s	
	\\text_lt	text,text	boolean	s	
	\\text_pattern_ge	text,text	boolean	s	
	\\text_pattern_gt	text,text	boolean	s	
	\\text_pattern_le	text,text	boolean	s	
	\\text_pattern_lt	text,text	boolean	s	
	\\text_smaller	text,text	text	s	
	\\textanycat	text,anynonarray	text	s	
	\\textcat	text,text	text	s	
	\\texteq	text,text	boolean	s	
	\\texteqname	text,name	boolean	s	
	\\textgename	text,name	boolean	s	
	\\textgtname	text,name	boolean	s	
	\\texticlike	text,text	boolean	s	
	\\texticnlike	text,text	boolean	s	
	\\texticregexeq	text,text	boolean	s	
	\\texticregexne	text,text	boolean	s	
	\\textlen	text	integer	s	
	\\textlename	text,name	boolean	s	
	\\textlike	text,text	boolean	s	
	\\textltname	text,name	boolean	s	
	\\textne	text,text	boolean	s	
	\\textnename	text,name	boolean	s	
	\\textnlike	text,text	boolean	s	
	\\textregexeq	text,text	boolean	s	
	\\textregexne	text,text	boolean	s	
	\\textsend	text	bytea	s	
	\\tideq	tid,tid	boolean	s	
	\\tidge	tid,tid	boolean	s	
	\\tidgt	tid,tid	boolean	s	
	\\tidlarger	tid,tid	tid	s	
	\\tidle	tid,tid	boolean	s	
	\\tidlt	tid,tid	boolean	s	
	\\tidne	tid,tid	boolean	s	
	\\tidsend	tid	bytea	s	
	\\tidsmaller	tid,tid	tid	s	
	\\time	interval	time without time zone	s	
	\\time	time with time zone	time without time zone	s	
	\\time	time without time zone,integer	time without time zone	s	
	\\time	timestamp with time zone	time without time zone	s	
	\\time	timestamp without time zone	time without time zone	s	
	\\time_cmp	time without time zone,time without time zone	integer	s	
	\\time_eq	time without time zone,time without time zone	boolean	s	
	\\time_ge	time without time zone,time without time zone	boolean	s	
	\\time_gt	time without time zone,time without time zone	boolean	s	
	\\time_hash	time without time zone	integer	s	
	\\time_hash_extended	time without time zone,bigint	bigint	s	
	\\time_larger	time without time zone,time without time zone	time without time zone	s	
	\\time_le	time without time zone,time without time zone	boolean	s	
	\\time_lt	time without time zone,time without time zone	boolean	s	
	\\time_mi_interval	time without time zone,interval	time without time zone	s	
	\\time_mi_time	time without time zone,time without time zone	interval	s	
	\\time_ne	time without time zone,time without time zone	boolean	s	
	\\time_pl_interval	time without time zone,interval	time without time zone	s	
	\\time_send	time without time zone	bytea	s	
	\\time_smaller	time without time zone,time without time zone	time without time zone	s	
	\\timedate_pl	time without time zone,date	timestamp without time zone	s	
	\\timeofday		text	s	
	\\timestamp	date	timestamp without time zone	s	
	\\timestamp	date,time without time zone	timestamp without time zone	s	
	\\timestamp	timestamp with time zone	timestamp without time zone	s	
	\\timestamp	timestamp without time zone,integer	timestamp without time zone	s	
	\\timestamp_cmp	timestamp without time zone,timestamp without time zone	integer	s	
	\\timestamp_cmp_date	timestamp without time zone,date	integer	s	
	\\timestamp_cmp_timestamptz	timestamp without time zone,timestamp with time zone	integer	s	
	\\timestamp_eq	timestamp without time zone,timestamp without time zone	boolean	s	
	\\timestamp_eq_date	timestamp without time zone,date	boolean	s	
	\\timestamp_eq_timestamptz	timestamp without time zone,timestamp with time zone	boolean	s	
	\\timestamp_ge	timestamp without time zone,timestamp without time zone	boolean	s	
	\\timestamp_ge_date	timestamp without time zone,date	boolean	s	
	\\timestamp_ge_timestamptz	timestamp without time zone,timestamp with time zone	boolean	s	
	\\timestamp_gt	timestamp without time zone,timestamp without time zone	boolean	s	
	\\timestamp_gt_date	timestamp without time zone,date	boolean	s	
	\\timestamp_gt_timestamptz	timestamp without time zone,timestamp with time zone	boolean	s	
	\\timestamp_hash	timestamp without time zone	integer	s	
	\\timestamp_hash_extended	timestamp without time zone,bigint	bigint	s	
	\\timestamp_larger	timestamp without time zone,timestamp without time zone	timestamp without time zone	s	
	\\timestamp_le	timestamp without time zone,timestamp without time zone	boolean	s	
	\\timestamp_le_date	timestamp without time zone,date	boolean	s	
	\\timestamp_le_timestamptz	timestamp without time zone,timestamp with time zone	boolean	s	
	\\timestamp_lt	timestamp without time zone,timestamp without time zone	boolean	s	
	\\timestamp_lt_date	timestamp without time zone,date	boolean	s	
	\\timestamp_lt_timestamptz	timestamp without time zone,timestamp with time zone	boolean	s	
	\\timestamp_mi	timestamp without time zone,timestamp without time zone	interval	s	
	\\timestamp_mi_interval	timestamp without time zone,interval	timestamp without time zone	s	
	\\timestamp_ne	timestamp without time zone,timestamp without time zone	boolean	s	
	\\timestamp_ne_date	timestamp without time zone,date	boolean	s	
	\\timestamp_ne_timestamptz	timestamp without time zone,timestamp with time zone	boolean	s	
	\\timestamp_pl_interval	timestamp without time zone,interval	timestamp without time zone	s	
	\\timestamp_send	timestamp without time zone	bytea	s	
	\\timestamp_smaller	timestamp without time zone,timestamp without time zone	timestamp without time zone	s	
	\\timestamptypmodin	cstring[]	integer	s	
	\\timestamptz	date	timestamp with time zone	s	
	\\timestamptz	date,time with time zone	timestamp with time zone	s	
	\\timestamptz	date,time without time zone	timestamp with time zone	s	
	\\timestamptz	timestamp with time zone,integer	timestamp with time zone	s	
	\\timestamptz	timestamp without time zone	timestamp with time zone	s	
	\\timestamptz_cmp	timestamp with time zone,timestamp with time zone	integer	s	
	\\timestamptz_cmp_date	timestamp with time zone,date	integer	s	
	\\timestamptz_cmp_timestamp	timestamp with time zone,timestamp without time zone	integer	s	
	\\timestamptz_eq	timestamp with time zone,timestamp with time zone	boolean	s	
	\\timestamptz_eq_date	timestamp with time zone,date	boolean	s	
	\\timestamptz_eq_timestamp	timestamp with time zone,timestamp without time zone	boolean	s	
	\\timestamptz_ge	timestamp with time zone,timestamp with time zone	boolean	s	
	\\timestamptz_ge_date	timestamp with time zone,date	boolean	s	
	\\timestamptz_ge_timestamp	timestamp with time zone,timestamp without time zone	boolean	s	
	\\timestamptz_gt	timestamp with time zone,timestamp with time zone	boolean	s	
	\\timestamptz_gt_date	timestamp with time zone,date	boolean	s	
	\\timestamptz_gt_timestamp	timestamp with time zone,timestamp without time zone	boolean	s	
	\\timestamptz_hash	timestamp with time zone	integer	s	
	\\timestamptz_hash_extended	timestamp with time zone,bigint	bigint	s	
	\\timestamptz_larger	timestamp with time zone,timestamp with time zone	timestamp with time zone	s	
	\\timestamptz_le	timestamp with time zone,timestamp with time zone	boolean	s	
	\\timestamptz_le_date	timestamp with time zone,date	boolean	s	
	\\timestamptz_le_timestamp	timestamp with time zone,timestamp without time zone	boolean	s	
	\\timestamptz_lt	timestamp with time zone,timestamp with time zone	boolean	s	
	\\timestamptz_lt_date	timestamp with time zone,date	boolean	s	
	\\timestamptz_lt_timestamp	timestamp with time zone,timestamp without time zone	boolean	s	
	\\timestamptz_mi	timestamp with time zone,timestamp with time zone	interval	s	
	\\timestamptz_mi_interval	timestamp with time zone,interval	timestamp with time zone	s	
	\\timestamptz_ne	timestamp with time zone,timestamp with time zone	boolean	s	
	\\timestamptz_ne_date	timestamp with time zone,date	boolean	s	
	\\timestamptz_ne_timestamp	timestamp with time zone,timestamp without time zone	boolean	s	
	\\timestamptz_pl_interval	timestamp with time zone,interval	timestamp with time zone	s	
	\\timestamptz_send	timestamp with time zone	bytea	s	
	\\timestamptz_smaller	timestamp with time zone,timestamp with time zone	timestamp with time zone	s	
	\\timestamptztypmodin	cstring[]	integer	s	
	\\timetypmodin	cstring[]	integer	s	
	\\timetz	time with time zone,integer	time with time zone	s	
	\\timetz	time without time zone	time with time zone	s	
	\\timetz	timestamp with time zone	time with time zone	s	
	\\timetz_cmp	time with time zone,time with time zone	integer	s	
	\\timetz_eq	time with time zone,time with time zone	boolean	s	
	\\timetz_ge	time with time zone,time with time zone	boolean	s	
	\\timetz_gt	time with time zone,time with time zone	boolean	s	
	\\timetz_hash	time with time zone	integer	s	
	\\timetz_hash_extended	time with time zone,bigint	bigint	s	
	\\timetz_larger	time with time zone,time with time zone	time with time zone	s	
	\\timetz_le	time with time zone,time with time zone	boolean	s	
	\\timetz_lt	time with time zone,time with time zone	boolean	s	
	\\timetz_mi_interval	time with time zone,interval	time with time zone	s	
	\\timetz_ne	time with time zone,time with time zone	boolean	s	
	\\timetz_pl_interval	time with time zone,interval	time with time zone	s	
	\\timetz_send	time with time zone	bytea	s	
	\\timetz_smaller	time with time zone,time with time zone	time with time zone	s	
	\\timetzdate_pl	time with time zone,date	timestamp with time zone	s	
	\\timetztypmodin	cstring[]	integer	s	
	\\timezone	interval,time with time zone	time with time zone	s	
	\\timezone	interval,timestamp with time zone	timestamp without time zone	s	
	\\timezone	interval,timestamp without time zone	timestamp with time zone	s	
	\\timezone	text,time with time zone	time with time zone	s	
	\\timezone	text,timestamp with time zone	timestamp without time zone	s	
	\\timezone	text,timestamp without time zone	timestamp with time zone	s	
	\\timezone	time with time zone	time with time zone	s	
	\\timezone	timestamp with time zone	timestamp without time zone	s	
	\\timezone	timestamp without time zone	timestamp with time zone	s	
	\\to_ascii	text	text	s	
	\\to_ascii	text,integer	text	s	
	\\to_ascii	text,name	text	s	
	\\to_bin	bigint	text	s	
	\\to_bin	integer	text	s	
	\\to_char	bigint,text	text	s	
	\\to_char	double precision,text	text	s	
	\\to_char	integer,text	text	s	
	\\to_char	interval,text	text	s	
	\\to_char	numeric,text	text	s	
	\\to_char	real,text	text	s	
	\\to_char	timestamp with time zone,text	text	s	
	\\to_char	timestamp without time zone,text	text	s	
	\\to_date	text,text	date	s	
	\\to_hex	bigint	text	s	
	\\to_hex	integer	text	s	
	\\to_json	anyelement	json	s	
	\\to_jsonb	anyelement	jsonb	s	
	\\to_number	text,text	numeric	s	
	\\to_oct	bigint	text	s	
	\\to_oct	integer	text	s	
	\\to_regclass	text	regclass	s	
	\\to_regcollation	text	regcollation	s	
	\\to_regnamespace	text	regnamespace	s	
	\\to_regoper	text	regoper	s	
	\\to_regoperator	text	regoperator	s	
	\\to_regproc	text	regproc	s	
	\\to_regprocedure	text	regprocedure	s	
	\\to_regrole	text	regrole	s	
	\\to_regtype	text	regtype	s	
	\\to_regtypemod	text	integer	s	
	\\to_timestamp	double precision	timestamp with time zone	s	
	\\to_timestamp	text,text	timestamp with time zone	s	
	\\to_tsquery	regconfig,text	tsquery	s	
	\\to_tsquery	text	tsquery	s	
	\\to_tsvector	json	tsvector	s	
	\\to_tsvector	jsonb	tsvector	s	
	\\to_tsvector	regconfig,json	tsvector	s	
	\\to_tsvector	regconfig,jsonb	tsvector	s	
	\\to_tsvector	regconfig,text	tsvector	s	
	\\to_tsvector	text	tsvector	s	
	\\transaction_timestamp		timestamp with time zone	s	
	\\translate	text,text,text	text	s	
	\\trim_array	anyarray,integer	anyarray	s	
	\\trim_scale	numeric	numeric	s	
	\\trunc	double precision	double precision	s	
	\\trunc	macaddr	macaddr	s	
	\\trunc	macaddr8	macaddr8	s	
	\\trunc	numeric	numeric	s	
	\\trunc	numeric,integer	numeric	s	
	\\ts_debug	regconfig,text	record	sr	alias:text;description:text;token:text;dictionaries:regdictionary[];dictionary:regdictionary;lexemes:text[]
	\\ts_debug	text	record	sr	alias:text;description:text;token:text;dictionaries:regdictionary[];dictionary:regdictionary;lexemes:text[]
	\\ts_delete	tsvector,text	tsvector	s	
	\\ts_delete	tsvector,text[]	tsvector	s	
	\\ts_filter	tsvector,char[]	tsvector	s	
	\\ts_headline	json,tsquery	json	s	
	\\ts_headline	json,tsquery,text	json	s	
	\\ts_headline	jsonb,tsquery	jsonb	s	
	\\ts_headline	jsonb,tsquery,text	jsonb	s	
	\\ts_headline	regconfig,json,tsquery	json	s	
	\\ts_headline	regconfig,json,tsquery,text	json	s	
	\\ts_headline	regconfig,jsonb,tsquery	jsonb	s	
	\\ts_headline	regconfig,jsonb,tsquery,text	jsonb	s	
	\\ts_headline	regconfig,text,tsquery	text	s	
	\\ts_headline	regconfig,text,tsquery,text	text	s	
	\\ts_headline	text,tsquery	text	s	
	\\ts_headline	text,tsquery,text	text	s	
	\\ts_lexize	regdictionary,text	text[]	s	
	\\ts_match_qv	tsquery,tsvector	boolean	s	
	\\ts_match_tq	text,tsquery	boolean	s	
	\\ts_match_tt	text,text	boolean	s	
	\\ts_match_vq	tsvector,tsquery	boolean	s	
	\\ts_parse	oid,text	record	sr	tokid:integer;token:text
	\\ts_parse	text,text	record	sr	tokid:integer;token:text
	\\ts_rank	real[],tsvector,tsquery	real	s	
	\\ts_rank	real[],tsvector,tsquery,integer	real	s	
	\\ts_rank	tsvector,tsquery	real	s	
	\\ts_rank	tsvector,tsquery,integer	real	s	
	\\ts_rank_cd	real[],tsvector,tsquery	real	s	
	\\ts_rank_cd	real[],tsvector,tsquery,integer	real	s	
	\\ts_rank_cd	tsvector,tsquery	real	s	
	\\ts_rank_cd	tsvector,tsquery,integer	real	s	
	\\ts_rewrite	tsquery,text	tsquery	s	
	\\ts_rewrite	tsquery,tsquery,tsquery	tsquery	s	
	\\ts_stat	text	record	sr	word:text;ndoc:integer;nentry:integer
	\\ts_stat	text,text	record	sr	word:text;ndoc:integer;nentry:integer
	\\ts_token_type	oid	record	sr	tokid:integer;alias:text;description:text
	\\ts_token_type	text	record	sr	tokid:integer;alias:text;description:text
	\\tsmultirange		tsmultirange	s	
	\\tsmultirange	tsrange	tsmultirange	s	
	\\tsmultirange	tsrange[]	tsmultirange	sv	
	\\tsq_mcontained	tsquery,tsquery	boolean	s	
	\\tsq_mcontains	tsquery,tsquery	boolean	s	
	\\tsquery_and	tsquery,tsquery	tsquery	s	
	\\tsquery_cmp	tsquery,tsquery	integer	s	
	\\tsquery_eq	tsquery,tsquery	boolean	s	
	\\tsquery_ge	tsquery,tsquery	boolean	s	
	\\tsquery_gt	tsquery,tsquery	boolean	s	
	\\tsquery_le	tsquery,tsquery	boolean	s	
	\\tsquery_lt	tsquery,tsquery	boolean	s	
	\\tsquery_ne	tsquery,tsquery	boolean	s	
	\\tsquery_not	tsquery	tsquery	s	
	\\tsquery_or	tsquery,tsquery	tsquery	s	
	\\tsquery_phrase	tsquery,tsquery	tsquery	s	
	\\tsquery_phrase	tsquery,tsquery,integer	tsquery	s	
	\\tsquerysend	tsquery	bytea	s	
	\\tsrange	timestamp without time zone,timestamp without time zone	tsrange		
	\\tsrange	timestamp without time zone,timestamp without time zone,text	tsrange		
	\\tsrange_subdiff	timestamp without time zone,timestamp without time zone	double precision	s	
	\\tstzmultirange		tstzmultirange	s	
	\\tstzmultirange	tstzrange	tstzmultirange	s	
	\\tstzmultirange	tstzrange[]	tstzmultirange	sv	
	\\tstzrange	timestamp with time zone,timestamp with time zone	tstzrange		
	\\tstzrange	timestamp with time zone,timestamp with time zone,text	tstzrange		
	\\tstzrange_subdiff	timestamp with time zone,timestamp with time zone	double precision	s	
	\\tsvector_cmp	tsvector,tsvector	integer	s	
	\\tsvector_concat	tsvector,tsvector	tsvector	s	
	\\tsvector_eq	tsvector,tsvector	boolean	s	
	\\tsvector_ge	tsvector,tsvector	boolean	s	
	\\tsvector_gt	tsvector,tsvector	boolean	s	
	\\tsvector_le	tsvector,tsvector	boolean	s	
	\\tsvector_lt	tsvector,tsvector	boolean	s	
	\\tsvector_ne	tsvector,tsvector	boolean	s	
	\\tsvector_to_array	tsvector	text[]	s	
	\\tsvectorsend	tsvector	bytea	s	
	\\txid_current		bigint	s	
	\\txid_current_if_assigned		bigint	s	
	\\txid_current_snapshot		txid_snapshot	s	
	\\txid_snapshot_send	txid_snapshot	bytea	s	
	\\txid_snapshot_xip	txid_snapshot	bigint	sr	
	\\txid_snapshot_xmax	txid_snapshot	bigint	s	
	\\txid_snapshot_xmin	txid_snapshot	bigint	s	
	\\txid_status	bigint	text	s	
	\\txid_visible_in_snapshot	bigint,txid_snapshot	boolean	s	
	\\unicode_assigned	text	boolean	s	
	\\unicode_version		text	s	
	\\unistr	text	text	s	
	\\unknownsend	unknown	bytea	s	
	\\unnest	anyarray	anyelement	sr	
	\\unnest	anymultirange	anyrange	sr	
	\\unnest	tsvector	record	sr	lexeme:text;positions:smallint[];weights:text[]
	\\upper	anymultirange	anyelement	s	
	\\upper	anyrange	anyelement	s	
	\\upper	text	text	s	
	\\upper_inc	anymultirange	boolean	s	
	\\upper_inc	anyrange	boolean	s	
	\\upper_inf	anymultirange	boolean	s	
	\\upper_inf	anyrange	boolean	s	
	\\uuid_cmp	uuid,uuid	integer	s	
	\\uuid_eq	uuid,uuid	boolean	s	
	\\uuid_extract_timestamp	uuid	timestamp with time zone	s	
	\\uuid_extract_version	uuid	smallint	s	
	\\uuid_ge	uuid,uuid	boolean	s	
	\\uuid_gt	uuid,uuid	boolean	s	
	\\uuid_hash	uuid	integer	s	
	\\uuid_hash_extended	uuid,bigint	bigint	s	
	\\uuid_le	uuid,uuid	boolean	s	
	\\uuid_lt	uuid,uuid	boolean	s	
	\\uuid_ne	uuid,uuid	boolean	s	
	\\uuid_send	uuid	bytea	s	
	\\uuidv4		uuid	s	
	\\uuidv7		uuid	s	
	\\uuidv7	interval	uuid	s	
	\\var_pop	bigint	numeric	a	
	\\var_pop	double precision	double precision	a	
	\\var_pop	integer	numeric	a	
	\\var_pop	numeric	numeric	a	
	\\var_pop	real	double precision	a	
	\\var_pop	smallint	numeric	a	
	\\var_samp	bigint	numeric	a	
	\\var_samp	double precision	double precision	a	
	\\var_samp	integer	numeric	a	
	\\var_samp	numeric	numeric	a	
	\\var_samp	real	double precision	a	
	\\var_samp	smallint	numeric	a	
	\\varbit	bit varying,integer,boolean	bit varying	s	
	\\varbit_send	bit varying	bytea	s	
	\\varbitcmp	bit varying,bit varying	integer	s	
	\\varbiteq	bit varying,bit varying	boolean	s	
	\\varbitge	bit varying,bit varying	boolean	s	
	\\varbitgt	bit varying,bit varying	boolean	s	
	\\varbitle	bit varying,bit varying	boolean	s	
	\\varbitlt	bit varying,bit varying	boolean	s	
	\\varbitne	bit varying,bit varying	boolean	s	
	\\varbittypmodin	cstring[]	integer	s	
	\\varchar	character varying,integer,boolean	character varying	s	
	\\varchar	name	character varying	s	
	\\varcharsend	character varying	bytea	s	
	\\varchartypmodin	cstring[]	integer	s	
	\\variance	bigint	numeric	a	
	\\variance	double precision	double precision	a	
	\\variance	integer	numeric	a	
	\\variance	numeric	numeric	a	
	\\variance	real	double precision	a	
	\\variance	smallint	numeric	a	
	\\version		text	s	
	\\void_send	void	bytea	s	
	\\websearch_to_tsquery	regconfig,text	tsquery	s	
	\\websearch_to_tsquery	text	tsquery	s	
	\\width	box	double precision	s	
	\\width_bucket	anycompatible,anycompatiblearray	integer	s	
	\\width_bucket	double precision,double precision,double precision,integer	integer	s	
	\\width_bucket	numeric,numeric,numeric,integer	integer	s	
	\\xid	xid8	xid	s	
	\\xid8_larger	xid8,xid8	xid8	s	
	\\xid8_smaller	xid8,xid8	xid8	s	
	\\xid8cmp	xid8,xid8	integer	s	
	\\xid8eq	xid8,xid8	boolean	s	
	\\xid8ge	xid8,xid8	boolean	s	
	\\xid8gt	xid8,xid8	boolean	s	
	\\xid8le	xid8,xid8	boolean	s	
	\\xid8lt	xid8,xid8	boolean	s	
	\\xid8ne	xid8,xid8	boolean	s	
	\\xid8send	xid8	bytea	s	
	\\xideq	xid,xid	boolean	s	
	\\xideqint4	xid,integer	boolean	s	
	\\xidneq	xid,xid	boolean	s	
	\\xidneqint4	xid,integer	boolean	s	
	\\xidsend	xid	bytea	s	
	\\xml	text	xml	s	
	\\xml_is_well_formed	text	boolean	s	
	\\xml_is_well_formed_content	text	boolean	s	
	\\xml_is_well_formed_document	text	boolean	s	
	\\xml_send	xml	bytea	s	
	\\xmlagg	xml	xml	a	
	\\xmlcomment	text	xml	s	
	\\xmlconcat2	xml,xml	xml		
	\\xmlexists	text,xml	boolean	s	
	\\xmltext	text	xml	s	
	\\xmlvalidate	xml,text	boolean	s	
	\\xpath	text,xml	xml[]	s	
	\\xpath	text,xml,text[]	xml[]	s	
	\\xpath_exists	text,xml	boolean	s	
	\\xpath_exists	text,xml,text[]	boolean	s	

operators_text : Str
operators_text =
	\\!!		tsquery	tsquery	s
	\\!~	character	text	boolean	s
	\\!~	name	text	boolean	s
	\\!~	text	text	boolean	s
	\\!~*	character	text	boolean	s
	\\!~*	name	text	boolean	s
	\\!~*	text	text	boolean	s
	\\!~~	bytea	bytea	boolean	s
	\\!~~	character	text	boolean	s
	\\!~~	name	text	boolean	s
	\\!~~	text	text	boolean	s
	\\!~~*	character	text	boolean	s
	\\!~~*	name	text	boolean	s
	\\!~~*	text	text	boolean	s
	\\#		path	integer	s
	\\#		polygon	integer	s
	\\#	bigint	bigint	bigint	s
	\\#	bit	bit	bit	s
	\\#	box	box	box	s
	\\#	integer	integer	integer	s
	\\#	line	line	point	s
	\\#	lseg	lseg	point	s
	\\#	smallint	smallint	smallint	s
	\\##	line	lseg	point	s
	\\##	lseg	box	point	s
	\\##	lseg	lseg	point	s
	\\##	point	box	point	s
	\\##	point	line	point	s
	\\##	point	lseg	point	s
	\\#-	jsonb	text[]	jsonb	s
	\\#>	json	text[]	json	s
	\\#>	jsonb	text[]	jsonb	s
	\\#>>	json	text[]	text	s
	\\#>>	jsonb	text[]	text	s
	\\%	bigint	bigint	bigint	s
	\\%	integer	integer	integer	s
	\\%	numeric	numeric	numeric	s
	\\%	smallint	smallint	smallint	s
	\\&	bigint	bigint	bigint	s
	\\&	bit	bit	bit	s
	\\&	inet	inet	inet	s
	\\&	integer	integer	integer	s
	\\&	macaddr	macaddr	macaddr	s
	\\&	macaddr8	macaddr8	macaddr8	s
	\\&	smallint	smallint	smallint	s
	\\&&	anyarray	anyarray	boolean	s
	\\&&	anymultirange	anymultirange	boolean	s
	\\&&	anymultirange	anyrange	boolean	s
	\\&&	anyrange	anymultirange	boolean	s
	\\&&	anyrange	anyrange	boolean	s
	\\&&	box	box	boolean	s
	\\&&	circle	circle	boolean	s
	\\&&	inet	inet	boolean	s
	\\&&	polygon	polygon	boolean	s
	\\&&	tsquery	tsquery	tsquery	s
	\\&<	anymultirange	anymultirange	boolean	s
	\\&<	anymultirange	anyrange	boolean	s
	\\&<	anyrange	anymultirange	boolean	s
	\\&<	anyrange	anyrange	boolean	s
	\\&<	box	box	boolean	s
	\\&<	circle	circle	boolean	s
	\\&<	polygon	polygon	boolean	s
	\\&<|	box	box	boolean	s
	\\&<|	circle	circle	boolean	s
	\\&<|	polygon	polygon	boolean	s
	\\&>	anymultirange	anymultirange	boolean	s
	\\&>	anymultirange	anyrange	boolean	s
	\\&>	anyrange	anymultirange	boolean	s
	\\&>	anyrange	anyrange	boolean	s
	\\&>	box	box	boolean	s
	\\&>	circle	circle	boolean	s
	\\&>	polygon	polygon	boolean	s
	\\*	anymultirange	anymultirange	anymultirange	s
	\\*	anyrange	anyrange	anyrange	s
	\\*	bigint	bigint	bigint	s
	\\*	bigint	integer	bigint	s
	\\*	bigint	money	money	s
	\\*	bigint	smallint	bigint	s
	\\*	box	point	box	s
	\\*	circle	point	circle	s
	\\*	double precision	double precision	double precision	s
	\\*	double precision	interval	interval	s
	\\*	double precision	money	money	s
	\\*	double precision	real	double precision	s
	\\*	integer	bigint	bigint	s
	\\*	integer	integer	integer	s
	\\*	integer	money	money	s
	\\*	integer	smallint	integer	s
	\\*	interval	double precision	interval	s
	\\*	money	bigint	money	s
	\\*	money	double precision	money	s
	\\*	money	integer	money	s
	\\*	money	real	money	s
	\\*	money	smallint	money	s
	\\*	numeric	numeric	numeric	s
	\\*	path	point	path	s
	\\*	point	point	point	s
	\\*	real	double precision	double precision	s
	\\*	real	money	money	s
	\\*	real	real	real	s
	\\*	smallint	bigint	bigint	s
	\\*	smallint	integer	integer	s
	\\*	smallint	money	money	s
	\\*	smallint	smallint	smallint	s
	\\*<	record	record	boolean	s
	\\*<=	record	record	boolean	s
	\\*<>	record	record	boolean	s
	\\*=	record	record	boolean	s
	\\*>	record	record	boolean	s
	\\*>=	record	record	boolean	s
	\\+		bigint	bigint	s
	\\+		double precision	double precision	s
	\\+		integer	integer	s
	\\+		numeric	numeric	s
	\\+		real	real	s
	\\+		smallint	smallint	s
	\\+	aclitem[]	aclitem	aclitem[]	s
	\\+	anymultirange	anymultirange	anymultirange	s
	\\+	anyrange	anyrange	anyrange	s
	\\+	bigint	bigint	bigint	s
	\\+	bigint	inet	inet	s
	\\+	bigint	integer	bigint	s
	\\+	bigint	smallint	bigint	s
	\\+	box	point	box	s
	\\+	circle	point	circle	s
	\\+	date	integer	date	s
	\\+	date	interval	timestamp without time zone	s
	\\+	date	time with time zone	timestamp with time zone	s
	\\+	date	time without time zone	timestamp without time zone	s
	\\+	double precision	double precision	double precision	s
	\\+	double precision	real	double precision	s
	\\+	inet	bigint	inet	s
	\\+	integer	bigint	bigint	s
	\\+	integer	date	date	s
	\\+	integer	integer	integer	s
	\\+	integer	smallint	integer	s
	\\+	interval	date	timestamp without time zone	s
	\\+	interval	interval	interval	s
	\\+	interval	time with time zone	time with time zone	s
	\\+	interval	time without time zone	time without time zone	s
	\\+	interval	timestamp with time zone	timestamp with time zone	s
	\\+	interval	timestamp without time zone	timestamp without time zone	s
	\\+	money	money	money	s
	\\+	numeric	numeric	numeric	s
	\\+	numeric	pg_lsn	pg_lsn	s
	\\+	path	path	path	s
	\\+	path	point	path	s
	\\+	pg_lsn	numeric	pg_lsn	s
	\\+	point	point	point	s
	\\+	real	double precision	double precision	s
	\\+	real	real	real	s
	\\+	smallint	bigint	bigint	s
	\\+	smallint	integer	integer	s
	\\+	smallint	smallint	smallint	s
	\\+	time with time zone	date	timestamp with time zone	s
	\\+	time with time zone	interval	time with time zone	s
	\\+	time without time zone	date	timestamp without time zone	s
	\\+	time without time zone	interval	time without time zone	s
	\\+	timestamp with time zone	interval	timestamp with time zone	s
	\\+	timestamp without time zone	interval	timestamp without time zone	s
	\\-		bigint	bigint	s
	\\-		double precision	double precision	s
	\\-		integer	integer	s
	\\-		interval	interval	s
	\\-		numeric	numeric	s
	\\-		real	real	s
	\\-		smallint	smallint	s
	\\-	aclitem[]	aclitem	aclitem[]	s
	\\-	anymultirange	anymultirange	anymultirange	s
	\\-	anyrange	anyrange	anyrange	s
	\\-	bigint	bigint	bigint	s
	\\-	bigint	integer	bigint	s
	\\-	bigint	smallint	bigint	s
	\\-	box	point	box	s
	\\-	circle	point	circle	s
	\\-	date	date	integer	s
	\\-	date	integer	date	s
	\\-	date	interval	timestamp without time zone	s
	\\-	double precision	double precision	double precision	s
	\\-	double precision	real	double precision	s
	\\-	inet	bigint	inet	s
	\\-	inet	inet	bigint	s
	\\-	integer	bigint	bigint	s
	\\-	integer	integer	integer	s
	\\-	integer	smallint	integer	s
	\\-	interval	interval	interval	s
	\\-	jsonb	integer	jsonb	
	\\-	jsonb	text	jsonb	
	\\-	jsonb	text[]	jsonb	
	\\-	money	money	money	s
	\\-	numeric	numeric	numeric	s
	\\-	path	point	path	s
	\\-	pg_lsn	numeric	pg_lsn	s
	\\-	pg_lsn	pg_lsn	numeric	s
	\\-	point	point	point	s
	\\-	real	double precision	double precision	s
	\\-	real	real	real	s
	\\-	smallint	bigint	bigint	s
	\\-	smallint	integer	integer	s
	\\-	smallint	smallint	smallint	s
	\\-	time with time zone	interval	time with time zone	s
	\\-	time without time zone	interval	time without time zone	s
	\\-	time without time zone	time without time zone	interval	s
	\\-	timestamp with time zone	interval	timestamp with time zone	s
	\\-	timestamp with time zone	timestamp with time zone	interval	s
	\\-	timestamp without time zone	interval	timestamp without time zone	s
	\\-	timestamp without time zone	timestamp without time zone	interval	s
	\\->	json	integer	json	s
	\\->	json	text	json	s
	\\->	jsonb	integer	jsonb	s
	\\->	jsonb	text	jsonb	s
	\\->>	json	integer	text	s
	\\->>	json	text	text	s
	\\->>	jsonb	integer	text	s
	\\->>	jsonb	text	text	s
	\\-|-	anymultirange	anymultirange	boolean	s
	\\-|-	anymultirange	anyrange	boolean	s
	\\-|-	anyrange	anymultirange	boolean	s
	\\-|-	anyrange	anyrange	boolean	s
	\\/	bigint	bigint	bigint	s
	\\/	bigint	integer	bigint	s
	\\/	bigint	smallint	bigint	s
	\\/	box	point	box	s
	\\/	circle	point	circle	s
	\\/	double precision	double precision	double precision	s
	\\/	double precision	real	double precision	s
	\\/	integer	bigint	bigint	s
	\\/	integer	integer	integer	s
	\\/	integer	smallint	integer	s
	\\/	interval	double precision	interval	s
	\\/	money	bigint	money	s
	\\/	money	double precision	money	s
	\\/	money	integer	money	s
	\\/	money	money	double precision	s
	\\/	money	real	money	s
	\\/	money	smallint	money	s
	\\/	numeric	numeric	numeric	s
	\\/	path	point	path	s
	\\/	point	point	point	s
	\\/	real	double precision	double precision	s
	\\/	real	real	real	s
	\\/	smallint	bigint	bigint	s
	\\/	smallint	integer	integer	s
	\\/	smallint	smallint	smallint	s
	\\<	anyarray	anyarray	boolean	s
	\\<	anyenum	anyenum	boolean	s
	\\<	anymultirange	anymultirange	boolean	s
	\\<	anyrange	anyrange	boolean	s
	\\<	bigint	bigint	boolean	s
	\\<	bigint	integer	boolean	s
	\\<	bigint	smallint	boolean	s
	\\<	bit	bit	boolean	s
	\\<	bit varying	bit varying	boolean	s
	\\<	boolean	boolean	boolean	s
	\\<	box	box	boolean	s
	\\<	bytea	bytea	boolean	s
	\\<	char	char	boolean	s
	\\<	character	character	boolean	s
	\\<	circle	circle	boolean	s
	\\<	date	date	boolean	s
	\\<	date	timestamp with time zone	boolean	s
	\\<	date	timestamp without time zone	boolean	s
	\\<	double precision	double precision	boolean	s
	\\<	double precision	real	boolean	s
	\\<	inet	inet	boolean	s
	\\<	integer	bigint	boolean	s
	\\<	integer	integer	boolean	s
	\\<	integer	smallint	boolean	s
	\\<	interval	interval	boolean	s
	\\<	jsonb	jsonb	boolean	s
	\\<	lseg	lseg	boolean	s
	\\<	macaddr	macaddr	boolean	s
	\\<	macaddr8	macaddr8	boolean	s
	\\<	money	money	boolean	s
	\\<	name	name	boolean	s
	\\<	name	text	boolean	s
	\\<	numeric	numeric	boolean	s
	\\<	oid	oid	boolean	s
	\\<	oidvector	oidvector	boolean	s
	\\<	path	path	boolean	s
	\\<	pg_lsn	pg_lsn	boolean	s
	\\<	real	double precision	boolean	s
	\\<	real	real	boolean	s
	\\<	record	record	boolean	s
	\\<	smallint	bigint	boolean	s
	\\<	smallint	integer	boolean	s
	\\<	smallint	smallint	boolean	s
	\\<	text	name	boolean	s
	\\<	text	text	boolean	s
	\\<	tid	tid	boolean	s
	\\<	time with time zone	time with time zone	boolean	s
	\\<	time without time zone	time without time zone	boolean	s
	\\<	timestamp with time zone	date	boolean	s
	\\<	timestamp with time zone	timestamp with time zone	boolean	s
	\\<	timestamp with time zone	timestamp without time zone	boolean	s
	\\<	timestamp without time zone	date	boolean	s
	\\<	timestamp without time zone	timestamp with time zone	boolean	s
	\\<	timestamp without time zone	timestamp without time zone	boolean	s
	\\<	tsquery	tsquery	boolean	s
	\\<	tsvector	tsvector	boolean	s
	\\<	uuid	uuid	boolean	s
	\\<	xid8	xid8	boolean	s
	\\<->	box	box	double precision	s
	\\<->	box	lseg	double precision	s
	\\<->	box	point	double precision	s
	\\<->	circle	circle	double precision	s
	\\<->	circle	point	double precision	s
	\\<->	circle	polygon	double precision	s
	\\<->	line	line	double precision	s
	\\<->	line	lseg	double precision	s
	\\<->	line	point	double precision	s
	\\<->	lseg	box	double precision	s
	\\<->	lseg	line	double precision	s
	\\<->	lseg	lseg	double precision	s
	\\<->	lseg	point	double precision	s
	\\<->	path	path	double precision	s
	\\<->	path	point	double precision	s
	\\<->	point	box	double precision	s
	\\<->	point	circle	double precision	s
	\\<->	point	line	double precision	s
	\\<->	point	lseg	double precision	s
	\\<->	point	path	double precision	s
	\\<->	point	point	double precision	s
	\\<->	point	polygon	double precision	s
	\\<->	polygon	circle	double precision	s
	\\<->	polygon	point	double precision	s
	\\<->	polygon	polygon	double precision	s
	\\<->	tsquery	tsquery	tsquery	
	\\<<	anymultirange	anymultirange	boolean	s
	\\<<	anymultirange	anyrange	boolean	s
	\\<<	anyrange	anymultirange	boolean	s
	\\<<	anyrange	anyrange	boolean	s
	\\<<	bigint	integer	bigint	s
	\\<<	bit	integer	bit	s
	\\<<	box	box	boolean	s
	\\<<	circle	circle	boolean	s
	\\<<	inet	inet	boolean	s
	\\<<	integer	integer	integer	s
	\\<<	point	point	boolean	s
	\\<<	polygon	polygon	boolean	s
	\\<<	smallint	integer	smallint	s
	\\<<=	inet	inet	boolean	s
	\\<<|	box	box	boolean	s
	\\<<|	circle	circle	boolean	s
	\\<<|	point	point	boolean	s
	\\<<|	polygon	polygon	boolean	s
	\\<=	anyarray	anyarray	boolean	s
	\\<=	anyenum	anyenum	boolean	s
	\\<=	anymultirange	anymultirange	boolean	s
	\\<=	anyrange	anyrange	boolean	s
	\\<=	bigint	bigint	boolean	s
	\\<=	bigint	integer	boolean	s
	\\<=	bigint	smallint	boolean	s
	\\<=	bit	bit	boolean	s
	\\<=	bit varying	bit varying	boolean	s
	\\<=	boolean	boolean	boolean	s
	\\<=	box	box	boolean	s
	\\<=	bytea	bytea	boolean	s
	\\<=	char	char	boolean	s
	\\<=	character	character	boolean	s
	\\<=	circle	circle	boolean	s
	\\<=	date	date	boolean	s
	\\<=	date	timestamp with time zone	boolean	s
	\\<=	date	timestamp without time zone	boolean	s
	\\<=	double precision	double precision	boolean	s
	\\<=	double precision	real	boolean	s
	\\<=	inet	inet	boolean	s
	\\<=	integer	bigint	boolean	s
	\\<=	integer	integer	boolean	s
	\\<=	integer	smallint	boolean	s
	\\<=	interval	interval	boolean	s
	\\<=	jsonb	jsonb	boolean	s
	\\<=	lseg	lseg	boolean	s
	\\<=	macaddr	macaddr	boolean	s
	\\<=	macaddr8	macaddr8	boolean	s
	\\<=	money	money	boolean	s
	\\<=	name	name	boolean	s
	\\<=	name	text	boolean	s
	\\<=	numeric	numeric	boolean	s
	\\<=	oid	oid	boolean	s
	\\<=	oidvector	oidvector	boolean	s
	\\<=	path	path	boolean	s
	\\<=	pg_lsn	pg_lsn	boolean	s
	\\<=	real	double precision	boolean	s
	\\<=	real	real	boolean	s
	\\<=	record	record	boolean	s
	\\<=	smallint	bigint	boolean	s
	\\<=	smallint	integer	boolean	s
	\\<=	smallint	smallint	boolean	s
	\\<=	text	name	boolean	s
	\\<=	text	text	boolean	s
	\\<=	tid	tid	boolean	s
	\\<=	time with time zone	time with time zone	boolean	s
	\\<=	time without time zone	time without time zone	boolean	s
	\\<=	timestamp with time zone	date	boolean	s
	\\<=	timestamp with time zone	timestamp with time zone	boolean	s
	\\<=	timestamp with time zone	timestamp without time zone	boolean	s
	\\<=	timestamp without time zone	date	boolean	s
	\\<=	timestamp without time zone	timestamp with time zone	boolean	s
	\\<=	timestamp without time zone	timestamp without time zone	boolean	s
	\\<=	tsquery	tsquery	boolean	s
	\\<=	tsvector	tsvector	boolean	s
	\\<=	uuid	uuid	boolean	s
	\\<=	xid8	xid8	boolean	s
	\\<>	anyarray	anyarray	boolean	s
	\\<>	anyenum	anyenum	boolean	s
	\\<>	anymultirange	anymultirange	boolean	s
	\\<>	anyrange	anyrange	boolean	s
	\\<>	bigint	bigint	boolean	s
	\\<>	bigint	integer	boolean	s
	\\<>	bigint	smallint	boolean	s
	\\<>	bit	bit	boolean	s
	\\<>	bit varying	bit varying	boolean	s
	\\<>	boolean	boolean	boolean	s
	\\<>	bytea	bytea	boolean	s
	\\<>	char	char	boolean	s
	\\<>	character	character	boolean	s
	\\<>	circle	circle	boolean	s
	\\<>	date	date	boolean	s
	\\<>	date	timestamp with time zone	boolean	s
	\\<>	date	timestamp without time zone	boolean	s
	\\<>	double precision	double precision	boolean	s
	\\<>	double precision	real	boolean	s
	\\<>	inet	inet	boolean	s
	\\<>	integer	bigint	boolean	s
	\\<>	integer	integer	boolean	s
	\\<>	integer	smallint	boolean	s
	\\<>	interval	interval	boolean	s
	\\<>	jsonb	jsonb	boolean	s
	\\<>	lseg	lseg	boolean	s
	\\<>	macaddr	macaddr	boolean	s
	\\<>	macaddr8	macaddr8	boolean	s
	\\<>	money	money	boolean	s
	\\<>	name	name	boolean	s
	\\<>	name	text	boolean	s
	\\<>	numeric	numeric	boolean	s
	\\<>	oid	oid	boolean	s
	\\<>	oidvector	oidvector	boolean	s
	\\<>	pg_lsn	pg_lsn	boolean	s
	\\<>	point	point	boolean	s
	\\<>	real	double precision	boolean	s
	\\<>	real	real	boolean	s
	\\<>	record	record	boolean	s
	\\<>	smallint	bigint	boolean	s
	\\<>	smallint	integer	boolean	s
	\\<>	smallint	smallint	boolean	s
	\\<>	text	name	boolean	s
	\\<>	text	text	boolean	s
	\\<>	tid	tid	boolean	s
	\\<>	time with time zone	time with time zone	boolean	s
	\\<>	time without time zone	time without time zone	boolean	s
	\\<>	timestamp with time zone	date	boolean	s
	\\<>	timestamp with time zone	timestamp with time zone	boolean	s
	\\<>	timestamp with time zone	timestamp without time zone	boolean	s
	\\<>	timestamp without time zone	date	boolean	s
	\\<>	timestamp without time zone	timestamp with time zone	boolean	s
	\\<>	timestamp without time zone	timestamp without time zone	boolean	s
	\\<>	tsquery	tsquery	boolean	s
	\\<>	tsvector	tsvector	boolean	s
	\\<>	uuid	uuid	boolean	s
	\\<>	xid	integer	boolean	s
	\\<>	xid	xid	boolean	s
	\\<>	xid8	xid8	boolean	s
	\\<@	anyarray	anyarray	boolean	s
	\\<@	anyelement	anymultirange	boolean	s
	\\<@	anyelement	anyrange	boolean	s
	\\<@	anymultirange	anymultirange	boolean	s
	\\<@	anymultirange	anyrange	boolean	s
	\\<@	anyrange	anymultirange	boolean	s
	\\<@	anyrange	anyrange	boolean	s
	\\<@	box	box	boolean	s
	\\<@	circle	circle	boolean	s
	\\<@	jsonb	jsonb	boolean	s
	\\<@	lseg	box	boolean	s
	\\<@	lseg	line	boolean	s
	\\<@	point	box	boolean	s
	\\<@	point	circle	boolean	s
	\\<@	point	line	boolean	s
	\\<@	point	lseg	boolean	s
	\\<@	point	path	boolean	s
	\\<@	point	polygon	boolean	s
	\\<@	polygon	polygon	boolean	s
	\\<@	tsquery	tsquery	boolean	s
	\\<^	box	box	boolean	s
	\\<^	point	point	boolean	s
	\\=	aclitem	aclitem	boolean	s
	\\=	anyarray	anyarray	boolean	s
	\\=	anyenum	anyenum	boolean	s
	\\=	anymultirange	anymultirange	boolean	s
	\\=	anyrange	anyrange	boolean	s
	\\=	bigint	bigint	boolean	s
	\\=	bigint	integer	boolean	s
	\\=	bigint	smallint	boolean	s
	\\=	bit	bit	boolean	s
	\\=	bit varying	bit varying	boolean	s
	\\=	boolean	boolean	boolean	s
	\\=	box	box	boolean	s
	\\=	bytea	bytea	boolean	s
	\\=	char	char	boolean	s
	\\=	character	character	boolean	s
	\\=	cid	cid	boolean	s
	\\=	circle	circle	boolean	s
	\\=	date	date	boolean	s
	\\=	date	timestamp with time zone	boolean	s
	\\=	date	timestamp without time zone	boolean	s
	\\=	double precision	double precision	boolean	s
	\\=	double precision	real	boolean	s
	\\=	inet	inet	boolean	s
	\\=	integer	bigint	boolean	s
	\\=	integer	integer	boolean	s
	\\=	integer	smallint	boolean	s
	\\=	interval	interval	boolean	s
	\\=	jsonb	jsonb	boolean	s
	\\=	line	line	boolean	s
	\\=	lseg	lseg	boolean	s
	\\=	macaddr	macaddr	boolean	s
	\\=	macaddr8	macaddr8	boolean	s
	\\=	money	money	boolean	s
	\\=	name	name	boolean	s
	\\=	name	text	boolean	s
	\\=	numeric	numeric	boolean	s
	\\=	oid	oid	boolean	s
	\\=	oidvector	oidvector	boolean	s
	\\=	path	path	boolean	s
	\\=	pg_lsn	pg_lsn	boolean	s
	\\=	real	double precision	boolean	s
	\\=	real	real	boolean	s
	\\=	record	record	boolean	s
	\\=	smallint	bigint	boolean	s
	\\=	smallint	integer	boolean	s
	\\=	smallint	smallint	boolean	s
	\\=	text	name	boolean	s
	\\=	text	text	boolean	s
	\\=	tid	tid	boolean	s
	\\=	time with time zone	time with time zone	boolean	s
	\\=	time without time zone	time without time zone	boolean	s
	\\=	timestamp with time zone	date	boolean	s
	\\=	timestamp with time zone	timestamp with time zone	boolean	s
	\\=	timestamp with time zone	timestamp without time zone	boolean	s
	\\=	timestamp without time zone	date	boolean	s
	\\=	timestamp without time zone	timestamp with time zone	boolean	s
	\\=	timestamp without time zone	timestamp without time zone	boolean	s
	\\=	tsquery	tsquery	boolean	s
	\\=	tsvector	tsvector	boolean	s
	\\=	uuid	uuid	boolean	s
	\\=	xid	integer	boolean	s
	\\=	xid	xid	boolean	s
	\\=	xid8	xid8	boolean	s
	\\>	anyarray	anyarray	boolean	s
	\\>	anyenum	anyenum	boolean	s
	\\>	anymultirange	anymultirange	boolean	s
	\\>	anyrange	anyrange	boolean	s
	\\>	bigint	bigint	boolean	s
	\\>	bigint	integer	boolean	s
	\\>	bigint	smallint	boolean	s
	\\>	bit	bit	boolean	s
	\\>	bit varying	bit varying	boolean	s
	\\>	boolean	boolean	boolean	s
	\\>	box	box	boolean	s
	\\>	bytea	bytea	boolean	s
	\\>	char	char	boolean	s
	\\>	character	character	boolean	s
	\\>	circle	circle	boolean	s
	\\>	date	date	boolean	s
	\\>	date	timestamp with time zone	boolean	s
	\\>	date	timestamp without time zone	boolean	s
	\\>	double precision	double precision	boolean	s
	\\>	double precision	real	boolean	s
	\\>	inet	inet	boolean	s
	\\>	integer	bigint	boolean	s
	\\>	integer	integer	boolean	s
	\\>	integer	smallint	boolean	s
	\\>	interval	interval	boolean	s
	\\>	jsonb	jsonb	boolean	s
	\\>	lseg	lseg	boolean	s
	\\>	macaddr	macaddr	boolean	s
	\\>	macaddr8	macaddr8	boolean	s
	\\>	money	money	boolean	s
	\\>	name	name	boolean	s
	\\>	name	text	boolean	s
	\\>	numeric	numeric	boolean	s
	\\>	oid	oid	boolean	s
	\\>	oidvector	oidvector	boolean	s
	\\>	path	path	boolean	s
	\\>	pg_lsn	pg_lsn	boolean	s
	\\>	real	double precision	boolean	s
	\\>	real	real	boolean	s
	\\>	record	record	boolean	s
	\\>	smallint	bigint	boolean	s
	\\>	smallint	integer	boolean	s
	\\>	smallint	smallint	boolean	s
	\\>	text	name	boolean	s
	\\>	text	text	boolean	s
	\\>	tid	tid	boolean	s
	\\>	time with time zone	time with time zone	boolean	s
	\\>	time without time zone	time without time zone	boolean	s
	\\>	timestamp with time zone	date	boolean	s
	\\>	timestamp with time zone	timestamp with time zone	boolean	s
	\\>	timestamp with time zone	timestamp without time zone	boolean	s
	\\>	timestamp without time zone	date	boolean	s
	\\>	timestamp without time zone	timestamp with time zone	boolean	s
	\\>	timestamp without time zone	timestamp without time zone	boolean	s
	\\>	tsquery	tsquery	boolean	s
	\\>	tsvector	tsvector	boolean	s
	\\>	uuid	uuid	boolean	s
	\\>	xid8	xid8	boolean	s
	\\>=	anyarray	anyarray	boolean	s
	\\>=	anyenum	anyenum	boolean	s
	\\>=	anymultirange	anymultirange	boolean	s
	\\>=	anyrange	anyrange	boolean	s
	\\>=	bigint	bigint	boolean	s
	\\>=	bigint	integer	boolean	s
	\\>=	bigint	smallint	boolean	s
	\\>=	bit	bit	boolean	s
	\\>=	bit varying	bit varying	boolean	s
	\\>=	boolean	boolean	boolean	s
	\\>=	box	box	boolean	s
	\\>=	bytea	bytea	boolean	s
	\\>=	char	char	boolean	s
	\\>=	character	character	boolean	s
	\\>=	circle	circle	boolean	s
	\\>=	date	date	boolean	s
	\\>=	date	timestamp with time zone	boolean	s
	\\>=	date	timestamp without time zone	boolean	s
	\\>=	double precision	double precision	boolean	s
	\\>=	double precision	real	boolean	s
	\\>=	inet	inet	boolean	s
	\\>=	integer	bigint	boolean	s
	\\>=	integer	integer	boolean	s
	\\>=	integer	smallint	boolean	s
	\\>=	interval	interval	boolean	s
	\\>=	jsonb	jsonb	boolean	s
	\\>=	lseg	lseg	boolean	s
	\\>=	macaddr	macaddr	boolean	s
	\\>=	macaddr8	macaddr8	boolean	s
	\\>=	money	money	boolean	s
	\\>=	name	name	boolean	s
	\\>=	name	text	boolean	s
	\\>=	numeric	numeric	boolean	s
	\\>=	oid	oid	boolean	s
	\\>=	oidvector	oidvector	boolean	s
	\\>=	path	path	boolean	s
	\\>=	pg_lsn	pg_lsn	boolean	s
	\\>=	real	double precision	boolean	s
	\\>=	real	real	boolean	s
	\\>=	record	record	boolean	s
	\\>=	smallint	bigint	boolean	s
	\\>=	smallint	integer	boolean	s
	\\>=	smallint	smallint	boolean	s
	\\>=	text	name	boolean	s
	\\>=	text	text	boolean	s
	\\>=	tid	tid	boolean	s
	\\>=	time with time zone	time with time zone	boolean	s
	\\>=	time without time zone	time without time zone	boolean	s
	\\>=	timestamp with time zone	date	boolean	s
	\\>=	timestamp with time zone	timestamp with time zone	boolean	s
	\\>=	timestamp with time zone	timestamp without time zone	boolean	s
	\\>=	timestamp without time zone	date	boolean	s
	\\>=	timestamp without time zone	timestamp with time zone	boolean	s
	\\>=	timestamp without time zone	timestamp without time zone	boolean	s
	\\>=	tsquery	tsquery	boolean	s
	\\>=	tsvector	tsvector	boolean	s
	\\>=	uuid	uuid	boolean	s
	\\>=	xid8	xid8	boolean	s
	\\>>	anymultirange	anymultirange	boolean	s
	\\>>	anymultirange	anyrange	boolean	s
	\\>>	anyrange	anymultirange	boolean	s
	\\>>	anyrange	anyrange	boolean	s
	\\>>	bigint	integer	bigint	s
	\\>>	bit	integer	bit	s
	\\>>	box	box	boolean	s
	\\>>	circle	circle	boolean	s
	\\>>	inet	inet	boolean	s
	\\>>	integer	integer	integer	s
	\\>>	point	point	boolean	s
	\\>>	polygon	polygon	boolean	s
	\\>>	smallint	integer	smallint	s
	\\>>=	inet	inet	boolean	s
	\\>^	box	box	boolean	s
	\\>^	point	point	boolean	s
	\\?	jsonb	text	boolean	s
	\\?#	box	box	boolean	s
	\\?#	line	box	boolean	s
	\\?#	line	line	boolean	s
	\\?#	lseg	box	boolean	s
	\\?#	lseg	line	boolean	s
	\\?#	lseg	lseg	boolean	s
	\\?#	path	path	boolean	s
	\\?&	jsonb	text[]	boolean	s
	\\?-		line	boolean	s
	\\?-		lseg	boolean	s
	\\?-	point	point	boolean	s
	\\?-|	line	line	boolean	s
	\\?-|	lseg	lseg	boolean	s
	\\?|		line	boolean	s
	\\?|		lseg	boolean	s
	\\?|	jsonb	text[]	boolean	s
	\\?|	point	point	boolean	s
	\\?||	line	line	boolean	s
	\\?||	lseg	lseg	boolean	s
	\\@		bigint	bigint	s
	\\@		double precision	double precision	s
	\\@		integer	integer	s
	\\@		numeric	numeric	s
	\\@		real	real	s
	\\@		smallint	smallint	s
	\\@-@		lseg	double precision	s
	\\@-@		path	double precision	s
	\\@>	aclitem[]	aclitem	boolean	s
	\\@>	anyarray	anyarray	boolean	s
	\\@>	anymultirange	anyelement	boolean	s
	\\@>	anymultirange	anymultirange	boolean	s
	\\@>	anymultirange	anyrange	boolean	s
	\\@>	anyrange	anyelement	boolean	s
	\\@>	anyrange	anymultirange	boolean	s
	\\@>	anyrange	anyrange	boolean	s
	\\@>	box	box	boolean	s
	\\@>	box	point	boolean	s
	\\@>	circle	circle	boolean	s
	\\@>	circle	point	boolean	s
	\\@>	jsonb	jsonb	boolean	s
	\\@>	path	point	boolean	s
	\\@>	polygon	point	boolean	s
	\\@>	polygon	polygon	boolean	s
	\\@>	tsquery	tsquery	boolean	s
	\\@?	jsonb	jsonpath	boolean	
	\\@@		box	point	s
	\\@@		circle	point	s
	\\@@		lseg	point	s
	\\@@		polygon	point	s
	\\@@	jsonb	jsonpath	boolean	
	\\@@	text	text	boolean	s
	\\@@	text	tsquery	boolean	s
	\\@@	tsquery	tsvector	boolean	s
	\\@@	tsvector	tsquery	boolean	s
	\\@@@	tsquery	tsvector	boolean	s
	\\@@@	tsvector	tsquery	boolean	s
	\\^	double precision	double precision	double precision	s
	\\^	numeric	numeric	numeric	s
	\\^@	text	text	boolean	s
	\\|	bigint	bigint	bigint	s
	\\|	bit	bit	bit	s
	\\|	inet	inet	inet	s
	\\|	integer	integer	integer	s
	\\|	macaddr	macaddr	macaddr	s
	\\|	macaddr8	macaddr8	macaddr8	s
	\\|	smallint	smallint	smallint	s
	\\|&>	box	box	boolean	s
	\\|&>	circle	circle	boolean	s
	\\|&>	polygon	polygon	boolean	s
	\\|/		double precision	double precision	s
	\\|>>	box	box	boolean	s
	\\|>>	circle	circle	boolean	s
	\\|>>	point	point	boolean	s
	\\|>>	polygon	polygon	boolean	s
	\\||	anycompatible	anycompatiblearray	anycompatiblearray	
	\\||	anycompatiblearray	anycompatible	anycompatiblearray	
	\\||	anycompatiblearray	anycompatiblearray	anycompatiblearray	
	\\||	anynonarray	text	text	s
	\\||	bit varying	bit varying	bit varying	s
	\\||	bytea	bytea	bytea	s
	\\||	jsonb	jsonb	jsonb	s
	\\||	text	anynonarray	text	s
	\\||	text	text	text	s
	\\||	tsquery	tsquery	tsquery	s
	\\||	tsvector	tsvector	tsvector	s
	\\||/		double precision	double precision	s
	\\~		bigint	bigint	s
	\\~		bit	bit	s
	\\~		inet	inet	s
	\\~		integer	integer	s
	\\~		macaddr	macaddr	s
	\\~		macaddr8	macaddr8	s
	\\~		smallint	smallint	s
	\\~	character	text	boolean	s
	\\~	name	text	boolean	s
	\\~	text	text	boolean	s
	\\~*	character	text	boolean	s
	\\~*	name	text	boolean	s
	\\~*	text	text	boolean	s
	\\~<=~	character	character	boolean	s
	\\~<=~	text	text	boolean	s
	\\~<~	character	character	boolean	s
	\\~<~	text	text	boolean	s
	\\~=	box	box	boolean	s
	\\~=	circle	circle	boolean	s
	\\~=	point	point	boolean	s
	\\~=	polygon	polygon	boolean	s
	\\~>=~	character	character	boolean	s
	\\~>=~	text	text	boolean	s
	\\~>~	character	character	boolean	s
	\\~>~	text	text	boolean	s
	\\~~	bytea	bytea	boolean	s
	\\~~	character	text	boolean	s
	\\~~	name	text	boolean	s
	\\~~	text	text	boolean	s
	\\~~*	character	text	boolean	s
	\\~~*	name	text	boolean	s
	\\~~*	text	text	boolean	s

casts_text : Str
casts_text =
	\\bigint	double precision	i
	\\bigint	integer	a
	\\bigint	money	a
	\\bigint	numeric	i
	\\bigint	oid	i
	\\bigint	real	i
	\\bigint	regclass	i
	\\bigint	regcollation	i
	\\bigint	regconfig	i
	\\bigint	regdictionary	i
	\\bigint	regnamespace	i
	\\bigint	regoper	i
	\\bigint	regoperator	i
	\\bigint	regproc	i
	\\bigint	regprocedure	i
	\\bigint	regrole	i
	\\bigint	regtype	i
	\\bigint	smallint	a
	\\bit	bit	i
	\\bit	bit varying	i
	\\bit varying	bit	i
	\\bit varying	bit varying	i
	\\boolean	character	a
	\\boolean	character varying	a
	\\boolean	text	a
	\\box	polygon	a
	\\char	character	a
	\\char	character varying	a
	\\char	text	i
	\\character	char	a
	\\character	character	i
	\\character	character varying	i
	\\character	name	i
	\\character	text	i
	\\character varying	char	a
	\\character varying	character	i
	\\character varying	character varying	i
	\\character varying	name	i
	\\character varying	regclass	i
	\\character varying	text	i
	\\cidr	character	a
	\\cidr	character varying	a
	\\cidr	inet	i
	\\cidr	text	a
	\\date	timestamp with time zone	i
	\\date	timestamp without time zone	i
	\\double precision	bigint	a
	\\double precision	integer	a
	\\double precision	numeric	a
	\\double precision	real	a
	\\double precision	smallint	a
	\\inet	character	a
	\\inet	character varying	a
	\\inet	cidr	a
	\\inet	text	a
	\\integer	bigint	i
	\\integer	double precision	i
	\\integer	money	a
	\\integer	numeric	i
	\\integer	oid	i
	\\integer	real	i
	\\integer	regclass	i
	\\integer	regcollation	i
	\\integer	regconfig	i
	\\integer	regdictionary	i
	\\integer	regnamespace	i
	\\integer	regoper	i
	\\integer	regoperator	i
	\\integer	regproc	i
	\\integer	regprocedure	i
	\\integer	regrole	i
	\\integer	regtype	i
	\\integer	smallint	a
	\\interval	interval	i
	\\interval	time without time zone	a
	\\json	jsonb	a
	\\jsonb	json	a
	\\macaddr	macaddr8	i
	\\macaddr8	macaddr	i
	\\money	numeric	a
	\\name	character	a
	\\name	character varying	a
	\\name	text	i
	\\numeric	bigint	a
	\\numeric	double precision	i
	\\numeric	integer	a
	\\numeric	money	a
	\\numeric	numeric	i
	\\numeric	real	i
	\\numeric	smallint	a
	\\oid	bigint	a
	\\oid	integer	a
	\\oid	regclass	i
	\\oid	regcollation	i
	\\oid	regconfig	i
	\\oid	regdictionary	i
	\\oid	regnamespace	i
	\\oid	regoper	i
	\\oid	regoperator	i
	\\oid	regproc	i
	\\oid	regprocedure	i
	\\oid	regrole	i
	\\oid	regtype	i
	\\path	polygon	a
	\\pg_dependencies	bytea	i
	\\pg_dependencies	text	i
	\\pg_mcv_list	bytea	i
	\\pg_mcv_list	text	i
	\\pg_ndistinct	bytea	i
	\\pg_ndistinct	text	i
	\\pg_node_tree	text	i
	\\point	box	a
	\\polygon	path	a
	\\real	bigint	a
	\\real	double precision	i
	\\real	integer	a
	\\real	numeric	a
	\\real	smallint	a
	\\regclass	bigint	a
	\\regclass	integer	a
	\\regclass	oid	i
	\\regcollation	bigint	a
	\\regcollation	integer	a
	\\regcollation	oid	i
	\\regconfig	bigint	a
	\\regconfig	integer	a
	\\regconfig	oid	i
	\\regdictionary	bigint	a
	\\regdictionary	integer	a
	\\regdictionary	oid	i
	\\regnamespace	bigint	a
	\\regnamespace	integer	a
	\\regnamespace	oid	i
	\\regoper	bigint	a
	\\regoper	integer	a
	\\regoper	oid	i
	\\regoper	regoperator	i
	\\regoperator	bigint	a
	\\regoperator	integer	a
	\\regoperator	oid	i
	\\regoperator	regoper	i
	\\regproc	bigint	a
	\\regproc	integer	a
	\\regproc	oid	i
	\\regproc	regprocedure	i
	\\regprocedure	bigint	a
	\\regprocedure	integer	a
	\\regprocedure	oid	i
	\\regprocedure	regproc	i
	\\regrole	bigint	a
	\\regrole	integer	a
	\\regrole	oid	i
	\\regtype	bigint	a
	\\regtype	integer	a
	\\regtype	oid	i
	\\smallint	bigint	i
	\\smallint	double precision	i
	\\smallint	integer	i
	\\smallint	numeric	i
	\\smallint	oid	i
	\\smallint	real	i
	\\smallint	regclass	i
	\\smallint	regcollation	i
	\\smallint	regconfig	i
	\\smallint	regdictionary	i
	\\smallint	regnamespace	i
	\\smallint	regoper	i
	\\smallint	regoperator	i
	\\smallint	regproc	i
	\\smallint	regprocedure	i
	\\smallint	regrole	i
	\\smallint	regtype	i
	\\text	char	a
	\\text	character	i
	\\text	character varying	i
	\\text	name	i
	\\text	regclass	i
	\\time with time zone	time with time zone	i
	\\time with time zone	time without time zone	a
	\\time without time zone	interval	i
	\\time without time zone	time with time zone	i
	\\time without time zone	time without time zone	i
	\\timestamp with time zone	date	a
	\\timestamp with time zone	time with time zone	a
	\\timestamp with time zone	time without time zone	a
	\\timestamp with time zone	timestamp with time zone	i
	\\timestamp with time zone	timestamp without time zone	a
	\\timestamp without time zone	date	a
	\\timestamp without time zone	time without time zone	a
	\\timestamp without time zone	timestamp with time zone	i
	\\timestamp without time zone	timestamp without time zone	i
	\\xml	character	a
	\\xml	character varying	a
	\\xml	text	a
