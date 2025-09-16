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
    public struct FlowNode_Create_v1_0: AsyncMigration {
        public func prepare(on database: Database) async throws {
            try await database.schema(SchemaName.flowNode)
                .id()
                .timestamps()
                .field("header", .string, .required)
                .field("headline", .string, .required)
                .field("subheadline", .string, .required)
                .field("body", .string, .required)
                .field("container_id", .uuid, .required,
                    .references(SchemaName.flowContainer, .id, onDelete: .cascade, onUpdate: .cascade)
                )
                .create()
        }
        
        public func revert(on database: Database) async throws {
            try await database.schema(SchemaName.flowNode)
                .delete()
        }
    }
}
