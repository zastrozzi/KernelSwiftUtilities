//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 01/05/2023.
//

import Foundation
import Vapor
import Fluent
import NIOConcurrencyHelpers
import KernelSwiftCommon

public protocol CRUDModel: Model, AuditableModel {
    associatedtype CreateDTO: Sendable = KernelSwiftCommon.Networking.HTTP.EmptyRequest
    associatedtype UpdateDTO: Sendable = KernelSwiftCommon.Networking.HTTP.EmptyRequest
    associatedtype ResponseDTO: Sendable = KernelSwiftCommon.Networking.HTTP.EmptyResponse
    associatedtype CreateOptions: Sendable = KernelFluentModel.EmptyCreateOptions
    associatedtype UpdateOptions: Sendable = KernelFluentModel.EmptyUpdateOptions
    associatedtype ResponseOptions: Sendable = KernelFluentModel.EmptyResponseOptions
    
    typealias DBAccessor = @Sendable () -> (Database)
    
    typealias SelfModel = Self
    
    typealias UpsertOptions = (create: CreateOptions?, update: UpdateOptions?)
    typealias OperationError = _CRUDOperationError<Self>
    typealias OperationOrder = _CRUDOperationOrder
    
    static func createFields(from dto: CreateDTO, withOptions options: CreateOptions?) throws -> Self
    static func updateFields(for model: SelfModel, from dto: UpdateDTO, withOptions options: UpdateOptions?) throws -> Void
    static func updateFromOptions(for model: SelfModel, options: UpdateOptions) throws -> Void
    
    static func createFields(
        onDB db: @escaping DBAccessor,
        from dto: CreateDTO,
        withAudit: Bool,
        as platformActor: KernelIdentity.Core.Model.PlatformActor?,
        withOptions options: CreateOptions?
    ) async throws -> Self
    
    static func updateFields(
        onDB db: @escaping DBAccessor,
        for model: SelfModel,
        from dto: UpdateDTO,
        withAudit: Bool,
        as platformActor: KernelIdentity.Core.Model.PlatformActor?,
        withOptions options: UpdateOptions?
    ) async throws -> Void
    
    static func updateFromOptions(
        onDB db: @escaping DBAccessor,
        for model: SelfModel,
        options: UpdateOptions,
        withAudit: Bool,
        as platformActor: KernelIdentity.Core.Model.PlatformActor?
    ) async throws -> Void
    
    func response(onDB db: @escaping DBAccessor, withOptions options: ResponseOptions?) async throws -> ResponseDTO
    func response(withOptions options: ResponseOptions?) throws -> ResponseDTO
}

extension CRUDModel {
    public static func createFields(from dto: CreateDTO, withOptions options: CreateOptions? = nil) throws -> Self {
        throw Abort(.notImplemented, reason: "createFields(from:withOptions:) not implemented for \(Self.self)")
    }
    public static func updateFields(for model: SelfModel, from dto: UpdateDTO, withOptions options: UpdateOptions? = nil) throws -> Void {
        throw Abort(.notImplemented, reason: "updateFields(for:from:withOptions:) not implemented for \(Self.self)")
    }
    public static func updateFromOptions(for model: SelfModel, options: UpdateOptions) throws {
        throw Abort(.notImplemented, reason: "updateFromOptions(for:options:) not implemented for \(Self.self)")
    }
    
    public func response(withOptions options: ResponseOptions? = nil) throws -> ResponseDTO {
        throw Abort(.notImplemented, reason: "response(withOptions:) not implemented for \(Self.self)")
    }
    
    public func response(onDB db: @escaping DBAccessor, withOptions options: ResponseOptions? = nil) async throws -> ResponseDTO {
        try response(withOptions: options)
    }
    
    public static func createFields(
        onDB db: @escaping DBAccessor,
        from dto: CreateDTO,
        withAudit: Bool,
        as platformActor: KernelIdentity.Core.Model.PlatformActor? = nil,
        withOptions options: CreateOptions? = nil
    ) async throws -> Self {
        try createFields(from: dto, withOptions: options)
    }
    
    public static func updateFields(
        onDB db: @escaping DBAccessor,
        for model: SelfModel,
        from dto: UpdateDTO,
        withAudit: Bool,
        as platformActor: KernelIdentity.Core.Model.PlatformActor? = nil,
        withOptions options: UpdateOptions? = nil
    ) async throws -> Void {
        try updateFields(for: model, from: dto, withOptions: options)
    }
    
    public static func updateFromOptions(
        onDB db: @escaping DBAccessor,
        for model: SelfModel,
        options: UpdateOptions,
        withAudit: Bool,
        as platformActor: KernelIdentity.Core.Model.PlatformActor? = nil
    ) async throws -> Void {
        try updateFromOptions(for: model, options: options)
    }
    
    public func updateIfChanged<Field: Equatable>(
        _ modelKeyPath: ReferenceWritableKeyPath<Self, Field>,
        from dtoValue: Field?
    ) throws {
        if let dtoValue, self[keyPath: modelKeyPath] != dtoValue {
            self[keyPath: modelKeyPath] = dtoValue
        }
    }
    
    public func updateIfChanged<Field: Equatable>(
        _ modelKeyPath: ReferenceWritableKeyPath<Self, Field?>,
        from dtoValue: Field?
    ) throws {
        if let dtoValue, self[keyPath: modelKeyPath] != dtoValue {
            self[keyPath: modelKeyPath] = dtoValue
        }
    }
    
    public func update<Field: Equatable>(
        _ modelKeyPath: ReferenceWritableKeyPath<Self, Field>,
        from dtoValue: Field?
    ) throws {
        if let dtoValue {
            self[keyPath: modelKeyPath] = dtoValue
        }
    }
    
    public static func makeQuery(on database: any Database) -> () -> QueryBuilder<Self> {
        return {
            Self.query(on: database)
        }
    }
}

extension CRUDModel {
    @discardableResult
    public static func create(
        from dto: CreateDTO,
        onDB db: @escaping DBAccessor,
        withAudit: Bool,
        as platformActor: KernelIdentity.Core.Model.PlatformActor? = nil,
        withOptions options: CreateOptions? = nil
    ) async throws -> Self {
        let model = try await createFields(onDB: db, from: dto, withAudit: withAudit, as: platformActor, withOptions: options)
        if withAudit {
            guard let platformActor else { throw Abort(.badRequest, reason: "No platform actor provided for audit") }
            try await model.createWithAudit(as: platformActor, onDB: db)
        }
        else { try await model.create(on: db()) }
        return model
    }
    
    @discardableResult
    public static func create(
        onDB db: @escaping DBAccessor,
        withAudit: Bool,
        as platformActor: KernelIdentity.Core.Model.PlatformActor? = nil,
        withOptions options: CreateOptions? = nil
    ) async throws -> Self where CreateDTO == KernelSwiftCommon.Networking.HTTP.EmptyRequest {
        let model = try await createFields(onDB: db, from: .init(), withAudit: withAudit, as: platformActor, withOptions: options)
        if withAudit {
            guard let platformActor else { throw Abort(.badRequest, reason: "No platform actor provided for audit") }
            try await model.createWithAudit(as: platformActor, onDB: db)
        }
        else { try await model.create(on: db()) }
        return model
    }
    
    @discardableResult
    public static func create(
        from dtos: [CreateDTO],
        onDB db: @escaping DBAccessor,
        withAudit: Bool,
        as platformActor: KernelIdentity.Core.Model.PlatformActor? = nil,
        withOptions options: CreateOptions? = nil
    ) async throws -> [Self] {
        let models = try await dtos.asyncMap { try await createFields(onDB: db, from: $0, withAudit: withAudit, as: platformActor, withOptions: options) }
        if withAudit {
            guard let platformActor else { throw Abort(.badRequest, reason: "No platform actor provided for audit") }
            try await models.createWithAudit(as: platformActor, onDB: db)
        }
        else { try await models.create(on: db()) }
        return models
    }
    
    @discardableResult
    public static func update(
        id: IDValue,
        from dto: UpdateDTO,
        onDB db: @escaping DBAccessor,
        withAudit: Bool,
        as platformActor: KernelIdentity.Core.Model.PlatformActor? = nil,
        withOptions options: UpdateOptions? = nil
    ) async throws -> Self {
        guard let model = try await find(id, on: db()) else { throw FluentError.noResults }
        try await updateFields(onDB: db, for: model, from: dto, withAudit: withAudit, as: platformActor, withOptions: options)
        if withAudit {
            guard let platformActor else { throw Abort(.badRequest, reason: "No platform actor provided for audit") }
            try await model.updateWithAudit(as: platformActor, onDB: db)
        }
        else { try await model.update(on: db()) }
        return model
    }
    
    @discardableResult
    public static func update(
        id: IDValue,
        onDB db: @escaping DBAccessor,
        withAudit: Bool,
        as platformActor: KernelIdentity.Core.Model.PlatformActor? = nil,
        fromOptions options: UpdateOptions
    ) async throws -> Self {
        guard let model = try await find(id, on: db()) else { throw FluentError.noResults }
        try await updateFromOptions(onDB: db, for: model, options: options, withAudit: withAudit, as: platformActor)
        if withAudit {
            guard let platformActor else { throw Abort(.badRequest, reason: "No platform actor provided for audit") }
            try await model.updateWithAudit(as: platformActor, onDB: db)
        }
        else { try await model.update(on: db()) }
        return model
    }
    
    @discardableResult
    public static func update(
        from dto: UpdateDTO,
        onDB db: @escaping DBAccessor,
        withAudit: Bool,
        as platformActor: KernelIdentity.Core.Model.PlatformActor? = nil,
        withOptions options: UpdateOptions? = nil
    ) async throws -> Self where UpdateDTO: Identifiable {
        guard let id = dto.id as? Self.IDValue, let model = try await find(id, on: db()) else { throw FluentError.noResults }
        try await updateFields(onDB: db, for: model, from: dto, withAudit: withAudit, as: platformActor, withOptions: options)
        if withAudit {
            guard let platformActor else { throw Abort(.badRequest, reason: "No platform actor provided for audit") }
            try await model.updateWithAudit(as: platformActor, onDB: db)
        }
        else { try await model.update(on: db()) }
        return model
    }
    
    @discardableResult
    public static func update(
        from dtos: [UpdateDTO],
        onDB db: @escaping DBAccessor,
        withAudit: Bool,
        as platformActor: KernelIdentity.Core.Model.PlatformActor? = nil,
        withOptions options: UpdateOptions? = nil
    ) async throws -> [Self] where UpdateDTO: Identifiable {
        return try await dtos.asyncMap {
            try await Self.update(
                from: $0,
                onDB: db,
                withAudit: withAudit,
                as: platformActor,
                withOptions: options
            )
        }
    }
    
    @discardableResult
    public static func update(
        from dtoIdPairs: [(id: IDValue, dto: UpdateDTO)],
        onDB db: @escaping DBAccessor,
        withAudit: Bool,
        as platformActor: KernelIdentity.Core.Model.PlatformActor? = nil,
        withOptions options: UpdateOptions? = nil
    ) async throws -> [Self] {
        let models = try await query(on: db()).filter(\._$id ~~ dtoIdPairs.map { $0.id }).all()
        try await models.concurrentForEach { model in
            if let dtoForModel = dtoIdPairs.first(where: { pair in pair.id == model.id }) {
                try await updateFields(onDB: db, for: model, from: dtoForModel.dto, withAudit: withAudit, as: platformActor, withOptions: options)
                if withAudit {
                    guard let platformActor else { throw Abort(.badRequest, reason: "No platform actor provided for audit") }
                    try await model.updateWithAudit(as: platformActor, onDB: db)
                }
                else { try await model.update(on: db()) }
                
            }
        }
        return models
    }
    
    @discardableResult
    public static func upsert(
        id: IDValue,
        from dto: UpdateDTO,
        onDB db: @escaping DBAccessor,
        withAudit: Bool,
        as platformActor: KernelIdentity.Core.Model.PlatformActor? = nil,
        withOptions options: UpsertOptions? = nil
    ) async throws -> Self where UpdateDTO == CreateDTO {
        if let model = try await find(id, on: db()) {
            try await updateFields(onDB: db, for: model, from: dto, withAudit: withAudit, as: platformActor, withOptions: options?.update)
            if withAudit {
                guard let platformActor else { throw Abort(.badRequest, reason: "No platform actor provided for audit") }
                try await model.updateWithAudit(as: platformActor, onDB: db)
            }
            else { try await model.update(on: db()) }
            return model
        } else {
            let createdModel = try await createFields(onDB: db, from: dto, withAudit: withAudit, as: platformActor, withOptions: options?.create)
            if withAudit {
                guard let platformActor else { throw Abort(.badRequest, reason: "No platform actor provided for audit") }
                try await createdModel.createWithAudit(as: platformActor, onDB: db)
            }
            else { try await createdModel.create(on: db()) }
            return createdModel
        }
    }
    
    @discardableResult
    public static func upsert(
        from dto: UpdateDTO,
        onDB db: @escaping DBAccessor,
        withAudit: Bool,
        as platformActor: KernelIdentity.Core.Model.PlatformActor? = nil,
        withOptions options: UpsertOptions? = nil
    ) async throws -> Self where UpdateDTO: Identifiable, UpdateDTO == CreateDTO {
        guard let id = dto.id as? Self.IDValue else { throw FluentError.idRequired }
        return try await upsert(id: id, from: dto, onDB: db, withAudit: withAudit, as: platformActor, withOptions: options)
    }
    
    @discardableResult
    public static func upsert(
        from dtos: [UpdateDTO],
        onDB db: @escaping DBAccessor,
        withAudit: Bool,
        as platformActor: KernelIdentity.Core.Model.PlatformActor? = nil,
        withOptions options: UpsertOptions? = nil
    ) async throws -> [Self] where UpdateDTO: Identifiable, UpdateDTO == CreateDTO {
        let updateModels: [Self] = try await query(on: db()).filter(\._$id ~~ dtos.compactMap { $0.id as? IDValue }).all()
        let updateModelIds = updateModels.map { $0.id }
        let createModels: [Self] = try await dtos.filter { dto in
            guard !updateModelIds.isEmpty else { return true }
            guard let dtoId = dto.id as? IDValue else { return false }
            guard !updateModelIds.contains(dtoId) else { return false }
            return true
        }.asyncMap { try await createFields(onDB: db, from: $0, withAudit: withAudit, as: platformActor, withOptions: options?.create) }
        if !createModels.isEmpty {
            if withAudit {
                guard let platformActor else { throw Abort(.badRequest, reason: "No platform actor provided for audit") }
                try await createModels.concurrentForEach { model in try await model.createWithAudit(as: platformActor, onDB: db) }
            }
            else { try await createModels.create(on: db()) }
        }
        if !updateModels.isEmpty {
            try await updateModels.concurrentForEach { updateModel in
                if let updateDto = dtos.first(where: { dto in
                    (dto.id as? IDValue) == updateModel.id
                }) {
                    try await updateFields(onDB: db, for: updateModel, from: updateDto, withAudit: withAudit, as: platformActor, withOptions: options?.update)
                }
                if withAudit {
                    guard let platformActor else { throw Abort(.badRequest, reason: "No platform actor provided for audit") }
                    try await updateModel.updateWithAudit(as: platformActor, onDB: db)
                }
                else { try await updateModel.update(on: db()) }
            }
        }
        return [createModels, updateModels].flatMap { $0 }
    }
    
    @discardableResult
    public static func upsert(
        from dtoIdPairs: [(id: IDValue, dto: UpdateDTO)],
        onDB db: @escaping DBAccessor,
        withAudit: Bool,
        as platformActor: KernelIdentity.Core.Model.PlatformActor? = nil,
        withOptions options: UpsertOptions? = nil
    ) async throws -> [Self] where UpdateDTO == CreateDTO {
        let updateModels: [Self] = try await query(on: db()).filter(\._$id ~~ dtoIdPairs.compactMap { $0.id }).all()
        let updateModelIds = updateModels.map { $0.id }
        let createModels: [Self] = try await dtoIdPairs.filter { dtoIdPair in
            guard !updateModelIds.isEmpty else { return true }
            guard !updateModelIds.contains(dtoIdPair.id) else { return false }
            return true
        }.asyncMap { return try await createFields(onDB: db, from: $0.dto, withAudit: withAudit, as: platformActor, withOptions: options?.create) }
        if !createModels.isEmpty {
            if withAudit {
                guard let platformActor else { throw Abort(.badRequest, reason: "No platform actor provided for audit") }
                try await createModels.concurrentForEach { model in try await model.createWithAudit(as: platformActor, onDB: db) }
            }
            else { try await createModels.create(on: db()) }
        }
        if !updateModels.isEmpty {
            try await updateModels.concurrentForEach { updateModel in
                if let updateDtoIdPair = dtoIdPairs.first(where: { dtoIdPair in
                    dtoIdPair.id == updateModel.id
                }) {
                    try await updateFields(onDB: db, for: updateModel, from: updateDtoIdPair.dto, withAudit: withAudit, as: platformActor, withOptions: options?.update)
                    if withAudit {
                        guard let platformActor else { throw Abort(.badRequest, reason: "No platform actor provided for audit") }
                        try await updateModel.updateWithAudit(as: platformActor, onDB: db)
                    }
                    else { try await updateModel.update(on: db()) }
                }
            }
        }
        return [createModels, updateModels].flatMap { $0 }
    }
    
    @discardableResult
    public static func delete(
        force: Bool = false,
        ids: [IDValue],
        onDB db: @escaping DBAccessor,
        withAudit: Bool,
        as platformActor: KernelIdentity.Core.Model.PlatformActor? = nil
    ) async throws -> [Self] {
        let deleteModels = try await query(on: db()).filter(\._$id ~~ ids).all()
        try await deleteModels.concurrentForEach { deleteModel in
            if withAudit {
                guard let platformActor else { throw Abort(.badRequest, reason: "No platform actor provided for audit") }
                try await deleteModel.deleteWithAudit(as: platformActor, force: force, onDB: db)
            }
            else { try await deleteModel.delete(force: force, on: db()) }
        }
        return deleteModels
    }
    
    @discardableResult
    public static func delete(
        force: Bool = false,
        id: IDValue,
        onDB db: @escaping DBAccessor,
        withAudit: Bool,
        as platformActor: KernelIdentity.Core.Model.PlatformActor? = nil
    ) async throws -> Self {
        guard let recordToDelete = try await Self.find(id, on: db()) else { throw FluentError.noResults }
        if withAudit {
            guard let platformActor else { throw Abort(.badRequest, reason: "No platform actor provided for audit") }
            try await recordToDelete.deleteWithAudit(as: platformActor, force: force, onDB: db)
        }
        else { try await recordToDelete.delete(force: force, on: db()) }
        return recordToDelete
    }
    
    @discardableResult
    public static func restore(
        id: IDValue,
        onDB db: @escaping DBAccessor,
        withAudit: Bool,
        as platformActor: KernelIdentity.Core.Model.PlatformActor? = nil
    ) async throws -> Self {
        guard let recordToRestore = try await Self.query(on: db()).includeDeleted(true).filter(\Self._$id == id).first() else { throw Abort(.notFound, reason: "No record found to restore") }
        if withAudit {
            guard let platformActor else { throw Abort(.badRequest, reason: "No platform actor provided for audit") }
            try await recordToRestore.restoreWithAudit(as: platformActor, onDB: db)
        }
        else { try await recordToRestore.restore(on: db()) }
        return recordToRestore
    }
}

extension CRUDModel {
    public func update(
        from dto: UpdateDTO,
        onDB db: @escaping DBAccessor,
        withAudit: Bool,
        as platformActor: KernelIdentity.Core.Model.PlatformActor? = nil,
        withOptions options: UpdateOptions? = nil
    ) async throws {
        try await Self.updateFields(onDB: db, for: self, from: dto, withAudit: withAudit, as: platformActor, withOptions: options)
        if withAudit {
            guard let platformActor else { throw Abort(.badRequest, reason: "No platform actor provided for audit") }
            try await updateWithAudit(as: platformActor, onDB: db)
        }
        else { try await update(on: db()) }
    }
    
    public func update(
        onDB db: @escaping DBAccessor,
        withAudit: Bool,
        as platformActor: KernelIdentity.Core.Model.PlatformActor? = nil,
        fromOptions options: UpdateOptions
    ) async throws {
        try await Self.updateFromOptions(onDB: db, for: self, options: options, withAudit: withAudit, as: platformActor)
        if withAudit {
            guard let platformActor else { throw Abort(.badRequest, reason: "No platform actor provided for audit") }
            try await updateWithAudit(as: platformActor, onDB: db)
        }
        else { try await update(on: db()) }
    }
}

public enum _CRUDOperationError<M: CRUDModel>: Error, CustomStringConvertible, LocalizedError {
    case createFailure(_ identifier: M.IDValue?, _ reasonDetail: String?)
    case saveFailure(_ identifier: M.IDValue?, _ reasonDetail: String?)
    case updateFailure(_ identifier: M.IDValue?, _ reasonDetail: String?)
    case upsertFailure(_ identifier: M.IDValue?, _ reasonDetail: String?)
    case deleteFailure(_ identifier: M.IDValue?, _ reasonDetail: String?)
    
    public var reason: String {
        switch self {
        case .createFailure(let identifier, let reasonDetail): return "Failed to create model for \(M.IDValue.self) \(identifier != nil ? String(describing: identifier!) : ""). \(reasonDetail ?? "")"
        case .saveFailure(let identifier, let reasonDetail): return "Failed to save model for \(M.IDValue.self) \(identifier != nil ? String(describing: identifier!) : ""). \(reasonDetail ?? "")"
        case .updateFailure(let identifier, let reasonDetail): return "Failed to update model for \(M.IDValue.self) \(identifier != nil ? String(describing: identifier!) : ""). \(reasonDetail ?? "")"
        case .upsertFailure(let identifier, let reasonDetail): return "Failed to upsert model for \(M.IDValue.self) \(identifier != nil ? String(describing: identifier!) : ""). \(reasonDetail ?? "")"
        case .deleteFailure(let identifier, let reasonDetail): return "Failed to delete model for \(M.IDValue.self) \(identifier != nil ? String(describing: identifier!) : ""). \(reasonDetail ?? "")"
        
        }
    }
    
    public var description: String { return "CRUDModel Operation Error: \(self.reason)" }
    public var errorDescription: String? { description }
}

public enum _CRUDOperationOrder: String, Codable, Equatable, CaseIterable, OpenAPIStringEnumSampleable {
    case ascending = "ascending"
    case descending = "descending"
}

extension KernelFluentModel {
    public struct EmptyCreateOptions: Sendable {}
    public struct EmptyUpdateOptions: Sendable {}
    public struct EmptyResponseOptions: Sendable {}
}

