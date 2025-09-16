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
    public struct AdminUser_Create_v1_0: AsyncMigration {
        public func prepare(on database: any Database) async throws {
            try await database.schema(SchemaName.adminUser)
                .id()
                .timestamps()
                .field("first_name", .string, .required)
                .field("last_name", .string, .required)
                .field("role", .string, .required)
                .create()
        }
        
        public func revert(on database: any Database) async throws {
            try await database.schema(SchemaName.adminUser)
                .delete()
        }
    }
}
