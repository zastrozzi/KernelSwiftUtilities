//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 30/04/2023.
//

import Foundation
import Vapor
import Fluent
import KernelSwiftCommon
//
//public protocol AuditableModel: Model, DatabaseTimestampedModel, PartialCodable, UnsafeSendable {
//    var auditDate: Date? { get set }
//    var auditCreatedAt: Date? { get }
//    
//}
//
//extension AuditableModel {
//    public func createWithAudit(onDB db: @escaping DBAccessor) async throws {
//        try await self.create(on: db())
//        let difference = Self.calculateDifference(for: .create(next: self))
//        let _ = try await KernelFluentModel.AuditableModelEvent.create(affectedRecordId: self.id, difference: difference, onDB: db)
//        
//        return
//    }
//    
//    public func saveWithAudit(onDB db: @escaping DBAccessor) async throws {
//        if let prev = try await Self.find(self.id, on: db()) {
//            guard let _ = try? await self.save(on: db()) else {
//                KernelFluentModel.logger.error("FAILED SAVE WITH AUDIT FOR: \(self)")
//                throw Abort(.imATeapot)
//            }
//            let difference = Self.calculateDifference(for: .update(previous: prev, next: self))
//            if difference.hasDifference {
//                let _ = try await KernelFluentModel.AuditableModelEvent.create(affectedRecordId: self.id, difference: difference, onDB: db)
//            }
//        } else {
//            guard let _ = try? await self.create(on: db()) else {
//                KernelFluentModel.logger.error("FAILED CREATE WITH AUDIT FOR: \(self)")
//                throw Abort(.imATeapot)
//            }
//            let difference = Self.calculateDifference(for: .create(next: self))
//            let _ = try await KernelFluentModel.AuditableModelEvent.create(affectedRecordId: self.id, difference: difference, onDB: db)
//        }
//    }
//    
//    public func updateWithAudit(onDB db: @escaping DBAccessor) async throws {
//        if let prev = try await Self.find(self.id, on: db()) {
//            guard let _ = try? await self.update(on: db()) else {
//                KernelFluentModel.logger.error("FAILED UPDATE WITH AUDIT FOR: \(self)")
//                throw Abort(.imATeapot)
//            }
//            let difference = Self.calculateDifference(for: .update(previous: prev, next: self))
//            if difference.hasDifference {
//                let _ = try await KernelFluentModel.AuditableModelEvent.create(affectedRecordId: self.id, difference: difference, onDB: db)
//            }
//        } else {
//            fatalError("CANNOT UPDATE A MODEL THAT DOESNT EXIST")
//        }
//    }
//    
//    public func deleteWithAudit(force: Bool = false, onDB db: @escaping DBAccessor) async throws {
//        if let prev = try await Self.find(self.id, on: db()) {
//            try await self.delete(force: force, on: db())
//            let difference = Self.calculateDifference(for: .delete(previous: prev))
//            let _ = try await KernelFluentModel.AuditableModelEvent.create(affectedRecordId: prev.id, difference: difference, onDB: db)
//        } else {
//            fatalError("CANNOT DELETE A MODEL THAT DOESNT EXIST")
//        }
//    }
//    
//    public func getAuditEvents(on database: Database) async throws -> [KernelFluentModel.AuditableModelEvent<Self>] {
//        let events = try await KernelFluentModel.AuditableModelEvent<Self>
//            .query(on: database)
//            .group(.and) { and in
//                and.filter(\KernelFluentModel.AuditableModelEvent<Self>.$affectedSchemaName == Self.schema)
//                let recordIdType = KernelFluentModel.AuditableModelEvent<Self>.determineRecordIdType(type: Self.IDValue.self)
//                switch recordIdType {
//                case .int: if let castId = self.id as? Int { and.filter(\KernelFluentModel.AuditableModelEvent<Self>.$recordIdInt == castId); break }
//                case .int16: if let castId = self.id as? Int16 { and.filter(\KernelFluentModel.AuditableModelEvent<Self>.$recordIdInt16 == castId); break }
//                case .int32: if let castId = self.id as? Int32 { and.filter(\KernelFluentModel.AuditableModelEvent<Self>.$recordIdInt32 == castId); break }
//                case .int64: if let castId = self.id as? Int64 { and.filter(\KernelFluentModel.AuditableModelEvent<Self>.$recordIdInt64 == castId); break }
//                case .string: if let castId = self.id as? String { and.filter(\KernelFluentModel.AuditableModelEvent<Self>.$recordIdString == castId); break }
//                case .uuid: if let castId = self.id as? UUID { and.filter(\KernelFluentModel.AuditableModelEvent<Self>.$recordIdUUID == castId); break }
//                default: and.filter(\KernelFluentModel.AuditableModelEvent<Self>.$affectedSchemaName == "bailout")
//                }
//            }
//            .all()
//        return events
//    }
//    
//    public func getAtDate(date: Date, on database: Database) async throws -> Self? {
//        
//        if let createdAtDate = auditCreatedAt { if createdAtDate > date { return nil } }
//        let events = try await KernelFluentModel.AuditableModelEvent<Self>
//            .query(on: database)
//            .group(.and) { and in
//                and.filter(\KernelFluentModel.AuditableModelEvent<Self>.$affectedSchemaName == Self.schema)
//                let recordIdType = KernelFluentModel.AuditableModelEvent<Self>.determineRecordIdType(type: Self.IDValue.self)
//                switch recordIdType {
//                case .int: if let castId = self.id as? Int { and.filter(\KernelFluentModel.AuditableModelEvent<Self>.$recordIdInt == castId); break }
//                case .int16: if let castId = self.id as? Int16 { and.filter(\KernelFluentModel.AuditableModelEvent<Self>.$recordIdInt16 == castId); break }
//                case .int32: if let castId = self.id as? Int32 { and.filter(\KernelFluentModel.AuditableModelEvent<Self>.$recordIdInt32 == castId); break }
//                case .int64: if let castId = self.id as? Int64 { and.filter(\KernelFluentModel.AuditableModelEvent<Self>.$recordIdInt64 == castId); break }
//                case .string: if let castId = self.id as? String { and.filter(\KernelFluentModel.AuditableModelEvent<Self>.$recordIdString == castId); break }
//                case .uuid: if let castId = self.id as? UUID { and.filter(\KernelFluentModel.AuditableModelEvent<Self>.$recordIdUUID == castId); break }
//                default: and.filter(\KernelFluentModel.AuditableModelEvent<Self>.$affectedSchemaName == "bailout")
//                }
//                and.filter(\KernelFluentModel.AuditableModelEvent<Self>.$dbCreatedAt > date)
//            }
//            .sort(\KernelFluentModel.AuditableModelEvent<Self>.$dbCreatedAt, .descending)
//            .all()
//        var newPartial = try self.asPartial()
//        events.compactMap { $0.difference.previous }.forEach { diff in
//            newPartial.update(from: diff)
//        }
//
//        let selfAtDate = try newPartial.decoded()
//        selfAtDate.setAuditDate(date)
//        return selfAtDate
//    }
//    
//    internal func setAuditDate(_ date: Date) {
//        self.auditDate = date
//    }
//    
//    internal func removeAuditDate() {
//        self.auditDate = nil
//    }
//}
