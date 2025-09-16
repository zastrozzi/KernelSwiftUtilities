//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 01/02/2025.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelDynamicQuery.Fluent.Migrations {
    public struct NumericFilter_Create_v1_0: AsyncMigration {
        public func prepare(on database: any Database) async throws {
            try await database.schema(SchemaName.numericFilter)
                .id()
                .timestamps()
                .group("col", columnIdentifiers)
                .field("field_array", .bool, .required)
                .field("method", .enum(KernelDynamicQuery.Core.APIModel.FilterMethod.self), .required)
                .field("data_type", .enum(KernelDynamicQuery.Core.APIModel.NumericDataType.self), .required)
                .field("int8_value", .int8)
                .field("int8_array_value", .array(of: .int8))
                .field("int16_value", .int16)
                .field("int16_array_value", .array(of: .int16))
                .field("int32_value", .int32)
                .field("int32_array_value", .array(of: .int32))
                .field("int64_value", .int64)
                .field("int64_array_value", .array(of: .int64))
                .field("uint8_value", .uint8)
                .field("uint8_array_value", .array(of: .uint8))
                .field("uint16_value", .uint16)
                .field("uint16_array_value", .array(of: .uint16))
                .field("uint32_value", .uint32)
                .field("uint32_array_value", .array(of: .uint32))
                .field("uint64_value", .uint64)
                .field("uint64_array_value", .array(of: .uint64))
                .field("double_value", .double)
                .field("double_array_value", .array(of: .double))
                .field("float_value", .float)
                .field("float_array_value", .array(of: .float))
                .field("query_id", .uuid, .required, .references(SchemaName.structuredQuery, .id, onDelete: .cascade, onUpdate: .cascade))
                .field("group_id", .uuid, .references(SchemaName.filterGroup, .id, onDelete: .cascade, onUpdate: .cascade))
                .create()
        }
        
        public func revert(on database: any Database) async throws {
            try await database.schema(SchemaName.numericFilter).delete()
        }
    }
}
