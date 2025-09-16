//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 01/02/2025.
//

import Vapor
import KernelSwiftCommon

extension KernelDynamicQuery.Core.APIModel.StringFilter {
    public struct StringFilterResponse: OpenAPIContent {
        public var id: UUID
        
        public var dbCreatedAt: Date
        public var dbUpdatedAt: Date
        public var dbDeletedAt: Date?
        
        public var column: KernelDynamicQuery.Core.APIModel.ColumnIdentifiers
        public var fieldIsArray: Bool
        public var filterMethod: KernelDynamicQuery.Core.APIModel.FilterMethod
        public var filterValue: String?
        public var filterArrayValue: [String]?
        
        public var structuredQueryId: UUID
        public var parentGroupId: UUID?
        
        public init(
            id: UUID,
            dbCreatedAt: Date,
            dbUpdatedAt: Date,
            dbDeletedAt: Date? = nil,
            column: KernelDynamicQuery.Core.APIModel.ColumnIdentifiers,
            fieldIsArray: Bool,
            filterMethod: KernelDynamicQuery.Core.APIModel.FilterMethod,
            filterValue: String? = nil,
            filterArrayValue: [String]? = nil,
            structuredQueryId: UUID,
            parentGroupId: UUID? = nil
        ) {
            self.id = id
            self.dbCreatedAt = dbCreatedAt
            self.dbUpdatedAt = dbUpdatedAt
            self.dbDeletedAt = dbDeletedAt
            self.column = column
            self.fieldIsArray = fieldIsArray
            self.filterMethod = filterMethod
            self.filterValue = filterValue
            self.filterArrayValue = filterArrayValue
            self.structuredQueryId = structuredQueryId
            self.parentGroupId = parentGroupId
        }
    }
}
