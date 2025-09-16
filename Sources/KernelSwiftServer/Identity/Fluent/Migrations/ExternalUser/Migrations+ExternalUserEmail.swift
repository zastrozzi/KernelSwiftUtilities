//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 20/09/2024.
//

import Vapor
import Fluent

extension KernelIdentity.Fluent.Migrations {
    public struct ExternalUserEmail_Create_v1_0: AsyncMigration {
        public func prepare(on database: any Database) async throws {
            try await database.schema(SchemaName.externalUserEmail)
                .id()
                .timestamps()
                .field("value", .string, .required)
                .field("is_verified", .bool, .required)
                .field("ext_user_id", .uuid, .required,
                    .references(SchemaName.externalUser, .id, onDelete: .cascade, onUpdate: .cascade)
                )
                .create()
        }
        
        public func revert(on database: any Database) async throws {
            try await database.schema(SchemaName.externalUserEmail)
                .delete()
        }
    }
}
