//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 20/09/2024.
//

import Vapor
import Fluent

extension KernelIdentity.Fluent.Migrations {
    public struct ExternalUserCredential_Create_v1_0: AsyncMigration {
        public func prepare(on database: any Database) async throws {
            try await database.schema(SchemaName.externalUserCredential)
                .id()
                .timestamps()
                .field("credential_type", .enum(KernelIdentity.Core.Model.CredentialType.toFluentEnum()), .required)
                .field("oidc_user_identifier", .string)
                .field("password_hash", .string)
                .field("is_valid", .bool, .required)
                .field("ext_user_id", .uuid, .required,
                    .references(SchemaName.externalUser, .id, onDelete: .cascade, onUpdate: .cascade)
                )
                .create()
        }
        
        public func revert(on database: any Database) async throws {
            try await database.schema(SchemaName.externalUserCredential)
                .delete()
        }
    }
}

