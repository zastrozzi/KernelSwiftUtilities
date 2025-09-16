//
//  File.swift
//  
//
//  Created by Jimmy Hough Jr on 9/23/23.
//


import Vapor
import Fluent
import KernelSwiftCommon

extension KernelCryptography.Fluent.Model {
    public final class ECSet: KernelFluentNamespacedModel, @unchecked Sendable {
        public static let namespacedSchema = SchemaName.ecSet

        @ID(key: .id) public var id: UUID?
        @Timestamp(key: "db_created_at", on: .create) public var dbCreatedAt: Date?
        @Timestamp(key: "db_updated_at", on: .update) public var dbUpdatedAt: Date?
        @Timestamp(key: "db_deleted_at", on: .delete) public var dbDeletedAt: Date?

        @KernelEnum(key: "domain_oid") public var domainOID: KernelSwiftCommon.ObjectID
        @Field(key: "x") public var x: String
        @Field(key: "y") public var y: String
        @Field(key: "secret") public var secret: String
        
        @Field(key: "skid_hex") public var skidHex: String
        @Field(key: "jwks_kid") public var jwksKid: String
        @Field(key: "x509t_kid") public var x509tKid: String
        
        public init() {}
        
        public enum CodingKeys: CodingKey, CaseIterable, Hashable {
            case id
            case dbCreatedAt
            case dbUpdatedAt
            case dbDeletedAt
            case domainOID
            case x
            case y
            case secret
            case skid_hex
            case jwks_kid
            case x509t_kid
        }
    }
}

extension KernelCryptography.Fluent.Model.ECSet: CRUDModel {
    
    public typealias CreateDTO = KernelCryptography.EC.Components
    public typealias UpdateDTO = KernelCryptography.EC.Components
    public typealias ResponseDTO = KernelCryptography.EC.Components
    
    public typealias CreateOptions = KernelFluentModel.EmptyCreateOptions
    public typealias UpdateOptions = KernelFluentModel.EmptyUpdateOptions
    public typealias ResponseOptions = KernelFluentModel.EmptyResponseOptions
    
    // fix
    public static func createFields(
        from dto: CreateDTO,
        withOptions options: CreateOptions?
    ) throws -> Self {
        let model = self.init()
        model.x = dto.point.x.toString()
        model.y = dto.point.y.toString()
        model.secret = dto.secret.toString()
        model.domainOID = dto.domain.oid
        model.skidHex = dto.skidString(hashMode: .sha1pkcs1DerHex)
        model.jwksKid = dto.jwksKidString(hashMode: .sha1ThumbBase64Url)
        model.x509tKid = dto.skidString(hashMode: .sha1X509DerB64)
        return model
    }
    
    //fix
    public static func updateFields(
        for model: SelfModel,
        from dto: UpdateDTO,
        withOptions options: UpdateOptions?
    ) throws {
        
       
    }
    
    public func response(
        withOptions options: ResponseOptions?
    ) throws -> ResponseDTO {
        return try .init(
            oid: domainOID,
            x: .init(x, radix: 10)!,
            y: .init(y, radix: 10)!,
            secret: .init(secret, radix: 10)!
        )
    }
    
    // awaiting abstracted api
    // check that nil coalesce use
    public func toKeyPairResponse() -> KernelCryptography.EC.KeyPairResponse {
        return .init(
            id: id ?? UUID(),
            dbCreatedAt: dbCreatedAt,
            dbUpdatedAt: dbUpdatedAt,
            dbDeletedAt: dbDeletedAt,
            domainOID: .oid(domainOID),
            x: x,
            y: y,
            secret: secret,
            skidHex: skidHex,
            jwksKid: jwksKid,
            x509tKid: x509tKid
        )
    }
}
