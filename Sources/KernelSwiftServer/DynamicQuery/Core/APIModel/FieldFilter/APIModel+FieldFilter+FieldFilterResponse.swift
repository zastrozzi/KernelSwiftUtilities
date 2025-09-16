//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 01/02/2025.
//

import Vapor
import KernelSwiftCommon

extension KernelDynamicQuery.Core.APIModel.FieldFilter {
    public struct FieldFilterResponse: OpenAPIContent {
        public var id: UUID
        
        public var dbCreatedAt: Date
        public var dbUpdatedAt: Date
        public var dbDeletedAt: Date?
        
        public var leftColumn: KernelDynamicQuery.Core.APIModel.ColumnIdentifiers
        public var rightColumn: KernelDynamicQuery.Core.APIModel.ColumnIdentifiers
        public var filterMethod: KernelDynamicQuery.Core.APIModel.FilterMethod
        
        public var structuredQueryId: UUID
        public var parentGroupId: UUID?
        
        public init(
            id: UUID,
            dbCreatedAt: Date,
            dbUpdatedAt: Date,
            dbDeletedAt: Date? = nil,
            leftColumn: KernelDynamicQuery.Core.APIModel.ColumnIdentifiers,
            rightColumn: KernelDynamicQuery.Core.APIModel.ColumnIdentifiers,
            filterMethod: KernelDynamicQuery.Core.APIModel.FilterMethod,
            structuredQueryId: UUID,
            parentGroupId: UUID? = nil
        ) {
            self.id = id
            self.dbCreatedAt = dbCreatedAt
            self.dbUpdatedAt = dbUpdatedAt
            self.dbDeletedAt = dbDeletedAt
            self.leftColumn = leftColumn
            self.rightColumn = rightColumn
            self.filterMethod = filterMethod
            self.structuredQueryId = structuredQueryId
            self.parentGroupId = parentGroupId
        }
    }
}
