//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 4/5/24.
//

import KernelSwiftCommon
import Vapor

extension KernelWebFront.Model.Flows {
    public struct RemoveFlowContinuationRequest: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public var childNodeId: UUID
        
        public init(
            childNodeId: UUID
        ) {
            self.childNodeId = childNodeId
        }
    }
}

extension KernelWebFront.Model.Flows.RemoveFlowContinuationRequest {
    public static var sample: KernelWebFront.Model.Flows.RemoveFlowContinuationRequest {
        .init(childNodeId: .zero)
    }
}
