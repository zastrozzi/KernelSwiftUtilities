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
    public struct AdminUserCredential_Create_v1_0: AsyncMigration {
        public func prepare(on database: any Database) async throws {
            try await database.schema(SchemaName.adminUserCredential)
                .id()
                .timestamps()
                .field("credential_type", .enum(KernelIdentity.Core.Model.CredentialType.toFluentEnum()), .required)
                .field("oidc_user_identifier", .string)
                .field("password_hash", .string)
                .field("admin_user_id", .uuid, .required,
                    .references(SchemaName.adminUser, .id, onDelete: .cascade, onUpdate: .cascade)
                )
                .create()
        }
        
        public func revert(on database: any Database) async throws {
            try await database.schema(SchemaName.adminUserCredential)
                .delete()
        }
    }
    
    public struct AdminUserCredential_Update_v1_1: AsyncMigration {
        public func prepare(on database: any Database) async throws {
            try await database.schema(SchemaName.adminUserCredential)
                .field("is_valid", .bool, .required)
                .update()
        }
        
        public func revert(on database: any Database) async throws {
            try await database.schema(SchemaName.adminUserCredential)
                .deleteField("is_valid")
                .update()
        }
    }
}
