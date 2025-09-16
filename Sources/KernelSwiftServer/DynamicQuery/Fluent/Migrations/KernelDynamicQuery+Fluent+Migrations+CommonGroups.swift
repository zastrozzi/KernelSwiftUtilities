//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 02/02/2025.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelDynamicQuery.Fluent.Migrations {
    public static let columnIdentifiers = SchemaBuilder.GroupedFieldBuilder
        .field("schema", .string, .required)
        .field("table", .string, .required)
        .field("field", .string, .required)
        .create()
    
    public static let tableIdentifiers = SchemaBuilder.GroupedFieldBuilder
        .field("schema", .string, .required)
        .field("table", .string, .required)
        .create()
}
