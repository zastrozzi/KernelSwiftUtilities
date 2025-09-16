//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 01/02/2025.
//

import Vapor
import KernelSwiftCommon

extension KernelDynamicQuery.Core.APIModel.UUIDFilter {
    public struct CreateUUIDFilterRequest: OpenAPIContent {
        public var column: KernelDynamicQuery.Core.APIModel.ColumnIdentifiers
        public var fieldIsArray: Bool
        public var filterMethod: KernelDynamicQuery.Core.APIModel.FilterMethod
        public var filterValue: UUID?
        public var filterArrayValue: [UUID]?
        
        public init(
            column: KernelDynamicQuery.Core.APIModel.ColumnIdentifiers,
            fieldIsArray: Bool,
            filterMethod: KernelDynamicQuery.Core.APIModel.FilterMethod,
            filterValue: UUID? = nil,
            filterArrayValue: [UUID]? = nil
        ) {
            self.column = column
            self.fieldIsArray = fieldIsArray
            self.filterMethod = filterMethod
            self.filterValue = filterValue
            self.filterArrayValue = filterArrayValue
        }
    }
}
