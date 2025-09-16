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
    public func createAdminUser(
        from requestBody: KernelIdentity.Core.Model.CreateAdminUserRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelIdentity.Fluent.Model.AdminUser {
        try platformActor.systemOrAdmin()
        let newAdminUser = try await KernelIdentity.Fluent.Model.AdminUser.create(
            from: requestBody,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
        return newAdminUser
    }
    
    public func getAdminUser(
        id adminUserId: UUID,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelIdentity.Fluent.Model.AdminUser {
        try platformActor.systemOrAdmin()
        guard let adminUser = try await KernelIdentity.Fluent.Model.AdminUser.find(adminUserId, on: selectDB(db)) else {
            throw Abort(.notFound, reason: "Admin user not found")
        }
        return adminUser
    }
    
    public func listAdminUsers(
        withPagination pagination: DefaultPaginatedQueryParams,
        dbCreatedAtFilters: DateFilterQueryParamObject? = nil,
        dbUpdatedAtFilters: DateFilterQueryParamObject? = nil,
        dbDeletedAtFilters: DateFilterQueryParamObject? = nil,
        firstNameFilters: StringFilterQueryParamObject? = nil,
        lastNameFilters: StringFilterQueryParamObject? = nil,
        roleFilters: StringFilterQueryParamObject? = nil,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> PaginatedPgResult<KernelIdentity.Fluent.Model.AdminUser> {
        try platformActor.systemOrAdmin()
        let adminUserCount = try await KernelIdentity.Fluent.Model.AdminUser.query(on: try selectDB(db))
            .includeDeleted(pagination.includeDeleted)
            .filterIfPresent(\.$dbCreatedAt, dateFilters: dbCreatedAtFilters)
            .filterIfPresent(\.$dbUpdatedAt, dateFilters: dbUpdatedAtFilters)
            .filterIfPresent(\.$dbDeletedAt, dateFilters: dbDeletedAtFilters)
            .filterIfPresent(\.$firstName, stringFilters: firstNameFilters)
            .filterIfPresent(\.$lastName, stringFilters: lastNameFilters)
            .filterIfPresent(\.$role, stringFilters: roleFilters)
            .count()
        let adminUsers = try await KernelIdentity.Fluent.Model.AdminUser.query(on: try selectDB(db))
            .includeDeleted(pagination.includeDeleted)
            .filterIfPresent(\.$dbCreatedAt, dateFilters: dbCreatedAtFilters)
            .filterIfPresent(\.$dbUpdatedAt, dateFilters: dbUpdatedAtFilters)
            .filterIfPresent(\.$dbDeletedAt, dateFilters: dbDeletedAtFilters)
            .filterIfPresent(\.$firstName, stringFilters: firstNameFilters)
            .filterIfPresent(\.$lastName, stringFilters: lastNameFilters)
            .filterIfPresent(\.$role, stringFilters: roleFilters)
            .paginatedSort(pagination)
            .all()
        return .init(results: adminUsers, total: adminUserCount)
    }
    
    public func updateAdminUser(
        id adminUserId: UUID,
        from requestBody: KernelIdentity.Core.Model.UpdateAdminUserRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelIdentity.Fluent.Model.AdminUser {
        try platformActor.systemOrAdmin()
        return try await KernelIdentity.Fluent.Model.AdminUser.update(
            id: adminUserId,
            from: requestBody,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
    }
    
    public func deleteAdminUser(
        id adminUserId: UUID,
        force: Bool = false,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws {
        try platformActor.systemOrAdmin()
        if case let .adminUser(platformActorAdminUserId) = platformActor {
            guard platformActorAdminUserId != adminUserId else { throw Abort(.forbidden, reason: "Cannot delete self") }
        }
        guard let adminUser = try await KernelIdentity.Fluent.Model.AdminUser.find(adminUserId, on: selectDB(db)) else { throw Abort(.notFound, reason: "Admin user not found") }
        guard adminUser.role != "super-admin" else { throw Abort(.forbidden, reason: "Cannot delete super admin") }
        try await KernelIdentity.Fluent.Model.AdminUser.delete(force: force, id: adminUserId, onDB: selectDB(db), withAudit: true, as: platformActor)
    }
}
