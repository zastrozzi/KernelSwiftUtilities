//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 4/5/24.
//

import KernelSwiftCommon
import Vapor

extension KernelIdentity.Core.Model {
    public struct AdminUserActionResponse: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public var id: UUID
        
        public var dbCreatedAt: Date
        public var dbUpdatedAt: Date
        public var dbDeletedAt: Date?
        
        public var type: LoggableAdminUserActionType
        public var props: [String: String]?
        public var sessionId: UUID
        
        public init(
            id: UUID,
            dbCreatedAt: Date,
            dbUpdatedAt: Date,
            dbDeletedAt: Date? = nil,
            type: LoggableAdminUserActionType,
            props: [String : String]? = nil,
            sessionId: UUID
        ) {
            self.id = id
            self.dbCreatedAt = dbCreatedAt
            self.dbUpdatedAt = dbUpdatedAt
            self.dbDeletedAt = dbDeletedAt
            self.type = type
            self.props = props
            self.sessionId = sessionId
        }
    }
}
