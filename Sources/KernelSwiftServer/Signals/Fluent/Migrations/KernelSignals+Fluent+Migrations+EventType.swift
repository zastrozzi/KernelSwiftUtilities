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
    public struct EventType_Create_v1_0: AsyncMigration {
        public func prepare(on database: any Database) async throws {
            try await database.schema(SchemaName.eventType)
                .id()
                .timestamps()
                .field("event_identifier", .string, .required)
                .field("payload_schema", .json, .required)
                .unique(on: "event_identifier")
                .create()
        }
        
        public func revert(on database: any Database) async throws {
            try await database.schema(SchemaName.eventType).delete()
        }
    }
}
