//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 07/12/2023.
//

import Vapor
import Fluent
import FluentPostgresDriver
import KernelSwiftCommon

extension KernelCryptography.Fluent.Migrations {
    public struct PrivateKey_Create_v1_0: AsyncMigration {
        public func prepare(on database: Database) async throws {
            try await database.schema(SchemaName.privateKey)
                .id()
                .timestamps()
                .group("kid") {
                    .field("hex", .string)
                    .field("jwks", .string)
                    .field("x509t", .string)
                }
                .optionalGroup("rsa") {
                    .field("key_size", .enum(KernelCryptography.RSA.KeySize.toFluentEnum()), .required)
                    .field("n", .data, .required)
                    .field("e", .data, .required)
                    .field("d", .data, .required)
                    .field("p", .data, .required)
                    .field("q", .data, .required)
                    .field("dp", .data, .required)
                    .field("dq", .data, .required)
                }
                .optionalGroup("ec") {
                    .field("domain_oid", .enum(KernelSwiftCommon.ObjectID.toFluentEnum()), .required)
                    .field("x", .data, .required)
                    .field("y", .data, .required)
                }
                .create()
        }
        
        public func revert(on database: Database) async throws {
            try await database.schema(SchemaName.privateKey)
                .delete()
        }
    }
}

