//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 05/02/2025.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelDynamicQuery.Fluent.Migrations {
    public struct JoinClause_Create_v1_0: AsyncMigration {
        public func prepare(on database: any Database) async throws {
            try await database.schema(SchemaName.joinClause)
                .id()
                .timestamps()
                .field("method", .enum(KernelDynamicQuery.Core.APIModel.JoinMethod.self), .required)
                .group("to", tableIdentifiers)
                .field("on_stmnt_id", .uuid, .required, .references(SchemaName.filterGroup, .id, onDelete: .cascade, onUpdate: .cascade))
                .field("query_id", .uuid, .required, .references(SchemaName.structuredQuery, .id, onDelete: .cascade, onUpdate: .cascade))
                .create()
        }
        
        public func revert(on database: any Database) async throws {
            try await database.schema(SchemaName.joinClause).delete()
        }
    }
}
