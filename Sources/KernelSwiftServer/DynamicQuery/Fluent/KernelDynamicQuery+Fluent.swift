//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 01/02/2025.
//

extension KernelDynamicQuery {
    public enum Fluent: KernelServerPlatform.FluentContainer {}
}

extension KernelDynamicQuery.Fluent {
    public enum SchemaName: String, KernelFluentNamespacedSchemaName {
        public static let namespace: String = "kdq"
        
        case structuredQuery = "structured_query"
        
        case filterGroup = "filter_group"
        
        case dateFilter = "date_filter"
        case numericFilter = "numeric_filter"
        case stringFilter = "string_filter"
        case booleanFilter = "boolean_filter"
        case enumFilter = "enum_filter"
        case uuidFilter = "uuid_filter"
        case fieldFilter = "field_filter"
        case joinClause = "join_clause"
    }
}

//SELECT
//kcu.table_schema AS referencing_table_schema,
//kcu.table_name AS referencing_table_name,
//kcu.column_name AS referencing_column_name,
//ccu.table_schema AS referenced_table_schema,
//ccu.table_name AS referenced_table_name,
//ccu.column_name AS referenced_column_name
//FROM
//information_schema.key_column_usage kcu
//JOIN
//information_schema.constraint_column_usage ccu
//ON kcu.constraint_name = ccu.constraint_name
//AND kcu.constraint_schema = ccu.constraint_schema
//JOIN
//information_schema.table_constraints tc
//ON kcu.constraint_name = tc.constraint_name
//AND kcu.constraint_schema = tc.constraint_schema
//AND kcu.constraint_name = tc.constraint_name
//AND tc.constraint_type = 'FOREIGN KEY'
//WHERE
//kcu.table_name = 'boolean_filter'
//AND kcu.table_schema = 'kdq';
