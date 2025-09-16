//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 19/06/2024.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelIdentity.Fluent.Migrations {
    public struct EnduserAddress_Create_v1_0: AsyncMigration {
        public func prepare(on database: any Database) async throws {
            try await database.schema(SchemaName.enduserAddress)
                .id()
                .timestamps()
                .field("refinement", .string)
                .field("number", .string)
                .field("street", .string)
                .field("city", .string)
                .field("region", .string)
                .field("postal_code", .string, .required)
                .field("country", .enum(ISO3166CountryAlpha2Code.toFluentEnum()), .required)
                .field("enduser_id", .uuid, .required,
                    .references(SchemaName.enduser, .id, onDelete: .cascade, onUpdate: .cascade)
                )
                .create()
        }
        
        public func revert(on database: any Database) async throws {
            try await database.schema(SchemaName.enduserAddress)
                .delete()
        }
    }
}

