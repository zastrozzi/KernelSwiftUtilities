//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 4/5/24.
//

import KernelSwiftCommon
import Vapor

extension KernelWebFront.Model.Flows {
    public struct CreateFlowNodeRequest: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public var header: String
        public var headline: String
        public var subheadline: String
        public var body: String
        
        public init(
            header: String,
            headline: String,
            subheadline: String,
            body: String
        ) {
            self.header = header
            self.headline = headline
            self.subheadline = subheadline
            self.body = body
        }
    }
}

extension KernelWebFront.Model.Flows.CreateFlowNodeRequest {
    public static var sample: KernelWebFront.Model.Flows.CreateFlowNodeRequest {
        .init(header: "Header", headline: "Headline", subheadline: "Subheadline", body: "Body")
    }
}
