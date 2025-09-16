//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 01/02/2025.
//

import Vapor
import KernelSwiftCommon

extension KernelDynamicQuery.Core.APIModel.BooleanFilter {
    public struct UpdateBooleanFilterRequest: OpenAPIContent {
        public var column: KernelDynamicQuery.Core.APIModel.ColumnIdentifiers?
        public var filterValue: Bool?
        
        public init(
            column: KernelDynamicQuery.Core.APIModel.ColumnIdentifiers? = nil,
            filterValue: Bool? = nil
        ) {
            self.column = column
            self.filterValue = filterValue
        }
    }
}
