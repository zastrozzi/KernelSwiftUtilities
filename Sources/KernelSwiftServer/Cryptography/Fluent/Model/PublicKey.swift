//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 05/12/2023.
//

import Vapor
import Fluent
import KernelSwiftCommon

extension KernelCryptography.Fluent.Model {
    public final class PublicKey: KernelFluentNamespacedModel, @unchecked Sendable {
        public static let namespacedSchema = SchemaName.publicKey
        
        @ID(key: .id) public var id: UUID?
        @Timestamp(key: "db_created_at", on: .create) public var dbCreatedAt: Date?
        @Timestamp(key: "db_updated_at", on: .update) public var dbUpdatedAt: Date?
        @Timestamp(key: "db_deleted_at", on: .delete) public var dbDeletedAt: Date?
        
        @Group(key: "kid") public var keyIdentifier: KeyIdentifierFields
        @OptionalGroup(key: "rsa") public var rsa: RSAComponentFields?
        @OptionalGroup(key: "ec") public var ec: ECComponentFields?
        
        public init() {}
    }
}

extension KernelCryptography.Fluent.Model.PublicKey {
    public final class RSAComponentFields: Fields, @unchecked Sendable {
        @KernelEnum(key: "key_size") public var keySize: KernelCryptography.RSA.KeySize
        @BigIntField(key: "n") public var n: KernelNumerics.BigInt
        @BigIntField(key: "e") public var e: KernelNumerics.BigInt
        
        public init() {}
        
        public static func createFields(
            from dto: KernelCryptography.RSA.PublicKey
        ) throws -> RSAComponentFields {
            let model = self.init()
            model.keySize = dto.keySize
            model.n = dto.n
            model.e = dto.e
            return model
        }
        
        public static func updateFields(
            for model: RSAComponentFields,
            with dto: KernelCryptography.RSA.PublicKey
        ) throws {
            if model.keySize != dto.keySize { model.keySize = dto.keySize }
            if model.n != dto.n { model.n = dto.n }
            if model.e != dto.e { model.e = dto.e }
        }
    }
    
    public final class ECComponentFields: Fields, @unchecked Sendable {
        @KernelEnum(key: "domain_oid") public var domainOID: KernelSwiftCommon.ObjectID
        @BigIntField(key: "x") public var x: KernelNumerics.BigInt
        @BigIntField(key: "y") public var y: KernelNumerics.BigInt
        
        public init() {}
        
        public static func createFields(
            from dto: KernelCryptography.EC.PublicKey
        ) throws -> ECComponentFields {
            let model = self.init()
            model.domainOID = dto.domain.oid
            model.x = dto.point.x
            model.y = dto.point.y
            return model
        }
        
        public static func updateFields(
            for model: ECComponentFields,
            with dto: KernelCryptography.EC.PublicKey
        ) throws {
            if model.domainOID != dto.domain.oid { model.domainOID = dto.domain.oid }
            if model.x != dto.point.x { model.x = dto.point.x }
            if model.y != dto.point.y { model.y = dto.point.y }
        }
    }
}
