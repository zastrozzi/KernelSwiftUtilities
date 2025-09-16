//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 06/07/2023.
//

import Vapor
import Fluent
import KernelSwiftCommon

extension KernelX509.Fluent.Model {
    public final class Certificate: KernelFluentNamespacedModel, @unchecked Sendable {
        public static let namespacedSchema = SchemaName.certificate
        
        @ID(key: .id) public var id: UUID?
        @Timestamp(key: "db_created_at", on: .create) public var dbCreatedAt: Date?
        @Timestamp(key: "db_updated_at", on: .update) public var dbUpdatedAt: Date?
        @Timestamp(key: "db_deleted_at", on: .delete) public var dbDeletedAt: Date?
        @Group(key: "tbs_cert") public var tbsCert: TBSCertificate
        @Group(key: "signature_alg") public var signatureAlgorithm: KernelCryptography.Fluent.Model.AlgorithmIdentifier
        @ASN1Field(key: "signature") public var signature: KernelASN1.ASN1BitString
        
        
        
        public init() {}
        
        public typealias CreateDTO = KernelX509.Certificate
        
        public static func createFields(
            from dto: CreateDTO
        ) throws -> Self {
            let model = self.init()
            model.tbsCert.version = dto.version.rawValue
            model.tbsCert.serialNumber = dto.serialNumber.rawValue
            model.tbsCert.signatureAlgorithm = .createFields(from: dto.signatureAlgorithm)
            model.tbsCert.issuer = .createFields(from: dto.issuer)
            model.tbsCert.validity = .createFields(from: dto.validity)
            model.tbsCert.subject = .createFields(from: dto.subject)
            model.tbsCert.subjectPublicKeyInfo = .createFields(from: dto.subjectPublicKeyInfo)
            model.tbsCert.extensions = dto.extensions
            model.signatureAlgorithm = .createFields(from: dto.signatureAlgorithm)
            model.signature = try .init(from: dto.keySignature.signatureBitString())
//            model.$publicKey.id = nil
            return model
        }
    }
}


extension KernelX509.Fluent.Model.Certificate {
    public final class TBSCertificate: Fields, @unchecked Sendable {
        @Field(key: "version") public var version: Int
        @BigIntField(key: "serial_number") public var serialNumber: KernelNumerics.BigInt
        @Group(key: "signature_alg") public var signatureAlgorithm: KernelCryptography.Fluent.Model.AlgorithmIdentifier
        @Group(key: "issuer") public var issuer: KernelX509.Fluent.Model.DistinguishedName
        @Group(key: "validity") public var validity: KernelX509.Fluent.Model.Validity
        @Group(key: "subject") public var subject: KernelX509.Fluent.Model.DistinguishedName
        @Group(key: "subject_pki") public var subjectPublicKeyInfo: KernelX509.Fluent.Model.PublicKeyFields
        @OptionalASN1Field(key: "extensions") public var extensions: KernelX509.ExtensionSet?
        
        public init() {}
    }
}
