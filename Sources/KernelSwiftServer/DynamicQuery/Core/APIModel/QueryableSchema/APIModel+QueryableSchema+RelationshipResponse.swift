//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 10/02/2025.
//

import KernelSwiftCommon
import Vapor

extension KernelDynamicQuery.Core.APIModel.QueryableSchema {
    public struct RelationshipResponse: OpenAPIContent, DynamicPropertyAccessible {
        public var id: UUID
        public var relationshipType: RelationshipType
        public var isOptional: Bool
        public var fromColumn: KernelDynamicQuery.Core.APIModel.ColumnIdentifiers
        public var toColumn: KernelDynamicQuery.Core.APIModel.ColumnIdentifiers
        public var joinFromColumn: KernelDynamicQuery.Core.APIModel.ColumnIdentifiers?
        public var joinToColumn: KernelDynamicQuery.Core.APIModel.ColumnIdentifiers?
        public var fromTableId: UUID
        public var fromColumnId: UUID
        public var toTableId: UUID
        public var toColumnId: UUID
        public var joinTableId: UUID?
        public var joinFromColumnId: UUID?
        public var joinToColumnId: UUID?
        
        public init(
            relationshipType: RelationshipType,
            isOptional: Bool,
            fromColumn: KernelDynamicQuery.Core.APIModel.ColumnIdentifiers,
            toColumn: KernelDynamicQuery.Core.APIModel.ColumnIdentifiers,
            joinFromColumn: KernelDynamicQuery.Core.APIModel.ColumnIdentifiers? = nil,
            joinToColumn: KernelDynamicQuery.Core.APIModel.ColumnIdentifiers? = nil
        ) {
            self.relationshipType = relationshipType
            self.isOptional = isOptional
            self.fromColumn = fromColumn
            self.toColumn = toColumn
            self.fromTableId = fromColumn.tableIdentifiers().uuidHash()
            self.fromColumnId = fromColumn.uuidHash()
            self.toTableId = toColumn.tableIdentifiers().uuidHash()
            self.toColumnId = toColumn.uuidHash()
            self.joinFromColumn = joinFromColumn
            self.joinToColumn = joinToColumn
            self.joinTableId = joinFromColumn?.tableIdentifiers().uuidHash()
            self.joinFromColumnId = joinFromColumn?.uuidHash()
            self.joinToColumnId = joinToColumn?.uuidHash()
            var idBytes: [UInt8] = []

            if let joinFromColumn, let joinToColumn {
                idBytes.append(contentsOf: joinFromColumn.bytesToHash())
                idBytes.append(contentsOf: joinToColumn.bytesToHash())
            }
            idBytes.append(contentsOf: fromColumn.bytesToHash())
            idBytes.append(contentsOf: toColumn.bytesToHash())
            self.id = .uuidHash(bytes: idBytes)
        }
        
        public init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer = try decoder.container(keyedBy: DatabaseCodingKeys.self)
            let referencingTableSchema = try container.decode(String.self, forKey: .referencingTableSchema)
            let referencingTableName = try container.decode(String.self, forKey: .referencingTableName)
            let referencingColumnName = try container.decode(String.self, forKey: .referencingColumnName)
            let isNullableRaw = try container.decode(String.self, forKey: .referencingColumnIsNullable)
            
            let referencedTableSchema = try container.decode(String.self, forKey: .referencedTableSchema)
            let referencedTableName = try container.decode(String.self, forKey: .referencedTableName)
            let referencedColumnName = try container.decode(String.self, forKey: .referencedColumnName)
            self.isOptional = isNullableRaw == "YES"
            self.relationshipType = .manyToOne
            self.fromColumn = .init(
                schema: referencingTableSchema,
                table: referencingTableName,
                field: referencingColumnName
            )
            self.toColumn = .init(
                schema: referencedTableSchema,
                table: referencedTableName,
                field: referencedColumnName
            )
            self.fromTableId = self.fromColumn.tableIdentifiers().uuidHash()
            self.fromColumnId = self.fromColumn.uuidHash()
            self.toTableId = self.toColumn.tableIdentifiers().uuidHash()
            self.toColumnId = self.toColumn.uuidHash()
            self.id = .uuidHash(bytes: self.fromColumn.bytesToHash() + self.toColumn.bytesToHash())
        }
        
        enum DatabaseCodingKeys: String, CodingKey {
            case referencingTableSchema = "referencing_table_schema"
            case referencingTableName = "referencing_table_name"
            case referencingColumnName = "referencing_column_name"
            case referencingColumnIsNullable = "referencing_column_is_nullable"
            case referencedTableSchema = "referenced_table_schema"
            case referencedTableName = "referenced_table_name"
            case referencedColumnName = "referenced_column_name"
        }
        
        public func makeCompanion() -> RelationshipResponse {
            let companionRelationshipType: RelationshipType = switch relationshipType {
            case .manyToOne: .oneToMany
            case .oneToMany: .manyToOne
            case .oneToOne: .oneToOne
            case .manyToMany: .manyToMany
            }
            
            let companionIsOptional = switch companionRelationshipType {
            case .manyToMany, .oneToMany: false
            case .oneToOne, .manyToOne: isOptional
            }
            
            return .init(
                relationshipType: companionRelationshipType,
                isOptional: companionIsOptional,
                fromColumn: toColumn,
                toColumn: fromColumn,
                joinFromColumn: joinToColumn,
                joinToColumn: joinFromColumn
            )
        }
    }
}

