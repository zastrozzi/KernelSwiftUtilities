//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 17/02/2025.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelDynamicQuery.Fluent.Migrations {
    public struct FieldFilter_Create_v1_0: AsyncMigration {
        public func prepare(on database: any Database) async throws {
            try await database.schema(SchemaName.fieldFilter)
                .id()
                .timestamps()
                .group("left_col", columnIdentifiers)
                .group("right_col", columnIdentifiers)
                .field("method", .enum(KernelDynamicQuery.Core.APIModel.FilterMethod.self), .required)
                .field("query_id", .uuid, .required, .references(SchemaName.structuredQuery, .id, onDelete: .cascade, onUpdate: .cascade))
                .field("group_id", .uuid, .references(SchemaName.filterGroup, .id, onDelete: .cascade, onUpdate: .cascade))
                .create()
        }
        
        public func revert(on database: any Database) async throws {
            try await database.schema(SchemaName.fieldFilter).delete()
        }
    }
}
