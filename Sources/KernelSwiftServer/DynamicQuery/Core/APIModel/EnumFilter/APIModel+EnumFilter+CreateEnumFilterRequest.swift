//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 01/02/2025.
//

import Vapor
import KernelSwiftCommon

extension KernelDynamicQuery.Core.APIModel.EnumFilter {
    public struct CreateEnumFilterRequest: OpenAPIContent {
        public var column: KernelDynamicQuery.Core.APIModel.ColumnIdentifiers
        public var fieldIsArray: Bool
        public var enumName: String
        public var filterMethod: KernelDynamicQuery.Core.APIModel.FilterMethod
        public var filterValue: String?
        public var filterArrayValue: [String]?
        
        public init(
            column: KernelDynamicQuery.Core.APIModel.ColumnIdentifiers,
            fieldIsArray: Bool,
            enumName: String,
            filterMethod: KernelDynamicQuery.Core.APIModel.FilterMethod,
            filterValue: String? = nil,
            filterArrayValue: [String]? = nil
        ) {
            self.column = column
            self.fieldIsArray = fieldIsArray
            self.enumName = enumName
            self.filterMethod = filterMethod
            self.filterValue = filterValue
            self.filterArrayValue = filterArrayValue
        }
    }
}
