//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 4/5/24.
//

import KernelSwiftCommon
import Vapor

extension KernelIdentity.Core.Model {
    public struct AdminUserResponse: Codable, Equatable, Content, OpenAPIEncodableSampleable, Sendable {
        public var id: UUID
        
        public var dbCreatedAt: Date
        public var dbUpdatedAt: Date
        public var dbDeletedAt: Date?
        
        public var firstName: String
        public var lastName: String
        public var role: String
        
        public init(
            id: UUID,
            dbCreatedAt: Date,
            dbUpdatedAt: Date,
            dbDeletedAt: Date? = nil,
            firstName: String,
            lastName: String,
            role: String
        ) {
            self.id = id
            self.dbCreatedAt = dbCreatedAt
            self.dbUpdatedAt = dbUpdatedAt
            self.dbDeletedAt = dbDeletedAt
            self.firstName = firstName
            self.lastName = lastName
            self.role = role
        }
    }
}
