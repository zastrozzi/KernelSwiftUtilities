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
    public enum FilterMethod: String, FluentStringEnum {
        public static let fluentEnumName: String = "kdq-filter_method"
        
        case equal = "equal"
        case notEqual = "notEqual"
        case greaterThan = "greaterThan"
        case greaterThanOrEqual = "greaterThanOrEqual"
        case lessThan = "lessThan"
        case lessThanOrEqual = "lessThanOrEqual"
        case contains = "contains"
        case notContains = "notContains"
        case startsWith = "startsWith"
        case notStartsWith = "notStartsWith"
        case endsWith = "endsWith"
        case notEndsWith = "notEndsWith"
        case subset = "subset"
        case notSubset = "notSubset"
    }
}

extension KernelDynamicQuery.Core.APIModel.FilterMethod {
//    public static func makeSQLExpression(
//        column: SQLColumn,
//        fieldIsArray: Bool,
//        filterMethod: KernelDynamicQuery.Core.APIModel.FilterMethod,
//        filterValue: KernelDynamicQuery.Core.APIModel.FilterValue
//    ) throws -> SQLExpression {
//        var sqlOperator: SQLExpression
//        var sqlValue: SQLExpression
//        
//        if fieldIsArray {
//            switch filterMethod {
//            case .equal:
//                sqlOperator = SQLBinaryOperator.equal
//            case .notEqual:
//                sqlOperator = SQLBinaryOperator.notEqual
//                
//            }
//        }
//        
//        switch filterValue {
//        case let .boolean(boolean):
//            guard !fieldIsArray else { throw KernelDynamicQuery.TypedError(.invalidFilterOperator) }
//            guard case .equal = filterMethod else {
//                throw KernelDynamicQuery.TypedError(.invalidFilterOperator)
//            }
//            sqlOperator = SQLBinaryOperator.equal
//            sqlValue = SQLLiteral.boolean(boolean)
//        case let .date(date):
//            
//        }
//        return SQLBinaryExpression(
//            left: column,
//            op: sqlOperator,
//            right: sqlValue
//        )
//    }
    
    public func sqlOperator(lhsArray: Bool, rhsArray: Bool) throws -> SQLExpression {
        switch (lhsArray, rhsArray) {
            case (false, false): try self.lhsSingleRhsSingleOperator()
            case (true, false): try self.lhsArrayRhsSingleOperator()
            case (false, true): try self.lhsSingleRhsArrayOperator()
            case (true, true): try self.lhsArrayRhsArrayOperator()
        }
    }
    
    public func lhsSingleRhsSingleOperator() throws -> SQLBinaryOperator {
        switch self {
        case .equal: .equal
        case .notEqual: .notEqual
        case .greaterThan: .greaterThan
        case .greaterThanOrEqual: .greaterThanOrEqual
        case .lessThan: .lessThan
        case .lessThanOrEqual: .lessThanOrEqual
        case .contains: .like
        case .notContains: .notLike
        case .startsWith: .like
        case .notStartsWith: .notLike
        case .endsWith: .like
        case .notEndsWith: .notLike
        case .subset: .in
        case .notSubset: .notIn
        }
    }
    
    public func lhsArrayRhsArrayOperator() throws -> SQLExpression {
        switch self {
        case .equal: SQLBinaryOperator.equal
        case .notEqual: SQLBinaryOperator.notEqual
        case .contains: SQLRaw("@>")
        case .notContains: SQLRaw("@>")
        case .subset: SQLRaw("<@")
        case .notSubset: SQLRaw("<@")
        default: throw KernelDynamicQuery.TypedError(.invalidFilterOperator)
        }
    }
    
    public func lhsArrayRhsSingleOperator() throws -> SQLExpression {
        switch self {
        case .equal: SQLBinaryOperator.equal
        case .notEqual: SQLBinaryOperator.notEqual
        case .contains: SQLRaw("@>")
        case .notContains: SQLRaw("@>")
        case .subset: SQLRaw("<@")
        case .notSubset: SQLRaw("<@")
        default: throw KernelDynamicQuery.TypedError(.invalidFilterOperator)
        }
    }
    
    public func lhsSingleRhsArrayOperator() throws -> SQLExpression {
        switch self {
        case .subset: SQLBinaryOperator.in
        case .notSubset: SQLBinaryOperator.notIn
        default: throw KernelDynamicQuery.TypedError(.invalidFilterOperator)
        }
    }
    
    
    
//    public var isArrayOperable: Bool {
//        switch self {
//        case    .equal,
//                .notEqual,
//                .subset,
//                .notSubset
//            : true
//        case    .greaterThan,
//                .greaterThanOrEqual,
//                .lessThan,
//                .lessThanOrEqual,
//                .contains,
//                .notContains,
//                .startsWith,
//                .notStartsWith,
//        }
//    }
}
