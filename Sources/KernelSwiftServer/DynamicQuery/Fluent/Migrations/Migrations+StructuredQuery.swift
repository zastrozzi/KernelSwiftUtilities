//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 01/02/2025.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelDynamicQuery.Fluent.Migrations {
    public struct StructuredQuery_Create_v1_0: AsyncMigration {
        public func prepare(on database: any Database) async throws {
            
            try await database.schema(SchemaName.structuredQuery)
                .id()
                .timestamps()
                .field("name", .string, .required)
                .create()
        }
        
        public func revert(on database: any Database) async throws {
            try await database.schema(SchemaName.structuredQuery).delete()
        }
    }
}
