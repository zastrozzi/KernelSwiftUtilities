//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 01/02/2025.
//

import Vapor
import KernelSwiftCommon

extension KernelDynamicQuery.Core.APIModel.StructuredQuery {
    public struct UpdateStructuredQueryRequest: OpenAPIContent {
        public var name: String?
        
        public init(
            name: String? = nil
        ) {
            self.name = name
        }
    }
}
