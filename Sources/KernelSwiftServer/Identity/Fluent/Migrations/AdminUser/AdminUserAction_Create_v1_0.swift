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
    public struct AdminUserAction_Create_v1_0: AsyncMigration {
        public func prepare(on database: any Database) async throws {
            try await database.schema(SchemaName.adminUserAction)
                .id()
                .timestamps()
                .field("type", .enum(KernelIdentity.Core.Model.LoggableAdminUserActionType.toFluentEnum()), .required)
                .field("props", .dictionary(of: .string))
                .field(
                    "session_id", .uuid, .required,
                    .references(SchemaName.adminUserSession, .id, onDelete: .cascade, onUpdate: .cascade)
                )
                .create()
        }
        
        public func revert(on database: any Database) async throws {
            try await database.schema(SchemaName.adminUserAction)
                .delete()
        }
    }
}
