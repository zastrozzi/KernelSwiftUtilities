//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 02/02/2025.
//

import Vapor
import Fluent
import KernelSwiftCommon
import SQLKit

extension KernelDynamicQuery.Fluent.Model {
    public final class ColumnIdentifiers: KernelFluentCRUDFields, @unchecked Sendable {
        @Field(key: "schema") public var schema: String
        @Field(key: "table") public var table: String
        @Field(key: "field") public var field: String
        
        public init() {}
        
        public typealias CreateDTO = KernelDynamicQuery.Core.APIModel.ColumnIdentifiers
        public typealias UpdateDTO = KernelDynamicQuery.Core.APIModel.ColumnIdentifiers
        public typealias ResponseDTO = KernelDynamicQuery.Core.APIModel.ColumnIdentifiers
        
        public static func createFields(
            from dto: CreateDTO
        ) throws -> Self {
            let model = self.init()
            model.schema = dto.schema
            model.table = dto.table
            model.field = dto.field
            return model
        }
        
        public static func updateFields(
            for model: ColumnIdentifiers,
            from dto: UpdateDTO
        ) throws {
            try model.updateIfChanged(\.schema, from: dto.schema)
            try model.updateIfChanged(\.table, from: dto.table)
            try model.updateIfChanged(\.field, from: dto.field)
        }
        
        public func response() throws -> ResponseDTO {
            .init(
                schema: schema,
                table: table,
                field: field
            )
        }
    }
}

extension KernelDynamicQuery.Fluent.Model.ColumnIdentifiers {
    public func sqlColumn() -> SQLColumn {
        SQLColumn(SQLIdentifier(field), table: SQLQualifiedTable(table, space: schema))
    }
    
    public func sqlTable() -> SQLNamespacedTable {
        SQLNamespacedTable(table, space: schema)
    }
}
