//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 1/5/24.
//

import KernelSwiftCommon
import Vapor

extension KernelWebFront.Model.Flows {
    public struct UpdateFlowContainerRequest: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public var name: String?
        public var entryNodeId: UUID?
        
        public init(
            name: String? = nil,
            entryNodeId: UUID? = nil
        ) {
            self.name = name
            self.entryNodeId = entryNodeId
        }
    }
}

extension KernelWebFront.Model.Flows.UpdateFlowContainerRequest {
    public static var sample: KernelWebFront.Model.Flows.UpdateFlowContainerRequest {
        .init(name: "Updated Flow Container", entryNodeId: .zero)
    }
}
