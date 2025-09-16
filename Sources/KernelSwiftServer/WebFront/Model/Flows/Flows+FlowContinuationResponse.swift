//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 4/5/24.
//

import KernelSwiftCommon
import Vapor

extension KernelWebFront.Model.Flows {
    public struct FlowContinuationResponse: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public var dbCreatedAt: Date?
        public var dbUpdatedAt: Date?
        public var dbDeletedAt: Date?
        
        public var condition: String
        public var childNodeId: UUID
        
        public init(
            dbCreatedAt: Date? = nil,
            dbUpdatedAt: Date? = nil,
            dbDeletedAt: Date? = nil,
            condition: String,
            childNodeId: UUID
        ) {
            self.dbCreatedAt = dbCreatedAt
            self.dbUpdatedAt = dbUpdatedAt
            self.dbDeletedAt = dbDeletedAt
            self.condition = condition
            self.childNodeId = childNodeId
        }
    }
}
