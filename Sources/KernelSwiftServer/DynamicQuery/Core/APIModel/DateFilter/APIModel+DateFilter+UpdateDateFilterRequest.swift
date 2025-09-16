//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 01/02/2025.
//

import Vapor
import KernelSwiftCommon

extension KernelDynamicQuery.Core.APIModel.DateFilter {
    public struct UpdateDateFilterRequest: OpenAPIContent {
        public var column: KernelDynamicQuery.Core.APIModel.ColumnIdentifiers?
        public var fieldIsArray: Bool?
        public var filterMethod: KernelDynamicQuery.Core.APIModel.FilterMethod?
        public var filterValue: Date?
        public var filterArrayValue: [Date]?
        
        public init(
            column: KernelDynamicQuery.Core.APIModel.ColumnIdentifiers? = nil,
            fieldIsArray: Bool? = nil,
            filterMethod: KernelDynamicQuery.Core.APIModel.FilterMethod? = nil,
            filterValue: Date? = nil,
            filterArrayValue: [Date]? = nil
        ) {
            self.column = column
            self.fieldIsArray = fieldIsArray
            self.filterMethod = filterMethod
            self.filterValue = filterValue
            self.filterArrayValue = filterArrayValue
        }
    }
}
