//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 12/02/2025.
//

import KernelSwiftCommon
import Vapor

extension KernelDynamicQuery.Core.APIModel.QueryableSchema {
    public enum RelationshipType: String, FluentStringEnum {
        public static let fluentEnumName: String = "kdq-schema_rel_type"
        
        case manyToOne
        case oneToMany
        case oneToOne
        case manyToMany
    }
}
