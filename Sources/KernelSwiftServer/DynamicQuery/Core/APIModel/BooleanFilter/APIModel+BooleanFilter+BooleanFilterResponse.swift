//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 01/02/2025.
//

import Vapor
import KernelSwiftCommon

extension KernelDynamicQuery.Core.APIModel.BooleanFilter {
    public struct BooleanFilterResponse: OpenAPIContent {
        public var id: UUID
        
        public var dbCreatedAt: Date
        public var dbUpdatedAt: Date
        public var dbDeletedAt: Date?
        
        public var column: KernelDynamicQuery.Core.APIModel.ColumnIdentifiers
        public var filterValue: Bool
        
        public var structuredQueryId: UUID
        public var parentGroupId: UUID?
        
        public init(
            id: UUID,
            dbCreatedAt: Date,
            dbUpdatedAt: Date,
            dbDeletedAt: Date? = nil,
            column: KernelDynamicQuery.Core.APIModel.ColumnIdentifiers,
            filterValue: Bool,
            structuredQueryId: UUID,
            parentGroupId: UUID? = nil
        ) {
            self.id = id
            self.dbCreatedAt = dbCreatedAt
            self.dbUpdatedAt = dbUpdatedAt
            self.dbDeletedAt = dbDeletedAt
            self.column = column
            self.filterValue = filterValue
            self.structuredQueryId = structuredQueryId
            self.parentGroupId = parentGroupId
        }
    }
}
