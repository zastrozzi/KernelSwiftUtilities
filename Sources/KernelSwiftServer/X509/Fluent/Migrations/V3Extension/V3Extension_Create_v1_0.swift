//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/07/2023.
//

import Vapor
import Fluent
import PostgresNIO

extension KernelX509.Fluent.Migrations {
    public struct V3Extension_Create_v1_0: AsyncMigration {
        public func prepare(on database: Database) async throws {
            try await database.schema(SchemaName.v3Extension)
                .id()
                .timestamps()
                .field("eid", .enum(KernelX509.Extension.ExtensionIdentifier.self), .required)
                .field("critical", .bool, .required)
//                .field("is_composite", .bool, .required)
                .field("ext_value", .data, .required)
                .field("csr_info_id", .uuid, .references(SchemaName.csrInfo, .id))
                .create()
        }
        
        public func revert(on database: Database) async throws {
            try await database.schema(SchemaName.v3Extension)
                .delete()
        }
    }
}
