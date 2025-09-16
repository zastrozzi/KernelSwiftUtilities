//
//  File.swift
//
//
//  Created by Jonathan Forbes on 1/5/24.
//

import KernelSwiftCommon
import Vapor

extension KernelWebFront.Model.Flows {
    public struct CreateFlowContinuationRequest: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public var condition: String
        public var childNodeId: UUID
        
        public init(
            condition: String,
            childNodeId: UUID
        ) {
            self.condition = condition
            self.childNodeId = childNodeId
        }
    }
}

extension KernelWebFront.Model.Flows.CreateFlowContinuationRequest {
    public static var sample: KernelWebFront.Model.Flows.CreateFlowContinuationRequest {
        .init(condition: "TRUE", childNodeId: .zero)
    }
}
