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
    public struct FlowContinuation_Create_v1_0: AsyncMigration {
        public func prepare(on database: Database) async throws {
            try await database.schema(SchemaName.flowContinuation)
                .id()
                .timestamps()
                .field("condition", .string, .required)
                .field("parent_node_id", .uuid, .required,
                    .references(SchemaName.flowNode, .id, onDelete: .cascade, onUpdate: .cascade)
                )
                .field("child_node_id", .uuid, .required,
                    .references(SchemaName.flowNode, .id, onDelete: .cascade, onUpdate: .cascade)
                )
                .create()
        }
        
        public func revert(on database: Database) async throws {
            try await database.schema(SchemaName.flowContinuation)
                .delete()
        }
    }
}
