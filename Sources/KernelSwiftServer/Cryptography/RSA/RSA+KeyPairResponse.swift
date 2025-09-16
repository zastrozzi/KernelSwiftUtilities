//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 05/10/2023.
//

import Foundation
import Vapor
import KernelSwiftCommon

extension KernelCryptography.RSA {
    public struct KeyPairResponse: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public var id: UUID
        public var subjectKeyId: String
        public var jwksKeyId: String
        public var x509tKeyId: String
        public var dbCreatedAt: Date?
        public var dbUpdatedAt: Date?
        public var dbDeletedAt: Date?
        
        public var keySize: KeySize
        public var n: String
        public var e: String
        public var d: String
        public var p: String
        public var q: String
        
        public init(
            id: UUID,
            subjectKeyId: String,
            jwksKeyId: String,
            x509tKeyId: String,
            dbCreatedAt: Date,
            dbUpdatedAt: Date,
            dbDeletedAt: Date? = nil,
            keySize: KeySize,
            n: String,
            e: String,
            d: String,
            p: String,
            q: String
        ) {
            self.id = id
            self.subjectKeyId = subjectKeyId
            self.jwksKeyId = jwksKeyId
            self.x509tKeyId = x509tKeyId
            self.dbCreatedAt = dbCreatedAt
            self.dbUpdatedAt = dbUpdatedAt
            self.dbDeletedAt = dbDeletedAt
            self.keySize = keySize
            self.n = n
            self.e = e
            self.d = d
            self.p = p
            self.q = q
        }
    }

}
