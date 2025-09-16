//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 01/02/2025.
//

import KernelSwiftCommon
import Vapor
import SQLKit

extension KernelDynamicQuery.Core.APIModel {
    public enum FilterRelation: String, FluentStringEnum {
        public static let fluentEnumName: String = "kdq-filter_relation"
        
        case and = "and"
        case or = "or"
    }
}

extension KernelDynamicQuery.Core.APIModel.FilterRelation {
    public func toSQL() -> SQLExpression {
        switch self {
        case .and: SQLRaw(" AND ")
        case .or: SQLRaw(" OR ")
        }
    }
}
