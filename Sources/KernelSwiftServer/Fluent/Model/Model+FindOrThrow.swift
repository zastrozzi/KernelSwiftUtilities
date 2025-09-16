//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 15/01/2025.
//

import Vapor
import Fluent

extension Model {
    public static func findOrThrow(
        _ id: Self.IDValue?,
        on database: any Database,
        error: () -> Error
    ) async throws -> Self {
        guard let result = try await self.find(id, on: database) else {
            throw error()
        }
        return result
    }
    
    public static func findOrThrow<Field: QueryableProperty>(
        _ fieldKeyPath: KeyPath<Self, Field>,
        equals value: Field.Value,
        on database: any Database,
        error: () -> Error
    ) async throws -> Self where Field.Model == Self {
        guard let result = try await self.query(on: database).filter(fieldKeyPath, .equal, value).first() else {
            throw error()
        }
        return result
    }
    
    public static func findOrThrow<Field>(
        _ field: QueryField<Self, Field>,
        on database: any Database,
        error: () -> Error
    ) async throws -> Self {
        switch field {
        case let .field(fieldKeyPath, value): try await findOrThrow(fieldKeyPath, equals: value, on: database, error: error)
        }
    }
    
    public static func findOrThrow<TrueField, FalseField>(
        _ field: ConditionalQueryField<Self, TrueField, FalseField>,
        on database: any Database,
        error: () -> Error
    ) async throws -> Self {
        switch field.condition {
        case true: try await findOrThrow(field.trueQueryField(), on: database, error: error)
        case false: try await findOrThrow(field.falseQueryField(), on: database, error: error)
        }
//        switch field {
//        case let .field(fieldKeyPath, value): try await findOrThrow(fieldKeyPath, equals: value, on: database, error: error)
//        }
    }
}
