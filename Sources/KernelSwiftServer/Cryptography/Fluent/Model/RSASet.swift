//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 03/07/2023.
//

import Vapor
import Fluent

extension KernelCryptography.Fluent.Model {
    
    public final class RSASet: KernelFluentNamespacedModel, @unchecked Sendable {
        public static let namespacedSchema = SchemaName.rsaSet
        //        public var auditDate: Date? = nil
        //        public var auditCreatedAt: Date? { self.dbCreatedAt }
        
        @ID(key: .id) public var id: UUID?
        @Timestamp(key: "db_created_at", on: .create) public var dbCreatedAt: Date?
        @Timestamp(key: "db_updated_at", on: .update) public var dbUpdatedAt: Date?
        @Timestamp(key: "db_deleted_at", on: .delete) public var dbDeletedAt: Date?
        
        @KernelEnum(key: "key_size") public var keySize: KernelCryptography.RSA.KeySize
        @Field(key: "n") public var n: String
        @Field(key: "e") public var e: String
        @Field(key: "d") public var d: String
        @Field(key: "p") public var p: String
        @Field(key: "q") public var q: String
        @Field(key: "skid_hex") public var skidHex: String
        @Field(key: "jwks_kid") public var jwksKid: String
        @Field(key: "x509t_kid") public var x509tKid: String
        
        public init() {}
        
        public enum CodingKeys: CodingKey, CaseIterable, Hashable {
            case id
            case dbCreatedAt
            case dbUpdatedAt
            case dbDeletedAt
            case keySize
            case n
            case e
            case d
            case p
            case q
            case skidHex
            case jwksKid
            case x509tKid
        }
    }
}

extension KernelCryptography.Fluent.Model.RSASet: CRUDModel {
    public typealias CreateDTO = KernelCryptography.RSA.Components
    public typealias UpdateDTO = KernelCryptography.RSA.Components
    public typealias ResponseDTO = KernelCryptography.RSA.Components
    public struct CreateOptions: Sendable {
        public var providedId: UUID
        
        public init(providedId: UUID) {
            self.providedId = providedId
        }
    }
    public typealias UpdateOptions = KernelFluentModel.EmptyUpdateOptions
    public typealias ResponseOptions = KernelFluentModel.EmptyResponseOptions
    
    public static func createFields(
        from dto: CreateDTO,
        withOptions options: CreateOptions? = nil
    ) throws -> Self {
        let model = self.init()
        model.id = options?.providedId
        model.keySize = dto.keySize
        model.n = dto.n.toString()
        model.d = dto.d.toString()
        model.e = dto.e.toString()
        model.p = dto.p.toString()
        model.q = dto.q.toString()
        model.skidHex = dto.skidString(hashMode: .sha1pkcs1DerHex)
        model.jwksKid = dto.jwksKidString(hashMode: .sha1ThumbBase64Url)
        model.x509tKid = dto.skidString(hashMode: .sha1X509DerB64)
        return model
    }
    
    public static func updateFields(
        for model: SelfModel,
        from dto: UpdateDTO,
        withOptions options: UpdateOptions? = nil
    ) throws {
        model.keySize = dto.keySize
        model.n = dto.n.toString()
        model.d = dto.d.toString()
        model.e = dto.e.toString()
        model.p = dto.p.toString()
        model.q = dto.q.toString()
        model.skidHex = dto.skidString(hashMode: .sha1pkcs1DerHex)
        model.jwksKid = dto.jwksKidString(hashMode: .sha1ThumbBase64Url)
        model.x509tKid = dto.skidString(hashMode: .sha1X509DerB64)
    }
    
    public func response(
        withOptions options: ResponseOptions? = nil
    ) throws -> KernelCryptography.RSA.Components {
        return .init(
            n: .init(n, radix: 10)!,
            e: .init(e, radix: 10)!,
            d: .init(d, radix: 10)!,
            p: .init(p, radix: 10)!,
            q: .init(q, radix: 10)!,
            keySize: keySize
        )
    }
    
    public func toRSAKeyPairResponse() -> KernelCryptography.RSA.KeyPairResponse {
        return .init(
            id: id!,
            subjectKeyId: skidHex,
            jwksKeyId: jwksKid,
            x509tKeyId: x509tKid,
            dbCreatedAt: dbCreatedAt!,
            dbUpdatedAt: dbUpdatedAt!,
            dbDeletedAt: dbDeletedAt,
            keySize: keySize,
            n: n,
            e: e,
            d: d,
            p: p,
            q: q
        )
    }
}
