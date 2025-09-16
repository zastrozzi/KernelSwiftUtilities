//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 01/02/2025.
//

import Vapor
import KernelSwiftCommon

extension KernelDynamicQuery.Core.APIModel.FilterGroup {
    public struct FilterGroupResponse: OpenAPIContent {
        public var id: UUID
        
        public var dbCreatedAt: Date
        public var dbUpdatedAt: Date
        public var dbDeletedAt: Date?
        
        public var relation: KernelDynamicQuery.Core.APIModel.FilterRelation
        public var nestLevel: Int
        
        public var structuredQueryId: UUID
        public var parentGroupId: UUID?
        
        public init(
            id: UUID,
            dbCreatedAt: Date,
            dbUpdatedAt: Date,
            dbDeletedAt: Date? = nil,
            relation: KernelDynamicQuery.Core.APIModel.FilterRelation,
            nestLevel: Int,
            structuredQueryId: UUID,
            parentGroupId: UUID? = nil
        ) {
            self.id = id
            self.dbCreatedAt = dbCreatedAt
            self.dbUpdatedAt = dbUpdatedAt
            self.dbDeletedAt = dbDeletedAt
            self.relation = relation
            self.nestLevel = nestLevel
            self.structuredQueryId = structuredQueryId
            self.parentGroupId = parentGroupId
        }
    }
}
