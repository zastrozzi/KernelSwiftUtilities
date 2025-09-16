//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 05/02/2025.
//

import KernelSwiftCommon
import Vapor
import SQLKit



extension KernelDynamicQuery.Core.APIModel {
    public enum JoinMethod: String, FluentStringEnum {
        public static let fluentEnumName: String = "kdq-join_method"
        
        case inner = "inner"
        case left = "left"
        case right = "right"
    }
}

extension KernelDynamicQuery.Core.APIModel.JoinMethod {
    public func toSQL() -> SQLJoinMethod {
        switch self {
        case .inner: .inner
        case .left: .left
        case .right: .right
        }
    }
}
