//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 06/05/2023.
//

import Foundation
import Vapor
import Fluent


//extension CRUDModel where Self: AuditableModel {
//    public static func create(from dto: CreateDTO, onDB db: @escaping DBAccessor, withOptions options: CreateOptions? = nil) async throws -> Self {
//        let model = try createFields(from: dto, withOptions: options)
//        try await model.createWithAudit(onDB: db)
//        return model
//    }
//    
//    public static func create(from dtos: [CreateDTO], onDB db: @escaping DBAccessor, withOptions options: CreateOptions? = nil) async throws -> [Self] {
//        let models = try dtos.map { try createFields(from: $0, withOptions: options) }
//        try await models.concurrentForEach { try await $0.createWithAudit(onDB: db) }
//        return models
////        return try await dtos.asyncMap { try await Self.create(from: $0, on: db) }
//    }
//    
//    public static func create(from dtosWithOptions: [(CreateDTO, CreateOptions)], onDB db: @escaping DBAccessor) async throws -> [Self] {
//        let models = try dtosWithOptions.map { try createFields(from: $0.0, withOptions: $0.1) }
//        try await models.concurrentForEach { try await $0.createWithAudit(onDB: db) }
//        return models
////        return try await dtos.asyncMap { try await Self.create(from: $0, on: db) }
//    }
//    
//    public static func update(id: IDValue, from dto: UpdateDTO, onDB db: @escaping DBAccessor, withOptions options: UpdateOptions? = nil) async throws -> Self {
//        guard let model = try await find(id, on: db()) else { throw FluentError.noResults }
//        try updateFields(for: model, from: dto, withOptions: options)
//        try await model.updateWithAudit(onDB: db)
//        return model
//    }
//    
//    public static func update(from dto: UpdateDTO, onDB db: @escaping DBAccessor, withOptions options: UpdateOptions? = nil) async throws -> Self where UpdateDTO: Identifiable {
//        guard let id = dto.id as? Self.IDValue, let model = try await find(id, on: db()) else { throw FluentError.noResults }
//        try updateFields(for: model, from: dto, withOptions: options)
//        try await model.updateWithAudit(onDB: db)
//        return model
//    }
//    
//    public static func update(from dtos: [UpdateDTO], onDB db: @escaping DBAccessor, withOptions options: UpdateOptions? = nil) async throws -> [Self] where UpdateDTO: Identifiable {
//        return try await dtos.asyncMap { try await Self.update(from: $0, onDB: db, withOptions: options) }
//    }
//    
//    public static func update(from dtosWithOptions: [(UpdateDTO, UpdateOptions)], onDB db: @escaping DBAccessor) async throws -> [Self] where UpdateDTO: Identifiable {
//        return try await dtosWithOptions.asyncMap { try await Self.update(from: $0.0, onDB: db, withOptions: $0.1) }
//    }
//    
//    public static func update(from dtoIdPairs: [(id: IDValue, dto: UpdateDTO)], onDB db: @escaping DBAccessor, withOptions options: UpdateOptions? = nil) async throws -> [Self] {
//        let models = try await query(on: db()).filter(\._$id ~~ dtoIdPairs.map { $0.id }).all()
//        try await models.concurrentForEach { model in
//            if let dtoForModel = dtoIdPairs.first(where: { pair in pair.id == model.id }) {
//                try updateFields(for: model, from: dtoForModel.dto, withOptions: options)
//                try await model.updateWithAudit(onDB: db)
//            }
//        }
//        return models
////        return try await dtoIdPairs.asyncMap { try await Self.update(id: $0.id, from: $0.dto, on: db) }
//    }
//    
//    public static func upsert(id: IDValue, from dto: UpdateDTO, onDB db: @escaping DBAccessor, withOptions options: UpsertOptions? = nil) async throws -> Self where UpdateDTO == CreateDTO {
//        if let model = try await find(id, on: db()) {
//            try updateFields(for: model, from: dto, withOptions: options?.update)
//            try await model.updateWithAudit(onDB: db)
//            return model
//        } else {
//            let createdModel = try createFields(from: dto, withOptions: options?.create)
//            try await createdModel.createWithAudit(onDB: db)
//            return createdModel
//        }
//    }
//    
//    public static func upsert(from dto: UpdateDTO, onDB db: @escaping DBAccessor, withOptions options: UpsertOptions? = nil) async throws -> Self where UpdateDTO: Identifiable, UpdateDTO == CreateDTO {
//        guard let id = dto.id as? Self.IDValue else { throw FluentError.idRequired }
//        return try await upsert(id: id, from: dto, onDB: db)
//    }
//    
//    public static func upsert(from dtos: [UpdateDTO], onDB db: @escaping DBAccessor, withOptions options: UpsertOptions? = nil) async throws -> [Self] where UpdateDTO: Identifiable, UpdateDTO == CreateDTO {
//        let updateModels: [Self] = try await query(on: db()).filter(\._$id ~~ dtos.compactMap { $0.id as? IDValue }).all()
//        let updateModelIds = updateModels.map { $0.id }
//        let createModels: [Self] = try dtos.filter { dto in
//            guard !updateModelIds.isEmpty else { return true }
//            guard let dtoId = dto.id as? IDValue else { return false }
//            guard !updateModelIds.contains(dtoId) else { return false }
//            return true
//        }.map { try createFields(from: $0, withOptions: options?.create) }
//        if !createModels.isEmpty { try await createModels.concurrentForEach { try await $0.createWithAudit(onDB: db) } }
//        if !updateModels.isEmpty {
//            try await updateModels.concurrentForEach { updateModel in
//                if let updateDto = dtos.first(where: { dto in
//                    (dto.id as? IDValue) == updateModel.id
//                }) {
//                    try updateFields(for: updateModel, from: updateDto, withOptions: options?.update)
//                }
//                try await updateModel.updateWithAudit(onDB: db)
//            }
//        }
//        return [createModels, updateModels].flatMap { $0 }
//    }
//    
//    public static func upsert(from dtosWithOptions: [(UpdateDTO, UpsertOptions)], onDB db: @escaping DBAccessor) async throws -> [Self] where UpdateDTO: Identifiable, UpdateDTO == CreateDTO {
//        let updateModels: [Self] = try await query(on: db()).filter(\._$id ~~ dtosWithOptions.compactMap { $0.0.id as? IDValue }).all()
//        let updateModelIds = updateModels.map { $0.id }
//        let createModels: [Self] = try dtosWithOptions.filter { dto in
//            guard !updateModelIds.isEmpty else { return true }
//            guard let dtoId = dto.0.id as? IDValue else { return false }
//            guard !updateModelIds.contains(dtoId) else { return false }
//            return true
//        }.map { try createFields(from: $0.0, withOptions: $0.1.create) }
//        if !createModels.isEmpty { try await createModels.concurrentForEach { try await $0.createWithAudit(onDB: db) } }
//        if !updateModels.isEmpty {
//            try await updateModels.concurrentForEach { updateModel in
//                if let updateDto = dtosWithOptions.first(where: { dto in
//                    (dto.0.id as? IDValue) == updateModel.id
//                }) {
//                    try updateFields(for: updateModel, from: updateDto.0, withOptions: updateDto.1.update)
//                }
//                try await updateModel.updateWithAudit(onDB: db)
//            }
//        }
//        return [createModels, updateModels].flatMap { $0 }
//    }
//    
//    public static func upsert(from dtoIdPairs: [(id: IDValue, dto: UpdateDTO)], onDB db: @escaping DBAccessor, withOptions options: UpsertOptions? = nil) async throws -> [Self] where UpdateDTO == CreateDTO {
//        let updateModels: [Self] = try await query(on: db()).filter(\._$id ~~ dtoIdPairs.compactMap { $0.id }).all()
//        let updateModelIds = updateModels.map { $0.id }
//        let createModels: [Self] = try dtoIdPairs.filter { dtoIdPair in
//            guard !updateModelIds.isEmpty else { return true }
//            guard !updateModelIds.contains(dtoIdPair.id) else { return false }
//            return true
//        }.map { return try createFields(from: $0.dto, withOptions: options?.create) }
//        if !createModels.isEmpty { try await createModels.concurrentForEach { try await $0.createWithAudit(onDB: db) } }
//        if !updateModels.isEmpty {
//            try await updateModels.concurrentForEach { updateModel in
//                if let updateDtoIdPair = dtoIdPairs.first(where: { dtoIdPair in
//                    dtoIdPair.id == updateModel.id
//                }) {
//                    try updateFields(for: updateModel, from: updateDtoIdPair.dto, withOptions: options?.update)
//                    try await updateModel.updateWithAudit(onDB: db)
//                }
//                
//            }
//        }
//        return [createModels, updateModels].flatMap { $0 }
//    }
//    
//    public static func delete(force: Bool = false, ids: [IDValue], onDB db: @escaping DBAccessor) async throws {
//        let deleteModels = try await query(on: db()).filter(\._$id ~~ ids).all()
//        try await deleteModels.concurrentForEach { try await $0.deleteWithAudit(force: force, onDB: db) }
////        return try await ids.asyncForEach { try await delete(force: force, id: $0, on: db()) }
//    }
//    
//    public static func delete(force: Bool = false, id: IDValue, onDB db: @escaping DBAccessor) async throws {
//        guard let recordToDelete = try await Self.find(id, on: db()) else { throw FluentError.noResults }
//        try await recordToDelete.deleteWithAudit(force: force, onDB: db)
//    }
//}
//
