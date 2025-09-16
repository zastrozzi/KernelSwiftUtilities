//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 05/02/2025.
//

import Fluent
import Vapor

extension ParentProperty where To: CRUDModel {
    public func conditionalResponse(
        _ condition: Bool? = false,
        withOptions options: To.ResponseOptions? = nil
    ) throws -> To.ResponseDTO? {
        guard let condition, condition else { return nil }
//        guard value != nil else { throw Abort(.badRequest, reason: "Relationship not loaded") }
        return try value?.response(withOptions: options)
    }
    
    public func load(if condition: Bool? = false, on database: any Database) async throws {
        guard let condition, condition else { return }
        try await self.load(on: database)
    }
}

extension Model where Self: CRUDModel {
    @discardableResult
    public func loadParent<ParentModel: CRUDModel>(
        _ parentKeyPath: KeyPath<Self, ParentProperty<Self, ParentModel>>,
        if condition: Bool? = false,
        onDB db: @escaping DBAccessor
    ) async throws -> Self {
        guard let condition, condition else { return self }
        try await self[keyPath: parentKeyPath].load(on: db())
        return self
    }
}
