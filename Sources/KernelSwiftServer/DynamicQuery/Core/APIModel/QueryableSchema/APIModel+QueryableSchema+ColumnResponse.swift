//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 11/02/2025.
//

import KernelSwiftCommon
import Vapor

extension KernelDynamicQuery.Core.APIModel.QueryableSchema {
    public struct ColumnResponse: OpenAPIContent {
        public var id: UUID
        public var columnIdentifiers: KernelDynamicQuery.Core.APIModel.ColumnIdentifiers
        public var ordinalPosition: Int32
        public var isNullable: Bool
        public var isCustom: Bool
        public var isArray: Bool
        public var isPrimaryKey: Bool
        public var isForeignKey: Bool
        public var isUnique: Bool
        public var dataType: ColumnDataType
        public var customDataType: String?
        public var tableId: UUID
        
        public init(
            columnIdentifiers: KernelDynamicQuery.Core.APIModel.ColumnIdentifiers,
            ordinalPosition: Int32,
            isNullable: Bool,
            isCustom: Bool,
            isArray: Bool,
            isPrimaryKey: Bool,
            isForeignKey: Bool,
            isUnique: Bool,
            dataType: ColumnDataType,
            customDataType: String? = nil,
            tableId: UUID
        ) {
            self.id = columnIdentifiers.uuidHash()
            self.columnIdentifiers = columnIdentifiers
            self.ordinalPosition = ordinalPosition
            self.isNullable = isNullable
            self.isCustom = isCustom
            self.isArray = isArray
            self.isPrimaryKey = isPrimaryKey
            self.isForeignKey = isForeignKey
            self.isUnique = isUnique
            self.dataType = dataType
            self.customDataType = customDataType
            self.tableId = tableId
        }
        
        public init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer = try decoder.container(keyedBy: DatabaseCodingKeys.self)
            let tableSchema = try container.decode(String.self, forKey: .tableSchema)
            let tableName = try container.decode(String.self, forKey: .tableName)
            let columnName = try container.decode(String.self, forKey: .columnName)
            self.columnIdentifiers = .init(schema: tableSchema, table: tableName, field: columnName)
            self.id = self.columnIdentifiers.uuidHash()
//            let isNullableRaw = try container.decode(String.self, forKey: .isNullable)
            self.ordinalPosition = try container.decode(Int32.self, forKey: .ordinalPosition)
            self.isNullable = try container.decode(Bool.self, forKey: .isNullable)
            let rawColumnType = try container.decode(RawColumnDataType.self, forKey: .udtName)
            self.isCustom = rawColumnType.isCustom
            self.isArray = rawColumnType.isArray
            self.isPrimaryKey = try container.decode(Bool.self, forKey: .isPrimaryKey)
            self.isForeignKey = try container.decode(Bool.self, forKey: .isForeignKey)
            self.isUnique = try container.decode(Bool.self, forKey: .isUnique)
            self.customDataType = rawColumnType.customDataType
            self.dataType = .init(from: rawColumnType)
            self.tableId = self.columnIdentifiers.tableIdentifiers().uuidHash()
        }
        
        enum DatabaseCodingKeys: String, CodingKey {
            case tableSchema = "table_schema"
            case tableName = "table_name"
            case columnName = "column_name"
            case ordinalPosition = "ordinal_position"
            case isNullable = "is_nullable"
            case udtName = "udt_name"
            case isPrimaryKey = "is_primary_key"
            case isForeignKey = "is_foreign_key"
            case isUnique = "is_unique"
            
        }
    }
}

// Enduser 7D7D0414-BA63-9908-E34C-BF056DE0E20C
// Audience E38668B9-2AE5-02A3-B2F4-D63E800F4EF2
// EnduserAddress -> Enduser AA063B48-B094-E85F-0D47-A00D5125163D
