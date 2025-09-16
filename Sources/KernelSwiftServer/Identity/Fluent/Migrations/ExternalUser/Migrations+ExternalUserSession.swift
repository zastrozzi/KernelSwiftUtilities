//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 20/09/2024.
//

import Vapor
import Fluent

extension KernelIdentity.Fluent.Migrations {
    public struct ExternalUserSession_Create_v1_0: AsyncMigration {
        public func prepare(on database: any Database) async throws {
            try await database.schema(SchemaName.externalUserSession)
                .id()
                .timestamps()
                .field("is_active", .bool, .required)
                .field("ext_user_id", .uuid, .required,
                    .references(SchemaName.externalUser, .id, onDelete: .cascade, onUpdate: .cascade)
                )
                .field("device_id", .uuid, .required,
                    .references(SchemaName.externalUserDevice, .id, onDelete: .cascade, onUpdate: .cascade)
                )
                .create()
        }
        
        public func revert(on database: any Database) async throws {
            try await database.schema(SchemaName.externalUserSession)
                .delete()
        }
    }
}
