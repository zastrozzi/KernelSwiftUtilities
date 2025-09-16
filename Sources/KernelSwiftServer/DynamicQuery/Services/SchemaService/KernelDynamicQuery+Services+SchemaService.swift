//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 10/02/2025.
//

import KernelSwiftCommon
import Vapor
import Fluent
import SQLKit

extension KernelDynamicQuery.Services {
    public struct SchemaService: DBAccessible, APIModelAccessible, Sendable {
        @KernelDI.Injected(\.vapor) public var app
        public typealias FeatureContainer = KernelDynamicQuery
        
        internal let tableCache: KernelServerPlatform.SimpleMemoryCache<UUID, APIModel.QueryableSchema.TableResponse>
        internal let columnCache: KernelServerPlatform.SimpleMemoryCache<UUID, APIModel.QueryableSchema.ColumnResponse>
        internal let relationshipCache: KernelServerPlatform.SimpleMemoryCache<UUID, APIModel.QueryableSchema.RelationshipResponse>
        
        public init() {
            Self.logInit()
            self.tableCache = .init()
            self.columnCache = .init()
            self.relationshipCache = .init()
        }
        
        public func registerSchema<SchemaModel: KernelFluentNamespacedModel>(
            _ modelType: SchemaModel.Type,
            as schemaDisplayName: String,
            on db: DatabaseID? = nil
        ) async throws {
            nonisolated(unsafe) var columnRows: [SQLRow] = []
            
            try await selectDB(db)
                .asSQL()
                .execute(sql: SchemaModel.columnsWithUsage(
                    schemaName: SchemaModel.namespacedSchema.namespace,
                    tableName: SchemaModel.namespacedSchema.table
                )) { columnRows.append($0) }
            
            try addTable(.init(
                displayName: schemaDisplayName,
                tableIdentifiers: .init(modelType)
            ))
            
            try columnRows.forEach {
                try addColumn($0.decode(model: APIModel.QueryableSchema.ColumnResponse.self))
            }
        }
        
        public func registerRelationships(on db: DatabaseID? = nil) async throws {
            nonisolated(unsafe) var parentRelationshipRows: [SQLRow] = []
            nonisolated(unsafe) var siblingRelationshipRows: [SQLRow] = []
            let tableIdentifiers = tableCache.all().map { $0.tableIdentifiers }
            try await selectDB(db).asSQL()
                .execute(sql: Self.siblingRelationships(tables: tableIdentifiers)) {
                    siblingRelationshipRows.append($0)
                }
            
            try siblingRelationshipRows.forEach {
                let relationship = try $0.decode(model: APIModel.QueryableSchema.SiblingRelationship.self)
                    .makeRelationship()
                if tableCache.has(relationship.fromTableId) {
                    try addRelationship(relationship)
                }
            }
            
            try await selectDB(db).asSQL()
                .execute(sql: Self.parentRelationships(tables: tableIdentifiers)) {
                    parentRelationshipRows.append($0)
                }
            
            try parentRelationshipRows.forEach {
                let relationship = try $0.decode(model: APIModel.QueryableSchema.RelationshipResponse.self)
                if tableCache.has(relationship.fromTableId) {
                    try addRelationship(relationship)
                    try addRelationship(relationship.makeCompanion())
                }
            }
        }
        
        public static func siblingRelationships(tables: [APIModel.TableIdentifiers]) -> SQLExpression {
            let tableNames = tables.map(\.table).uniqued()
            let schemaNames = tables.map(\.schema).uniqued()
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
                SQLBinaryExpression(SQLColumn("table_name", table: "ccu1"), .in, SQLGroupExpression(tableNames.map { SQLLiteral.string($0) })),
                SQLBinaryExpression(SQLColumn("table_schema", table: "ccu1"), .in, SQLGroupExpression(schemaNames.map { SQLLiteral.string($0) }))
//                SQLBinaryExpression(SQLColumn("table_name", table: "ccu2"), .notEqual, SQLColumn("table_name", table: "ccu1"))
            )
            return select
        }
        
        public static func parentRelationships(tables: [APIModel.TableIdentifiers]) -> SQLExpression {
            let tableNames = tables.map(\.table).uniqued()
            let schemaNames = tables.map(\.schema).uniqued()
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
                SQLBinaryExpression(SQLColumn("table_name", table: "kcu"), .in, SQLGroupExpression(tableNames.map { SQLLiteral.string($0) })),
                SQLBinaryExpression(SQLColumn("table_schema", table: "kcu"), .in, SQLGroupExpression(schemaNames.map { SQLLiteral.string($0) }))
            )
            
            return select
        }
    }
}
