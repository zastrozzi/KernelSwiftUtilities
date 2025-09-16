//
//  File.swift
//
//
//  Created by Jonathan Forbes on 1/5/24.
//

import KernelSwiftCommon
import Vapor

extension KernelWebFront.Model.Flows {
    public struct UpdateFlowContinuationRequest: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public var condition: String?
        public var childNodeId: UUID
        
        public init(
            condition: String? = nil,
            childNodeId: UUID
        ) {
            self.condition = condition
            self.childNodeId = childNodeId
        }
    }
}

extension KernelWebFront.Model.Flows.UpdateFlowContinuationRequest {
    public static var sample: KernelWebFront.Model.Flows.UpdateFlowContinuationRequest {
        .init(condition: "FALSE", childNodeId: .zero)
    }
}
