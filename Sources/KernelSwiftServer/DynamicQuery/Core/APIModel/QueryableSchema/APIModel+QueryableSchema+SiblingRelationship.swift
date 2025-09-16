//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 12/02/2025.
//

import KernelSwiftCommon
import Vapor

extension KernelDynamicQuery.Core.APIModel.QueryableSchema {
    public struct SiblingRelationship: OpenAPIContent {
        public var fromColumn: KernelDynamicQuery.Core.APIModel.ColumnIdentifiers
        public var toColumn: KernelDynamicQuery.Core.APIModel.ColumnIdentifiers
        public var joinFromColumn: KernelDynamicQuery.Core.APIModel.ColumnIdentifiers
        public var joinToColumn: KernelDynamicQuery.Core.APIModel.ColumnIdentifiers
        
        public init(
            fromColumn: KernelDynamicQuery.Core.APIModel.ColumnIdentifiers,
            toColumn: KernelDynamicQuery.Core.APIModel.ColumnIdentifiers,
            joinFromColumn: KernelDynamicQuery.Core.APIModel.ColumnIdentifiers,
            joinToColumn: KernelDynamicQuery.Core.APIModel.ColumnIdentifiers
        ) {
            self.fromColumn = fromColumn
            self.toColumn = toColumn
            self.joinFromColumn = joinFromColumn
            self.joinToColumn = joinToColumn
        }
        
        public init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer = try decoder.container(keyedBy: DatabaseCodingKeys.self)
            let joinTableSchema = try container.decode(String.self, forKey: .joinTableSchema)
            let joinTableName = try container.decode(String.self, forKey: .joinTableName)
            let joinReferencingColumnName = try container.decode(String.self, forKey: .joinReferencingColumnName)
            let joinReferencedColumnName = try container.decode(String.self, forKey: .joinReferencedColumnName)
            let referencingTableSchema = try container.decode(String.self, forKey: .referencingTableSchema)
            let referencingTableName = try container.decode(String.self, forKey: .referencingTableName)
            let referencingColumnName = try container.decode(String.self, forKey: .referencingColumnName)
            let referencedTableSchema = try container.decode(String.self, forKey: .referencedTableSchema)
            let referencedTableName = try container.decode(String.self, forKey: .referencedTableName)
            let referencedColumnName = try container.decode(String.self, forKey: .referencedColumnName)
            
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
            
            self.joinFromColumn = .init(
                schema: joinTableSchema,
                table: joinTableName,
                field: joinReferencingColumnName
            )
            
            self.joinToColumn = .init(
                schema: joinTableSchema,
                table: joinTableName,
                field: joinReferencedColumnName
            )
        }
        
        enum DatabaseCodingKeys: String, CodingKey {
            case joinTableSchema = "join_table_schema"
            case joinTableName = "join_table_name"
            case joinReferencingColumnName = "join_referencing_column_name"
            case joinReferencedColumnName = "join_referenced_column_name"
            case referencingTableSchema = "referencing_table_schema"
            case referencingTableName = "referencing_table_name"
            case referencingColumnName = "referencing_column_name"
            case referencedTableSchema = "referenced_table_schema"
            case referencedTableName = "referenced_table_name"
            case referencedColumnName = "referenced_column_name"
        }
        
        public func makeRelationship() -> RelationshipResponse {
            return .init(
                relationshipType: .manyToMany,
                isOptional: false,
                fromColumn: fromColumn,
                toColumn: toColumn,
                joinFromColumn: joinFromColumn,
                joinToColumn: joinToColumn
            )
        }
    }
}
