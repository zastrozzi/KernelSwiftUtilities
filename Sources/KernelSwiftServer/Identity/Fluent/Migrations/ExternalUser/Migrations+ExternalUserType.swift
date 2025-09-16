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
    public struct ExternalUserType_Create_v1_0: AsyncMigration {
        public func prepare(on database: Database) async throws {
            try await database.schema(SchemaName.externalUserType)
                .id()
                .timestamps()
                .field("name", .string, .required)
                .create()
        }
        
        public func revert(on database: Database) async throws {
            try await database.schema(SchemaName.externalUserType)
                .delete()
        }
    }
}
