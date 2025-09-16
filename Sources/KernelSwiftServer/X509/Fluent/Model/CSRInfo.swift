//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 03/07/2023.
//

import Vapor
import Fluent
import KernelSwiftCommon

extension KernelX509.Fluent.Model {
    public final class CSRInfo: KernelFluentNamespacedModel, @unchecked Sendable {
        public static let namespacedSchema = SchemaName.csrInfo
        //        public var auditDate: Date? = nil
        //        public var auditCreatedAt: Date? { self.dbCreatedAt }
        
        @ID(key: .id) public var id: UUID?
        @Timestamp(key: "db_created_at", on: .create) public var dbCreatedAt: Date?
        @Timestamp(key: "db_updated_at", on: .update) public var dbUpdatedAt: Date?
        @Timestamp(key: "db_deleted_at", on: .delete) public var dbDeletedAt: Date?
        
        @Field(key: "version") public var version: Int
        @KernelEnum(key: "signature_alg") public var signatureAlgorithm: KernelASN1.ASN1AlgorithmIdentifier
        
        @Parent(key: "rsa_set_id") public var rsaSet: KernelCryptography.Fluent.Model.RSASet
        @Children(for: \.$csrInfo) public var rdnItems: [RDNItem]
        @Children(for: \.$csrInfo) public var extensions: [V3Extension]
        
        public init() {}
        
        public enum CodingKeys: CodingKey, CaseIterable, Hashable {
            case id
            case dbCreatedAt
            case dbUpdatedAt
            case dbDeletedAt
            case version
            case signatureAlgorithm
        }
    }
}
