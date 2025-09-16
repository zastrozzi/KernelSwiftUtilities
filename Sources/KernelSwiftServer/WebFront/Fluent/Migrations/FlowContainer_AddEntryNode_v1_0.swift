//
//  File.swift
//
//
//  Created by Jonathan Forbes on 1/5/24.
//

import Vapor
import Fluent
import FluentPostgresDriver
import KernelSwiftCommon

extension KernelWebFront.Fluent.Migrations {
    public struct FlowContainer_AddEntryNode_v1_0: AsyncMigration {
        public func prepare(on database: Database) async throws {
            try await database.schema(SchemaName.flowContainer)
                .field("entry_node_id", .uuid, .references(SchemaName.flowNode, .id, onDelete: .setNull, onUpdate: .cascade))
                .update()
        }
        
        public func revert(on database: Database) async throws {
            try await database.schema(SchemaName.flowContainer)
                .deleteField("entry_node_id")
                .update()
        }
    }
}
