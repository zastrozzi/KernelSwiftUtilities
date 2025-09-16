//
//  File.swift
//
//
//  Created by Jonathan Forbes on 4/5/24.
//

import KernelSwiftCommon
import Vapor

extension KernelIdentity.Core.Model {
    public struct EnduserSessionResponse: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public var id: UUID
        
        public var dbCreatedAt: Date
        public var dbUpdatedAt: Date
        public var dbDeletedAt: Date?
        
        public var isActive: Bool
        public var enduserId: UUID
        public var deviceId: UUID
        
        public init(
            id: UUID,
            dbCreatedAt: Date,
            dbUpdatedAt: Date,
            dbDeletedAt: Date? = nil,
            isActive: Bool,
            enduserId: UUID,
            deviceId: UUID
        ) {
            self.id = id
            self.dbCreatedAt = dbCreatedAt
            self.dbUpdatedAt = dbUpdatedAt
            self.dbDeletedAt = dbDeletedAt
            self.isActive = isActive
            self.enduserId = enduserId
            self.deviceId = deviceId
        }
    }
}
