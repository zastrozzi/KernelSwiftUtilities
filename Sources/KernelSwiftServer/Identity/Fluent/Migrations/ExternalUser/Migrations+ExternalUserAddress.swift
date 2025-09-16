//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 20/09/2024.
//

import Vapor
import Fluent

extension KernelIdentity.Fluent.Migrations {
    public struct ExternalUserAddress_Create_v1_0: AsyncMigration {
        public func prepare(on database: Database) async throws {
            try await database.schema(SchemaName.externalUserAddress)
                .id()
                .timestamps()
                .field("name", .string)
                .field("refinement", .string)
                .field("number", .string)
                .field("street", .string)
                .field("city", .string)
                .field("region", .string)
                .field("postal_code", .string)
                .field("country", .enum(ISO3166CountryAlpha2Code.toFluentEnum()), .required)
                .field("lat", .double)
                .field("lon", .double)
                .field("ext_user_id", .uuid, .required,
                    .references(SchemaName.externalUser, .id, onDelete: .cascade, onUpdate: .cascade)
                )
                .create()
        }
        
        public func revert(on database: Database) async throws {
            try await database.schema(SchemaName.externalUserAddress)
                .delete()
        }
    }
}
