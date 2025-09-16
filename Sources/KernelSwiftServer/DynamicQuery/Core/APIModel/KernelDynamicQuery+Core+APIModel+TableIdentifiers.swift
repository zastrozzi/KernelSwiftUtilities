//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 11/02/2025.
//

import Vapor
import KernelSwiftCommon

extension KernelDynamicQuery.Core.APIModel {
    public struct TableIdentifiers: OpenAPIContent, UUIDHashable, DynamicPropertyAccessible {
        public var schema: String
        public var table: String
        
        public init(
            schema: String,
            table: String
        ) {
            self.schema = schema
            self.table = table
        }
        
        public init<SchemaModel: KernelFluentNamespacedModel>(
            _ modelType: SchemaModel.Type
        ) {
            self.schema = SchemaModel.namespacedSchema.namespace
            self.table = SchemaModel.namespacedSchema.table
        }
        
        public static var sample: Self {
            .init(
                schema: "k_id",
                table: "enduser"
            )
        }
        
        public func bytesToHash() -> [UInt8] {
            schema.utf8Bytes + table.utf8Bytes
        }
    }
}
