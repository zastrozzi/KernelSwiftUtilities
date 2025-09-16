//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 01/02/2025.
//

import Vapor
import KernelSwiftCommon

extension KernelDynamicQuery.Core.APIModel.DateFilter {
    public struct CreateDateFilterRequest: OpenAPIContent {
        public var column: KernelDynamicQuery.Core.APIModel.ColumnIdentifiers
        public var fieldIsArray: Bool
        public var filterMethod: KernelDynamicQuery.Core.APIModel.FilterMethod
        public var filterValue: Date?
        public var filterArrayValue: [Date]?
        
        public init(
            column: KernelDynamicQuery.Core.APIModel.ColumnIdentifiers,
            fieldIsArray: Bool,
            filterMethod: KernelDynamicQuery.Core.APIModel.FilterMethod,
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
