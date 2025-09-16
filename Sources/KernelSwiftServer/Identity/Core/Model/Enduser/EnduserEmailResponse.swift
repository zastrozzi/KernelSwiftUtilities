//
//  File.swift
//
//
//  Created by Jonathan Forbes on 4/5/24.
//

import KernelSwiftCommon
import Vapor

extension KernelIdentity.Core.Model {
    public struct EnduserEmailResponse: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public var id: UUID
        
        public var dbCreatedAt: Date
        public var dbUpdatedAt: Date
        public var dbDeletedAt: Date?
        
        public var emailAddressValue: String
        public var isVerified: Bool
        public var enduserId: UUID
        
        public init(
            id: UUID,
            dbCreatedAt: Date,
            dbUpdatedAt: Date,
            dbDeletedAt: Date? = nil,
            emailAddressValue: String,
            isVerified: Bool,
            enduserId: UUID
        ) {
            self.id = id
            self.dbCreatedAt = dbCreatedAt
            self.dbUpdatedAt = dbUpdatedAt
            self.dbDeletedAt = dbDeletedAt
            self.emailAddressValue = emailAddressValue
            self.isVerified = isVerified
            self.enduserId = enduserId
        }
    }
}
