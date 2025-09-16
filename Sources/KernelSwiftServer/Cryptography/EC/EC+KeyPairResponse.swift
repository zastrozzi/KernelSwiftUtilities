//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/10/2023.
//

import Foundation
import Vapor
import KernelSwiftCommon

extension KernelCryptography.EC {
    public struct KeyPairResponse: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public var id: UUID
        
        public var dbCreatedAt: Date?
        public var dbUpdatedAt: Date?
        public var dbDeletedAt: Date?
        
        public var x: String
        public var y: String
        public var domainOID: KernelNumerics.EC.Curve
        public var secret: String
        public var skidHex: String
        public var jwksKid: String
        public var x509tKid: String
        
        public init(
            id: UUID,
            dbCreatedAt: Date? = nil,
            dbUpdatedAt: Date? = nil,
            dbDeletedAt: Date? = nil,
            domainOID: KernelNumerics.EC.Curve,
            x: String,
            y: String,
            secret: String,
            skidHex: String,
            jwksKid: String,
            x509tKid: String
        ) {
            self.id = id
            self.dbCreatedAt = dbCreatedAt
            self.dbUpdatedAt = dbUpdatedAt
            self.dbDeletedAt = dbDeletedAt
            self.domainOID = domainOID
            self.x = x
            self.y = y
            self.secret = secret
            self.skidHex = skidHex
            self.jwksKid = jwksKid
            self.x509tKid = x509tKid
        }
        
    }
}
