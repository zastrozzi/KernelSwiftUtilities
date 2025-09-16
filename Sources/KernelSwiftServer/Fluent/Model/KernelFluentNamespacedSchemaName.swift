//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 16/06/2024.
//

import KernelSwiftCommon
import FluentKit
import SQLKit

public protocol KernelFluentNamespacedSchemaName: RawRepresentableAsString, Codable, Equatable, CaseIterable, Sendable {
    static var namespace: String { get }
}

extension KernelFluentNamespacedSchemaName {
//    public var forFluent: String { self.rawValue }
    public var table: String { self.rawValue }
    public var namespace: String { Self.namespace }
    public var namespaceResolvedTable: String { self.namespace + "." + self.table }
    public var namespaceHyphenResolvedTable: String { self.namespace + "-" + self.table }
    public typealias Migration = KernelFluentModel.NamespacedSchemaMigration<Self>
}

extension Database {   
    public func schema<S: KernelFluentNamespacedSchemaName>(_ schemaName: S) -> SchemaBuilder {
        return schema(schemaName.table, space: schemaName.namespace)
    }
}

extension DatabaseSchema.FieldConstraint {
    public static func references<S: KernelFluentNamespacedSchemaName>(
        _ schemaName: S,
        _ field: FieldKey,
        onDelete: DatabaseSchema.ForeignKeyAction = .noAction,
        onUpdate: DatabaseSchema.ForeignKeyAction = .noAction
    ) -> Self {
        .foreignKey(
            schemaName.table,
            space: schemaName.namespace,
            .key(field),
            onDelete: onDelete,
            onUpdate: onUpdate
        )
    }
}

extension SchemaBuilder {
    @discardableResult
    public func foreignKey<S: KernelFluentNamespacedSchemaName>(
        _ field: FieldKey,
        references foreignSchemaName: S,
        _ foreignField: FieldKey,
        onDelete: DatabaseSchema.ForeignKeyAction = .noAction,
        onUpdate: DatabaseSchema.ForeignKeyAction = .noAction,
        name: String? = nil
    ) -> Self {
        self.schema.createConstraints.append(.constraint(
            .foreignKey(
                [.key(field)],
                foreignSchemaName.table,
                space: foreignSchemaName.namespace,
                [.key(foreignField)],
                onDelete: onDelete,
                onUpdate: onUpdate
            ),
            name: name
        ))
        return self
    }
    
    @discardableResult
    public func foreignKey<S: KernelFluentNamespacedSchemaName>(
        _ fields: [FieldKey],
        references foreignSchemaName: S,
        _ foreignFields: [FieldKey],
        onDelete: DatabaseSchema.ForeignKeyAction = .noAction,
        onUpdate: DatabaseSchema.ForeignKeyAction = .noAction,
        name: String? = nil
    ) -> Self {
        self.schema.createConstraints.append(.constraint(
            .foreignKey(
                fields.map { .key($0) },
                foreignSchemaName.table,
                space: foreignSchemaName.namespace,
                foreignFields.map { .key($0) },
                onDelete: onDelete,
                onUpdate: onUpdate
            ),
            name: name
        ))
        return self
    }
}

extension DatabaseSchema.ConstraintAlgorithm {
    public static func foreignKey<S: KernelFluentNamespacedSchemaName>(
        _ fields: [DatabaseSchema.FieldName],
        _ schemaName: S,
        _ foreign: [DatabaseSchema.FieldName],
        onDelete: DatabaseSchema.ForeignKeyAction = .noAction,
        onUpdate: DatabaseSchema.ForeignKeyAction = .noAction
    ) -> Self {
        .foreignKey(
            fields,
            schemaName.table,
            space: schemaName.namespace,
            foreign,
            onDelete: onDelete,
            onUpdate: onUpdate
        )
    }
    
    public static func foreignKey<S: KernelFluentNamespacedSchemaName>(
        _ fields: [FieldKey],
        _ schemaName: S,
        _ foreign: [FieldKey],
        onDelete: DatabaseSchema.ForeignKeyAction = .noAction,
        onUpdate: DatabaseSchema.ForeignKeyAction = .noAction
    ) -> Self {
        .foreignKey(
            fields.map { .key($0) },
            schemaName.table,
            space: schemaName.namespace,
            foreign.map { .key($0) },
            onDelete: onDelete,
            onUpdate: onUpdate
        )
    }
    
    public static func foreignKey<S: KernelFluentNamespacedSchemaName>(
        _ field: DatabaseSchema.FieldName,
        _ schemaName: S,
        _ foreign: DatabaseSchema.FieldName,
        onDelete: DatabaseSchema.ForeignKeyAction = .noAction,
        onUpdate: DatabaseSchema.ForeignKeyAction = .noAction
    ) -> Self {
        .foreignKey(
            [field],
            schemaName.table,
            space: schemaName.namespace,
            [foreign],
            onDelete: onDelete,
            onUpdate: onUpdate
        )
    }
    
    public static func foreignKey<S: KernelFluentNamespacedSchemaName>(
        _ field: FieldKey,
        _ schemaName: S,
        _ foreign: FieldKey,
        onDelete: DatabaseSchema.ForeignKeyAction = .noAction,
        onUpdate: DatabaseSchema.ForeignKeyAction = .noAction
    ) -> Self {
        .foreignKey(
            [field],
            schemaName,
            [foreign],
            onDelete: onDelete,
            onUpdate: onUpdate
        )
    }
}

extension KernelFluentModel {
    public struct NamespacedSchemaMigration<S: KernelFluentNamespacedSchemaName>: AsyncMigration {
        public init() {}
        
        public func prepare(on database: Database) async throws {
            try await (database as! SQLDatabase)
                .raw("CREATE SCHEMA IF NOT EXISTS \(unsafeRaw: S.namespace)")
                .run()
        }
        
        public func revert(on database: Database) async throws {
            try await (database as! SQLDatabase)
                .raw("DROP SCHEMA IF EXISTS \(unsafeRaw: S.namespace)")
                .run()
        }
    }
}
