//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 01/02/2025.
//

import Vapor
import KernelSwiftCommon

extension KernelDynamicQuery.Core.APIModel.FilterGroup {
    public struct UpdateFilterGroupRequest: OpenAPIContent {
        public var relation: KernelDynamicQuery.Core.APIModel.FilterRelation?
        
        public init(
            relation: KernelDynamicQuery.Core.APIModel.FilterRelation? = nil
        ) {
            self.relation = relation
        }
    }
}
