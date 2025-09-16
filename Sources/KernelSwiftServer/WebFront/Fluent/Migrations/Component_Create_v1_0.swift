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
    public struct Component_Create_v1_0: AsyncMigration {
        public func prepare(on database: Database) async throws {
            try await database.schema(SchemaName.component)
                .id()
                .timestamps()
                .field("site_revision_id", .uuid, .references(SchemaName.siteRevision, .id, onDelete: .cascade, onUpdate: .cascade))
                .create()
        }
        
        public func revert(on database: Database) async throws {
            try await database.schema(SchemaName.component)
                .delete()
        }
    }
}
