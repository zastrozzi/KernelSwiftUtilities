//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 26/5/24.
//

import Foundation
import FluentKit
import Vapor

public protocol AuditableModel: KernelFluentNamespacedModel, Sendable {}

extension AuditableModel {
    public func getChanges(withDefaultedValues defaultedValues: Bool = false) -> [FieldKey: DatabaseQuery.Value] {
        let input = KernelFluentModel.Audit.DiffableModelDictionary(wantsUnmodifiedKeys: defaultedValues)
        self.input(to: input)
        return input.storage
    }
    
    public func createWithAudit(
        as platformActor: KernelIdentity.Core.Model.PlatformActor,
        onDB db: @escaping CRUDModel.DBAccessor
    ) async throws {
        let newChanges = self.getChanges()
        
        do {
            let _ = try await self.create(on: db())
        } catch {
            KernelFluentModel.logger.error("FAILED CREATE WITH DIFF FOR: \(self)")
            print("ORIGINAL ERROR", String(reflecting: error))
            throw Abort(.badRequest, reason: "Failed to create")
        }
        let auditEvent = KernelFluentModel.Audit.Event()
        auditEvent.eventData = newChanges.reduce(into: [:]) { $0[$1.key.description] = .init(previous: .null, next: $1.value) }
        auditEvent.affectedSchema = Self.namespacedSchema.namespace
        auditEvent.affectedTable = Self.namespacedSchema.table
        auditEvent.affectedId = self.id! as! UUID
        auditEvent.eventType = .create
        
        auditEvent.platformActor = platformActor
        
        try await auditEvent.create(on: db())
    }
    
    public func updateWithAudit(
        as platformActor: KernelIdentity.Core.Model.PlatformActor,
        onDB db: @escaping CRUDModel.DBAccessor
    ) async throws {
        guard let prev = try await Self.find(self.id, on: db()) else { throw Abort(.notFound, reason: "Record not found") }
        let prevChanges = prev.getChanges(withDefaultedValues: true)
        let difference: [String: KernelFluentModel.Audit.EventFieldData] = self.getChanges()
            .filter { $0.value != prevChanges[$0.key] }
            .reduce(into: [:]) { $0[$1.key.description] = .init(previous: prevChanges[$1.key] ?? .null, next: $1.value) }
        if difference.isEmpty { return }
        let auditEvent = KernelFluentModel.Audit.Event()
        auditEvent.affectedSchema = Self.namespacedSchema.namespace
        auditEvent.affectedTable = Self.namespacedSchema.table
        auditEvent.affectedId = self.id! as! UUID
        auditEvent.eventType = .update
        auditEvent.eventData = difference
        auditEvent.platformActor = platformActor
        guard let _ = try? await self.update(on: db()) else {
            KernelFluentModel.logger.error("FAILED UPDATE WITH DIFF FOR: \(self)")
            throw Abort(.badRequest, reason: "Failed to update")
        }
        try await auditEvent.create(on: db())
    }
    
    public func deleteWithAudit(
        as platformActor: KernelIdentity.Core.Model.PlatformActor,
        force: Bool = false,
        onDB db: @escaping CRUDModel.DBAccessor
    ) async throws {
        
        let auditEvent = KernelFluentModel.Audit.Event()
        auditEvent.eventData = self.getChanges().reduce(into: [:]) { $0[$1.key.description] = .init(previous: $1.value, next: .null) }
        guard let _ = try? await self.delete(force: force, on: db()) else {
            KernelFluentModel.logger.error("FAILED DELETE WITH DIFF FOR: \(self)")
            throw Abort(.badRequest, reason: "Failed to delete")
        }
        auditEvent.affectedSchema = Self.namespacedSchema.namespace
        auditEvent.affectedTable = Self.namespacedSchema.table
        auditEvent.affectedId = self.id! as! UUID
        auditEvent.eventType = .delete
        
        auditEvent.platformActor = platformActor
        try await auditEvent.create(on: db())
    }
    
    public func restoreWithAudit(
        as platformActor: KernelIdentity.Core.Model.PlatformActor,
        onDB db: @escaping CRUDModel.DBAccessor
    ) async throws {
        let auditEvent = KernelFluentModel.Audit.Event()
        auditEvent.eventData = self.getChanges().reduce(into: [:]) { $0[$1.key.description] = .init(previous: .null, next: $1.value) }
        guard let _ = try? await self.restore(on: db()) else {
            KernelFluentModel.logger.error("FAILED RESTORE WITH DIFF FOR: \(self)")
            throw Abort(.badRequest, reason: "Failed to restore")
        }
        auditEvent.affectedSchema = Self.namespacedSchema.namespace
        auditEvent.affectedTable = Self.namespacedSchema.table
        auditEvent.affectedId = self.id! as! UUID
        auditEvent.eventType = .restore
        
        auditEvent.platformActor = platformActor
        try await auditEvent.create(on: db())
    }
}

extension Collection where Element: AuditableModel, Self: Sendable {
    public func deleteWithAudit(
        as platformActor: KernelIdentity.Core.Model.PlatformActor,
        force: Bool = false,
        onDB db: @escaping CRUDModel.DBAccessor
    ) async throws {
        let auditEvents: [KernelFluentModel.Audit.Event] = self.map { record in
            let auditEvent = KernelFluentModel.Audit.Event()
            auditEvent.eventData = record.getChanges().reduce(into: [:]) { $0[$1.key.description] = .init(previous: $1.value, next: .null) }
            auditEvent.affectedSchema = Element.namespacedSchema.namespace
            auditEvent.affectedTable = Element.namespacedSchema.table
            auditEvent.affectedId = record.id! as! UUID
            auditEvent.eventType = .delete
            auditEvent.platformActor = platformActor
            return auditEvent
        }
        
        guard let _ = try? await self.delete(force: force, on: db()) else {
            KernelFluentModel.logger.error("FAILED DELETE WITH DIFF FOR: \(self)")
            throw Abort(.badRequest, reason: "Failed to delete")
        }
        
        try await auditEvents.create(on: db())
    }
    
    public func createWithAudit(
        as platformActor: KernelIdentity.Core.Model.PlatformActor,
        onDB db: @escaping CRUDModel.DBAccessor
    ) async throws {
        let createMap: [UUID: Element] = self.reduce(into: [:]) { $0[.init()] = $1 }
        let changeMap: [UUID: [FieldKey: DatabaseQuery.Value]] = createMap.mapValues { $0.getChanges() }
        guard let _ = try? await createMap.values.create(on: db()) else {
            KernelFluentModel.logger.error("FAILED CREATE WITH DIFF FOR: \(self)")
            throw Abort(.badRequest, reason: "Failed to create")
        }
        
        let auditEvents: [KernelFluentModel.Audit.Event] = changeMap.map { id, changes in
            let auditEvent = KernelFluentModel.Audit.Event()
            auditEvent.eventData = changes.reduce(into: [:]) { $0[$1.key.description] = .init(previous: .null, next: $1.value) }
            auditEvent.affectedSchema = Element.namespacedSchema.namespace
            auditEvent.affectedTable = Element.namespacedSchema.table
            auditEvent.affectedId = createMap[id]!.id! as! UUID
            auditEvent.eventType = .create
            auditEvent.platformActor = platformActor
            return auditEvent
        }
        
        try await auditEvents.create(on: db())
    }
}

