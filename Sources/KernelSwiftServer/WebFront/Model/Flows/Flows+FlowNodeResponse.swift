//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 4/5/24.
//

import KernelSwiftCommon
import Vapor

extension KernelWebFront.Model.Flows {
    public struct FlowNodeResponse: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public var id: UUID
        
        public var dbCreatedAt: Date
        public var dbUpdatedAt: Date
        public var dbDeletedAt: Date?
        
        public var header: String
        public var headline: String
        public var subheadline: String
        public var body: String
        public var containerId: UUID
        public var continuations: [FlowContinuationResponse]
        
        public init(
            id: UUID,
            dbCreatedAt: Date,
            dbUpdatedAt: Date,
            dbDeletedAt: Date? = nil,
            header: String,
            headline: String,
            subheadline: String,
            body: String,
            containerId: UUID,
            continuations: [FlowContinuationResponse]
        ) {
            self.id = id
            self.dbCreatedAt = dbCreatedAt
            self.dbUpdatedAt = dbUpdatedAt
            self.dbDeletedAt = dbDeletedAt
            self.header = header
            self.headline = headline
            self.subheadline = subheadline
            self.body = body
            self.containerId = containerId
            self.continuations = continuations
        }
    }
}
