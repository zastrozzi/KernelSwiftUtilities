//
//  File.swift
//  
//
//  Created by Jimmy Hough Jr on 9/25/23.
//

import Vapor
import Fluent
import FluentPostgresDriver
import KernelSwiftCommon

extension KernelCryptography.Fluent.Migrations {
    public struct ECSet_Create_v1_0: AsyncMigration {
        public func prepare(on database: Database) async throws {
            try await database.schema(SchemaName.ecSet)
                .id()
                .timestamps()
        
                .field("x", .string, .required)
                .field("y", .string, .required)
                .field("secret", .string, .required)
                .field("domain_oid", .enum(KernelSwiftCommon.ObjectID.toFluentEnum()), .required)
            
                .field("skid_hex", .string, .required)
                .field("jwks_kid", .string, .required)
                .field("x509t_kid", .string, .required)
                .create()
        }
        
        public func revert(on database: Database) async throws {
            try await database.schema(SchemaName.ecSet)
                .delete()
        }
    }
}
