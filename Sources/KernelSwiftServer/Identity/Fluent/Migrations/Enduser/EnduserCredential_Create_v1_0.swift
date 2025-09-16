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
    public struct EnduserCredential_Create_v1_0: AsyncMigration {
        public func prepare(on database: any Database) async throws {
            try await database.schema(SchemaName.enduserCredential)
                .id()
                .timestamps()
                .field("credential_type", .enum(KernelIdentity.Core.Model.CredentialType.toFluentEnum()), .required)
                .field("oidc_user_identifier", .string)
                .field("password_hash", .string)
                .field("enduser_id", .uuid, .required,
                    .references(SchemaName.enduser, .id, onDelete: .cascade, onUpdate: .cascade)
                )
                .create()
        }
        
        public func revert(on database: any Database) async throws {
            try await database.schema(SchemaName.enduserCredential)
                .delete()
        }
    }
    
    public struct EnduserCredential_Update_v1_1: AsyncMigration {
        public func prepare(on database: any Database) async throws {
            try await database.schema(SchemaName.enduserCredential)
                .field("is_valid", .bool, .required)
                .update()
        }
        
        public func revert(on database: any Database) async throws {
            try await database.schema(SchemaName.enduserCredential)
                .deleteField("is_valid")
                .update()
        }
    }
}
