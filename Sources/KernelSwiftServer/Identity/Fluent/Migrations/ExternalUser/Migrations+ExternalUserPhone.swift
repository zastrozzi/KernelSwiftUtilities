//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 20/09/2024.
//

import Vapor
import Fluent

extension KernelIdentity.Fluent.Migrations {
    public struct ExternalUserPhone_Create_v1_0: AsyncMigration {
        public func prepare(on database: any Database) async throws {
            try await database.schema(SchemaName.externalUserPhone)
                .id()
                .timestamps()
                .field("phone_number_value", .string, .required)
                .field("is_whatsapp", .bool, .required)
                .field("is_sms", .bool, .required)
                .field("is_voice", .bool, .required)
                .field("is_whatsapp_verified", .bool, .required)
                .field("is_sms_verified", .bool, .required)
                .field("is_voice_verified", .bool, .required)
                .field("preferred_contact_method", .enum(KernelIdentity.Core.Model.PhoneContactMethod.toFluentEnum()), .required)
                .field("ext_user_id", .uuid, .required,
                    .references(SchemaName.externalUser, .id, onDelete: .cascade, onUpdate: .cascade)
                )
                .create()
        }
        
        public func revert(on database: any Database) async throws {
            try await database.schema(SchemaName.externalUserPhone)
                .delete()
        }
    }
}
