//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 20/09/2024.
//

import Vapor
import Fluent
import KernelSwiftCommon

extension KernelIdentity.Fluent.Migrations {
    public struct ExternalUser_Create_v1_0: AsyncMigration {
        public func prepare(on database: Database) async throws {
            try await database.schema(SchemaName.externalUser)
                .id()
                .timestamps()
                .field("first_name", .string, .required)
                .field("last_name", .string, .required)
                .field("type_id", .uuid, .required, .references(SchemaName.externalUserType, .id, onDelete: .cascade, onUpdate: .cascade))
                .create()
        }
        
        public func revert(on database: Database) async throws {
            try await database.schema(SchemaName.externalUser)
                .delete()
        }
    }
}
