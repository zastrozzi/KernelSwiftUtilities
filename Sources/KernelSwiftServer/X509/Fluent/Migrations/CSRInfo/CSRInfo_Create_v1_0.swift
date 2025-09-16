//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 03/07/2023.
//

import Vapor
import Fluent
import FluentPostgresDriver
import KernelSwiftCommon

extension KernelX509.Fluent.Migrations {
    public struct CSRInfo_Create_v1_0: AsyncMigration {
        public func prepare(on database: Database) async throws {
            try await database.schema(SchemaName.csrInfo)
                .id()
                .timestamps()
                .field("version", .int, .required)
                .field("signature_alg", .enum(KernelASN1.ASN1AlgorithmIdentifier.self), .required)
                .field("rsa_set_id", .uuid, .references(KernelCryptography.Fluent.SchemaName.rsaSet, .id), .required)
                .create()
        }
        
        public func revert(on database: Database) async throws {
            try await database.schema(SchemaName.csrInfo)
                .delete()
        }
    }
}
