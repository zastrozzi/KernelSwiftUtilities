//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 17/08/2024.
//

import Vapor
import Fluent
import FluentPostgresDriver
import KernelSwiftCommon

extension KernelWebFront.Fluent.Migrations {
    public struct Site_Create_v1_0: AsyncMigration {
        public func prepare(on database: any Database) async throws {
            try await database.schema(SchemaName.site)
                .id()
                .timestamps()
                .field("name", .string, .required)
                .field("url", .string, .required)
                .field("description", .string)
                .create()
        }
        
        public func revert(on database: any Database) async throws {
            try await database.schema(SchemaName.site)
                .delete()
        }
    }
}
