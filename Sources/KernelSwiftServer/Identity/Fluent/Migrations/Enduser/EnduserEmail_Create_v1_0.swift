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
    public struct EnduserEmail_Create_v1_0: AsyncMigration {
        public func prepare(on database: any Database) async throws {
            try await database.schema(SchemaName.enduserEmail)
                .id()
                .timestamps()
                .field("email_address_value", .string, .required)
                .field("is_verified", .bool, .required)
                .field("enduser_id", .uuid, .required,
                    .references(SchemaName.enduser, .id, onDelete: .cascade, onUpdate: .cascade)
                )
                .create()
        }
        
        public func revert(on database: any Database) async throws {
            try await database.schema(SchemaName.enduserEmail)
                .delete()
        }
    }
}
