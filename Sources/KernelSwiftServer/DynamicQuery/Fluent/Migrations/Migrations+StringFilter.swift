//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 01/02/2025.
//

import KernelSwiftCommon
import Vapor
import Fluent
import SQLKit
import PostgresKit

extension KernelDynamicQuery.Fluent.Migrations {
    public struct StringFilter_Create_v1_0: AsyncMigration {
        public func prepare(on database: any Database) async throws {
            try await database.schema(SchemaName.stringFilter)
                .id()
                .timestamps()
                .group("col", columnIdentifiers)
                .field("field_array", .bool, .required)
                .field("method", .enum(KernelDynamicQuery.Core.APIModel.FilterMethod.self), .required)
                .field("value", .string)
                .field("array_value", .array(of: .string))
                .field("query_id", .uuid, .required, .references(SchemaName.structuredQuery, .id, onDelete: .cascade, onUpdate: .cascade))
                .field("group_id", .uuid, .references(SchemaName.filterGroup, .id, onDelete: .cascade, onUpdate: .cascade))
                .create()
        }
        
        public func revert(on database: any Database) async throws {
            try await database.schema(SchemaName.stringFilter).delete()
        }
    }
}
