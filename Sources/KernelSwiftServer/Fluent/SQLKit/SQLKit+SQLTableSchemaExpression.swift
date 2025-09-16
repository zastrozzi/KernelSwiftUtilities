//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 10/02/2025.
//

import SQLKit
import FluentKit
import Fluent
import Vapor
import PostgresNIO

extension Schema {
    static var spaceIfNotAliased: String? {
        self.alias == nil ? self.space : nil
    }
    
    static var sqlTable: SQLQualifiedTable {
        .init(self.schemaOrAlias, space: self.spaceIfNotAliased)
    }
    
    public static func columns(schemaName: String, tableName: String) -> SQLExpression {
        var selectExpression = SQLSelect()
        selectExpression.columns = [
            SQLAlias(SQLColumn("table_schema", table: "isc"), as: "table_schema"),
            SQLAlias(SQLColumn("table_name", table: "isc"), as: "table_name"),
            SQLAlias(SQLColumn("column_name", table: "isc"), as: "column_name"),
            SQLAlias(SQLColumn("is_nullable", table: "isc"), as: "is_nullable"),
            SQLAlias(SQLColumn("udt_name", table: "isc"), as: "udt_name")
        ]
        selectExpression.tables = [
            SQLAlias(SQLQualifiedTable("columns", space: "information_schema"), as: "isc")
        ]
        selectExpression.predicate = SQLBinaryExpression(
            operator: .and,
            SQLBinaryExpression(
                SQLColumn("table_name", table: "isc"),
                .equal,
                SQLLiteral.string(tableName)
            ),
            SQLBinaryExpression(
                SQLColumn("table_schema", table: "isc"),
                .equal,
                SQLLiteral.string(schemaName)
            )
        )
        return selectExpression
    }
    
    public static func columnsWithUsage(schemaName: String, tableName: String) -> SQLExpression {
        var selectExpression = SQLSelect()
        selectExpression.columns = [
            SQLAlias(SQLColumn("table_schema", table: "isc"), as: "table_schema"),
            SQLAlias(SQLColumn("table_name", table: "isc"), as: "table_name"),
            SQLAlias(SQLColumn("column_name", table: "isc"), as: "column_name"),
            SQLAlias(SQLColumn("ordinal_position", table: "isc"), as: "ordinal_position"),
            SQLAlias(
                SQLBinaryExpression(SQLColumn("is_nullable", table: "isc"), .equal, SQLLiteral.string("YES")),
                as: "is_nullable"
            ),
            SQLAlias(SQLColumn("udt_name", table: "isc"), as: "udt_name"),
            SQLAlias(
                SQLFunction.coalesce(
                    SQLFunction(
                        "bool_or",
                        args: SQLBinaryExpression(
                            SQLColumn("constraint_type", table: "tc"),
                            .equal,
                            SQLLiteral.string("PRIMARY KEY")
                        )
                    ),
                    SQLLiteral.boolean(false)
                ),
                as: "is_primary_key"
            ),
            SQLAlias(
                SQLFunction.coalesce(
                    SQLFunction(
                        "bool_or",
                        args: SQLBinaryExpression(
                            SQLColumn("constraint_type", table: "tc"),
                            .equal,
                            SQLLiteral.string("FOREIGN KEY")
                        )
                    ),
                    SQLLiteral.boolean(false)
                ),
                as: "is_foreign_key"
            ),
            SQLAlias(
                SQLFunction.coalesce(
                    SQLFunction(
                        "bool_or",
                        args: SQLBinaryExpression(
                            operator: .or,
                            SQLBinaryExpression(
                                SQLColumn("constraint_type", table: "tc"),
                                .equal,
                                SQLLiteral.string("UNIQUE")
                            ),
                            SQLBinaryExpression(
                                SQLColumn("constraint_type", table: "tc"),
                                .equal,
                                SQLLiteral.string("PRIMARY_KEY")
                            )
                        )
                    ),
                    SQLLiteral.boolean(false)
                ),
                as: "is_unique"
            )
        ]
        selectExpression.tables = [
            SQLAlias(SQLQualifiedTable("columns", space: "information_schema"), as: "isc")
        ]
        selectExpression.joins = [
            SQLJoin(
                method: SQLJoinMethod.left,
                table: SQLAlias(SQLQualifiedTable("key_column_usage", space: "information_schema"), as: "kcu"),
                expression: SQLBinaryExpression(
                    operator: .and,
                    SQLBinaryExpression(
                        SQLColumn("table_schema", table: "isc"),
                        .equal,
                        SQLColumn("table_schema", table: "kcu")
                    ),
                    SQLBinaryExpression(
                        SQLColumn("table_name", table: "isc"),
                        .equal,
                        SQLColumn("table_name", table: "kcu")
                    ),
                    SQLBinaryExpression(
                        SQLColumn("column_name", table: "isc"),
                        .equal,
                        SQLColumn("column_name", table: "kcu")
                    )
                )
            ),
            SQLJoin(
                method: SQLJoinMethod.left,
                table: SQLAlias(SQLQualifiedTable("table_constraints", space: "information_schema"), as: "tc"),
                expression: SQLBinaryExpression(
                    operator: .and,
                    SQLBinaryExpression(
                        SQLColumn("constraint_name", table: "kcu"),
                        .equal,
                        SQLColumn("constraint_name", table: "tc")
                    ),
                    SQLBinaryExpression(
                        SQLColumn("constraint_schema", table: "kcu"),
                        .equal,
                        SQLColumn("constraint_schema", table: "tc")
                    )
                )
            )
        ]
        selectExpression.predicate = SQLBinaryExpression(
            operator: .and,
            SQLBinaryExpression(
                SQLColumn("table_name", table: "isc"),
                .equal,
                SQLLiteral.string(tableName)
            ),
            SQLBinaryExpression(
                SQLColumn("table_schema", table: "isc"),
                .equal,
                SQLLiteral.string(schemaName)
            )
        )
        selectExpression.groupBy = [
            SQLColumn("table_schema", table: "isc"),
            SQLColumn("table_name", table: "isc"),
            SQLColumn("column_name", table: "isc"),
            SQLColumn("ordinal_position", table: "isc"),
            SQLColumn("is_nullable", table: "isc"),
            SQLColumn("udt_name", table: "isc")
        ]
        return selectExpression
    }
    
    public static func parentRelationships(schemaName: String, tableName: String) -> SQLExpression {
        var select = SQLSelect()
        select.columns = [
            SQLAlias(SQLColumn("table_schema", table: "kcu"), as: "referencing_table_schema"),
            SQLAlias(SQLColumn("table_name", table: "kcu"), as: "referencing_table_name"),
            SQLAlias(SQLColumn("column_name", table: "kcu"), as: "referencing_column_name"),
            SQLAlias(SQLColumn("is_nullable", table: "isc"), as: "referencing_column_is_nullable"),
            SQLAlias(SQLColumn("table_schema", table: "ccu"), as: "referenced_table_schema"),
            SQLAlias(SQLColumn("table_name", table: "ccu"), as: "referenced_table_name"),
            SQLAlias(SQLColumn("column_name", table: "ccu"), as: "referenced_column_name")
        ]
        select.tables = [
            SQLAlias(SQLQualifiedTable("key_column_usage", space: "information_schema"), as: "kcu")
        ]
        select.joins = [
            SQLJoin(
                method: SQLJoinMethod.inner,
                table: SQLAlias(SQLQualifiedTable("constraint_column_usage", space: "information_schema"), as: "ccu"),
                expression: SQLBinaryExpression(
                    operator: .and,
                    SQLBinaryExpression(
                        SQLColumn("constraint_name", table: "kcu"),
                        .equal,
                        SQLColumn("constraint_name", table: "ccu")
                    ),
                    SQLBinaryExpression(
                        SQLColumn("constraint_schema", table: "kcu"),
                        .equal,
                        SQLColumn("constraint_schema", table: "ccu")
                    )
                )
            ),
            SQLJoin(
                method: SQLJoinMethod.inner,
                table: SQLAlias(SQLQualifiedTable("table_constraints", space: "information_schema"), as: "tc"),
                expression: SQLBinaryExpression(
                    operator: .and,
                    SQLBinaryExpression(
                        SQLColumn("constraint_name", table: "kcu"),
                        .equal,
                        SQLColumn("constraint_name", table: "tc")
                    ),
                    SQLBinaryExpression(
                        SQLColumn("constraint_schema", table: "kcu"),
                        .equal,
                        SQLColumn("constraint_schema", table: "tc")
                    ),
                    SQLBinaryExpression(
                        SQLColumn("constraint_type", table: "tc"),
                        .equal,
                        SQLLiteral.string("FOREIGN KEY")
                    )
                )
            ),
            SQLJoin(
                method: SQLJoinMethod.inner,
                table: SQLAlias(SQLQualifiedTable("columns", space: "information_schema"), as: "isc"),
                expression: SQLBinaryExpression(
                    operator: .and,
                    SQLBinaryExpression(
                        SQLColumn("table_schema", table: "kcu"),
                        .equal,
                        SQLColumn("table_schema", table: "isc")
                    ),
                    SQLBinaryExpression(
                        SQLColumn("table_name", table: "kcu"),
                        .equal,
                        SQLColumn("table_name", table: "isc")
                    ),
                    SQLBinaryExpression(
                        SQLColumn("column_name", table: "kcu"),
                        .equal,
                        SQLColumn("column_name", table: "isc")
                    )
                )
            )
        ]
        select.predicate = SQLBinaryExpression(
            operator: .and,
            SQLBinaryExpression(
                SQLColumn("table_name", table: "kcu"),
                .equal,
                SQLLiteral.string(tableName)
            ),
            SQLBinaryExpression(
                SQLColumn("table_schema", table: "kcu"),
                .equal,
                SQLLiteral.string(schemaName)
            )
        )
        
        return select
    }
    
    public static func siblingRelationships(schemaName: String, tableName: String) -> SQLExpression {
        var select = SQLSelect()
        select.columns = [
            SQLAlias(SQLColumn("table_schema", table: "kcu1"), as: "join_table_schema"),
            SQLAlias(SQLColumn("table_name", table: "kcu1"), as: "join_table_name"),
            SQLAlias(SQLColumn("column_name", table: "kcu1"), as: "join_referencing_column_name"),
            SQLAlias(SQLColumn("column_name", table: "kcu2"), as: "join_referenced_column_name"),
            SQLAlias(SQLColumn("table_schema", table: "ccu1"), as: "referencing_table_schema"),
            SQLAlias(SQLColumn("table_name", table: "ccu1"), as: "referencing_table_name"),
            SQLAlias(SQLColumn("column_name", table: "ccu1"), as: "referencing_column_name"),
            SQLAlias(SQLColumn("table_schema", table: "ccu2"), as: "referenced_table_schema"),
            SQLAlias(SQLColumn("table_name", table: "ccu2"), as: "referenced_table_name"),
            SQLAlias(SQLColumn("column_name", table: "ccu2"), as: "referenced_column_name")
        ]
        select.tables = [ SQLAlias(SQLQualifiedTable("key_column_usage", space: "information_schema"), as: "kcu1") ]
        select.joins = [
            SQLJoin(
                method: SQLJoinMethod.inner,
                table: SQLAlias(SQLQualifiedTable("constraint_column_usage", space: "information_schema"), as: "ccu1"),
                expression: SQLBinaryExpression(
                    operator: .and,
                    SQLBinaryExpression(SQLColumn("constraint_name", table: "kcu1"), .equal, SQLColumn("constraint_name", table: "ccu1")),
                    SQLBinaryExpression(SQLColumn("constraint_schema", table: "kcu1"), .equal, SQLColumn("constraint_schema", table: "ccu1"))
                )
            ),
            SQLJoin(
                method: SQLJoinMethod.inner,
                table: SQLAlias(SQLQualifiedTable("table_constraints", space: "information_schema"), as: "tc1"),
                expression: SQLBinaryExpression(
                    operator: .and,
                    SQLBinaryExpression(SQLColumn("constraint_name", table: "kcu1"), .equal, SQLColumn("constraint_name", table: "tc1")),
                    SQLBinaryExpression(SQLColumn("constraint_schema", table: "kcu1"), .equal, SQLColumn("constraint_schema", table: "tc1")),
                    SQLBinaryExpression(SQLColumn("constraint_type", table: "tc1"), .equal, SQLLiteral.string("FOREIGN KEY"))
                )
            ),
            SQLJoin(
                method: SQLJoinMethod.inner,
                table: SQLAlias(SQLQualifiedTable("key_column_usage", space: "information_schema"), as: "kcu2"),
                expression: SQLBinaryExpression(
                    operator: .and,
                    SQLBinaryExpression(SQLColumn("table_schema", table: "kcu1"), .equal, SQLColumn("table_schema", table: "kcu2")),
                    SQLBinaryExpression(SQLColumn("table_name", table: "kcu1"), .equal, SQLColumn("table_name", table: "kcu2")),
                    SQLBinaryExpression(SQLColumn("column_name", table: "kcu1"), .notEqual, SQLColumn("column_name", table: "kcu2"))
                )
            ),
            SQLJoin(
                method: SQLJoinMethod.inner,
                table: SQLAlias(SQLQualifiedTable("constraint_column_usage", space: "information_schema"), as: "ccu2"),
                expression: SQLBinaryExpression(
                    operator: .and,
                    SQLBinaryExpression(SQLColumn("constraint_name", table: "kcu2"), .equal, SQLColumn("constraint_name", table: "ccu2")),
                    SQLBinaryExpression(SQLColumn("constraint_schema", table: "kcu2"), .equal, SQLColumn("constraint_schema", table: "ccu2"))
                )
            ),
            SQLJoin(
                method: SQLJoinMethod.inner,
                table: SQLAlias(SQLQualifiedTable("table_constraints", space: "information_schema"), as: "tc2"),
                expression: SQLBinaryExpression(
                    operator: .and,
                    SQLBinaryExpression(SQLColumn("constraint_name", table: "kcu2"), .equal, SQLColumn("constraint_name", table: "tc2")),
                    SQLBinaryExpression(SQLColumn("constraint_schema", table: "kcu2"), .equal, SQLColumn("constraint_schema", table: "tc2")),
                    SQLBinaryExpression(SQLColumn("constraint_type", table: "tc2"), .equal, SQLLiteral.string("FOREIGN KEY"))
                )
            )
        ]
        select.predicate = SQLBinaryExpression(
            operator: .and,
            SQLBinaryExpression(SQLColumn("table_name", table: "ccu1"), .equal, SQLLiteral.string(tableName)),
            SQLBinaryExpression(SQLColumn("table_schema", table: "ccu1"), .equal, SQLLiteral.string(schemaName)),
            SQLBinaryExpression(SQLColumn("table_name", table: "ccu2"), .notEqual, SQLLiteral.string(tableName))
        )

        return select
    }
    
    
}


//select kcu.table_schema || '.' ||kcu.table_name as foreign_table,
//'>-' as rel,
//rel_tco.table_schema || '.' || rel_tco.table_name as primary_table,
//string_agg(kcu.column_name, ', ') as fk_columns,
//kcu.constraint_name
//from information_schema.table_constraints tco
//join information_schema.key_column_usage kcu
//on tco.constraint_schema = kcu.constraint_schema
//and tco.constraint_name = kcu.constraint_name
//join information_schema.referential_constraints rco
//on tco.constraint_schema = rco.constraint_schema
//and tco.constraint_name = rco.constraint_name
//join information_schema.table_constraints rel_tco
//on rco.unique_constraint_schema = rel_tco.constraint_schema
//and rco.unique_constraint_name = rel_tco.constraint_name
//where tco.constraint_type = 'FOREIGN KEY'
//group by kcu.table_schema,
//kcu.table_name,
//rel_tco.table_name,
//rel_tco.table_schema,
//kcu.constraint_name
//order by kcu.table_schema,
//kcu.table_name;
