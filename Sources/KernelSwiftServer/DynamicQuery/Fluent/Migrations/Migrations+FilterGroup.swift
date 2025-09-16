//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 01/02/2025.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelDynamicQuery.Fluent.Migrations {
    public struct FilterGroup_Create_v1_0: AsyncMigration {
        public func prepare(on database: any Database) async throws {
            try await database.schema(SchemaName.filterGroup)
                .id()
                .timestamps()
                .field("relation", .enum(KernelDynamicQuery.Core.APIModel.FilterRelation.self), .required)
                .field("nest_level", .int, .required)
                .field("query_id", .uuid, .required, .references(SchemaName.structuredQuery, .id, onDelete: .cascade, onUpdate: .cascade))
                .field("parent_id", .uuid, .references(SchemaName.filterGroup, .id, onDelete: .cascade, onUpdate: .cascade))
                .create()
        }
        
        public func revert(on database: any Database) async throws {
            try await database.schema(SchemaName.filterGroup).delete()
        }
    }
}
