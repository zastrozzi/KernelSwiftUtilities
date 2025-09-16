//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 14/06/2023.
//

import FluentKit
import KernelSwiftCommon

public protocol KernelFluentSchemaName: RawRepresentableAsString, Codable, Equatable, CaseIterable {}

extension KernelFluentSchemaName {
    public var forFluent: String { self.rawValue }
}

extension Database {
    public func schema<S: KernelFluentSchemaName>(_ schemaName: S, space: String? = nil) -> SchemaBuilder {
        return schema(schemaName.forFluent, space: space)
    }
}

extension DatabaseSchema.FieldConstraint {
    public static func references<S: KernelFluentSchemaName>(
        _ schema: S,
        space: String? = nil,
        _ field: FieldKey,
        onDelete: DatabaseSchema.ForeignKeyAction = .noAction,
        onUpdate: DatabaseSchema.ForeignKeyAction = .noAction
    ) -> Self {
        .foreignKey(
            schema.forFluent,
            space: space,
            .key(field),
            onDelete: onDelete,
            onUpdate: onUpdate
        )
    }
}

extension Schema {
    public static var _spaceIfNotAliased: String? {
        return self.alias == nil ? self.space : nil
    }
}
