//
//  File.swift
//
//
//  Created by Jonathan Forbes on 19/6/24.
//

import Vapor
import KernelSwiftCommon
import Fluent

extension KernelIdentity.Services.AdminUserService {
    public func createEmail(
        forAdminUser adminUserId: UUID,
        from requestBody: KernelIdentity.Core.Model.CreateAdminUserEmailRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> FluentModel.AdminUserEmail {
        try platformActor.systemOrAdmin()
        let newEmail = try await FluentModel.AdminUserEmail.create(
            from: requestBody, onDB: selectDB(db),
            withAudit: true, as: platformActor,
            withOptions: .init(adminUserId: adminUserId)
        )
        return newEmail
    }
    
    public func getEmail(
        id emailId: UUID,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> FluentModel.AdminUserEmail {
        try platformActor.systemOrAdmin()
        guard let email = try await FluentModel.AdminUserEmail.find(emailId, on: selectDB(db)) else {
            throw Abort(.notFound, reason: "Email not found")
        }
        return email
    }
    
    public func listEmails(
        forAdminUser adminUserId: UUID? = nil,
        withPagination pagination: DefaultPaginatedQueryParams,
        dbCreatedAtFilters: DateFilterQueryParamObject? = nil,
        dbUpdatedAtFilters: DateFilterQueryParamObject? = nil,
        dbDeletedAtFilters: DateFilterQueryParamObject? = nil,
        emailAddressValueFilters: StringFilterQueryParamObject? = nil,
        isVerified: Bool? = nil,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> PaginatedPgResult<FluentModel.AdminUserEmail> {
        try platformActor.systemOrAdmin()
        let selectedDB: Database = try selectDB(db)
        
        let dateFilters = FluentModel.AdminUserEmail.query(on: selectedDB)
            .filterIfPresent(\.$dbCreatedAt, dateFilters: dbCreatedAtFilters)
            .filterIfPresent(\.$dbUpdatedAt, dateFilters: dbUpdatedAtFilters)
            .filterIfPresent(\.$dbDeletedAt, dateFilters: dbDeletedAtFilters)
        
        let stringFilters = FluentModel.AdminUserEmail.query(on: selectedDB)
            .filterIfPresent(\.$emailAddressValue, stringFilters: emailAddressValueFilters)
        
        let boolFilters = FluentModel.AdminUserEmail.query(on: selectedDB)
            .filterIfPresent(\.$isVerified, .equal, isVerified)
        
        let relationFilters = FluentModel.AdminUserEmail.query(on: selectedDB)
            .filterIfPresent(\.$adminUser.$id, .equal, adminUserId)
        
        let emailCount = try await FluentModel.AdminUserEmail.query(on: selectedDB)
            .includeDeleted(pagination.includeDeleted)
            .addFilters(dateFilters, stringFilters, boolFilters, relationFilters)
            .count()
        
        let emails = try await FluentModel.AdminUserEmail.query(on: selectedDB)
            .includeDeleted(pagination.includeDeleted)
            .addFilters(dateFilters, stringFilters, boolFilters, relationFilters)
            .paginatedSort(pagination)
            .all()
        
        return .init(results: emails, total: emailCount)
    }
    
    public func updateEmail(
        id emailId: UUID,
        from requestBody: KernelIdentity.Core.Model.UpdateAdminUserEmailRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> FluentModel.AdminUserEmail {
        try platformActor.systemOrAdmin()
        return try await FluentModel.AdminUserEmail.update(
            id: emailId,
            from: requestBody,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
    }
    
    public func deleteEmail(
        id emailId: UUID,
        force: Bool = false,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws {
        try platformActor.systemOrAdmin()
        try await FluentModel.AdminUserEmail.delete(
            force: force,
            id: emailId,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
    }
}
