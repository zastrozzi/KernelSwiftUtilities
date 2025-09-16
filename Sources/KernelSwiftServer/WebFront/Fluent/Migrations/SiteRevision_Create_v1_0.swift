//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 17/08/2024.
//

import Vapor
import Fluent
import FluentPostgresDriver
import KernelSwiftCommon

extension KernelWebFront.Fluent.Migrations {
    public struct SiteRevision_Create_v1_0: AsyncMigration {
        public init() {}
        
        public func prepare(on database: any Database) async throws {
            try await database.schema(SchemaName.siteRevision)
                .id()
                .timestamps()
                .field("name", .string, .required)
                .field("description", .string)
                .field("url", .string, .required)
                .field("site_id", .uuid, .required, .references(SchemaName.site, .id, onDelete: .cascade, onUpdate: .cascade))
                .create()
        }
        
        public func revert(on database: any Database) async throws {
            try await database.schema(SchemaName.siteRevision)
                .delete()
        }
    }
}
