//
//  File.swift
//
//
//  Created by Jonathan Forbes on 30/4/24.
//

import Vapor
import Fluent
import FluentPostgresDriver
import KernelSwiftCommon

extension KernelIdentity.Fluent.Migrations {
    public struct EnduserDevice_Create_v1_0: AsyncMigration {
        public func prepare(on database: any Database) async throws {
            try await database.schema(SchemaName.enduserDevice)
                .id()
                .timestamps()
                .field("user_agent", .string, .required)
                .field("system", .enum(KernelIdentity.Core.Model.DeviceSystem.toFluentEnum()), .required)
                .field("os_version", .string)
                .field("apns_push_token", .string)
                .field("fcm_push_token", .string)
                .field("channels", .string)
                .field("local_device_identifier", .string)
                .field("last_seen_at", .datetime, .required)
                .field("enduser_id", .uuid, .required,
                    .references(SchemaName.enduser, .id, onDelete: .cascade, onUpdate: .cascade)
                )
                .create()
        }
        
        public func revert(on database: any Database) async throws {
            try await database.schema(SchemaName.enduserDevice)
                .delete()
        }
    }
}
