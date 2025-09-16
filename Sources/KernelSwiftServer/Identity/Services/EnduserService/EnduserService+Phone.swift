//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 19/06/2024.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelIdentity.Services.EnduserService {
    public func createPhone(
        forEnduser enduserId: UUID,
        from requestBody: KernelIdentity.Core.Model.CreateEnduserPhoneRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> FluentModel.EnduserPhone {
        try platformActor.checkEnduser(id: enduserId)
        let newPhone = try await FluentModel.EnduserPhone.create(
            from: requestBody,
            onDB: selectDB(db),
            withAudit: true, as: platformActor,
            withOptions: .init(enduserId: enduserId)
        )
        return newPhone
    }
    
    public func getPhone(
        id phoneId: UUID,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> FluentModel.EnduserPhone {
        guard let phone = try await FluentModel.EnduserPhone.find(phoneId, on: selectDB(db)) else {
            throw Abort(.notFound, reason: "Phone not found")
        }
        try platformActor.checkEnduser(id: phone.$enduser.id)
        return phone
    }
    
    public func getPhone(
        phoneNumber phoneNumberValue: String,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> FluentModel.EnduserPhone {
        try await FluentModel.EnduserPhone.findOrThrow(.field(\.$phoneNumberValue, phoneNumberValue), on: selectDB(db)) {
            Abort(.notFound, reason: "Phone not found")
        }
        
    }
    
    public func listPhones(
        forEnduser enduserId: UUID? = nil,
        withPagination pagination: DefaultPaginatedQueryParams,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> PaginatedPgResult<FluentModel.EnduserPhone> {
        let enduserId = try platformActor.replaceEnduserId(enduserId)
        let phoneCount = try await FluentModel.EnduserPhone.query(on: try selectDB(db))
            .includeDeleted(pagination.includeDeleted)
            .filterIfPresent(\.$enduser.$id, .equal, enduserId)
            .count()
        let phones = try await FluentModel.EnduserPhone.query(on: try selectDB(db))
            .includeDeleted(pagination.includeDeleted)
            .filterIfPresent(\.$enduser.$id, .equal, enduserId)
            .paginatedSort(pagination)
            .all()
        return .init(results: phones, total: phoneCount)
    }
    
    public func updatePhone(
        id phoneId: UUID,
        from requestBody: KernelIdentity.Core.Model.UpdateEnduserPhoneRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> FluentModel.EnduserPhone {
        let _ = try await getPhone(id: phoneId, on: db, as: platformActor)
        return try await FluentModel.EnduserPhone.update(id: phoneId, from: requestBody, onDB: selectDB(db), withAudit: true, as: platformActor)
    }
    
    public func deletePhone(
        id phoneId: UUID,
        force: Bool = false,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws {
        let _ = try await getPhone(id: phoneId, on: db, as: platformActor)
        try await FluentModel.EnduserPhone.delete(force: force, id: phoneId, onDB: selectDB(db), withAudit: true, as: platformActor)
    }
}

