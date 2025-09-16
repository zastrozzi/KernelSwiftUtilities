//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 03/07/2023.
//

import Vapor
import Fluent
import FluentPostgresDriver
import SQLKit

extension KernelCryptography.Fluent.Migrations {
    public struct RSASet_Create_v1_0: AsyncMigration {
        public func prepare(on database: Database) async throws {
            try await database.schema(SchemaName.rsaSet)
                .id()
                .timestamps()
                .field("key_size", .enum(KernelCryptography.RSA.KeySize.toFluentEnum()), .required)
                .field("n", .string, .required)
                .field("e", .string, .required)
                .field("d", .string, .required)
                .field("p", .string, .required)
                .field("q", .string, .required)
                .field("skid_hex", .string, .required)
                .field("jwks_kid", .string, .required)
                .field("x509t_kid", .string, .required)
                .create()
        }
        
        public func revert(on database: Database) async throws {
            try await database.schema(SchemaName.rsaSet)
                .delete()
        }
    }
    
    public struct RSASet_Update_v1_1: AsyncMigration {
        public func prepare(on database: Database) async throws {
            try await database.schema(SchemaName.rsaSet)
                .unique(on: "skid_hex")
                .unique(on: "jwks_kid")
                .unique(on: "x509t_kid")
                .update()
        }
        
        public func revert(on database: Database) async throws {
            try await database.schema(SchemaName.rsaSet)
                .deleteUnique(on: "skid_hex")
                .deleteUnique(on: "jwks_kid")
                .deleteUnique(on: "x509t_kid")
                .update()
        }
    }
}
