//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 03/12/2023.
//

import Vapor
import Fluent
import FluentPostgresDriver
import KernelSwiftCommon

extension KernelX509.Fluent.Migrations {
    public struct Certificate_Create_v1_0: AsyncMigration {
        public func prepare(on database: Database) async throws {
            let algorithmIdentifierSchema = SchemaBuilder.GroupedFieldBuilder
                .field("id", .enum(asn1AlgEnum), .required)
                .group("params") {
                    .field("curve", .enum(asn1ECCurveEnum))
                }
                .create()
            
            let distinguishedNameSchema = SchemaBuilder.GroupedFieldBuilder
                .field("asn1", .data)
                .field("cn", .string)
                .field("c", .string)
                .field("l", .string)
                .field("st", .string)
                .field("oi", .string)
                .field("o", .string)
                .field("ou", .string)
                .field("street", .string)
                .field("e", .string)
                .create()
            
            try await database.schema(SchemaName.certificate)
                .id()
                .timestamps()
                .group("tbs_cert") {
                    .field("version", .int, .required)
                    .field("serial_number", .data, .required)
                    .group("signature_alg", algorithmIdentifierSchema)
                    .group("issuer", distinguishedNameSchema)
                    .group("validity") {
                        .field("not_before", .datetime, .required)
                        .field("not_after", .datetime, .required)
                    }
                    .group("subject", distinguishedNameSchema)
                    .group("subject_pki") {
                        .group("alg", algorithmIdentifierSchema)
                        .field("key", .data, .required)
                        .field("db_id", .uuid, .references(KernelCryptography.Fluent.SchemaName.publicKey, "id", onDelete: .setNull, onUpdate: .setNull))
                    }
                    .field("extensions", .data)
                }
                .group("signature_alg", algorithmIdentifierSchema)
                .field("signature", .data, .required)
                .create()
        }
        
        public func revert(on database: Database) async throws {
            try await database.schema(SchemaName.certificate)
                .delete()
        }
    }
}

public struct GroupMigration_Create: AsyncMigration {
    public func prepare(on database: Database) async throws {
        try await database.schema("some_group_schema")
            .id()
            .timestamps()
            .field("root_prop1", .int, .required)
            .group("group1") {
                .field("prop1", .datetime, .required)
                .field("prop2", .datetime, .required)
                .field("prop3", .uint8, .required)
                .field("prop4", .uint8, .required)
            }
//            .group("group2") {
//                .field("prop1", .datetime, .required)
//                .field("prop2", .datetime, .required)
//                .field("prop3", .uint8, .required)
//                .field("prop4", .uint8, .required)
//                .group("level2") {
//                    .field("prop1", .datetime, .required)
//                    .field("prop2", .datetime, .required)
//                    .field("prop3", .uint8, .required)
//                    .field("prop4", .uint8, .required)
//                }
//            }
            .create()
    }
    
    public func revert(on database: Database) async throws {
        try await database.schema("some_group_schema")
            .delete()
    }
    
    public init() {}
}

public struct GroupSchemaMigration_Create: AsyncMigration {
    public func prepare(on database: Database) async throws {
        let algorithmIdentifierSchema = SchemaBuilder.GroupedFieldBuilder
            .field("id", .string, .required)
            .group("params") {
                .field("curve", .string, .required)
            }
            .create()
            
        
        try await database.schema("some_group_schema")
            .id()
            .timestamps()
            .field("rootprop1", .int, .required)
            .optionalGroup("group1") {
                .field("prop1", .datetime)
                .field("prop2", .datetime, .required)
                .group("alg", algorithmIdentifierSchema)
                .field("prop3", .string)
            }
            .group("group2") {
                .field("prop1", .datetime)
                .field("prop2", .datetime, .required)
                .field("prop3", .uint8)
                .field("prop4", .uint8, .required)
                .group("level2") {
                    .field("prop1", .datetime)
                    .field("prop2", .datetime, .required)
                    .group("level3") {
                        .field("prop1", .datetime)
                        .field("prop2", .datetime, .required)
                        .group("alg", algorithmIdentifierSchema)
                    }
                }
                .field("prop5", .datetime)
            }
            .field("rootprop2", .int, .required)
            .create()
    }
    
    public func revert(on database: Database) async throws {
        try await database.schema("some_group_schema")
            .delete()
    }
    
    public init() {}
}

let asn1AlgEnum = KernelASN1.ASN1AlgorithmIdentifier.toFluentEnum()
let asn1ECCurveEnum = KernelSwiftCommon.ObjectID.toFluentEnum()
