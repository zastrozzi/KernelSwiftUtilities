//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 02/02/2025.
//

import Vapor
import KernelSwiftCommon

extension KernelDynamicQuery.Core.APIModel {
    public struct ColumnIdentifiers: OpenAPIContent, UUIDHashable, CustomStringConvertible, DynamicPropertyAccessible {
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
        
        public static var sample: Self {
            .init(
                schema: "k_id",
                table: "enduser",
                field: "first_name"
            )
        }
        
        public func bytesToHash() -> [UInt8] {
            schema.utf8Bytes + table.utf8Bytes + field.utf8Bytes
        }
        
        public func tableIdentifiers() -> TableIdentifiers {
            .init(schema: schema, table: table)
        }
        
        public var description: String {
            schema + "." + table + "." + field
        }
    }
}
// 5117288734983185000
