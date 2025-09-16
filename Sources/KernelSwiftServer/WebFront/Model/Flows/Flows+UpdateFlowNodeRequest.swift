//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 4/5/24.
//

import KernelSwiftCommon
import Vapor

extension KernelWebFront.Model.Flows {
    public struct UpdateFlowNodeRequest: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public var header: String?
        public var headline: String?
        public var subheadline: String?
        public var body: String?
        
        public init(
            header: String? = nil,
            headline: String? = nil,
            subheadline: String? = nil,
            body: String? = nil
        ) {
            self.header = header
            self.headline = headline
            self.subheadline = subheadline
            self.body = body
        }
    }
}

extension KernelWebFront.Model.Flows.UpdateFlowNodeRequest {
    public static var sample: KernelWebFront.Model.Flows.UpdateFlowNodeRequest {
        .init(header: "Updated Header", headline: "Updated Headline", subheadline: "Updated Subheadline", body: "Updated Body")
    }
}
