//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/07/2023.
//

import Vapor
import Fluent

extension KernelX509.Fluent.Migrations {
    public struct RDNItem_Create_v1_0: AsyncMigration {
        public func prepare(on database: Database) async throws {
            try await database.schema(SchemaName.rdnItem)
                .id()
                .timestamps()
                .field("attribute_type", .enum(KernelX509.Common.RelativeDistinguishedName.AttributeType.self), .required)
                .field("attribute_value_type", .enum(KernelX509.Common.RelativeDistinguishedName.AttributeValueType.self), .required)
                .field("string_value", .string, .required)
                .field("csr_info_id", .uuid, .references(SchemaName.csrInfo, .id))
                .create()
        }
        
        public func revert(on database: Database) async throws {
            try await database.schema(SchemaName.rdnItem)
                .delete()
        }
    }
}
