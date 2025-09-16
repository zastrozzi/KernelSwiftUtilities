//
//  File.swift
//  UnionCDP
//
//  Created by Jonathan Forbes on 07/02/2025.
//

import KernelSwiftCommon
import Vapor

extension KernelSignals.Core.APIModel {
    public struct CreateEventTypeRequest: OpenAPIContent {
        public var eventIdentifier: String
        public var payloadSchema: EventPayloadSchema
        
        public init(
            eventIdentifier: String,
            payloadSchema: EventPayloadSchema
        ) {
            self.eventIdentifier = eventIdentifier
            self.payloadSchema = payloadSchema
        }
    }
}
