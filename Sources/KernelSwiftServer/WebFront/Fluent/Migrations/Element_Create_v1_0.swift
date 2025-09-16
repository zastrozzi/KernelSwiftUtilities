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
    public struct Element_Create_v1_0: AsyncMigration {
        public init() {}
        
        public func prepare(on database: any Database) async throws {
            try await database.schema(SchemaName.element)
                .id()
                .timestamps()
                .create()
        }
        
        public func revert(on database: any Database) async throws {
            try await database.schema(SchemaName.element)
                .delete()
        }
    }
}
