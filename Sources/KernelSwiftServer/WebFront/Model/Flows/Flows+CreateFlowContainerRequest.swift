//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 1/5/24.
//

import KernelSwiftCommon
import Vapor

extension KernelWebFront.Model.Flows {
    public struct CreateFlowContainerRequest: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public var name: String
        
        public init(
            name: String
        ) {
            self.name = name
        }
    }
}

extension KernelWebFront.Model.Flows.CreateFlowContainerRequest {
    public static var sample: KernelWebFront.Model.Flows.CreateFlowContainerRequest {
        .init(name: "New Flow Container")
    }
}
