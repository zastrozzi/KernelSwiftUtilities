//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 11/11/2023.
//

import Vapor
import Fluent

extension KernelCryptography.Fluent.Model {
    
    public final class PKCS8EncryptionSet: KernelFluentNamespacedModel, @unchecked Sendable {
        public static let namespacedSchema = SchemaName.pkcs8EncryptionSet
        
        @ID(key: .id) public var id: UUID?
        @Timestamp(key: "db_created_at", on: .create) public var dbCreatedAt: Date?
        @Timestamp(key: "db_updated_at", on: .update) public var dbUpdatedAt: Date?
        @Timestamp(key: "db_deleted_at", on: .delete) public var dbDeletedAt: Date?
        
        
        
        
        @OptionalParent(key: "ec_set_id") public var ecSet: ECSet?
        @OptionalParent(key: "rsa_set_id") public var rsaSet: RSASet?
        
        public init() {}
    }
}

