//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 19/06/2024.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelIdentity.Services.AdminUserService {
    public func createPhone(
        forAdminUser adminUserId: UUID,
        from requestBody: KernelIdentity.Core.Model.CreateAdminUserPhoneRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> FluentModel.AdminUserPhone {
        try platformActor.systemOrAdmin()
        let newPhone = try await FluentModel.AdminUserPhone.create(
            from: requestBody,
            onDB: selectDB(db),
            withAudit: true, as: platformActor,
            withOptions: .init(adminUserId: adminUserId)
        )
        return newPhone
    }
    
    public func getPhone(
        id phoneId: UUID,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> FluentModel.AdminUserPhone {
        try platformActor.systemOrAdmin()
        guard let phone = try await FluentModel.AdminUserPhone.find(phoneId, on: selectDB(db)) else {
            throw Abort(.notFound, reason: "Phone not found")
        }
        return phone
    }
    
    public func listPhones(
        forAdminUser adminUserId: UUID? = nil,
        withPagination pagination: DefaultPaginatedQueryParams,
        dbCreatedAtFilters: DateFilterQueryParamObject? = nil,
        dbUpdatedAtFilters: DateFilterQueryParamObject? = nil,
        dbDeletedAtFilters: DateFilterQueryParamObject? = nil,
        phoneNumberValueFilters: StringFilterQueryParamObject? = nil,
        isWhatsapp: Bool? = nil,
        isSMS: Bool? = nil,
        isVoice: Bool? = nil,
        isWhatsappVerified: Bool? = nil,
        isSMSVerified: Bool? = nil,
        isVoiceVerified: Bool? = nil,
        preferredContactMethodFilters: FluentEnumFilterQueryParamObject<KernelIdentity.Core.Model.PhoneContactMethod>? = nil,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> PaginatedPgResult<FluentModel.AdminUserPhone> {
        try platformActor.systemOrAdmin()
        let selectedDB: Database = try selectDB(db)
        
        let dateFilters = FluentModel.AdminUserPhone.query(on: selectedDB)
            .filterIfPresent(\.$dbCreatedAt, dateFilters: dbCreatedAtFilters)
            .filterIfPresent(\.$dbUpdatedAt, dateFilters: dbUpdatedAtFilters)
            .filterIfPresent(\.$dbDeletedAt, dateFilters: dbDeletedAtFilters)
        
        let stringFilters = FluentModel.AdminUserPhone.query(on: selectedDB)
            .filterIfPresent(\.$phoneNumberValue, stringFilters: phoneNumberValueFilters)
        
        let boolFilters = FluentModel.AdminUserPhone.query(on: selectedDB)
            .filterIfPresent(\.$isWhatsapp, .equal, isWhatsapp)
            .filterIfPresent(\.$isSMS, .equal, isSMS)
            .filterIfPresent(\.$isVoice, .equal, isVoice)
            .filterIfPresent(\.$isWhatsappVerified, .equal, isWhatsappVerified)
            .filterIfPresent(\.$isSMSVerified, .equal, isSMSVerified)
            .filterIfPresent(\.$isVoiceVerified, .equal, isVoiceVerified)
        
        let enumFilters = FluentModel.AdminUserPhone.query(on: selectedDB)
            .filterIfPresent(\.$preferredContactMethod, enumFilters: preferredContactMethodFilters)
        
        let relationFilters = FluentModel.AdminUserPhone.query(on: selectedDB)
            .filterIfPresent(\.$adminUser.$id, .equal, adminUserId)
        
        let phoneCount = try await FluentModel.AdminUserPhone.query(on: selectedDB)
            .includeDeleted(pagination.includeDeleted)
            .addFilters(dateFilters, stringFilters, boolFilters, enumFilters, relationFilters)
            .count()
        let phones = try await FluentModel.AdminUserPhone.query(on: selectedDB)
            .includeDeleted(pagination.includeDeleted)
            .addFilters(dateFilters, stringFilters, boolFilters, enumFilters, relationFilters)
            .paginatedSort(pagination)
            .all()
        return .init(results: phones, total: phoneCount)
    }
    
    public func updatePhone(
        id phoneId: UUID,
        from requestBody: KernelIdentity.Core.Model.UpdateAdminUserPhoneRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> FluentModel.AdminUserPhone {
        let _ = try await getPhone(id: phoneId, on: db, as: platformActor)
        return try await FluentModel.AdminUserPhone.update(
            id: phoneId,
            from: requestBody,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
    }
    
    public func deletePhone(
        id phoneId: UUID,
        force: Bool = false,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws {
        let _ = try await getPhone(id: phoneId, on: db, as: platformActor)
        try await FluentModel.AdminUserPhone.delete(
            force: force,
            id: phoneId,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
    }
}
