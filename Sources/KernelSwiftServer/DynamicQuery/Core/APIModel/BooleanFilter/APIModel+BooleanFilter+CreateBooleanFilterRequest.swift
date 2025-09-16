//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 01/02/2025.
//

import Vapor
import KernelSwiftCommon

extension KernelDynamicQuery.Core.APIModel.BooleanFilter {
    public struct CreateBooleanFilterRequest: OpenAPIContent {
        public var column: KernelDynamicQuery.Core.APIModel.ColumnIdentifiers
        public var filterValue: Bool
        
        public init(
            column: KernelDynamicQuery.Core.APIModel.ColumnIdentifiers,
            filterValue: Bool
        ) {
            self.column = column
            self.filterValue = filterValue
        }
    }
}
