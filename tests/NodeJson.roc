# Derived from PostgreSQL 18.6, src/backend/parser/gram.y and the node
# headers and functions it uses.
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

## Parse trees as JSON, written the way libpg_query writes Postgres's own
## trees, so that the two can be compared as text. Written by
## `tools/actions.roc`, do not edit.
import pg.Node

NodeJson :: [].{
	## The `RawStmt` nodes of a parse, as the `stmts` array.
	stmts : List(Node) -> Str
	stmts = |raw| stmts_json(raw)

	## One node, with its type around it.
	node : Node -> Str
	node = |n| node_json(n)
}

node_json : Node -> Str
node_json = |n|
	match n {
		Null => "null"
		NodeList(items) => if items.is_empty() "null" else "{\"List\":{\"items\":${elements(items)}}}"
		ATAlterConstraint(r) => "{\"ATAlterConstraint\":{${json_at_alter_constraint(r)}}}"
		AArrayExpr(r) => "{\"A_ArrayExpr\":{${json_a_array_expr(r)}}}"
		AConst(r) => "{\"A_Const\":{${json_a_const(r)}}}"
		AExpr(r) => "{\"A_Expr\":{${json_a_expr(r)}}}"
		AIndices(r) => "{\"A_Indices\":{${json_a_indices(r)}}}"
		AIndirection(r) => "{\"A_Indirection\":{${json_a_indirection(r)}}}"
		AStar(r) => "{\"A_Star\":{${json_a_star(r)}}}"
		AccessPriv(r) => "{\"AccessPriv\":{${json_access_priv(r)}}}"
		Alias(r) => "{\"Alias\":{${json_alias(r)}}}"
		AlterCollationStmt(r) => "{\"AlterCollationStmt\":{${json_alter_collation_stmt(r)}}}"
		AlterDatabaseRefreshCollStmt(r) => "{\"AlterDatabaseRefreshCollStmt\":{${json_alter_database_refresh_coll_stmt(r)}}}"
		AlterDatabaseSetStmt(r) => "{\"AlterDatabaseSetStmt\":{${json_alter_database_set_stmt(r)}}}"
		AlterDatabaseStmt(r) => "{\"AlterDatabaseStmt\":{${json_alter_database_stmt(r)}}}"
		AlterDefaultPrivilegesStmt(r) => "{\"AlterDefaultPrivilegesStmt\":{${json_alter_default_privileges_stmt(r)}}}"
		AlterDomainStmt(r) => "{\"AlterDomainStmt\":{${json_alter_domain_stmt(r)}}}"
		AlterEnumStmt(r) => "{\"AlterEnumStmt\":{${json_alter_enum_stmt(r)}}}"
		AlterEventTrigStmt(r) => "{\"AlterEventTrigStmt\":{${json_alter_event_trig_stmt(r)}}}"
		AlterExtensionContentsStmt(r) => "{\"AlterExtensionContentsStmt\":{${json_alter_extension_contents_stmt(r)}}}"
		AlterExtensionStmt(r) => "{\"AlterExtensionStmt\":{${json_alter_extension_stmt(r)}}}"
		AlterFdwStmt(r) => "{\"AlterFdwStmt\":{${json_alter_fdw_stmt(r)}}}"
		AlterForeignServerStmt(r) => "{\"AlterForeignServerStmt\":{${json_alter_foreign_server_stmt(r)}}}"
		AlterFunctionStmt(r) => "{\"AlterFunctionStmt\":{${json_alter_function_stmt(r)}}}"
		AlterObjectDependsStmt(r) => "{\"AlterObjectDependsStmt\":{${json_alter_object_depends_stmt(r)}}}"
		AlterObjectSchemaStmt(r) => "{\"AlterObjectSchemaStmt\":{${json_alter_object_schema_stmt(r)}}}"
		AlterOpFamilyStmt(r) => "{\"AlterOpFamilyStmt\":{${json_alter_op_family_stmt(r)}}}"
		AlterOperatorStmt(r) => "{\"AlterOperatorStmt\":{${json_alter_operator_stmt(r)}}}"
		AlterOwnerStmt(r) => "{\"AlterOwnerStmt\":{${json_alter_owner_stmt(r)}}}"
		AlterPolicyStmt(r) => "{\"AlterPolicyStmt\":{${json_alter_policy_stmt(r)}}}"
		AlterPublicationStmt(r) => "{\"AlterPublicationStmt\":{${json_alter_publication_stmt(r)}}}"
		AlterRoleSetStmt(r) => "{\"AlterRoleSetStmt\":{${json_alter_role_set_stmt(r)}}}"
		AlterRoleStmt(r) => "{\"AlterRoleStmt\":{${json_alter_role_stmt(r)}}}"
		AlterSeqStmt(r) => "{\"AlterSeqStmt\":{${json_alter_seq_stmt(r)}}}"
		AlterStatsStmt(r) => "{\"AlterStatsStmt\":{${json_alter_stats_stmt(r)}}}"
		AlterSubscriptionStmt(r) => "{\"AlterSubscriptionStmt\":{${json_alter_subscription_stmt(r)}}}"
		AlterSystemStmt(r) => "{\"AlterSystemStmt\":{${json_alter_system_stmt(r)}}}"
		AlterTSConfigurationStmt(r) => "{\"AlterTSConfigurationStmt\":{${json_alter_ts_configuration_stmt(r)}}}"
		AlterTSDictionaryStmt(r) => "{\"AlterTSDictionaryStmt\":{${json_alter_ts_dictionary_stmt(r)}}}"
		AlterTableCmd(r) => "{\"AlterTableCmd\":{${json_alter_table_cmd(r)}}}"
		AlterTableMoveAllStmt(r) => "{\"AlterTableMoveAllStmt\":{${json_alter_table_move_all_stmt(r)}}}"
		AlterTableSpaceOptionsStmt(r) => "{\"AlterTableSpaceOptionsStmt\":{${json_alter_table_space_options_stmt(r)}}}"
		AlterTableStmt(r) => "{\"AlterTableStmt\":{${json_alter_table_stmt(r)}}}"
		AlterTypeStmt(r) => "{\"AlterTypeStmt\":{${json_alter_type_stmt(r)}}}"
		AlterUserMappingStmt(r) => "{\"AlterUserMappingStmt\":{${json_alter_user_mapping_stmt(r)}}}"
		BitString(r) => "{\"BitString\":{${json_bit_string(r)}}}"
		BoolExpr(r) => "{\"BoolExpr\":{${json_bool_expr(r)}}}"
		Boolean(r) => "{\"Boolean\":{${json_boolean(r)}}}"
		BooleanTest(r) => "{\"BooleanTest\":{${json_boolean_test(r)}}}"
		CTECycleClause(r) => "{\"CTECycleClause\":{${json_cte_cycle_clause(r)}}}"
		CTESearchClause(r) => "{\"CTESearchClause\":{${json_cte_search_clause(r)}}}"
		CallStmt(r) => "{\"CallStmt\":{${json_call_stmt(r)}}}"
		CaseExpr(r) => "{\"CaseExpr\":{${json_case_expr(r)}}}"
		CaseWhen(r) => "{\"CaseWhen\":{${json_case_when(r)}}}"
		CheckPointStmt(r) => "{\"CheckPointStmt\":{${json_check_point_stmt(r)}}}"
		ClosePortalStmt(r) => "{\"ClosePortalStmt\":{${json_close_portal_stmt(r)}}}"
		ClusterStmt(r) => "{\"ClusterStmt\":{${json_cluster_stmt(r)}}}"
		CoalesceExpr(r) => "{\"CoalesceExpr\":{${json_coalesce_expr(r)}}}"
		CollateClause(r) => "{\"CollateClause\":{${json_collate_clause(r)}}}"
		ColumnDef(r) => "{\"ColumnDef\":{${json_column_def(r)}}}"
		ColumnRef(r) => "{\"ColumnRef\":{${json_column_ref(r)}}}"
		CommentStmt(r) => "{\"CommentStmt\":{${json_comment_stmt(r)}}}"
		CommonTableExpr(r) => "{\"CommonTableExpr\":{${json_common_table_expr(r)}}}"
		CompositeTypeStmt(r) => "{\"CompositeTypeStmt\":{${json_composite_type_stmt(r)}}}"
		Constraint(r) => "{\"Constraint\":{${json_constraint(r)}}}"
		ConstraintsSetStmt(r) => "{\"ConstraintsSetStmt\":{${json_constraints_set_stmt(r)}}}"
		CopyStmt(r) => "{\"CopyStmt\":{${json_copy_stmt(r)}}}"
		CreateAmStmt(r) => "{\"CreateAmStmt\":{${json_create_am_stmt(r)}}}"
		CreateCastStmt(r) => "{\"CreateCastStmt\":{${json_create_cast_stmt(r)}}}"
		CreateConversionStmt(r) => "{\"CreateConversionStmt\":{${json_create_conversion_stmt(r)}}}"
		CreateDomainStmt(r) => "{\"CreateDomainStmt\":{${json_create_domain_stmt(r)}}}"
		CreateEnumStmt(r) => "{\"CreateEnumStmt\":{${json_create_enum_stmt(r)}}}"
		CreateEventTrigStmt(r) => "{\"CreateEventTrigStmt\":{${json_create_event_trig_stmt(r)}}}"
		CreateExtensionStmt(r) => "{\"CreateExtensionStmt\":{${json_create_extension_stmt(r)}}}"
		CreateFdwStmt(r) => "{\"CreateFdwStmt\":{${json_create_fdw_stmt(r)}}}"
		CreateForeignServerStmt(r) => "{\"CreateForeignServerStmt\":{${json_create_foreign_server_stmt(r)}}}"
		CreateForeignTableStmt(r) => "{\"CreateForeignTableStmt\":{${json_create_foreign_table_stmt(r)}}}"
		CreateFunctionStmt(r) => "{\"CreateFunctionStmt\":{${json_create_function_stmt(r)}}}"
		CreateOpClassItem(r) => "{\"CreateOpClassItem\":{${json_create_op_class_item(r)}}}"
		CreateOpClassStmt(r) => "{\"CreateOpClassStmt\":{${json_create_op_class_stmt(r)}}}"
		CreateOpFamilyStmt(r) => "{\"CreateOpFamilyStmt\":{${json_create_op_family_stmt(r)}}}"
		CreatePLangStmt(r) => "{\"CreatePLangStmt\":{${json_create_p_lang_stmt(r)}}}"
		CreatePolicyStmt(r) => "{\"CreatePolicyStmt\":{${json_create_policy_stmt(r)}}}"
		CreatePublicationStmt(r) => "{\"CreatePublicationStmt\":{${json_create_publication_stmt(r)}}}"
		CreateRangeStmt(r) => "{\"CreateRangeStmt\":{${json_create_range_stmt(r)}}}"
		CreateRoleStmt(r) => "{\"CreateRoleStmt\":{${json_create_role_stmt(r)}}}"
		CreateSchemaStmt(r) => "{\"CreateSchemaStmt\":{${json_create_schema_stmt(r)}}}"
		CreateSeqStmt(r) => "{\"CreateSeqStmt\":{${json_create_seq_stmt(r)}}}"
		CreateStatsStmt(r) => "{\"CreateStatsStmt\":{${json_create_stats_stmt(r)}}}"
		CreateStmt(r) => "{\"CreateStmt\":{${json_create_stmt(r)}}}"
		CreateSubscriptionStmt(r) => "{\"CreateSubscriptionStmt\":{${json_create_subscription_stmt(r)}}}"
		CreateTableAsStmt(r) => "{\"CreateTableAsStmt\":{${json_create_table_as_stmt(r)}}}"
		CreateTableSpaceStmt(r) => "{\"CreateTableSpaceStmt\":{${json_create_table_space_stmt(r)}}}"
		CreateTransformStmt(r) => "{\"CreateTransformStmt\":{${json_create_transform_stmt(r)}}}"
		CreateTrigStmt(r) => "{\"CreateTrigStmt\":{${json_create_trig_stmt(r)}}}"
		CreateUserMappingStmt(r) => "{\"CreateUserMappingStmt\":{${json_create_user_mapping_stmt(r)}}}"
		CreatedbStmt(r) => "{\"CreatedbStmt\":{${json_createdb_stmt(r)}}}"
		CurrentOfExpr(r) => "{\"CurrentOfExpr\":{${json_current_of_expr(r)}}}"
		DeallocateStmt(r) => "{\"DeallocateStmt\":{${json_deallocate_stmt(r)}}}"
		DeclareCursorStmt(r) => "{\"DeclareCursorStmt\":{${json_declare_cursor_stmt(r)}}}"
		DefElem(r) => "{\"DefElem\":{${json_def_elem(r)}}}"
		DefineStmt(r) => "{\"DefineStmt\":{${json_define_stmt(r)}}}"
		DeleteStmt(r) => "{\"DeleteStmt\":{${json_delete_stmt(r)}}}"
		DiscardStmt(r) => "{\"DiscardStmt\":{${json_discard_stmt(r)}}}"
		DoStmt(r) => "{\"DoStmt\":{${json_do_stmt(r)}}}"
		DropOwnedStmt(r) => "{\"DropOwnedStmt\":{${json_drop_owned_stmt(r)}}}"
		DropRoleStmt(r) => "{\"DropRoleStmt\":{${json_drop_role_stmt(r)}}}"
		DropStmt(r) => "{\"DropStmt\":{${json_drop_stmt(r)}}}"
		DropSubscriptionStmt(r) => "{\"DropSubscriptionStmt\":{${json_drop_subscription_stmt(r)}}}"
		DropTableSpaceStmt(r) => "{\"DropTableSpaceStmt\":{${json_drop_table_space_stmt(r)}}}"
		DropUserMappingStmt(r) => "{\"DropUserMappingStmt\":{${json_drop_user_mapping_stmt(r)}}}"
		DropdbStmt(r) => "{\"DropdbStmt\":{${json_dropdb_stmt(r)}}}"
		ExecuteStmt(r) => "{\"ExecuteStmt\":{${json_execute_stmt(r)}}}"
		ExplainStmt(r) => "{\"ExplainStmt\":{${json_explain_stmt(r)}}}"
		FetchStmt(r) => "{\"FetchStmt\":{${json_fetch_stmt(r)}}}"
		Float(r) => "{\"Float\":{${json_float(r)}}}"
		FuncCall(r) => "{\"FuncCall\":{${json_func_call(r)}}}"
		FunctionParameter(r) => "{\"FunctionParameter\":{${json_function_parameter(r)}}}"
		GrantRoleStmt(r) => "{\"GrantRoleStmt\":{${json_grant_role_stmt(r)}}}"
		GrantStmt(r) => "{\"GrantStmt\":{${json_grant_stmt(r)}}}"
		GroupClause(r) => "{\"GroupClause\":{${json_group_clause(r)}}}"
		GroupingFunc(r) => "{\"GroupingFunc\":{${json_grouping_func(r)}}}"
		GroupingSet(r) => "{\"GroupingSet\":{${json_grouping_set(r)}}}"
		ImportForeignSchemaStmt(r) => "{\"ImportForeignSchemaStmt\":{${json_import_foreign_schema_stmt(r)}}}"
		ImportQual(r) => "{\"ImportQual\":{${json_import_qual(r)}}}"
		IndexElem(r) => "{\"IndexElem\":{${json_index_elem(r)}}}"
		IndexStmt(r) => "{\"IndexStmt\":{${json_index_stmt(r)}}}"
		InferClause(r) => "{\"InferClause\":{${json_infer_clause(r)}}}"
		InsertStmt(r) => "{\"InsertStmt\":{${json_insert_stmt(r)}}}"
		Integer(r) => "{\"Integer\":{${json_integer(r)}}}"
		IntoClause(r) => "{\"IntoClause\":{${json_into_clause(r)}}}"
		JoinExpr(r) => "{\"JoinExpr\":{${json_join_expr(r)}}}"
		JsonAggConstructor(r) => "{\"JsonAggConstructor\":{${json_json_agg_constructor(r)}}}"
		JsonArgument(r) => "{\"JsonArgument\":{${json_json_argument(r)}}}"
		JsonArrayAgg(r) => "{\"JsonArrayAgg\":{${json_json_array_agg(r)}}}"
		JsonArrayConstructor(r) => "{\"JsonArrayConstructor\":{${json_json_array_constructor(r)}}}"
		JsonArrayQueryConstructor(r) => "{\"JsonArrayQueryConstructor\":{${json_json_array_query_constructor(r)}}}"
		JsonBehavior(r) => "{\"JsonBehavior\":{${json_json_behavior(r)}}}"
		JsonFormat(r) => "{\"JsonFormat\":{${json_json_format(r)}}}"
		JsonFuncExpr(r) => "{\"JsonFuncExpr\":{${json_json_func_expr(r)}}}"
		JsonIsPredicate(r) => "{\"JsonIsPredicate\":{${json_json_is_predicate(r)}}}"
		JsonKeyValue(r) => "{\"JsonKeyValue\":{${json_json_key_value(r)}}}"
		JsonObjectAgg(r) => "{\"JsonObjectAgg\":{${json_json_object_agg(r)}}}"
		JsonObjectConstructor(r) => "{\"JsonObjectConstructor\":{${json_json_object_constructor(r)}}}"
		JsonOutput(r) => "{\"JsonOutput\":{${json_json_output(r)}}}"
		JsonParseExpr(r) => "{\"JsonParseExpr\":{${json_json_parse_expr(r)}}}"
		JsonReturning(r) => "{\"JsonReturning\":{${json_json_returning(r)}}}"
		JsonScalarExpr(r) => "{\"JsonScalarExpr\":{${json_json_scalar_expr(r)}}}"
		JsonSerializeExpr(r) => "{\"JsonSerializeExpr\":{${json_json_serialize_expr(r)}}}"
		JsonTable(r) => "{\"JsonTable\":{${json_json_table(r)}}}"
		JsonTableColumn(r) => "{\"JsonTableColumn\":{${json_json_table_column(r)}}}"
		JsonTablePathSpec(r) => "{\"JsonTablePathSpec\":{${json_json_table_path_spec(r)}}}"
		JsonValueExpr(r) => "{\"JsonValueExpr\":{${json_json_value_expr(r)}}}"
		KeyAction(r) => "{\"KeyAction\":{${json_key_action(r)}}}"
		KeyActions(r) => "{\"KeyActions\":{${json_key_actions(r)}}}"
		ListenStmt(r) => "{\"ListenStmt\":{${json_listen_stmt(r)}}}"
		LoadStmt(r) => "{\"LoadStmt\":{${json_load_stmt(r)}}}"
		LockStmt(r) => "{\"LockStmt\":{${json_lock_stmt(r)}}}"
		LockingClause(r) => "{\"LockingClause\":{${json_locking_clause(r)}}}"
		MergeStmt(r) => "{\"MergeStmt\":{${json_merge_stmt(r)}}}"
		MergeSupportFunc(r) => "{\"MergeSupportFunc\":{${json_merge_support_func(r)}}}"
		MergeWhenClause(r) => "{\"MergeWhenClause\":{${json_merge_when_clause(r)}}}"
		MinMaxExpr(r) => "{\"MinMaxExpr\":{${json_min_max_expr(r)}}}"
		MultiAssignRef(r) => "{\"MultiAssignRef\":{${json_multi_assign_ref(r)}}}"
		NamedArgExpr(r) => "{\"NamedArgExpr\":{${json_named_arg_expr(r)}}}"
		NotifyStmt(r) => "{\"NotifyStmt\":{${json_notify_stmt(r)}}}"
		NullTest(r) => "{\"NullTest\":{${json_null_test(r)}}}"
		ObjectWithArgs(r) => "{\"ObjectWithArgs\":{${json_object_with_args(r)}}}"
		OnConflictClause(r) => "{\"OnConflictClause\":{${json_on_conflict_clause(r)}}}"
		PLAssignStmt(r) => "{\"PLAssignStmt\":{${json_pl_assign_stmt(r)}}}"
		ParamRef(r) => "{\"ParamRef\":{${json_param_ref(r)}}}"
		PartitionBoundSpec(r) => "{\"PartitionBoundSpec\":{${json_partition_bound_spec(r)}}}"
		PartitionCmd(r) => "{\"PartitionCmd\":{${json_partition_cmd(r)}}}"
		PartitionElem(r) => "{\"PartitionElem\":{${json_partition_elem(r)}}}"
		PartitionSpec(r) => "{\"PartitionSpec\":{${json_partition_spec(r)}}}"
		PrepareStmt(r) => "{\"PrepareStmt\":{${json_prepare_stmt(r)}}}"
		PrivTarget(r) => "{\"PrivTarget\":{${json_priv_target(r)}}}"
		PublicationObjSpec(r) => "{\"PublicationObjSpec\":{${json_publication_obj_spec(r)}}}"
		PublicationTable(r) => "{\"PublicationTable\":{${json_publication_table(r)}}}"
		RangeFunction(r) => "{\"RangeFunction\":{${json_range_function(r)}}}"
		RangeSubselect(r) => "{\"RangeSubselect\":{${json_range_subselect(r)}}}"
		RangeTableFunc(r) => "{\"RangeTableFunc\":{${json_range_table_func(r)}}}"
		RangeTableFuncCol(r) => "{\"RangeTableFuncCol\":{${json_range_table_func_col(r)}}}"
		RangeTableSample(r) => "{\"RangeTableSample\":{${json_range_table_sample(r)}}}"
		RangeVar(r) => "{\"RangeVar\":{${json_range_var(r)}}}"
		RawStmt(r) => "{\"RawStmt\":{${json_raw_stmt(r)}}}"
		ReassignOwnedStmt(r) => "{\"ReassignOwnedStmt\":{${json_reassign_owned_stmt(r)}}}"
		RefreshMatViewStmt(r) => "{\"RefreshMatViewStmt\":{${json_refresh_mat_view_stmt(r)}}}"
		ReindexStmt(r) => "{\"ReindexStmt\":{${json_reindex_stmt(r)}}}"
		RenameStmt(r) => "{\"RenameStmt\":{${json_rename_stmt(r)}}}"
		ReplicaIdentityStmt(r) => "{\"ReplicaIdentityStmt\":{${json_replica_identity_stmt(r)}}}"
		ResTarget(r) => "{\"ResTarget\":{${json_res_target(r)}}}"
		ReturnStmt(r) => "{\"ReturnStmt\":{${json_return_stmt(r)}}}"
		ReturningClause(r) => "{\"ReturningClause\":{${json_returning_clause(r)}}}"
		ReturningOption(r) => "{\"ReturningOption\":{${json_returning_option(r)}}}"
		RoleSpec(r) => "{\"RoleSpec\":{${json_role_spec(r)}}}"
		RowExpr(r) => "{\"RowExpr\":{${json_row_expr(r)}}}"
		RuleStmt(r) => "{\"RuleStmt\":{${json_rule_stmt(r)}}}"
		SQLValueFunction(r) => "{\"SQLValueFunction\":{${json_sql_value_function(r)}}}"
		SecLabelStmt(r) => "{\"SecLabelStmt\":{${json_sec_label_stmt(r)}}}"
		SelectLimit(r) => "{\"SelectLimit\":{${json_select_limit(r)}}}"
		SelectStmt(r) => "{\"SelectStmt\":{${json_select_stmt(r)}}}"
		SetToDefault(r) => "{\"SetToDefault\":{${json_set_to_default(r)}}}"
		SortBy(r) => "{\"SortBy\":{${json_sort_by(r)}}}"
		StatsElem(r) => "{\"StatsElem\":{${json_stats_elem(r)}}}"
		String(r) => "{\"String\":{${json_string(r)}}}"
		SubLink(r) => "{\"SubLink\":{${json_sub_link(r)}}}"
		TableLikeClause(r) => "{\"TableLikeClause\":{${json_table_like_clause(r)}}}"
		TransactionStmt(r) => "{\"TransactionStmt\":{${json_transaction_stmt(r)}}}"
		TriggerTransition(r) => "{\"TriggerTransition\":{${json_trigger_transition(r)}}}"
		TruncateStmt(r) => "{\"TruncateStmt\":{${json_truncate_stmt(r)}}}"
		TypeCast(r) => "{\"TypeCast\":{${json_type_cast(r)}}}"
		TypeName(r) => "{\"TypeName\":{${json_type_name(r)}}}"
		UnlistenStmt(r) => "{\"UnlistenStmt\":{${json_unlisten_stmt(r)}}}"
		UpdateStmt(r) => "{\"UpdateStmt\":{${json_update_stmt(r)}}}"
		VacuumRelation(r) => "{\"VacuumRelation\":{${json_vacuum_relation(r)}}}"
		VacuumStmt(r) => "{\"VacuumStmt\":{${json_vacuum_stmt(r)}}}"
		VariableSetStmt(r) => "{\"VariableSetStmt\":{${json_variable_set_stmt(r)}}}"
		VariableShowStmt(r) => "{\"VariableShowStmt\":{${json_variable_show_stmt(r)}}}"
		ViewStmt(r) => "{\"ViewStmt\":{${json_view_stmt(r)}}}"
		WindowDef(r) => "{\"WindowDef\":{${json_window_def(r)}}}"
		WithClause(r) => "{\"WithClause\":{${json_with_clause(r)}}}"
		XmlExpr(r) => "{\"XmlExpr\":{${json_xml_expr(r)}}}"
		XmlSerialize(r) => "{\"XmlSerialize\":{${json_xml_serialize(r)}}}"
	}

## A node's fields without its type around it.
body : Node -> Str
body = |n|
	match n {
		Null | NodeList(_) => ""
		ATAlterConstraint(r) => json_at_alter_constraint(r)
		AArrayExpr(r) => json_a_array_expr(r)
		AConst(r) => json_a_const(r)
		AExpr(r) => json_a_expr(r)
		AIndices(r) => json_a_indices(r)
		AIndirection(r) => json_a_indirection(r)
		AStar(r) => json_a_star(r)
		AccessPriv(r) => json_access_priv(r)
		Alias(r) => json_alias(r)
		AlterCollationStmt(r) => json_alter_collation_stmt(r)
		AlterDatabaseRefreshCollStmt(r) => json_alter_database_refresh_coll_stmt(r)
		AlterDatabaseSetStmt(r) => json_alter_database_set_stmt(r)
		AlterDatabaseStmt(r) => json_alter_database_stmt(r)
		AlterDefaultPrivilegesStmt(r) => json_alter_default_privileges_stmt(r)
		AlterDomainStmt(r) => json_alter_domain_stmt(r)
		AlterEnumStmt(r) => json_alter_enum_stmt(r)
		AlterEventTrigStmt(r) => json_alter_event_trig_stmt(r)
		AlterExtensionContentsStmt(r) => json_alter_extension_contents_stmt(r)
		AlterExtensionStmt(r) => json_alter_extension_stmt(r)
		AlterFdwStmt(r) => json_alter_fdw_stmt(r)
		AlterForeignServerStmt(r) => json_alter_foreign_server_stmt(r)
		AlterFunctionStmt(r) => json_alter_function_stmt(r)
		AlterObjectDependsStmt(r) => json_alter_object_depends_stmt(r)
		AlterObjectSchemaStmt(r) => json_alter_object_schema_stmt(r)
		AlterOpFamilyStmt(r) => json_alter_op_family_stmt(r)
		AlterOperatorStmt(r) => json_alter_operator_stmt(r)
		AlterOwnerStmt(r) => json_alter_owner_stmt(r)
		AlterPolicyStmt(r) => json_alter_policy_stmt(r)
		AlterPublicationStmt(r) => json_alter_publication_stmt(r)
		AlterRoleSetStmt(r) => json_alter_role_set_stmt(r)
		AlterRoleStmt(r) => json_alter_role_stmt(r)
		AlterSeqStmt(r) => json_alter_seq_stmt(r)
		AlterStatsStmt(r) => json_alter_stats_stmt(r)
		AlterSubscriptionStmt(r) => json_alter_subscription_stmt(r)
		AlterSystemStmt(r) => json_alter_system_stmt(r)
		AlterTSConfigurationStmt(r) => json_alter_ts_configuration_stmt(r)
		AlterTSDictionaryStmt(r) => json_alter_ts_dictionary_stmt(r)
		AlterTableCmd(r) => json_alter_table_cmd(r)
		AlterTableMoveAllStmt(r) => json_alter_table_move_all_stmt(r)
		AlterTableSpaceOptionsStmt(r) => json_alter_table_space_options_stmt(r)
		AlterTableStmt(r) => json_alter_table_stmt(r)
		AlterTypeStmt(r) => json_alter_type_stmt(r)
		AlterUserMappingStmt(r) => json_alter_user_mapping_stmt(r)
		BitString(r) => json_bit_string(r)
		BoolExpr(r) => json_bool_expr(r)
		Boolean(r) => json_boolean(r)
		BooleanTest(r) => json_boolean_test(r)
		CTECycleClause(r) => json_cte_cycle_clause(r)
		CTESearchClause(r) => json_cte_search_clause(r)
		CallStmt(r) => json_call_stmt(r)
		CaseExpr(r) => json_case_expr(r)
		CaseWhen(r) => json_case_when(r)
		CheckPointStmt(r) => json_check_point_stmt(r)
		ClosePortalStmt(r) => json_close_portal_stmt(r)
		ClusterStmt(r) => json_cluster_stmt(r)
		CoalesceExpr(r) => json_coalesce_expr(r)
		CollateClause(r) => json_collate_clause(r)
		ColumnDef(r) => json_column_def(r)
		ColumnRef(r) => json_column_ref(r)
		CommentStmt(r) => json_comment_stmt(r)
		CommonTableExpr(r) => json_common_table_expr(r)
		CompositeTypeStmt(r) => json_composite_type_stmt(r)
		Constraint(r) => json_constraint(r)
		ConstraintsSetStmt(r) => json_constraints_set_stmt(r)
		CopyStmt(r) => json_copy_stmt(r)
		CreateAmStmt(r) => json_create_am_stmt(r)
		CreateCastStmt(r) => json_create_cast_stmt(r)
		CreateConversionStmt(r) => json_create_conversion_stmt(r)
		CreateDomainStmt(r) => json_create_domain_stmt(r)
		CreateEnumStmt(r) => json_create_enum_stmt(r)
		CreateEventTrigStmt(r) => json_create_event_trig_stmt(r)
		CreateExtensionStmt(r) => json_create_extension_stmt(r)
		CreateFdwStmt(r) => json_create_fdw_stmt(r)
		CreateForeignServerStmt(r) => json_create_foreign_server_stmt(r)
		CreateForeignTableStmt(r) => json_create_foreign_table_stmt(r)
		CreateFunctionStmt(r) => json_create_function_stmt(r)
		CreateOpClassItem(r) => json_create_op_class_item(r)
		CreateOpClassStmt(r) => json_create_op_class_stmt(r)
		CreateOpFamilyStmt(r) => json_create_op_family_stmt(r)
		CreatePLangStmt(r) => json_create_p_lang_stmt(r)
		CreatePolicyStmt(r) => json_create_policy_stmt(r)
		CreatePublicationStmt(r) => json_create_publication_stmt(r)
		CreateRangeStmt(r) => json_create_range_stmt(r)
		CreateRoleStmt(r) => json_create_role_stmt(r)
		CreateSchemaStmt(r) => json_create_schema_stmt(r)
		CreateSeqStmt(r) => json_create_seq_stmt(r)
		CreateStatsStmt(r) => json_create_stats_stmt(r)
		CreateStmt(r) => json_create_stmt(r)
		CreateSubscriptionStmt(r) => json_create_subscription_stmt(r)
		CreateTableAsStmt(r) => json_create_table_as_stmt(r)
		CreateTableSpaceStmt(r) => json_create_table_space_stmt(r)
		CreateTransformStmt(r) => json_create_transform_stmt(r)
		CreateTrigStmt(r) => json_create_trig_stmt(r)
		CreateUserMappingStmt(r) => json_create_user_mapping_stmt(r)
		CreatedbStmt(r) => json_createdb_stmt(r)
		CurrentOfExpr(r) => json_current_of_expr(r)
		DeallocateStmt(r) => json_deallocate_stmt(r)
		DeclareCursorStmt(r) => json_declare_cursor_stmt(r)
		DefElem(r) => json_def_elem(r)
		DefineStmt(r) => json_define_stmt(r)
		DeleteStmt(r) => json_delete_stmt(r)
		DiscardStmt(r) => json_discard_stmt(r)
		DoStmt(r) => json_do_stmt(r)
		DropOwnedStmt(r) => json_drop_owned_stmt(r)
		DropRoleStmt(r) => json_drop_role_stmt(r)
		DropStmt(r) => json_drop_stmt(r)
		DropSubscriptionStmt(r) => json_drop_subscription_stmt(r)
		DropTableSpaceStmt(r) => json_drop_table_space_stmt(r)
		DropUserMappingStmt(r) => json_drop_user_mapping_stmt(r)
		DropdbStmt(r) => json_dropdb_stmt(r)
		ExecuteStmt(r) => json_execute_stmt(r)
		ExplainStmt(r) => json_explain_stmt(r)
		FetchStmt(r) => json_fetch_stmt(r)
		Float(r) => json_float(r)
		FuncCall(r) => json_func_call(r)
		FunctionParameter(r) => json_function_parameter(r)
		GrantRoleStmt(r) => json_grant_role_stmt(r)
		GrantStmt(r) => json_grant_stmt(r)
		GroupClause(r) => json_group_clause(r)
		GroupingFunc(r) => json_grouping_func(r)
		GroupingSet(r) => json_grouping_set(r)
		ImportForeignSchemaStmt(r) => json_import_foreign_schema_stmt(r)
		ImportQual(r) => json_import_qual(r)
		IndexElem(r) => json_index_elem(r)
		IndexStmt(r) => json_index_stmt(r)
		InferClause(r) => json_infer_clause(r)
		InsertStmt(r) => json_insert_stmt(r)
		Integer(r) => json_integer(r)
		IntoClause(r) => json_into_clause(r)
		JoinExpr(r) => json_join_expr(r)
		JsonAggConstructor(r) => json_json_agg_constructor(r)
		JsonArgument(r) => json_json_argument(r)
		JsonArrayAgg(r) => json_json_array_agg(r)
		JsonArrayConstructor(r) => json_json_array_constructor(r)
		JsonArrayQueryConstructor(r) => json_json_array_query_constructor(r)
		JsonBehavior(r) => json_json_behavior(r)
		JsonFormat(r) => json_json_format(r)
		JsonFuncExpr(r) => json_json_func_expr(r)
		JsonIsPredicate(r) => json_json_is_predicate(r)
		JsonKeyValue(r) => json_json_key_value(r)
		JsonObjectAgg(r) => json_json_object_agg(r)
		JsonObjectConstructor(r) => json_json_object_constructor(r)
		JsonOutput(r) => json_json_output(r)
		JsonParseExpr(r) => json_json_parse_expr(r)
		JsonReturning(r) => json_json_returning(r)
		JsonScalarExpr(r) => json_json_scalar_expr(r)
		JsonSerializeExpr(r) => json_json_serialize_expr(r)
		JsonTable(r) => json_json_table(r)
		JsonTableColumn(r) => json_json_table_column(r)
		JsonTablePathSpec(r) => json_json_table_path_spec(r)
		JsonValueExpr(r) => json_json_value_expr(r)
		KeyAction(r) => json_key_action(r)
		KeyActions(r) => json_key_actions(r)
		ListenStmt(r) => json_listen_stmt(r)
		LoadStmt(r) => json_load_stmt(r)
		LockStmt(r) => json_lock_stmt(r)
		LockingClause(r) => json_locking_clause(r)
		MergeStmt(r) => json_merge_stmt(r)
		MergeSupportFunc(r) => json_merge_support_func(r)
		MergeWhenClause(r) => json_merge_when_clause(r)
		MinMaxExpr(r) => json_min_max_expr(r)
		MultiAssignRef(r) => json_multi_assign_ref(r)
		NamedArgExpr(r) => json_named_arg_expr(r)
		NotifyStmt(r) => json_notify_stmt(r)
		NullTest(r) => json_null_test(r)
		ObjectWithArgs(r) => json_object_with_args(r)
		OnConflictClause(r) => json_on_conflict_clause(r)
		PLAssignStmt(r) => json_pl_assign_stmt(r)
		ParamRef(r) => json_param_ref(r)
		PartitionBoundSpec(r) => json_partition_bound_spec(r)
		PartitionCmd(r) => json_partition_cmd(r)
		PartitionElem(r) => json_partition_elem(r)
		PartitionSpec(r) => json_partition_spec(r)
		PrepareStmt(r) => json_prepare_stmt(r)
		PrivTarget(r) => json_priv_target(r)
		PublicationObjSpec(r) => json_publication_obj_spec(r)
		PublicationTable(r) => json_publication_table(r)
		RangeFunction(r) => json_range_function(r)
		RangeSubselect(r) => json_range_subselect(r)
		RangeTableFunc(r) => json_range_table_func(r)
		RangeTableFuncCol(r) => json_range_table_func_col(r)
		RangeTableSample(r) => json_range_table_sample(r)
		RangeVar(r) => json_range_var(r)
		RawStmt(r) => json_raw_stmt(r)
		ReassignOwnedStmt(r) => json_reassign_owned_stmt(r)
		RefreshMatViewStmt(r) => json_refresh_mat_view_stmt(r)
		ReindexStmt(r) => json_reindex_stmt(r)
		RenameStmt(r) => json_rename_stmt(r)
		ReplicaIdentityStmt(r) => json_replica_identity_stmt(r)
		ResTarget(r) => json_res_target(r)
		ReturnStmt(r) => json_return_stmt(r)
		ReturningClause(r) => json_returning_clause(r)
		ReturningOption(r) => json_returning_option(r)
		RoleSpec(r) => json_role_spec(r)
		RowExpr(r) => json_row_expr(r)
		RuleStmt(r) => json_rule_stmt(r)
		SQLValueFunction(r) => json_sql_value_function(r)
		SecLabelStmt(r) => json_sec_label_stmt(r)
		SelectLimit(r) => json_select_limit(r)
		SelectStmt(r) => json_select_stmt(r)
		SetToDefault(r) => json_set_to_default(r)
		SortBy(r) => json_sort_by(r)
		StatsElem(r) => json_stats_elem(r)
		String(r) => json_string(r)
		SubLink(r) => json_sub_link(r)
		TableLikeClause(r) => json_table_like_clause(r)
		TransactionStmt(r) => json_transaction_stmt(r)
		TriggerTransition(r) => json_trigger_transition(r)
		TruncateStmt(r) => json_truncate_stmt(r)
		TypeCast(r) => json_type_cast(r)
		TypeName(r) => json_type_name(r)
		UnlistenStmt(r) => json_unlisten_stmt(r)
		UpdateStmt(r) => json_update_stmt(r)
		VacuumRelation(r) => json_vacuum_relation(r)
		VacuumStmt(r) => json_vacuum_stmt(r)
		VariableSetStmt(r) => json_variable_set_stmt(r)
		VariableShowStmt(r) => json_variable_show_stmt(r)
		ViewStmt(r) => json_view_stmt(r)
		WindowDef(r) => json_window_def(r)
		WithClause(r) => json_with_clause(r)
		XmlExpr(r) => json_xml_expr(r)
		XmlSerialize(r) => json_xml_serialize(r)
	}

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

json_at_alter_constraint : Node.ATAlterConstraint -> Str
json_at_alter_constraint = |r|
	fields(
		[
			text_field("conname", r.conname),
			bool_field("alterEnforceability", r.alter_enforceability),
			bool_field("is_enforced", r.is_enforced),
			bool_field("alterDeferrability", r.alter_deferrability),
			bool_field("deferrable", r.deferrable),
			bool_field("initdeferred", r.initdeferred),
			bool_field("alterInheritability", r.alter_inheritability),
			bool_field("noinherit", r.noinherit),
		],
	)

json_a_array_expr : Node.AArrayExpr -> Str
json_a_array_expr = |r|
	fields(
		[
			list_field("elements", r.elements),
			int_field("list_start", r.list_start),
			int_field("list_end", r.list_end),
			int_field("location", r.location),
		],
	)

json_a_const : Node.AConst -> Str
json_a_const = |r| (if r.isnull "\"isnull\":true" else a_const_value(r.val)).concat(",\"location\":${r.location.to_str()}")

json_a_expr : Node.AExpr -> Str
json_a_expr = |r|
	fields(
		[
			enum_field("kind", enum_a_expr_kind(r.kind)),
			list_field("name", r.name),
			node_field("lexpr", r.lexpr),
			node_field("rexpr", r.rexpr),
			int_field("rexpr_list_start", r.rexpr_list_start),
			int_field("rexpr_list_end", r.rexpr_list_end),
			int_field("location", r.location),
		],
	)

json_a_indices : Node.AIndices -> Str
json_a_indices = |r|
	fields(
		[
			bool_field("is_slice", r.is_slice),
			node_field("lidx", r.lidx),
			node_field("uidx", r.uidx),
		],
	)

json_a_indirection : Node.AIndirection -> Str
json_a_indirection = |r|
	fields(
		[
			node_field("arg", r.arg),
			list_field("indirection", r.indirection),
		],
	)

json_a_star : Node.AStar -> Str
json_a_star = |_r| ""

json_access_priv : Node.AccessPriv -> Str
json_access_priv = |r|
	fields(
		[
			text_field("priv_name", r.priv_name),
			list_field("cols", r.cols),
		],
	)

json_alias : Node.Alias -> Str
json_alias = |r|
	fields(
		[
			text_field("aliasname", r.aliasname),
			list_field("colnames", r.colnames),
		],
	)

json_alter_collation_stmt : Node.AlterCollationStmt -> Str
json_alter_collation_stmt = |r|
	fields(
		[
			list_field("collname", r.collname),
		],
	)

json_alter_database_refresh_coll_stmt : Node.AlterDatabaseRefreshCollStmt -> Str
json_alter_database_refresh_coll_stmt = |r|
	fields(
		[
			text_field("dbname", r.dbname),
		],
	)

json_alter_database_set_stmt : Node.AlterDatabaseSetStmt -> Str
json_alter_database_set_stmt = |r|
	fields(
		[
			text_field("dbname", r.dbname),
			specific_ptr_field("setstmt", r.setstmt),
		],
	)

json_alter_database_stmt : Node.AlterDatabaseStmt -> Str
json_alter_database_stmt = |r|
	fields(
		[
			text_field("dbname", r.dbname),
			list_field("options", r.options),
		],
	)

json_alter_default_privileges_stmt : Node.AlterDefaultPrivilegesStmt -> Str
json_alter_default_privileges_stmt = |r|
	fields(
		[
			list_field("options", r.options),
			specific_ptr_field("action", r.action),
		],
	)

json_alter_domain_stmt : Node.AlterDomainStmt -> Str
json_alter_domain_stmt = |r|
	fields(
		[
			char_field("subtype", r.subtype),
			list_field("typeName", r.type_name),
			text_field("name", r.name),
			node_field("def", r.def),
			enum_field("behavior", enum_drop_behavior(r.behavior)),
			bool_field("missing_ok", r.missing_ok),
		],
	)

json_alter_enum_stmt : Node.AlterEnumStmt -> Str
json_alter_enum_stmt = |r|
	fields(
		[
			list_field("typeName", r.type_name),
			text_field("oldVal", r.old_val),
			text_field("newVal", r.new_val),
			text_field("newValNeighbor", r.new_val_neighbor),
			bool_field("newValIsAfter", r.new_val_is_after),
			bool_field("skipIfNewValExists", r.skip_if_new_val_exists),
		],
	)

json_alter_event_trig_stmt : Node.AlterEventTrigStmt -> Str
json_alter_event_trig_stmt = |r|
	fields(
		[
			text_field("trigname", r.trigname),
			char_field("tgenabled", r.tgenabled),
		],
	)

json_alter_extension_contents_stmt : Node.AlterExtensionContentsStmt -> Str
json_alter_extension_contents_stmt = |r|
	fields(
		[
			text_field("extname", r.extname),
			int_field("action", r.action),
			enum_field("objtype", enum_object_type(r.objtype)),
			node_field("object", r.object),
		],
	)

json_alter_extension_stmt : Node.AlterExtensionStmt -> Str
json_alter_extension_stmt = |r|
	fields(
		[
			text_field("extname", r.extname),
			list_field("options", r.options),
		],
	)

json_alter_fdw_stmt : Node.AlterFdwStmt -> Str
json_alter_fdw_stmt = |r|
	fields(
		[
			text_field("fdwname", r.fdwname),
			list_field("func_options", r.func_options),
			list_field("options", r.options),
		],
	)

json_alter_foreign_server_stmt : Node.AlterForeignServerStmt -> Str
json_alter_foreign_server_stmt = |r|
	fields(
		[
			text_field("servername", r.servername),
			text_field("version", r.version),
			list_field("options", r.options),
			bool_field("has_version", r.has_version),
		],
	)

json_alter_function_stmt : Node.AlterFunctionStmt -> Str
json_alter_function_stmt = |r|
	fields(
		[
			enum_field("objtype", enum_object_type(r.objtype)),
			specific_ptr_field("func", r.func),
			list_field("actions", r.actions),
		],
	)

json_alter_object_depends_stmt : Node.AlterObjectDependsStmt -> Str
json_alter_object_depends_stmt = |r|
	fields(
		[
			enum_field("objectType", enum_object_type(r.object_type)),
			specific_ptr_field("relation", r.relation),
			node_field("object", r.object),
			specific_ptr_field("extname", r.extname),
			bool_field("remove", r.remove),
		],
	)

json_alter_object_schema_stmt : Node.AlterObjectSchemaStmt -> Str
json_alter_object_schema_stmt = |r|
	fields(
		[
			enum_field("objectType", enum_object_type(r.object_type)),
			specific_ptr_field("relation", r.relation),
			node_field("object", r.object),
			text_field("newschema", r.newschema),
			bool_field("missing_ok", r.missing_ok),
		],
	)

json_alter_op_family_stmt : Node.AlterOpFamilyStmt -> Str
json_alter_op_family_stmt = |r|
	fields(
		[
			list_field("opfamilyname", r.opfamilyname),
			text_field("amname", r.amname),
			bool_field("isDrop", r.is_drop),
			list_field("items", r.items),
		],
	)

json_alter_operator_stmt : Node.AlterOperatorStmt -> Str
json_alter_operator_stmt = |r|
	fields(
		[
			specific_ptr_field("opername", r.opername),
			list_field("options", r.options),
		],
	)

json_alter_owner_stmt : Node.AlterOwnerStmt -> Str
json_alter_owner_stmt = |r|
	fields(
		[
			enum_field("objectType", enum_object_type(r.object_type)),
			specific_ptr_field("relation", r.relation),
			node_field("object", r.object),
			specific_ptr_field("newowner", r.newowner),
		],
	)

json_alter_policy_stmt : Node.AlterPolicyStmt -> Str
json_alter_policy_stmt = |r|
	fields(
		[
			text_field("policy_name", r.policy_name),
			specific_ptr_field("table", r.table),
			list_field("roles", r.roles),
			node_field("qual", r.qual),
			node_field("with_check", r.with_check),
		],
	)

json_alter_publication_stmt : Node.AlterPublicationStmt -> Str
json_alter_publication_stmt = |r|
	fields(
		[
			text_field("pubname", r.pubname),
			list_field("options", r.options),
			list_field("pubobjects", r.pubobjects),
			bool_field("for_all_tables", r.for_all_tables),
			enum_field("action", enum_alter_publication_action(r.action)),
		],
	)

json_alter_role_set_stmt : Node.AlterRoleSetStmt -> Str
json_alter_role_set_stmt = |r|
	fields(
		[
			specific_ptr_field("role", r.role),
			text_field("database", r.database),
			specific_ptr_field("setstmt", r.setstmt),
		],
	)

json_alter_role_stmt : Node.AlterRoleStmt -> Str
json_alter_role_stmt = |r|
	fields(
		[
			specific_ptr_field("role", r.role),
			list_field("options", r.options),
			int_field("action", r.action),
		],
	)

json_alter_seq_stmt : Node.AlterSeqStmt -> Str
json_alter_seq_stmt = |r|
	fields(
		[
			specific_ptr_field("sequence", r.sequence),
			list_field("options", r.options),
			bool_field("for_identity", r.for_identity),
			bool_field("missing_ok", r.missing_ok),
		],
	)

json_alter_stats_stmt : Node.AlterStatsStmt -> Str
json_alter_stats_stmt = |r|
	fields(
		[
			list_field("defnames", r.defnames),
			node_field("stxstattarget", r.stxstattarget),
			bool_field("missing_ok", r.missing_ok),
		],
	)

json_alter_subscription_stmt : Node.AlterSubscriptionStmt -> Str
json_alter_subscription_stmt = |r|
	fields(
		[
			enum_field("kind", enum_alter_subscription_type(r.kind)),
			text_field("subname", r.subname),
			text_field("conninfo", r.conninfo),
			list_field("publication", r.publication),
			list_field("options", r.options),
		],
	)

json_alter_system_stmt : Node.AlterSystemStmt -> Str
json_alter_system_stmt = |r|
	fields(
		[
			specific_ptr_field("setstmt", r.setstmt),
		],
	)

json_alter_ts_configuration_stmt : Node.AlterTSConfigurationStmt -> Str
json_alter_ts_configuration_stmt = |r|
	fields(
		[
			enum_field("kind", enum_alter_ts_config_type(r.kind)),
			list_field("cfgname", r.cfgname),
			list_field("tokentype", r.tokentype),
			list_field("dicts", r.dicts),
			bool_field("override", r.override),
			bool_field("replace", r.replace),
			bool_field("missing_ok", r.missing_ok),
		],
	)

json_alter_ts_dictionary_stmt : Node.AlterTSDictionaryStmt -> Str
json_alter_ts_dictionary_stmt = |r|
	fields(
		[
			list_field("dictname", r.dictname),
			list_field("options", r.options),
		],
	)

json_alter_table_cmd : Node.AlterTableCmd -> Str
json_alter_table_cmd = |r|
	fields(
		[
			enum_field("subtype", enum_alter_table_type(r.subtype)),
			text_field("name", r.name),
			int_field("num", r.num),
			specific_ptr_field("newowner", r.newowner),
			node_field("def", r.def),
			enum_field("behavior", enum_drop_behavior(r.behavior)),
			bool_field("missing_ok", r.missing_ok),
			bool_field("recurse", r.recurse),
		],
	)

json_alter_table_move_all_stmt : Node.AlterTableMoveAllStmt -> Str
json_alter_table_move_all_stmt = |r|
	fields(
		[
			text_field("orig_tablespacename", r.orig_tablespacename),
			enum_field("objtype", enum_object_type(r.objtype)),
			list_field("roles", r.roles),
			text_field("new_tablespacename", r.new_tablespacename),
			bool_field("nowait", r.nowait),
		],
	)

json_alter_table_space_options_stmt : Node.AlterTableSpaceOptionsStmt -> Str
json_alter_table_space_options_stmt = |r|
	fields(
		[
			text_field("tablespacename", r.tablespacename),
			list_field("options", r.options),
			bool_field("isReset", r.is_reset),
		],
	)

json_alter_table_stmt : Node.AlterTableStmt -> Str
json_alter_table_stmt = |r|
	fields(
		[
			specific_ptr_field("relation", r.relation),
			list_field("cmds", r.cmds),
			enum_field("objtype", enum_object_type(r.objtype)),
			bool_field("missing_ok", r.missing_ok),
		],
	)

json_alter_type_stmt : Node.AlterTypeStmt -> Str
json_alter_type_stmt = |r|
	fields(
		[
			list_field("typeName", r.type_name),
			list_field("options", r.options),
		],
	)

json_alter_user_mapping_stmt : Node.AlterUserMappingStmt -> Str
json_alter_user_mapping_stmt = |r|
	fields(
		[
			specific_ptr_field("user", r.user),
			text_field("servername", r.servername),
			list_field("options", r.options),
		],
	)

json_bit_string : Node.BitString -> Str
json_bit_string = |r| "\"bsval\":${token(r.bsval)}"

json_bool_expr : Node.BoolExpr -> Str
json_bool_expr = |r|
	fields(
		[
			enum_field("boolop", enum_bool_expr_type(r.boolop)),
			list_field("args", r.args),
			int_field("location", r.location),
		],
	)

json_boolean : Node.Boolean -> Str
json_boolean = |r| "\"boolval\":${if r.boolval "true" else "false"}"

json_boolean_test : Node.BooleanTest -> Str
json_boolean_test = |r|
	fields(
		[
			node_field("arg", r.arg),
			enum_field("booltesttype", enum_bool_test_type(r.booltesttype)),
			int_field("location", r.location),
		],
	)

json_cte_cycle_clause : Node.CTECycleClause -> Str
json_cte_cycle_clause = |r|
	fields(
		[
			list_field("cycle_col_list", r.cycle_col_list),
			text_field("cycle_mark_column", r.cycle_mark_column),
			node_field("cycle_mark_value", r.cycle_mark_value),
			node_field("cycle_mark_default", r.cycle_mark_default),
			text_field("cycle_path_column", r.cycle_path_column),
			int_field("location", r.location),
			uint_field("cycle_mark_type", r.cycle_mark_type),
			int_field("cycle_mark_typmod", r.cycle_mark_typmod),
			uint_field("cycle_mark_collation", r.cycle_mark_collation),
			uint_field("cycle_mark_neop", r.cycle_mark_neop),
		],
	)

json_cte_search_clause : Node.CTESearchClause -> Str
json_cte_search_clause = |r|
	fields(
		[
			list_field("search_col_list", r.search_col_list),
			bool_field("search_breadth_first", r.search_breadth_first),
			text_field("search_seq_column", r.search_seq_column),
			int_field("location", r.location),
		],
	)

json_call_stmt : Node.CallStmt -> Str
json_call_stmt = |r|
	fields(
		[
			specific_ptr_field("funccall", r.funccall),
			specific_ptr_field("funcexpr", r.funcexpr),
			list_field("outargs", r.outargs),
		],
	)

json_case_expr : Node.CaseExpr -> Str
json_case_expr = |r|
	fields(
		[
			uint_field("casetype", r.casetype),
			uint_field("casecollid", r.casecollid),
			node_field("arg", r.arg),
			list_field("args", r.args),
			node_field("defresult", r.defresult),
			int_field("location", r.location),
		],
	)

json_case_when : Node.CaseWhen -> Str
json_case_when = |r|
	fields(
		[
			node_field("expr", r.expr),
			node_field("result", r.result),
			int_field("location", r.location),
		],
	)

json_check_point_stmt : Node.CheckPointStmt -> Str
json_check_point_stmt = |_r| ""

json_close_portal_stmt : Node.ClosePortalStmt -> Str
json_close_portal_stmt = |r|
	fields(
		[
			text_field("portalname", r.portalname),
		],
	)

json_cluster_stmt : Node.ClusterStmt -> Str
json_cluster_stmt = |r|
	fields(
		[
			specific_ptr_field("relation", r.relation),
			text_field("indexname", r.indexname),
			list_field("params", r.params),
		],
	)

json_coalesce_expr : Node.CoalesceExpr -> Str
json_coalesce_expr = |r|
	fields(
		[
			uint_field("coalescetype", r.coalescetype),
			uint_field("coalescecollid", r.coalescecollid),
			list_field("args", r.args),
			int_field("location", r.location),
		],
	)

json_collate_clause : Node.CollateClause -> Str
json_collate_clause = |r|
	fields(
		[
			node_field("arg", r.arg),
			list_field("collname", r.collname),
			int_field("location", r.location),
		],
	)

json_column_def : Node.ColumnDef -> Str
json_column_def = |r|
	fields(
		[
			text_field("colname", r.colname),
			specific_ptr_field("typeName", r.type_name),
			text_field("compression", r.compression),
			int_field("inhcount", r.inhcount),
			bool_field("is_local", r.is_local),
			bool_field("is_not_null", r.is_not_null),
			bool_field("is_from_type", r.is_from_type),
			char_field("storage", r.storage),
			text_field("storage_name", r.storage_name),
			node_field("raw_default", r.raw_default),
			node_field("cooked_default", r.cooked_default),
			char_field("identity", r.identity),
			specific_ptr_field("identitySequence", r.identity_sequence),
			char_field("generated", r.generated),
			specific_ptr_field("collClause", r.coll_clause),
			uint_field("collOid", r.coll_oid),
			list_field("constraints", r.constraints),
			list_field("fdwoptions", r.fdwoptions),
			int_field("location", r.location),
		],
	)

json_column_ref : Node.ColumnRef -> Str
json_column_ref = |r|
	fields(
		[
			list_field("fields", r.fields),
			int_field("location", r.location),
		],
	)

json_comment_stmt : Node.CommentStmt -> Str
json_comment_stmt = |r|
	fields(
		[
			enum_field("objtype", enum_object_type(r.objtype)),
			node_field("object", r.object),
			text_field("comment", r.comment),
		],
	)

json_common_table_expr : Node.CommonTableExpr -> Str
json_common_table_expr = |r|
	fields(
		[
			text_field("ctename", r.ctename),
			list_field("aliascolnames", r.aliascolnames),
			enum_field("ctematerialized", enum_cte_materialize(r.ctematerialized)),
			node_field("ctequery", r.ctequery),
			specific_ptr_field("search_clause", r.search_clause),
			specific_ptr_field("cycle_clause", r.cycle_clause),
			int_field("location", r.location),
			bool_field("cterecursive", r.cterecursive),
			int_field("cterefcount", r.cterefcount),
			list_field("ctecolnames", r.ctecolnames),
			list_field("ctecoltypes", r.ctecoltypes),
			list_field("ctecoltypmods", r.ctecoltypmods),
			list_field("ctecolcollations", r.ctecolcollations),
		],
	)

json_composite_type_stmt : Node.CompositeTypeStmt -> Str
json_composite_type_stmt = |r|
	fields(
		[
			specific_ptr_field("typevar", r.typevar),
			list_field("coldeflist", r.coldeflist),
		],
	)

json_constraint : Node.Constraint -> Str
json_constraint = |r|
	fields(
		[
			enum_field("contype", enum_constr_type(r.contype)),
			text_field("conname", r.conname),
			bool_field("deferrable", r.deferrable),
			bool_field("initdeferred", r.initdeferred),
			bool_field("is_enforced", r.is_enforced),
			bool_field("skip_validation", r.skip_validation),
			bool_field("initially_valid", r.initially_valid),
			bool_field("is_no_inherit", r.is_no_inherit),
			node_field("raw_expr", r.raw_expr),
			text_field("cooked_expr", r.cooked_expr),
			char_field("generated_when", r.generated_when),
			char_field("generated_kind", r.generated_kind),
			bool_field("nulls_not_distinct", r.nulls_not_distinct),
			list_field("keys", r.keys),
			bool_field("without_overlaps", r.without_overlaps),
			list_field("including", r.including),
			list_field("exclusions", r.exclusions),
			list_field("options", r.options),
			text_field("indexname", r.indexname),
			text_field("indexspace", r.indexspace),
			bool_field("reset_default_tblspc", r.reset_default_tblspc),
			text_field("access_method", r.access_method),
			node_field("where_clause", r.where_clause),
			specific_ptr_field("pktable", r.pktable),
			list_field("fk_attrs", r.fk_attrs),
			list_field("pk_attrs", r.pk_attrs),
			bool_field("fk_with_period", r.fk_with_period),
			bool_field("pk_with_period", r.pk_with_period),
			char_field("fk_matchtype", r.fk_matchtype),
			char_field("fk_upd_action", r.fk_upd_action),
			char_field("fk_del_action", r.fk_del_action),
			list_field("fk_del_set_cols", r.fk_del_set_cols),
			list_field("old_conpfeqop", r.old_conpfeqop),
			uint_field("old_pktable_oid", r.old_pktable_oid),
			int_field("location", r.location),
		],
	)

json_constraints_set_stmt : Node.ConstraintsSetStmt -> Str
json_constraints_set_stmt = |r|
	fields(
		[
			list_field("constraints", r.constraints),
			bool_field("deferred", r.deferred),
		],
	)

json_copy_stmt : Node.CopyStmt -> Str
json_copy_stmt = |r|
	fields(
		[
			specific_ptr_field("relation", r.relation),
			node_field("query", r.query),
			list_field("attlist", r.attlist),
			bool_field("is_from", r.is_from),
			bool_field("is_program", r.is_program),
			text_field("filename", r.filename),
			list_field("options", r.options),
			node_field("whereClause", r.where_clause),
		],
	)

json_create_am_stmt : Node.CreateAmStmt -> Str
json_create_am_stmt = |r|
	fields(
		[
			text_field("amname", r.amname),
			list_field("handler_name", r.handler_name),
			char_field("amtype", r.amtype),
		],
	)

json_create_cast_stmt : Node.CreateCastStmt -> Str
json_create_cast_stmt = |r|
	fields(
		[
			specific_ptr_field("sourcetype", r.sourcetype),
			specific_ptr_field("targettype", r.targettype),
			specific_ptr_field("func", r.func),
			enum_field("context", enum_coercion_context(r.context)),
			bool_field("inout", r.inout),
		],
	)

json_create_conversion_stmt : Node.CreateConversionStmt -> Str
json_create_conversion_stmt = |r|
	fields(
		[
			list_field("conversion_name", r.conversion_name),
			text_field("for_encoding_name", r.for_encoding_name),
			text_field("to_encoding_name", r.to_encoding_name),
			list_field("func_name", r.func_name),
			bool_field("def", r.def),
		],
	)

json_create_domain_stmt : Node.CreateDomainStmt -> Str
json_create_domain_stmt = |r|
	fields(
		[
			list_field("domainname", r.domainname),
			specific_ptr_field("typeName", r.type_name),
			specific_ptr_field("collClause", r.coll_clause),
			list_field("constraints", r.constraints),
		],
	)

json_create_enum_stmt : Node.CreateEnumStmt -> Str
json_create_enum_stmt = |r|
	fields(
		[
			list_field("typeName", r.type_name),
			list_field("vals", r.vals),
		],
	)

json_create_event_trig_stmt : Node.CreateEventTrigStmt -> Str
json_create_event_trig_stmt = |r|
	fields(
		[
			text_field("trigname", r.trigname),
			text_field("eventname", r.eventname),
			list_field("whenclause", r.whenclause),
			list_field("funcname", r.funcname),
		],
	)

json_create_extension_stmt : Node.CreateExtensionStmt -> Str
json_create_extension_stmt = |r|
	fields(
		[
			text_field("extname", r.extname),
			bool_field("if_not_exists", r.if_not_exists),
			list_field("options", r.options),
		],
	)

json_create_fdw_stmt : Node.CreateFdwStmt -> Str
json_create_fdw_stmt = |r|
	fields(
		[
			text_field("fdwname", r.fdwname),
			list_field("func_options", r.func_options),
			list_field("options", r.options),
		],
	)

json_create_foreign_server_stmt : Node.CreateForeignServerStmt -> Str
json_create_foreign_server_stmt = |r|
	fields(
		[
			text_field("servername", r.servername),
			text_field("servertype", r.servertype),
			text_field("version", r.version),
			text_field("fdwname", r.fdwname),
			bool_field("if_not_exists", r.if_not_exists),
			list_field("options", r.options),
		],
	)

json_create_foreign_table_stmt : Node.CreateForeignTableStmt -> Str
json_create_foreign_table_stmt = |r|
	fields(
		[
			specific_field("base", r.base),
			text_field("servername", r.servername),
			list_field("options", r.options),
		],
	)

json_create_function_stmt : Node.CreateFunctionStmt -> Str
json_create_function_stmt = |r|
	fields(
		[
			bool_field("is_procedure", r.is_procedure),
			bool_field("replace", r.replace),
			list_field("funcname", r.funcname),
			list_field("parameters", r.parameters),
			specific_ptr_field("returnType", r.return_type),
			list_field("options", r.options),
			node_field("sql_body", r.sql_body),
		],
	)

json_create_op_class_item : Node.CreateOpClassItem -> Str
json_create_op_class_item = |r|
	fields(
		[
			int_field("itemtype", r.itemtype),
			specific_ptr_field("name", r.name),
			int_field("number", r.number),
			list_field("order_family", r.order_family),
			list_field("class_args", r.class_args),
			specific_ptr_field("storedtype", r.storedtype),
		],
	)

json_create_op_class_stmt : Node.CreateOpClassStmt -> Str
json_create_op_class_stmt = |r|
	fields(
		[
			list_field("opclassname", r.opclassname),
			list_field("opfamilyname", r.opfamilyname),
			text_field("amname", r.amname),
			specific_ptr_field("datatype", r.datatype),
			list_field("items", r.items),
			bool_field("isDefault", r.is_default),
		],
	)

json_create_op_family_stmt : Node.CreateOpFamilyStmt -> Str
json_create_op_family_stmt = |r|
	fields(
		[
			list_field("opfamilyname", r.opfamilyname),
			text_field("amname", r.amname),
		],
	)

json_create_p_lang_stmt : Node.CreatePLangStmt -> Str
json_create_p_lang_stmt = |r|
	fields(
		[
			bool_field("replace", r.replace),
			text_field("plname", r.plname),
			list_field("plhandler", r.plhandler),
			list_field("plinline", r.plinline),
			list_field("plvalidator", r.plvalidator),
			bool_field("pltrusted", r.pltrusted),
		],
	)

json_create_policy_stmt : Node.CreatePolicyStmt -> Str
json_create_policy_stmt = |r|
	fields(
		[
			text_field("policy_name", r.policy_name),
			specific_ptr_field("table", r.table),
			text_field("cmd_name", r.cmd_name),
			bool_field("permissive", r.permissive),
			list_field("roles", r.roles),
			node_field("qual", r.qual),
			node_field("with_check", r.with_check),
		],
	)

json_create_publication_stmt : Node.CreatePublicationStmt -> Str
json_create_publication_stmt = |r|
	fields(
		[
			text_field("pubname", r.pubname),
			list_field("options", r.options),
			list_field("pubobjects", r.pubobjects),
			bool_field("for_all_tables", r.for_all_tables),
		],
	)

json_create_range_stmt : Node.CreateRangeStmt -> Str
json_create_range_stmt = |r|
	fields(
		[
			list_field("typeName", r.type_name),
			list_field("params", r.params),
		],
	)

json_create_role_stmt : Node.CreateRoleStmt -> Str
json_create_role_stmt = |r|
	fields(
		[
			enum_field("stmt_type", enum_role_stmt_type(r.stmt_type)),
			text_field("role", r.role),
			list_field("options", r.options),
		],
	)

json_create_schema_stmt : Node.CreateSchemaStmt -> Str
json_create_schema_stmt = |r|
	fields(
		[
			text_field("schemaname", r.schemaname),
			specific_ptr_field("authrole", r.authrole),
			list_field("schemaElts", r.schema_elts),
			bool_field("if_not_exists", r.if_not_exists),
		],
	)

json_create_seq_stmt : Node.CreateSeqStmt -> Str
json_create_seq_stmt = |r|
	fields(
		[
			specific_ptr_field("sequence", r.sequence),
			list_field("options", r.options),
			uint_field("ownerId", r.owner_id),
			bool_field("for_identity", r.for_identity),
			bool_field("if_not_exists", r.if_not_exists),
		],
	)

json_create_stats_stmt : Node.CreateStatsStmt -> Str
json_create_stats_stmt = |r|
	fields(
		[
			list_field("defnames", r.defnames),
			list_field("stat_types", r.stat_types),
			list_field("exprs", r.exprs),
			list_field("relations", r.relations),
			text_field("stxcomment", r.stxcomment),
			bool_field("transformed", r.transformed),
			bool_field("if_not_exists", r.if_not_exists),
			uint_field("owner", r.owner),
		],
	)

json_create_stmt : Node.CreateStmt -> Str
json_create_stmt = |r|
	fields(
		[
			specific_ptr_field("relation", r.relation),
			list_field("tableElts", r.table_elts),
			list_field("inhRelations", r.inh_relations),
			specific_ptr_field("partbound", r.partbound),
			specific_ptr_field("partspec", r.partspec),
			specific_ptr_field("ofTypename", r.of_typename),
			list_field("constraints", r.constraints),
			list_field("nnconstraints", r.nnconstraints),
			list_field("options", r.options),
			enum_field("oncommit", enum_on_commit_action(r.oncommit)),
			text_field("tablespacename", r.tablespacename),
			text_field("accessMethod", r.access_method),
			bool_field("if_not_exists", r.if_not_exists),
		],
	)

json_create_subscription_stmt : Node.CreateSubscriptionStmt -> Str
json_create_subscription_stmt = |r|
	fields(
		[
			text_field("subname", r.subname),
			text_field("conninfo", r.conninfo),
			list_field("publication", r.publication),
			list_field("options", r.options),
		],
	)

json_create_table_as_stmt : Node.CreateTableAsStmt -> Str
json_create_table_as_stmt = |r|
	fields(
		[
			node_field("query", r.query),
			specific_ptr_field("into", r.into),
			enum_field("objtype", enum_object_type(r.objtype)),
			bool_field("is_select_into", r.is_select_into),
			bool_field("if_not_exists", r.if_not_exists),
		],
	)

json_create_table_space_stmt : Node.CreateTableSpaceStmt -> Str
json_create_table_space_stmt = |r|
	fields(
		[
			text_field("tablespacename", r.tablespacename),
			specific_ptr_field("owner", r.owner),
			text_field("location", r.location),
			list_field("options", r.options),
		],
	)

json_create_transform_stmt : Node.CreateTransformStmt -> Str
json_create_transform_stmt = |r|
	fields(
		[
			bool_field("replace", r.replace),
			specific_ptr_field("type_name", r.type_name),
			text_field("lang", r.lang),
			specific_ptr_field("fromsql", r.fromsql),
			specific_ptr_field("tosql", r.tosql),
		],
	)

json_create_trig_stmt : Node.CreateTrigStmt -> Str
json_create_trig_stmt = |r|
	fields(
		[
			bool_field("replace", r.replace),
			bool_field("isconstraint", r.isconstraint),
			text_field("trigname", r.trigname),
			specific_ptr_field("relation", r.relation),
			list_field("funcname", r.funcname),
			list_field("args", r.args),
			bool_field("row", r.row),
			int_field("timing", r.timing),
			int_field("events", r.events),
			list_field("columns", r.columns),
			node_field("whenClause", r.when_clause),
			list_field("transitionRels", r.transition_rels),
			bool_field("deferrable", r.deferrable),
			bool_field("initdeferred", r.initdeferred),
			specific_ptr_field("constrrel", r.constrrel),
		],
	)

json_create_user_mapping_stmt : Node.CreateUserMappingStmt -> Str
json_create_user_mapping_stmt = |r|
	fields(
		[
			specific_ptr_field("user", r.user),
			text_field("servername", r.servername),
			bool_field("if_not_exists", r.if_not_exists),
			list_field("options", r.options),
		],
	)

json_createdb_stmt : Node.CreatedbStmt -> Str
json_createdb_stmt = |r|
	fields(
		[
			text_field("dbname", r.dbname),
			list_field("options", r.options),
		],
	)

json_current_of_expr : Node.CurrentOfExpr -> Str
json_current_of_expr = |r|
	fields(
		[
			uint_field("cvarno", r.cvarno),
			text_field("cursor_name", r.cursor_name),
			int_field("cursor_param", r.cursor_param),
		],
	)

json_deallocate_stmt : Node.DeallocateStmt -> Str
json_deallocate_stmt = |r|
	fields(
		[
			text_field("name", r.name),
			bool_field("isall", r.isall),
			int_field("location", r.location),
		],
	)

json_declare_cursor_stmt : Node.DeclareCursorStmt -> Str
json_declare_cursor_stmt = |r|
	fields(
		[
			text_field("portalname", r.portalname),
			int_field("options", r.options),
			node_field("query", r.query),
		],
	)

json_def_elem : Node.DefElem -> Str
json_def_elem = |r|
	fields(
		[
			text_field("defnamespace", r.defnamespace),
			text_field("defname", r.defname),
			node_field("arg", r.arg),
			enum_field("defaction", enum_def_elem_action(r.defaction)),
			int_field("location", r.location),
		],
	)

json_define_stmt : Node.DefineStmt -> Str
json_define_stmt = |r|
	fields(
		[
			enum_field("kind", enum_object_type(r.kind)),
			bool_field("oldstyle", r.oldstyle),
			list_field("defnames", r.defnames),
			list_field("args", r.args),
			list_field("definition", r.definition),
			bool_field("if_not_exists", r.if_not_exists),
			bool_field("replace", r.replace),
		],
	)

json_delete_stmt : Node.DeleteStmt -> Str
json_delete_stmt = |r|
	fields(
		[
			specific_ptr_field("relation", r.relation),
			list_field("usingClause", r.using_clause),
			node_field("whereClause", r.where_clause),
			specific_ptr_field("returningClause", r.returning_clause),
			specific_ptr_field("withClause", r.with_clause),
		],
	)

json_discard_stmt : Node.DiscardStmt -> Str
json_discard_stmt = |r|
	fields(
		[
			enum_field("target", enum_discard_mode(r.target)),
		],
	)

json_do_stmt : Node.DoStmt -> Str
json_do_stmt = |r|
	fields(
		[
			list_field("args", r.args),
		],
	)

json_drop_owned_stmt : Node.DropOwnedStmt -> Str
json_drop_owned_stmt = |r|
	fields(
		[
			list_field("roles", r.roles),
			enum_field("behavior", enum_drop_behavior(r.behavior)),
		],
	)

json_drop_role_stmt : Node.DropRoleStmt -> Str
json_drop_role_stmt = |r|
	fields(
		[
			list_field("roles", r.roles),
			bool_field("missing_ok", r.missing_ok),
		],
	)

json_drop_stmt : Node.DropStmt -> Str
json_drop_stmt = |r|
	fields(
		[
			list_field("objects", r.objects),
			enum_field("removeType", enum_object_type(r.remove_type)),
			enum_field("behavior", enum_drop_behavior(r.behavior)),
			bool_field("missing_ok", r.missing_ok),
			bool_field("concurrent", r.concurrent),
		],
	)

json_drop_subscription_stmt : Node.DropSubscriptionStmt -> Str
json_drop_subscription_stmt = |r|
	fields(
		[
			text_field("subname", r.subname),
			bool_field("missing_ok", r.missing_ok),
			enum_field("behavior", enum_drop_behavior(r.behavior)),
		],
	)

json_drop_table_space_stmt : Node.DropTableSpaceStmt -> Str
json_drop_table_space_stmt = |r|
	fields(
		[
			text_field("tablespacename", r.tablespacename),
			bool_field("missing_ok", r.missing_ok),
		],
	)

json_drop_user_mapping_stmt : Node.DropUserMappingStmt -> Str
json_drop_user_mapping_stmt = |r|
	fields(
		[
			specific_ptr_field("user", r.user),
			text_field("servername", r.servername),
			bool_field("missing_ok", r.missing_ok),
		],
	)

json_dropdb_stmt : Node.DropdbStmt -> Str
json_dropdb_stmt = |r|
	fields(
		[
			text_field("dbname", r.dbname),
			bool_field("missing_ok", r.missing_ok),
			list_field("options", r.options),
		],
	)

json_execute_stmt : Node.ExecuteStmt -> Str
json_execute_stmt = |r|
	fields(
		[
			text_field("name", r.name),
			list_field("params", r.params),
		],
	)

json_explain_stmt : Node.ExplainStmt -> Str
json_explain_stmt = |r|
	fields(
		[
			node_field("query", r.query),
			list_field("options", r.options),
		],
	)

json_fetch_stmt : Node.FetchStmt -> Str
json_fetch_stmt = |r|
	fields(
		[
			enum_field("direction", enum_fetch_direction(r.direction)),
			int_field("howMany", r.how_many),
			text_field("portalname", r.portalname),
			bool_field("ismove", r.ismove),
		],
	)

json_float : Node.Float -> Str
json_float = |r| "\"fval\":${token(r.fval)}"

json_func_call : Node.FuncCall -> Str
json_func_call = |r|
	fields(
		[
			list_field("funcname", r.funcname),
			list_field("args", r.args),
			list_field("agg_order", r.agg_order),
			node_field("agg_filter", r.agg_filter),
			specific_ptr_field("over", r.over),
			bool_field("agg_within_group", r.agg_within_group),
			bool_field("agg_star", r.agg_star),
			bool_field("agg_distinct", r.agg_distinct),
			bool_field("func_variadic", r.func_variadic),
			enum_field("funcformat", enum_coercion_form(r.funcformat)),
			int_field("location", r.location),
		],
	)

json_function_parameter : Node.FunctionParameter -> Str
json_function_parameter = |r|
	fields(
		[
			text_field("name", r.name),
			specific_ptr_field("argType", r.arg_type),
			enum_field("mode", enum_function_parameter_mode(r.mode)),
			node_field("defexpr", r.defexpr),
			int_field("location", r.location),
		],
	)

json_grant_role_stmt : Node.GrantRoleStmt -> Str
json_grant_role_stmt = |r|
	fields(
		[
			list_field("granted_roles", r.granted_roles),
			list_field("grantee_roles", r.grantee_roles),
			bool_field("is_grant", r.is_grant),
			list_field("opt", r.opt),
			specific_ptr_field("grantor", r.grantor),
			enum_field("behavior", enum_drop_behavior(r.behavior)),
		],
	)

json_grant_stmt : Node.GrantStmt -> Str
json_grant_stmt = |r|
	fields(
		[
			bool_field("is_grant", r.is_grant),
			enum_field("targtype", enum_grant_target_type(r.targtype)),
			enum_field("objtype", enum_object_type(r.objtype)),
			list_field("objects", r.objects),
			list_field("privileges", r.privileges),
			list_field("grantees", r.grantees),
			bool_field("grant_option", r.grant_option),
			specific_ptr_field("grantor", r.grantor),
			enum_field("behavior", enum_drop_behavior(r.behavior)),
		],
	)

json_group_clause : Node.GroupClause -> Str
json_group_clause = |r|
	fields(
		[
			bool_field("distinct", r.distinct),
			list_field("list", r.list),
		],
	)

json_grouping_func : Node.GroupingFunc -> Str
json_grouping_func = |r|
	fields(
		[
			list_field("args", r.args),
			list_field("refs", r.refs),
			list_field("cols", r.cols),
			uint_field("agglevelsup", r.agglevelsup),
			int_field("location", r.location),
		],
	)

json_grouping_set : Node.GroupingSet -> Str
json_grouping_set = |r|
	fields(
		[
			enum_field("kind", enum_grouping_set_kind(r.kind)),
			list_field("content", r.content),
			int_field("location", r.location),
		],
	)

json_import_foreign_schema_stmt : Node.ImportForeignSchemaStmt -> Str
json_import_foreign_schema_stmt = |r|
	fields(
		[
			text_field("server_name", r.server_name),
			text_field("remote_schema", r.remote_schema),
			text_field("local_schema", r.local_schema),
			enum_field("list_type", enum_import_foreign_schema_type(r.list_type)),
			list_field("table_list", r.table_list),
			list_field("options", r.options),
		],
	)

json_import_qual : Node.ImportQual -> Str
json_import_qual = |r|
	fields(
		[
			enum_field("type", enum_import_foreign_schema_type(r.type)),
			list_field("table_names", r.table_names),
		],
	)

json_index_elem : Node.IndexElem -> Str
json_index_elem = |r|
	fields(
		[
			text_field("name", r.name),
			node_field("expr", r.expr),
			text_field("indexcolname", r.indexcolname),
			list_field("collation", r.collation),
			list_field("opclass", r.opclass),
			list_field("opclassopts", r.opclassopts),
			enum_field("ordering", enum_sort_by_dir(r.ordering)),
			enum_field("nulls_ordering", enum_sort_by_nulls(r.nulls_ordering)),
		],
	)

json_index_stmt : Node.IndexStmt -> Str
json_index_stmt = |r|
	fields(
		[
			text_field("idxname", r.idxname),
			specific_ptr_field("relation", r.relation),
			text_field("accessMethod", r.access_method),
			text_field("tableSpace", r.table_space),
			list_field("indexParams", r.index_params),
			list_field("indexIncludingParams", r.index_including_params),
			list_field("options", r.options),
			node_field("whereClause", r.where_clause),
			list_field("excludeOpNames", r.exclude_op_names),
			text_field("idxcomment", r.idxcomment),
			uint_field("indexOid", r.index_oid),
			uint_field("oldNumber", r.old_number),
			uint_field("oldCreateSubid", r.old_create_subid),
			uint_field("oldFirstRelfilelocatorSubid", r.old_first_relfilelocator_subid),
			bool_field("unique", r.unique),
			bool_field("nulls_not_distinct", r.nulls_not_distinct),
			bool_field("primary", r.primary),
			bool_field("isconstraint", r.isconstraint),
			bool_field("iswithoutoverlaps", r.iswithoutoverlaps),
			bool_field("deferrable", r.deferrable),
			bool_field("initdeferred", r.initdeferred),
			bool_field("transformed", r.transformed),
			bool_field("concurrent", r.concurrent),
			bool_field("if_not_exists", r.if_not_exists),
			bool_field("reset_default_tblspc", r.reset_default_tblspc),
		],
	)

json_infer_clause : Node.InferClause -> Str
json_infer_clause = |r|
	fields(
		[
			list_field("indexElems", r.index_elems),
			node_field("whereClause", r.where_clause),
			text_field("conname", r.conname),
			int_field("location", r.location),
		],
	)

json_insert_stmt : Node.InsertStmt -> Str
json_insert_stmt = |r|
	fields(
		[
			specific_ptr_field("relation", r.relation),
			list_field("cols", r.cols),
			node_field("selectStmt", r.select_stmt),
			specific_ptr_field("onConflictClause", r.on_conflict_clause),
			specific_ptr_field("returningClause", r.returning_clause),
			specific_ptr_field("withClause", r.with_clause),
			enum_field("override", enum_overriding_kind(r.override)),
		],
	)

json_integer : Node.Integer -> Str
json_integer = |r| if r.ival != 0 "\"ival\":${r.ival.to_str()}" else ""

json_into_clause : Node.IntoClause -> Str
json_into_clause = |r|
	fields(
		[
			specific_ptr_field("rel", r.rel),
			list_field("colNames", r.col_names),
			text_field("accessMethod", r.access_method),
			list_field("options", r.options),
			enum_field("onCommit", enum_on_commit_action(r.on_commit)),
			text_field("tableSpaceName", r.table_space_name),
			specific_ptr_field("viewQuery", r.view_query),
			bool_field("skipData", r.skip_data),
		],
	)

json_join_expr : Node.JoinExpr -> Str
json_join_expr = |r|
	fields(
		[
			enum_field("jointype", enum_join_type(r.jointype)),
			bool_field("isNatural", r.is_natural),
			node_field("larg", r.larg),
			node_field("rarg", r.rarg),
			list_field("usingClause", r.using_clause),
			specific_ptr_field("join_using_alias", r.join_using_alias),
			node_field("quals", r.quals),
			specific_ptr_field("alias", r.alias),
			int_field("rtindex", r.rtindex),
		],
	)

json_json_agg_constructor : Node.JsonAggConstructor -> Str
json_json_agg_constructor = |r|
	fields(
		[
			specific_ptr_field("output", r.output),
			node_field("agg_filter", r.agg_filter),
			list_field("agg_order", r.agg_order),
			specific_ptr_field("over", r.over),
			int_field("location", r.location),
		],
	)

json_json_argument : Node.JsonArgument -> Str
json_json_argument = |r|
	fields(
		[
			specific_ptr_field("val", r.val),
			text_field("name", r.name),
		],
	)

json_json_array_agg : Node.JsonArrayAgg -> Str
json_json_array_agg = |r|
	fields(
		[
			specific_ptr_field("constructor", r.constructor),
			specific_ptr_field("arg", r.arg),
			bool_field("absent_on_null", r.absent_on_null),
		],
	)

json_json_array_constructor : Node.JsonArrayConstructor -> Str
json_json_array_constructor = |r|
	fields(
		[
			list_field("exprs", r.exprs),
			specific_ptr_field("output", r.output),
			bool_field("absent_on_null", r.absent_on_null),
			int_field("location", r.location),
		],
	)

json_json_array_query_constructor : Node.JsonArrayQueryConstructor -> Str
json_json_array_query_constructor = |r|
	fields(
		[
			node_field("query", r.query),
			specific_ptr_field("output", r.output),
			specific_ptr_field("format", r.format),
			bool_field("absent_on_null", r.absent_on_null),
			int_field("location", r.location),
		],
	)

json_json_behavior : Node.JsonBehavior -> Str
json_json_behavior = |r|
	fields(
		[
			enum_field("btype", enum_json_behavior_type(r.btype)),
			node_field("expr", r.expr),
			bool_field("coerce", r.coerce),
			int_field("location", r.location),
		],
	)

json_json_format : Node.JsonFormat -> Str
json_json_format = |r|
	fields(
		[
			enum_field("format_type", enum_json_format_type(r.format_type)),
			enum_field("encoding", enum_json_encoding(r.encoding)),
			int_field("location", r.location),
		],
	)

json_json_func_expr : Node.JsonFuncExpr -> Str
json_json_func_expr = |r|
	fields(
		[
			enum_field("op", enum_json_expr_op(r.op)),
			text_field("column_name", r.column_name),
			specific_ptr_field("context_item", r.context_item),
			node_field("pathspec", r.pathspec),
			list_field("passing", r.passing),
			specific_ptr_field("output", r.output),
			specific_ptr_field("on_empty", r.on_empty),
			specific_ptr_field("on_error", r.on_error),
			enum_field("wrapper", enum_json_wrapper(r.wrapper)),
			enum_field("quotes", enum_json_quotes(r.quotes)),
			int_field("location", r.location),
		],
	)

json_json_is_predicate : Node.JsonIsPredicate -> Str
json_json_is_predicate = |r|
	fields(
		[
			node_field("expr", r.expr),
			specific_ptr_field("format", r.format),
			enum_field("item_type", enum_json_value_type(r.item_type)),
			bool_field("unique_keys", r.unique_keys),
			int_field("location", r.location),
		],
	)

json_json_key_value : Node.JsonKeyValue -> Str
json_json_key_value = |r|
	fields(
		[
			node_field("key", r.key),
			specific_ptr_field("value", r.value),
		],
	)

json_json_object_agg : Node.JsonObjectAgg -> Str
json_json_object_agg = |r|
	fields(
		[
			specific_ptr_field("constructor", r.constructor),
			specific_ptr_field("arg", r.arg),
			bool_field("absent_on_null", r.absent_on_null),
			bool_field("unique", r.unique),
		],
	)

json_json_object_constructor : Node.JsonObjectConstructor -> Str
json_json_object_constructor = |r|
	fields(
		[
			list_field("exprs", r.exprs),
			specific_ptr_field("output", r.output),
			bool_field("absent_on_null", r.absent_on_null),
			bool_field("unique", r.unique),
			int_field("location", r.location),
		],
	)

json_json_output : Node.JsonOutput -> Str
json_json_output = |r|
	fields(
		[
			specific_ptr_field("typeName", r.type_name),
			specific_ptr_field("returning", r.returning),
		],
	)

json_json_parse_expr : Node.JsonParseExpr -> Str
json_json_parse_expr = |r|
	fields(
		[
			specific_ptr_field("expr", r.expr),
			specific_ptr_field("output", r.output),
			bool_field("unique_keys", r.unique_keys),
			int_field("location", r.location),
		],
	)

json_json_returning : Node.JsonReturning -> Str
json_json_returning = |r|
	fields(
		[
			specific_ptr_field("format", r.format),
			uint_field("typid", r.typid),
			int_field("typmod", r.typmod),
		],
	)

json_json_scalar_expr : Node.JsonScalarExpr -> Str
json_json_scalar_expr = |r|
	fields(
		[
			node_field("expr", r.expr),
			specific_ptr_field("output", r.output),
			int_field("location", r.location),
		],
	)

json_json_serialize_expr : Node.JsonSerializeExpr -> Str
json_json_serialize_expr = |r|
	fields(
		[
			specific_ptr_field("expr", r.expr),
			specific_ptr_field("output", r.output),
			int_field("location", r.location),
		],
	)

json_json_table : Node.JsonTable -> Str
json_json_table = |r|
	fields(
		[
			specific_ptr_field("context_item", r.context_item),
			specific_ptr_field("pathspec", r.pathspec),
			list_field("passing", r.passing),
			list_field("columns", r.columns),
			specific_ptr_field("on_error", r.on_error),
			specific_ptr_field("alias", r.alias),
			bool_field("lateral", r.lateral),
			int_field("location", r.location),
		],
	)

json_json_table_column : Node.JsonTableColumn -> Str
json_json_table_column = |r|
	fields(
		[
			enum_field("coltype", enum_json_table_column_type(r.coltype)),
			text_field("name", r.name),
			specific_ptr_field("typeName", r.type_name),
			specific_ptr_field("pathspec", r.pathspec),
			specific_ptr_field("format", r.format),
			enum_field("wrapper", enum_json_wrapper(r.wrapper)),
			enum_field("quotes", enum_json_quotes(r.quotes)),
			list_field("columns", r.columns),
			specific_ptr_field("on_empty", r.on_empty),
			specific_ptr_field("on_error", r.on_error),
			int_field("location", r.location),
		],
	)

json_json_table_path_spec : Node.JsonTablePathSpec -> Str
json_json_table_path_spec = |r|
	fields(
		[
			node_field("string", r.string),
			text_field("name", r.name),
			int_field("name_location", r.name_location),
			int_field("location", r.location),
		],
	)

json_json_value_expr : Node.JsonValueExpr -> Str
json_json_value_expr = |r|
	fields(
		[
			node_field("raw_expr", r.raw_expr),
			node_field("formatted_expr", r.formatted_expr),
			specific_ptr_field("format", r.format),
		],
	)

json_key_action : Node.KeyAction -> Str
json_key_action = |r|
	fields(
		[
			char_field("action", r.action),
			list_field("cols", r.cols),
		],
	)

json_key_actions : Node.KeyActions -> Str
json_key_actions = |r|
	fields(
		[
			specific_ptr_field("updateAction", r.update_action),
			specific_ptr_field("deleteAction", r.delete_action),
		],
	)

json_listen_stmt : Node.ListenStmt -> Str
json_listen_stmt = |r|
	fields(
		[
			text_field("conditionname", r.conditionname),
		],
	)

json_load_stmt : Node.LoadStmt -> Str
json_load_stmt = |r|
	fields(
		[
			text_field("filename", r.filename),
		],
	)

json_lock_stmt : Node.LockStmt -> Str
json_lock_stmt = |r|
	fields(
		[
			list_field("relations", r.relations),
			int_field("mode", r.mode),
			bool_field("nowait", r.nowait),
		],
	)

json_locking_clause : Node.LockingClause -> Str
json_locking_clause = |r|
	fields(
		[
			list_field("lockedRels", r.locked_rels),
			enum_field("strength", enum_lock_clause_strength(r.strength)),
			enum_field("waitPolicy", enum_lock_wait_policy(r.wait_policy)),
		],
	)

json_merge_stmt : Node.MergeStmt -> Str
json_merge_stmt = |r|
	fields(
		[
			specific_ptr_field("relation", r.relation),
			node_field("sourceRelation", r.source_relation),
			node_field("joinCondition", r.join_condition),
			list_field("mergeWhenClauses", r.merge_when_clauses),
			specific_ptr_field("returningClause", r.returning_clause),
			specific_ptr_field("withClause", r.with_clause),
		],
	)

json_merge_support_func : Node.MergeSupportFunc -> Str
json_merge_support_func = |r|
	fields(
		[
			uint_field("msftype", r.msftype),
			uint_field("msfcollid", r.msfcollid),
			int_field("location", r.location),
		],
	)

json_merge_when_clause : Node.MergeWhenClause -> Str
json_merge_when_clause = |r|
	fields(
		[
			enum_field("matchKind", enum_merge_match_kind(r.match_kind)),
			enum_field("commandType", enum_cmd_type(r.command_type)),
			enum_field("override", enum_overriding_kind(r.override)),
			node_field("condition", r.condition),
			list_field("targetList", r.target_list),
			list_field("values", r.values),
		],
	)

json_min_max_expr : Node.MinMaxExpr -> Str
json_min_max_expr = |r|
	fields(
		[
			uint_field("minmaxtype", r.minmaxtype),
			uint_field("minmaxcollid", r.minmaxcollid),
			uint_field("inputcollid", r.inputcollid),
			enum_field("op", enum_min_max_op(r.op)),
			list_field("args", r.args),
			int_field("location", r.location),
		],
	)

json_multi_assign_ref : Node.MultiAssignRef -> Str
json_multi_assign_ref = |r|
	fields(
		[
			node_field("source", r.source),
			int_field("colno", r.colno),
			int_field("ncolumns", r.ncolumns),
		],
	)

json_named_arg_expr : Node.NamedArgExpr -> Str
json_named_arg_expr = |r|
	fields(
		[
			node_field("arg", r.arg),
			text_field("name", r.name),
			int_field("argnumber", r.argnumber),
			int_field("location", r.location),
		],
	)

json_notify_stmt : Node.NotifyStmt -> Str
json_notify_stmt = |r|
	fields(
		[
			text_field("conditionname", r.conditionname),
			text_field("payload", r.payload),
		],
	)

json_null_test : Node.NullTest -> Str
json_null_test = |r|
	fields(
		[
			node_field("arg", r.arg),
			enum_field("nulltesttype", enum_null_test_type(r.nulltesttype)),
			bool_field("argisrow", r.argisrow),
			int_field("location", r.location),
		],
	)

json_object_with_args : Node.ObjectWithArgs -> Str
json_object_with_args = |r|
	fields(
		[
			list_field("objname", r.objname),
			list_field("objargs", r.objargs),
			list_field("objfuncargs", r.objfuncargs),
			bool_field("args_unspecified", r.args_unspecified),
		],
	)

json_on_conflict_clause : Node.OnConflictClause -> Str
json_on_conflict_clause = |r|
	fields(
		[
			enum_field("action", enum_on_conflict_action(r.action)),
			specific_ptr_field("infer", r.infer),
			list_field("targetList", r.target_list),
			node_field("whereClause", r.where_clause),
			int_field("location", r.location),
		],
	)

json_pl_assign_stmt : Node.PLAssignStmt -> Str
json_pl_assign_stmt = |r|
	fields(
		[
			text_field("name", r.name),
			list_field("indirection", r.indirection),
			int_field("nnames", r.nnames),
			specific_ptr_field("val", r.val),
			int_field("location", r.location),
		],
	)

json_param_ref : Node.ParamRef -> Str
json_param_ref = |r|
	fields(
		[
			int_field("number", r.number),
			int_field("location", r.location),
		],
	)

json_partition_bound_spec : Node.PartitionBoundSpec -> Str
json_partition_bound_spec = |r|
	fields(
		[
			char_field("strategy", r.strategy),
			bool_field("is_default", r.is_default),
			int_field("modulus", r.modulus),
			int_field("remainder", r.remainder),
			list_field("listdatums", r.listdatums),
			list_field("lowerdatums", r.lowerdatums),
			list_field("upperdatums", r.upperdatums),
			int_field("location", r.location),
		],
	)

json_partition_cmd : Node.PartitionCmd -> Str
json_partition_cmd = |r|
	fields(
		[
			specific_ptr_field("name", r.name),
			specific_ptr_field("bound", r.bound),
			bool_field("concurrent", r.concurrent),
		],
	)

json_partition_elem : Node.PartitionElem -> Str
json_partition_elem = |r|
	fields(
		[
			text_field("name", r.name),
			node_field("expr", r.expr),
			list_field("collation", r.collation),
			list_field("opclass", r.opclass),
			int_field("location", r.location),
		],
	)

json_partition_spec : Node.PartitionSpec -> Str
json_partition_spec = |r|
	fields(
		[
			enum_field("strategy", enum_partition_strategy(r.strategy)),
			list_field("partParams", r.part_params),
			int_field("location", r.location),
		],
	)

json_prepare_stmt : Node.PrepareStmt -> Str
json_prepare_stmt = |r|
	fields(
		[
			text_field("name", r.name),
			list_field("argtypes", r.argtypes),
			node_field("query", r.query),
		],
	)

json_priv_target : Node.PrivTarget -> Str
json_priv_target = |r|
	fields(
		[
			enum_field("targtype", enum_grant_target_type(r.targtype)),
			enum_field("objtype", enum_object_type(r.objtype)),
			list_field("objs", r.objs),
		],
	)

json_publication_obj_spec : Node.PublicationObjSpec -> Str
json_publication_obj_spec = |r|
	fields(
		[
			enum_field("pubobjtype", enum_publication_obj_spec_type(r.pubobjtype)),
			text_field("name", r.name),
			specific_ptr_field("pubtable", r.pubtable),
			int_field("location", r.location),
		],
	)

json_publication_table : Node.PublicationTable -> Str
json_publication_table = |r|
	fields(
		[
			specific_ptr_field("relation", r.relation),
			node_field("whereClause", r.where_clause),
			list_field("columns", r.columns),
		],
	)

json_range_function : Node.RangeFunction -> Str
json_range_function = |r|
	fields(
		[
			bool_field("lateral", r.lateral),
			bool_field("ordinality", r.ordinality),
			bool_field("is_rowsfrom", r.is_rowsfrom),
			list_field("functions", r.functions),
			specific_ptr_field("alias", r.alias),
			list_field("coldeflist", r.coldeflist),
		],
	)

json_range_subselect : Node.RangeSubselect -> Str
json_range_subselect = |r|
	fields(
		[
			bool_field("lateral", r.lateral),
			node_field("subquery", r.subquery),
			specific_ptr_field("alias", r.alias),
		],
	)

json_range_table_func : Node.RangeTableFunc -> Str
json_range_table_func = |r|
	fields(
		[
			bool_field("lateral", r.lateral),
			node_field("docexpr", r.docexpr),
			node_field("rowexpr", r.rowexpr),
			list_field("namespaces", r.namespaces),
			list_field("columns", r.columns),
			specific_ptr_field("alias", r.alias),
			int_field("location", r.location),
		],
	)

json_range_table_func_col : Node.RangeTableFuncCol -> Str
json_range_table_func_col = |r|
	fields(
		[
			text_field("colname", r.colname),
			specific_ptr_field("typeName", r.type_name),
			bool_field("for_ordinality", r.for_ordinality),
			bool_field("is_not_null", r.is_not_null),
			node_field("colexpr", r.colexpr),
			node_field("coldefexpr", r.coldefexpr),
			int_field("location", r.location),
		],
	)

json_range_table_sample : Node.RangeTableSample -> Str
json_range_table_sample = |r|
	fields(
		[
			node_field("relation", r.relation),
			list_field("method", r.method),
			list_field("args", r.args),
			node_field("repeatable", r.repeatable),
			int_field("location", r.location),
		],
	)

json_range_var : Node.RangeVar -> Str
json_range_var = |r|
	fields(
		[
			text_field("catalogname", r.catalogname),
			text_field("schemaname", r.schemaname),
			text_field("relname", r.relname),
			bool_field("inh", r.inh),
			char_field("relpersistence", r.relpersistence),
			specific_ptr_field("alias", r.alias),
			int_field("location", r.location),
		],
	)

json_raw_stmt : Node.RawStmt -> Str
json_raw_stmt = |r|
	fields(
		[
			node_field("stmt", r.stmt),
			int_field("stmt_location", r.stmt_location),
			int_field("stmt_len", r.stmt_len),
		],
	)

json_reassign_owned_stmt : Node.ReassignOwnedStmt -> Str
json_reassign_owned_stmt = |r|
	fields(
		[
			list_field("roles", r.roles),
			specific_ptr_field("newrole", r.newrole),
		],
	)

json_refresh_mat_view_stmt : Node.RefreshMatViewStmt -> Str
json_refresh_mat_view_stmt = |r|
	fields(
		[
			bool_field("concurrent", r.concurrent),
			bool_field("skipData", r.skip_data),
			specific_ptr_field("relation", r.relation),
		],
	)

json_reindex_stmt : Node.ReindexStmt -> Str
json_reindex_stmt = |r|
	fields(
		[
			enum_field("kind", enum_reindex_object_type(r.kind)),
			specific_ptr_field("relation", r.relation),
			text_field("name", r.name),
			list_field("params", r.params),
		],
	)

json_rename_stmt : Node.RenameStmt -> Str
json_rename_stmt = |r|
	fields(
		[
			enum_field("renameType", enum_object_type(r.rename_type)),
			enum_field("relationType", enum_object_type(r.relation_type)),
			specific_ptr_field("relation", r.relation),
			node_field("object", r.object),
			text_field("subname", r.subname),
			text_field("newname", r.newname),
			enum_field("behavior", enum_drop_behavior(r.behavior)),
			bool_field("missing_ok", r.missing_ok),
		],
	)

json_replica_identity_stmt : Node.ReplicaIdentityStmt -> Str
json_replica_identity_stmt = |r|
	fields(
		[
			char_field("identity_type", r.identity_type),
			text_field("name", r.name),
		],
	)

json_res_target : Node.ResTarget -> Str
json_res_target = |r|
	fields(
		[
			text_field("name", r.name),
			list_field("indirection", r.indirection),
			node_field("val", r.val),
			int_field("location", r.location),
		],
	)

json_return_stmt : Node.ReturnStmt -> Str
json_return_stmt = |r|
	fields(
		[
			node_field("returnval", r.returnval),
		],
	)

json_returning_clause : Node.ReturningClause -> Str
json_returning_clause = |r|
	fields(
		[
			list_field("options", r.options),
			list_field("exprs", r.exprs),
		],
	)

json_returning_option : Node.ReturningOption -> Str
json_returning_option = |r|
	fields(
		[
			enum_field("option", enum_returning_option_kind(r.option)),
			text_field("value", r.value),
			int_field("location", r.location),
		],
	)

json_role_spec : Node.RoleSpec -> Str
json_role_spec = |r|
	fields(
		[
			enum_field("roletype", enum_role_spec_type(r.roletype)),
			text_field("rolename", r.rolename),
			int_field("location", r.location),
		],
	)

json_row_expr : Node.RowExpr -> Str
json_row_expr = |r|
	fields(
		[
			list_field("args", r.args),
			uint_field("row_typeid", r.row_typeid),
			enum_field("row_format", enum_coercion_form(r.row_format)),
			list_field("colnames", r.colnames),
			int_field("location", r.location),
		],
	)

json_rule_stmt : Node.RuleStmt -> Str
json_rule_stmt = |r|
	fields(
		[
			specific_ptr_field("relation", r.relation),
			text_field("rulename", r.rulename),
			node_field("whereClause", r.where_clause),
			enum_field("event", enum_cmd_type(r.event)),
			bool_field("instead", r.instead),
			list_field("actions", r.actions),
			bool_field("replace", r.replace),
		],
	)

json_sql_value_function : Node.SQLValueFunction -> Str
json_sql_value_function = |r|
	fields(
		[
			enum_field("op", enum_sql_value_function_op(r.op)),
			uint_field("type", r.type),
			int_field("typmod", r.typmod),
			int_field("location", r.location),
		],
	)

json_sec_label_stmt : Node.SecLabelStmt -> Str
json_sec_label_stmt = |r|
	fields(
		[
			enum_field("objtype", enum_object_type(r.objtype)),
			node_field("object", r.object),
			text_field("provider", r.provider),
			text_field("label", r.label),
		],
	)

json_select_limit : Node.SelectLimit -> Str
json_select_limit = |r|
	fields(
		[
			node_field("limitOffset", r.limit_offset),
			node_field("limitCount", r.limit_count),
			enum_field("limitOption", enum_limit_option(r.limit_option)),
			int_field("offsetLoc", r.offset_loc),
			int_field("countLoc", r.count_loc),
			int_field("optionLoc", r.option_loc),
		],
	)

json_select_stmt : Node.SelectStmt -> Str
json_select_stmt = |r|
	fields(
		[
			list_field("distinctClause", r.distinct_clause),
			specific_ptr_field("intoClause", r.into_clause),
			list_field("targetList", r.target_list),
			list_field("fromClause", r.from_clause),
			node_field("whereClause", r.where_clause),
			list_field("groupClause", r.group_clause),
			bool_field("groupDistinct", r.group_distinct),
			node_field("havingClause", r.having_clause),
			list_field("windowClause", r.window_clause),
			list_field("valuesLists", r.values_lists),
			list_field("sortClause", r.sort_clause),
			node_field("limitOffset", r.limit_offset),
			node_field("limitCount", r.limit_count),
			enum_field("limitOption", limit_option(r)),
			list_field("lockingClause", r.locking_clause),
			specific_ptr_field("withClause", r.with_clause),
			enum_field("op", enum_set_operation(r.op)),
			bool_field("all", r.all),
			specific_ptr_field("larg", r.larg),
			specific_ptr_field("rarg", r.rarg),
		],
	)

json_set_to_default : Node.SetToDefault -> Str
json_set_to_default = |r|
	fields(
		[
			uint_field("typeId", r.type_id),
			int_field("typeMod", r.type_mod),
			uint_field("collation", r.collation),
			int_field("location", r.location),
		],
	)

json_sort_by : Node.SortBy -> Str
json_sort_by = |r|
	fields(
		[
			node_field("node", r.node),
			enum_field("sortby_dir", enum_sort_by_dir(r.sortby_dir)),
			enum_field("sortby_nulls", enum_sort_by_nulls(r.sortby_nulls)),
			list_field("useOp", r.use_op),
			int_field("location", r.location),
		],
	)

json_stats_elem : Node.StatsElem -> Str
json_stats_elem = |r|
	fields(
		[
			text_field("name", r.name),
			node_field("expr", r.expr),
		],
	)

json_string : Node.String -> Str
json_string = |r| "\"sval\":${token(r.sval)}"

json_sub_link : Node.SubLink -> Str
json_sub_link = |r|
	fields(
		[
			enum_field("subLinkType", enum_sub_link_type(r.sub_link_type)),
			int_field("subLinkId", r.sub_link_id),
			node_field("testexpr", r.testexpr),
			list_field("operName", r.oper_name),
			node_field("subselect", r.subselect),
			int_field("location", r.location),
		],
	)

json_table_like_clause : Node.TableLikeClause -> Str
json_table_like_clause = |r|
	fields(
		[
			specific_ptr_field("relation", r.relation),
			uint_field("options", r.options),
			uint_field("relationOid", r.relation_oid),
		],
	)

json_transaction_stmt : Node.TransactionStmt -> Str
json_transaction_stmt = |r|
	fields(
		[
			enum_field("kind", enum_transaction_stmt_kind(r.kind)),
			list_field("options", r.options),
			text_field("savepoint_name", r.savepoint_name),
			text_field("gid", r.gid),
			bool_field("chain", r.chain),
			int_field("location", r.location),
		],
	)

json_trigger_transition : Node.TriggerTransition -> Str
json_trigger_transition = |r|
	fields(
		[
			text_field("name", r.name),
			bool_field("isNew", r.is_new),
			bool_field("isTable", r.is_table),
		],
	)

json_truncate_stmt : Node.TruncateStmt -> Str
json_truncate_stmt = |r|
	fields(
		[
			list_field("relations", r.relations),
			bool_field("restart_seqs", r.restart_seqs),
			enum_field("behavior", enum_drop_behavior(r.behavior)),
		],
	)

json_type_cast : Node.TypeCast -> Str
json_type_cast = |r|
	fields(
		[
			node_field("arg", r.arg),
			specific_ptr_field("typeName", r.type_name),
			int_field("location", r.location),
		],
	)

json_type_name : Node.TypeName -> Str
json_type_name = |r|
	fields(
		[
			list_field("names", r.names),
			uint_field("typeOid", r.type_oid),
			bool_field("setof", r.setof),
			bool_field("pct_type", r.pct_type),
			list_field("typmods", r.typmods),
			int_field("typemod", r.typemod),
			list_field("arrayBounds", r.array_bounds),
			int_field("location", r.location),
		],
	)

json_unlisten_stmt : Node.UnlistenStmt -> Str
json_unlisten_stmt = |r|
	fields(
		[
			text_field("conditionname", r.conditionname),
		],
	)

json_update_stmt : Node.UpdateStmt -> Str
json_update_stmt = |r|
	fields(
		[
			specific_ptr_field("relation", r.relation),
			list_field("targetList", r.target_list),
			node_field("whereClause", r.where_clause),
			list_field("fromClause", r.from_clause),
			specific_ptr_field("returningClause", r.returning_clause),
			specific_ptr_field("withClause", r.with_clause),
		],
	)

json_vacuum_relation : Node.VacuumRelation -> Str
json_vacuum_relation = |r|
	fields(
		[
			specific_ptr_field("relation", r.relation),
			uint_field("oid", r.oid),
			list_field("va_cols", r.va_cols),
		],
	)

json_vacuum_stmt : Node.VacuumStmt -> Str
json_vacuum_stmt = |r|
	fields(
		[
			list_field("options", r.options),
			list_field("rels", r.rels),
			bool_field("is_vacuumcmd", r.is_vacuumcmd),
		],
	)

json_variable_set_stmt : Node.VariableSetStmt -> Str
json_variable_set_stmt = |r|
	fields(
		[
			enum_field("kind", enum_variable_set_kind(r.kind)),
			text_field("name", r.name),
			list_field("args", r.args),
			bool_field("jumble_args", r.jumble_args),
			bool_field("is_local", r.is_local),
			int_field("location", r.location),
		],
	)

json_variable_show_stmt : Node.VariableShowStmt -> Str
json_variable_show_stmt = |r|
	fields(
		[
			text_field("name", r.name),
		],
	)

json_view_stmt : Node.ViewStmt -> Str
json_view_stmt = |r|
	fields(
		[
			specific_ptr_field("view", r.view),
			list_field("aliases", r.aliases),
			node_field("query", r.query),
			bool_field("replace", r.replace),
			list_field("options", r.options),
			enum_field("withCheckOption", enum_view_check_option(r.with_check_option)),
		],
	)

json_window_def : Node.WindowDef -> Str
json_window_def = |r|
	fields(
		[
			text_field("name", r.name),
			text_field("refname", r.refname),
			list_field("partitionClause", r.partition_clause),
			list_field("orderClause", r.order_clause),
			int_field("frameOptions", r.frame_options),
			node_field("startOffset", r.start_offset),
			node_field("endOffset", r.end_offset),
			int_field("location", r.location),
		],
	)

json_with_clause : Node.WithClause -> Str
json_with_clause = |r|
	fields(
		[
			list_field("ctes", r.ctes),
			bool_field("recursive", r.recursive),
			int_field("location", r.location),
		],
	)

json_xml_expr : Node.XmlExpr -> Str
json_xml_expr = |r|
	fields(
		[
			enum_field("op", enum_xml_expr_op(r.op)),
			text_field("name", r.name),
			list_field("named_args", r.named_args),
			list_field("arg_names", r.arg_names),
			list_field("args", r.args),
			enum_field("xmloption", enum_xml_option_type(r.xmloption)),
			bool_field("indent", r.indent),
			uint_field("type", r.type),
			int_field("typmod", r.typmod),
			int_field("location", r.location),
		],
	)

json_xml_serialize : Node.XmlSerialize -> Str
json_xml_serialize = |r|
	fields(
		[
			enum_field("xmloption", enum_xml_option_type(r.xmloption)),
			node_field("expr", r.expr),
			specific_ptr_field("typeName", r.type_name),
			bool_field("indent", r.indent),
			int_field("location", r.location),
		],
	)

enum_a_expr_kind : I64 -> Str
enum_a_expr_kind = |v|
	match v {
		0 => "AEXPR_OP"
		1 => "AEXPR_OP_ANY"
		2 => "AEXPR_OP_ALL"
		3 => "AEXPR_DISTINCT"
		4 => "AEXPR_NOT_DISTINCT"
		5 => "AEXPR_NULLIF"
		6 => "AEXPR_IN"
		7 => "AEXPR_LIKE"
		8 => "AEXPR_ILIKE"
		9 => "AEXPR_SIMILAR"
		10 => "AEXPR_BETWEEN"
		11 => "AEXPR_NOT_BETWEEN"
		12 => "AEXPR_BETWEEN_SYM"
		13 => "AEXPR_NOT_BETWEEN_SYM"
		_ => "<A_Expr_Kind ${v.to_str()}>"
	}

enum_drop_behavior : I64 -> Str
enum_drop_behavior = |v|
	match v {
		0 => "DROP_RESTRICT"
		1 => "DROP_CASCADE"
		_ => "<DropBehavior ${v.to_str()}>"
	}

enum_object_type : I64 -> Str
enum_object_type = |v|
	match v {
		0 => "OBJECT_ACCESS_METHOD"
		1 => "OBJECT_AGGREGATE"
		2 => "OBJECT_AMOP"
		3 => "OBJECT_AMPROC"
		4 => "OBJECT_ATTRIBUTE"
		5 => "OBJECT_CAST"
		6 => "OBJECT_COLUMN"
		7 => "OBJECT_COLLATION"
		8 => "OBJECT_CONVERSION"
		9 => "OBJECT_DATABASE"
		10 => "OBJECT_DEFAULT"
		11 => "OBJECT_DEFACL"
		12 => "OBJECT_DOMAIN"
		13 => "OBJECT_DOMCONSTRAINT"
		14 => "OBJECT_EVENT_TRIGGER"
		15 => "OBJECT_EXTENSION"
		16 => "OBJECT_FDW"
		17 => "OBJECT_FOREIGN_SERVER"
		18 => "OBJECT_FOREIGN_TABLE"
		19 => "OBJECT_FUNCTION"
		20 => "OBJECT_INDEX"
		21 => "OBJECT_LANGUAGE"
		22 => "OBJECT_LARGEOBJECT"
		23 => "OBJECT_MATVIEW"
		24 => "OBJECT_OPCLASS"
		25 => "OBJECT_OPERATOR"
		26 => "OBJECT_OPFAMILY"
		27 => "OBJECT_PARAMETER_ACL"
		28 => "OBJECT_POLICY"
		29 => "OBJECT_PROCEDURE"
		30 => "OBJECT_PUBLICATION"
		31 => "OBJECT_PUBLICATION_NAMESPACE"
		32 => "OBJECT_PUBLICATION_REL"
		33 => "OBJECT_ROLE"
		34 => "OBJECT_ROUTINE"
		35 => "OBJECT_RULE"
		36 => "OBJECT_SCHEMA"
		37 => "OBJECT_SEQUENCE"
		38 => "OBJECT_SUBSCRIPTION"
		39 => "OBJECT_STATISTIC_EXT"
		40 => "OBJECT_TABCONSTRAINT"
		41 => "OBJECT_TABLE"
		42 => "OBJECT_TABLESPACE"
		43 => "OBJECT_TRANSFORM"
		44 => "OBJECT_TRIGGER"
		45 => "OBJECT_TSCONFIGURATION"
		46 => "OBJECT_TSDICTIONARY"
		47 => "OBJECT_TSPARSER"
		48 => "OBJECT_TSTEMPLATE"
		49 => "OBJECT_TYPE"
		50 => "OBJECT_USER_MAPPING"
		51 => "OBJECT_VIEW"
		_ => "<ObjectType ${v.to_str()}>"
	}

enum_alter_publication_action : I64 -> Str
enum_alter_publication_action = |v|
	match v {
		0 => "AP_AddObjects"
		1 => "AP_DropObjects"
		2 => "AP_SetObjects"
		_ => "<AlterPublicationAction ${v.to_str()}>"
	}

enum_alter_subscription_type : I64 -> Str
enum_alter_subscription_type = |v|
	match v {
		0 => "ALTER_SUBSCRIPTION_OPTIONS"
		1 => "ALTER_SUBSCRIPTION_CONNECTION"
		2 => "ALTER_SUBSCRIPTION_SET_PUBLICATION"
		3 => "ALTER_SUBSCRIPTION_ADD_PUBLICATION"
		4 => "ALTER_SUBSCRIPTION_DROP_PUBLICATION"
		5 => "ALTER_SUBSCRIPTION_REFRESH"
		6 => "ALTER_SUBSCRIPTION_ENABLED"
		7 => "ALTER_SUBSCRIPTION_SKIP"
		_ => "<AlterSubscriptionType ${v.to_str()}>"
	}

enum_alter_ts_config_type : I64 -> Str
enum_alter_ts_config_type = |v|
	match v {
		0 => "ALTER_TSCONFIG_ADD_MAPPING"
		1 => "ALTER_TSCONFIG_ALTER_MAPPING_FOR_TOKEN"
		2 => "ALTER_TSCONFIG_REPLACE_DICT"
		3 => "ALTER_TSCONFIG_REPLACE_DICT_FOR_TOKEN"
		4 => "ALTER_TSCONFIG_DROP_MAPPING"
		_ => "<AlterTSConfigType ${v.to_str()}>"
	}

enum_alter_table_type : I64 -> Str
enum_alter_table_type = |v|
	match v {
		0 => "AT_AddColumn"
		1 => "AT_AddColumnToView"
		2 => "AT_ColumnDefault"
		3 => "AT_CookedColumnDefault"
		4 => "AT_DropNotNull"
		5 => "AT_SetNotNull"
		6 => "AT_SetExpression"
		7 => "AT_DropExpression"
		8 => "AT_SetStatistics"
		9 => "AT_SetOptions"
		10 => "AT_ResetOptions"
		11 => "AT_SetStorage"
		12 => "AT_SetCompression"
		13 => "AT_DropColumn"
		14 => "AT_AddIndex"
		15 => "AT_ReAddIndex"
		16 => "AT_AddConstraint"
		17 => "AT_ReAddConstraint"
		18 => "AT_ReAddDomainConstraint"
		19 => "AT_AlterConstraint"
		20 => "AT_ValidateConstraint"
		21 => "AT_AddIndexConstraint"
		22 => "AT_DropConstraint"
		23 => "AT_ReAddComment"
		24 => "AT_AlterColumnType"
		25 => "AT_AlterColumnGenericOptions"
		26 => "AT_ChangeOwner"
		27 => "AT_ClusterOn"
		28 => "AT_DropCluster"
		29 => "AT_SetLogged"
		30 => "AT_SetUnLogged"
		31 => "AT_DropOids"
		32 => "AT_SetAccessMethod"
		33 => "AT_SetTableSpace"
		34 => "AT_SetRelOptions"
		35 => "AT_ResetRelOptions"
		36 => "AT_ReplaceRelOptions"
		37 => "AT_EnableTrig"
		38 => "AT_EnableAlwaysTrig"
		39 => "AT_EnableReplicaTrig"
		40 => "AT_DisableTrig"
		41 => "AT_EnableTrigAll"
		42 => "AT_DisableTrigAll"
		43 => "AT_EnableTrigUser"
		44 => "AT_DisableTrigUser"
		45 => "AT_EnableRule"
		46 => "AT_EnableAlwaysRule"
		47 => "AT_EnableReplicaRule"
		48 => "AT_DisableRule"
		49 => "AT_AddInherit"
		50 => "AT_DropInherit"
		51 => "AT_AddOf"
		52 => "AT_DropOf"
		53 => "AT_ReplicaIdentity"
		54 => "AT_EnableRowSecurity"
		55 => "AT_DisableRowSecurity"
		56 => "AT_ForceRowSecurity"
		57 => "AT_NoForceRowSecurity"
		58 => "AT_GenericOptions"
		59 => "AT_AttachPartition"
		60 => "AT_DetachPartition"
		61 => "AT_DetachPartitionFinalize"
		62 => "AT_AddIdentity"
		63 => "AT_SetIdentity"
		64 => "AT_DropIdentity"
		65 => "AT_ReAddStatistics"
		_ => "<AlterTableType ${v.to_str()}>"
	}

enum_bool_expr_type : I64 -> Str
enum_bool_expr_type = |v|
	match v {
		0 => "AND_EXPR"
		1 => "OR_EXPR"
		2 => "NOT_EXPR"
		_ => "<BoolExprType ${v.to_str()}>"
	}

enum_bool_test_type : I64 -> Str
enum_bool_test_type = |v|
	match v {
		0 => "IS_TRUE"
		1 => "IS_NOT_TRUE"
		2 => "IS_FALSE"
		3 => "IS_NOT_FALSE"
		4 => "IS_UNKNOWN"
		5 => "IS_NOT_UNKNOWN"
		_ => "<BoolTestType ${v.to_str()}>"
	}

enum_cte_materialize : I64 -> Str
enum_cte_materialize = |v|
	match v {
		0 => "CTEMaterializeDefault"
		1 => "CTEMaterializeAlways"
		2 => "CTEMaterializeNever"
		_ => "<CTEMaterialize ${v.to_str()}>"
	}

enum_constr_type : I64 -> Str
enum_constr_type = |v|
	match v {
		0 => "CONSTR_NULL"
		1 => "CONSTR_NOTNULL"
		2 => "CONSTR_DEFAULT"
		3 => "CONSTR_IDENTITY"
		4 => "CONSTR_GENERATED"
		5 => "CONSTR_CHECK"
		6 => "CONSTR_PRIMARY"
		7 => "CONSTR_UNIQUE"
		8 => "CONSTR_EXCLUSION"
		9 => "CONSTR_FOREIGN"
		10 => "CONSTR_ATTR_DEFERRABLE"
		11 => "CONSTR_ATTR_NOT_DEFERRABLE"
		12 => "CONSTR_ATTR_DEFERRED"
		13 => "CONSTR_ATTR_IMMEDIATE"
		14 => "CONSTR_ATTR_ENFORCED"
		15 => "CONSTR_ATTR_NOT_ENFORCED"
		_ => "<ConstrType ${v.to_str()}>"
	}

enum_coercion_context : I64 -> Str
enum_coercion_context = |v|
	match v {
		0 => "COERCION_IMPLICIT"
		1 => "COERCION_ASSIGNMENT"
		2 => "COERCION_PLPGSQL"
		3 => "COERCION_EXPLICIT"
		_ => "<CoercionContext ${v.to_str()}>"
	}

enum_role_stmt_type : I64 -> Str
enum_role_stmt_type = |v|
	match v {
		0 => "ROLESTMT_ROLE"
		1 => "ROLESTMT_USER"
		2 => "ROLESTMT_GROUP"
		_ => "<RoleStmtType ${v.to_str()}>"
	}

enum_on_commit_action : I64 -> Str
enum_on_commit_action = |v|
	match v {
		0 => "ONCOMMIT_NOOP"
		1 => "ONCOMMIT_PRESERVE_ROWS"
		2 => "ONCOMMIT_DELETE_ROWS"
		3 => "ONCOMMIT_DROP"
		_ => "<OnCommitAction ${v.to_str()}>"
	}

enum_def_elem_action : I64 -> Str
enum_def_elem_action = |v|
	match v {
		0 => "DEFELEM_UNSPEC"
		1 => "DEFELEM_SET"
		2 => "DEFELEM_ADD"
		3 => "DEFELEM_DROP"
		_ => "<DefElemAction ${v.to_str()}>"
	}

enum_discard_mode : I64 -> Str
enum_discard_mode = |v|
	match v {
		0 => "DISCARD_ALL"
		1 => "DISCARD_PLANS"
		2 => "DISCARD_SEQUENCES"
		3 => "DISCARD_TEMP"
		_ => "<DiscardMode ${v.to_str()}>"
	}

enum_fetch_direction : I64 -> Str
enum_fetch_direction = |v|
	match v {
		0 => "FETCH_FORWARD"
		1 => "FETCH_BACKWARD"
		2 => "FETCH_ABSOLUTE"
		3 => "FETCH_RELATIVE"
		_ => "<FetchDirection ${v.to_str()}>"
	}

enum_coercion_form : I64 -> Str
enum_coercion_form = |v|
	match v {
		0 => "COERCE_EXPLICIT_CALL"
		1 => "COERCE_EXPLICIT_CAST"
		2 => "COERCE_IMPLICIT_CAST"
		3 => "COERCE_SQL_SYNTAX"
		_ => "<CoercionForm ${v.to_str()}>"
	}

enum_function_parameter_mode : I64 -> Str
enum_function_parameter_mode = |v|
	match v {
		105 => "FUNC_PARAM_IN"
		111 => "FUNC_PARAM_OUT"
		98 => "FUNC_PARAM_INOUT"
		118 => "FUNC_PARAM_VARIADIC"
		116 => "FUNC_PARAM_TABLE"
		100 => "FUNC_PARAM_DEFAULT"
		_ => "<FunctionParameterMode ${v.to_str()}>"
	}

enum_grant_target_type : I64 -> Str
enum_grant_target_type = |v|
	match v {
		0 => "ACL_TARGET_OBJECT"
		1 => "ACL_TARGET_ALL_IN_SCHEMA"
		2 => "ACL_TARGET_DEFAULTS"
		_ => "<GrantTargetType ${v.to_str()}>"
	}

enum_grouping_set_kind : I64 -> Str
enum_grouping_set_kind = |v|
	match v {
		0 => "GROUPING_SET_EMPTY"
		1 => "GROUPING_SET_SIMPLE"
		2 => "GROUPING_SET_ROLLUP"
		3 => "GROUPING_SET_CUBE"
		4 => "GROUPING_SET_SETS"
		_ => "<GroupingSetKind ${v.to_str()}>"
	}

enum_import_foreign_schema_type : I64 -> Str
enum_import_foreign_schema_type = |v|
	match v {
		0 => "FDW_IMPORT_SCHEMA_ALL"
		1 => "FDW_IMPORT_SCHEMA_LIMIT_TO"
		2 => "FDW_IMPORT_SCHEMA_EXCEPT"
		_ => "<ImportForeignSchemaType ${v.to_str()}>"
	}

enum_sort_by_dir : I64 -> Str
enum_sort_by_dir = |v|
	match v {
		0 => "SORTBY_DEFAULT"
		1 => "SORTBY_ASC"
		2 => "SORTBY_DESC"
		3 => "SORTBY_USING"
		_ => "<SortByDir ${v.to_str()}>"
	}

enum_sort_by_nulls : I64 -> Str
enum_sort_by_nulls = |v|
	match v {
		0 => "SORTBY_NULLS_DEFAULT"
		1 => "SORTBY_NULLS_FIRST"
		2 => "SORTBY_NULLS_LAST"
		_ => "<SortByNulls ${v.to_str()}>"
	}

enum_overriding_kind : I64 -> Str
enum_overriding_kind = |v|
	match v {
		0 => "OVERRIDING_NOT_SET"
		1 => "OVERRIDING_USER_VALUE"
		2 => "OVERRIDING_SYSTEM_VALUE"
		_ => "<OverridingKind ${v.to_str()}>"
	}

enum_join_type : I64 -> Str
enum_join_type = |v|
	match v {
		0 => "JOIN_INNER"
		1 => "JOIN_LEFT"
		2 => "JOIN_FULL"
		3 => "JOIN_RIGHT"
		4 => "JOIN_SEMI"
		5 => "JOIN_ANTI"
		6 => "JOIN_RIGHT_SEMI"
		7 => "JOIN_RIGHT_ANTI"
		8 => "JOIN_UNIQUE_OUTER"
		9 => "JOIN_UNIQUE_INNER"
		_ => "<JoinType ${v.to_str()}>"
	}

enum_json_behavior_type : I64 -> Str
enum_json_behavior_type = |v|
	match v {
		0 => "JSON_BEHAVIOR_NULL"
		1 => "JSON_BEHAVIOR_ERROR"
		2 => "JSON_BEHAVIOR_EMPTY"
		3 => "JSON_BEHAVIOR_TRUE"
		4 => "JSON_BEHAVIOR_FALSE"
		5 => "JSON_BEHAVIOR_UNKNOWN"
		6 => "JSON_BEHAVIOR_EMPTY_ARRAY"
		7 => "JSON_BEHAVIOR_EMPTY_OBJECT"
		8 => "JSON_BEHAVIOR_DEFAULT"
		_ => "<JsonBehaviorType ${v.to_str()}>"
	}

enum_json_format_type : I64 -> Str
enum_json_format_type = |v|
	match v {
		0 => "JS_FORMAT_DEFAULT"
		1 => "JS_FORMAT_JSON"
		2 => "JS_FORMAT_JSONB"
		_ => "<JsonFormatType ${v.to_str()}>"
	}

enum_json_encoding : I64 -> Str
enum_json_encoding = |v|
	match v {
		0 => "JS_ENC_DEFAULT"
		1 => "JS_ENC_UTF8"
		2 => "JS_ENC_UTF16"
		3 => "JS_ENC_UTF32"
		_ => "<JsonEncoding ${v.to_str()}>"
	}

enum_json_expr_op : I64 -> Str
enum_json_expr_op = |v|
	match v {
		0 => "JSON_EXISTS_OP"
		1 => "JSON_QUERY_OP"
		2 => "JSON_VALUE_OP"
		3 => "JSON_TABLE_OP"
		_ => "<JsonExprOp ${v.to_str()}>"
	}

enum_json_wrapper : I64 -> Str
enum_json_wrapper = |v|
	match v {
		0 => "JSW_UNSPEC"
		1 => "JSW_NONE"
		2 => "JSW_CONDITIONAL"
		3 => "JSW_UNCONDITIONAL"
		_ => "<JsonWrapper ${v.to_str()}>"
	}

enum_json_quotes : I64 -> Str
enum_json_quotes = |v|
	match v {
		0 => "JS_QUOTES_UNSPEC"
		1 => "JS_QUOTES_KEEP"
		2 => "JS_QUOTES_OMIT"
		_ => "<JsonQuotes ${v.to_str()}>"
	}

enum_json_value_type : I64 -> Str
enum_json_value_type = |v|
	match v {
		0 => "JS_TYPE_ANY"
		1 => "JS_TYPE_OBJECT"
		2 => "JS_TYPE_ARRAY"
		3 => "JS_TYPE_SCALAR"
		_ => "<JsonValueType ${v.to_str()}>"
	}

enum_json_table_column_type : I64 -> Str
enum_json_table_column_type = |v|
	match v {
		0 => "JTC_FOR_ORDINALITY"
		1 => "JTC_REGULAR"
		2 => "JTC_EXISTS"
		3 => "JTC_FORMATTED"
		4 => "JTC_NESTED"
		_ => "<JsonTableColumnType ${v.to_str()}>"
	}

enum_lock_clause_strength : I64 -> Str
enum_lock_clause_strength = |v|
	match v {
		0 => "LCS_NONE"
		1 => "LCS_FORKEYSHARE"
		2 => "LCS_FORSHARE"
		3 => "LCS_FORNOKEYUPDATE"
		4 => "LCS_FORUPDATE"
		_ => "<LockClauseStrength ${v.to_str()}>"
	}

enum_lock_wait_policy : I64 -> Str
enum_lock_wait_policy = |v|
	match v {
		0 => "LockWaitBlock"
		1 => "LockWaitSkip"
		2 => "LockWaitError"
		_ => "<LockWaitPolicy ${v.to_str()}>"
	}

enum_merge_match_kind : I64 -> Str
enum_merge_match_kind = |v|
	match v {
		0 => "MERGE_WHEN_MATCHED"
		1 => "MERGE_WHEN_NOT_MATCHED_BY_SOURCE"
		2 => "MERGE_WHEN_NOT_MATCHED_BY_TARGET"
		_ => "<MergeMatchKind ${v.to_str()}>"
	}

enum_cmd_type : I64 -> Str
enum_cmd_type = |v|
	match v {
		0 => "CMD_UNKNOWN"
		1 => "CMD_SELECT"
		2 => "CMD_UPDATE"
		3 => "CMD_INSERT"
		4 => "CMD_DELETE"
		5 => "CMD_MERGE"
		6 => "CMD_UTILITY"
		7 => "CMD_NOTHING"
		_ => "<CmdType ${v.to_str()}>"
	}

enum_min_max_op : I64 -> Str
enum_min_max_op = |v|
	match v {
		0 => "IS_GREATEST"
		1 => "IS_LEAST"
		_ => "<MinMaxOp ${v.to_str()}>"
	}

enum_null_test_type : I64 -> Str
enum_null_test_type = |v|
	match v {
		0 => "IS_NULL"
		1 => "IS_NOT_NULL"
		_ => "<NullTestType ${v.to_str()}>"
	}

enum_on_conflict_action : I64 -> Str
enum_on_conflict_action = |v|
	match v {
		0 => "ONCONFLICT_NONE"
		1 => "ONCONFLICT_NOTHING"
		2 => "ONCONFLICT_UPDATE"
		_ => "<OnConflictAction ${v.to_str()}>"
	}

enum_partition_strategy : I64 -> Str
enum_partition_strategy = |v|
	match v {
		108 => "PARTITION_STRATEGY_LIST"
		114 => "PARTITION_STRATEGY_RANGE"
		104 => "PARTITION_STRATEGY_HASH"
		_ => "<PartitionStrategy ${v.to_str()}>"
	}

enum_publication_obj_spec_type : I64 -> Str
enum_publication_obj_spec_type = |v|
	match v {
		0 => "PUBLICATIONOBJ_TABLE"
		1 => "PUBLICATIONOBJ_TABLES_IN_SCHEMA"
		2 => "PUBLICATIONOBJ_TABLES_IN_CUR_SCHEMA"
		3 => "PUBLICATIONOBJ_CONTINUATION"
		_ => "<PublicationObjSpecType ${v.to_str()}>"
	}

enum_reindex_object_type : I64 -> Str
enum_reindex_object_type = |v|
	match v {
		0 => "REINDEX_OBJECT_INDEX"
		1 => "REINDEX_OBJECT_TABLE"
		2 => "REINDEX_OBJECT_SCHEMA"
		3 => "REINDEX_OBJECT_SYSTEM"
		4 => "REINDEX_OBJECT_DATABASE"
		_ => "<ReindexObjectType ${v.to_str()}>"
	}

enum_returning_option_kind : I64 -> Str
enum_returning_option_kind = |v|
	match v {
		0 => "RETURNING_OPTION_OLD"
		1 => "RETURNING_OPTION_NEW"
		_ => "<ReturningOptionKind ${v.to_str()}>"
	}

enum_role_spec_type : I64 -> Str
enum_role_spec_type = |v|
	match v {
		0 => "ROLESPEC_CSTRING"
		1 => "ROLESPEC_CURRENT_ROLE"
		2 => "ROLESPEC_CURRENT_USER"
		3 => "ROLESPEC_SESSION_USER"
		4 => "ROLESPEC_PUBLIC"
		_ => "<RoleSpecType ${v.to_str()}>"
	}

enum_sql_value_function_op : I64 -> Str
enum_sql_value_function_op = |v|
	match v {
		0 => "SVFOP_CURRENT_DATE"
		1 => "SVFOP_CURRENT_TIME"
		2 => "SVFOP_CURRENT_TIME_N"
		3 => "SVFOP_CURRENT_TIMESTAMP"
		4 => "SVFOP_CURRENT_TIMESTAMP_N"
		5 => "SVFOP_LOCALTIME"
		6 => "SVFOP_LOCALTIME_N"
		7 => "SVFOP_LOCALTIMESTAMP"
		8 => "SVFOP_LOCALTIMESTAMP_N"
		9 => "SVFOP_CURRENT_ROLE"
		10 => "SVFOP_CURRENT_USER"
		11 => "SVFOP_USER"
		12 => "SVFOP_SESSION_USER"
		13 => "SVFOP_CURRENT_CATALOG"
		14 => "SVFOP_CURRENT_SCHEMA"
		_ => "<SQLValueFunctionOp ${v.to_str()}>"
	}

enum_limit_option : I64 -> Str
enum_limit_option = |v|
	match v {
		0 => "LIMIT_OPTION_COUNT"
		1 => "LIMIT_OPTION_WITH_TIES"
		_ => "<LimitOption ${v.to_str()}>"
	}

enum_set_operation : I64 -> Str
enum_set_operation = |v|
	match v {
		0 => "SETOP_NONE"
		1 => "SETOP_UNION"
		2 => "SETOP_INTERSECT"
		3 => "SETOP_EXCEPT"
		_ => "<SetOperation ${v.to_str()}>"
	}

enum_sub_link_type : I64 -> Str
enum_sub_link_type = |v|
	match v {
		0 => "EXISTS_SUBLINK"
		1 => "ALL_SUBLINK"
		2 => "ANY_SUBLINK"
		3 => "ROWCOMPARE_SUBLINK"
		4 => "EXPR_SUBLINK"
		5 => "MULTIEXPR_SUBLINK"
		6 => "ARRAY_SUBLINK"
		7 => "CTE_SUBLINK"
		_ => "<SubLinkType ${v.to_str()}>"
	}

enum_transaction_stmt_kind : I64 -> Str
enum_transaction_stmt_kind = |v|
	match v {
		0 => "TRANS_STMT_BEGIN"
		1 => "TRANS_STMT_START"
		2 => "TRANS_STMT_COMMIT"
		3 => "TRANS_STMT_ROLLBACK"
		4 => "TRANS_STMT_SAVEPOINT"
		5 => "TRANS_STMT_RELEASE"
		6 => "TRANS_STMT_ROLLBACK_TO"
		7 => "TRANS_STMT_PREPARE"
		8 => "TRANS_STMT_COMMIT_PREPARED"
		9 => "TRANS_STMT_ROLLBACK_PREPARED"
		_ => "<TransactionStmtKind ${v.to_str()}>"
	}

enum_variable_set_kind : I64 -> Str
enum_variable_set_kind = |v|
	match v {
		0 => "VAR_SET_VALUE"
		1 => "VAR_SET_DEFAULT"
		2 => "VAR_SET_CURRENT"
		3 => "VAR_SET_MULTI"
		4 => "VAR_RESET"
		5 => "VAR_RESET_ALL"
		_ => "<VariableSetKind ${v.to_str()}>"
	}

enum_view_check_option : I64 -> Str
enum_view_check_option = |v|
	match v {
		0 => "NO_CHECK_OPTION"
		1 => "LOCAL_CHECK_OPTION"
		2 => "CASCADED_CHECK_OPTION"
		_ => "<ViewCheckOption ${v.to_str()}>"
	}

enum_xml_expr_op : I64 -> Str
enum_xml_expr_op = |v|
	match v {
		0 => "IS_XMLCONCAT"
		1 => "IS_XMLELEMENT"
		2 => "IS_XMLFOREST"
		3 => "IS_XMLPARSE"
		4 => "IS_XMLPI"
		5 => "IS_XMLROOT"
		6 => "IS_XMLSERIALIZE"
		7 => "IS_DOCUMENT"
		_ => "<XmlExprOp ${v.to_str()}>"
	}

enum_xml_option_type : I64 -> Str
enum_xml_option_type = |v|
	match v {
		0 => "XMLOPTION_DOCUMENT"
		1 => "XMLOPTION_CONTENT"
		_ => "<XmlOptionType ${v.to_str()}>"
	}
