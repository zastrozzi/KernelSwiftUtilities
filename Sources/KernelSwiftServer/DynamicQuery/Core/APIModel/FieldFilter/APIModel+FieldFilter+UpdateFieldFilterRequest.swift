//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 01/02/2025.
//

import Vapor
import KernelSwiftCommon

extension KernelDynamicQuery.Core.APIModel.FieldFilter {
    public struct UpdateFieldFilterRequest: OpenAPIContent {
        public var leftColumn: KernelDynamicQuery.Core.APIModel.ColumnIdentifiers?
        public var rightColumn: KernelDynamicQuery.Core.APIModel.ColumnIdentifiers?
        public var filterMethod: KernelDynamicQuery.Core.APIModel.FilterMethod?
        
        public init(
            leftColumn: KernelDynamicQuery.Core.APIModel.ColumnIdentifiers? = nil,
            rightColumn: KernelDynamicQuery.Core.APIModel.ColumnIdentifiers? = nil,
            filterMethod: KernelDynamicQuery.Core.APIModel.FilterMethod? = nil
        ) {
            self.leftColumn = leftColumn
            self.rightColumn = rightColumn
            self.filterMethod = filterMethod
        }
    }
}
