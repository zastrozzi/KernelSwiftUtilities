//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 04/11/2024.
//

import Vapor
import Fluent
import KernelSwiftCommon

extension Model {
    public static func resolvedPathString<Field: QueryableProperty>(for fieldKeyPath: KeyPath<Self, Field>) -> String {
        var path: String = ""
        if let space = Self._spaceIfNotAliased { path.append("\"\(space)\".") }
        path.append("\"\(Self.schemaOrAlias)\"")
        path.append(fieldPathString(for: fieldKeyPath))
        return path
    }
    
    public static func fieldPathString<Field: QueryableProperty>(for fieldKeyPath: KeyPath<Self, Field>) -> String {
        var subpath: String = ""
        for pathItem in Self.path(for: fieldKeyPath) {
            subpath.append(".\"\(pathItem.description)\"")
        }
        return subpath
    }
    
    public static func queryableProperties() -> [any Property & AnyQueryableProperty] {
        return KernelSwiftCommon.Reflection.ChildSequence(subject: Self.init()).compactMap { $1 as? any Property & AnyQueryableProperty }
    }
    
    public static func dbProperties() -> [any AnyDatabaseProperty] {
        return KernelSwiftCommon.Reflection.ChildSequence(subject: Self.init()).compactMap { $1 as? any AnyDatabaseProperty }
    }
    
//    public static var fieldProperties: [FieldProperty] {
//        return KernelSwiftCommon.Reflection.ChildSequence(subject: Self.init()).compactMap { $1 as? AnyQueryableProperty }
//    }
}

public struct ResolvedFieldPath: Sendable {
    public var schema: String
    public var table: String
    public var field: String
    
    public init(
        schema: String,
        table: String,
        field: String
    ) {
        self.schema = schema
        self.table = table
        self.field = field
    }
}
