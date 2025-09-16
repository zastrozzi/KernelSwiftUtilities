//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/02/2025.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelSignals.Fluent.Migrations {
    public struct Event_Create_v1_0: AsyncMigration {
        public func prepare(on database: any Database) async throws {
            try await database.schema(SchemaName.event)
                .id()
                .timestamps()
                .field("event_identifier", .string, .required)
                .field("payload", .json, .required)
                .field("payload_schema", .json, .required)
                .field("event_type_id", .uuid, .required, .references(SchemaName.eventType, .id, onDelete: .cascade, onUpdate: .cascade))
                .create()
        }
        
        public func revert(on database: any Database) async throws {
            try await database.schema(SchemaName.event).delete()
        }
    }
}
