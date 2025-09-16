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
    public func createSession(
        forAdminUser adminUserId: UUID,
        forDevice deviceId: UUID,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> FluentModel.AdminUserSession {
        try platformActor.systemOrAdmin()
        let newSession = try await FluentModel.AdminUserSession.create(
            from: KernelSwiftCommon.Networking.HTTP.EmptyRequest(), 
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor,
            withOptions: .init(adminUserId: adminUserId, deviceId: deviceId)
        )
        return newSession
    }
    
    public func getSession(
        id sessionId: UUID,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> FluentModel.AdminUserSession {
        try platformActor.systemOrAdmin()
        guard let session = try await FluentModel.AdminUserSession.find(sessionId, on: selectDB(db)) else {
            throw Abort(.notFound, reason: "Session not found")
        }
        return session
    }
    
    public func invalidateSessions(
        forAdminUser adminUserId: UUID,
        forDevice deviceId: UUID,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws {
        try platformActor.systemOrAdmin()
        let sessions = try await FluentModel.AdminUserSession.query(on: try selectDB(db))
            .filterIfPresent(\.$adminUser.$id, .equal, adminUserId)
            .filterIfPresent(\.$device.$id, .equal, deviceId)
            .filter(\.$isActive, .equal, true)
            .all()
        let _ = try await FluentModel.AdminUserSession.update(
            from: sessions.map { (id: $0.id!, dto: .init()) },
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor,
            withOptions: .init(isActive: false))
    }
    
    public func invalidateSessions(
        forAdminUser adminUserId: UUID,
        excludingDevice deviceId: UUID? = nil,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws {
        try platformActor.systemOrAdmin()
        let sessions = try await FluentModel.AdminUserSession.query(on: try selectDB(db))
            .filterIfPresent(\.$adminUser.$id, .equal, adminUserId)
            .filterIfPresent(\.$device.$id, .notEqual, deviceId)
            .filter(\.$isActive, .equal, true)
            .all()
        let _ = try await FluentModel.AdminUserSession.update(
            from: sessions.map { (id: $0.id!, dto: .init()) },
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor,
            withOptions: .init(isActive: false))
    }
    
    public func listSessions(
        forAdminUser adminUserId: UUID? = nil,
        forDevice deviceId: UUID? = nil,
        withPagination pagination: DefaultPaginatedQueryParams,
        dbCreatedAtFilters: DateFilterQueryParamObject? = nil,
        dbUpdatedAtFilters: DateFilterQueryParamObject? = nil,
        dbDeletedAtFilters: DateFilterQueryParamObject? = nil,
        isActive: Bool? = nil,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> PaginatedPgResult<FluentModel.AdminUserSession> {
        try platformActor.systemOrAdmin()
        let selectedDB: Database = try selectDB(db)
        
        let dateFilters = FluentModel.AdminUserSession.query(on: selectedDB)
            .filterIfPresent(\.$dbCreatedAt, dateFilters: dbCreatedAtFilters)
            .filterIfPresent(\.$dbUpdatedAt, dateFilters: dbUpdatedAtFilters)
            .filterIfPresent(\.$dbDeletedAt, dateFilters: dbDeletedAtFilters)
        
        let boolFilters = FluentModel.AdminUserSession.query(on: selectedDB)
            .filterIfPresent(\.$isActive, .equal, isActive)
        
        let relationFilters = FluentModel.AdminUserSession.query(on: selectedDB)
            .filterIfPresent(\.$adminUser.$id, .equal, adminUserId)
            .filterIfPresent(\.$device.$id, .equal, deviceId)
        
        let sessionCount = try await FluentModel.AdminUserSession.query(on: selectedDB)
            .includeDeleted(pagination.includeDeleted)
            .addFilters(dateFilters, boolFilters, relationFilters)
            .count()
        
        let sessions = try await FluentModel.AdminUserSession.query(on: selectedDB)
            .includeDeleted(pagination.includeDeleted)
            .addFilters(dateFilters, boolFilters, relationFilters)
            .paginatedSort(pagination)
            .all()
        
        return .init(results: sessions, total: sessionCount)
    }
    
    public func updateSession(
        id sessionId: UUID,
        isActive: Bool,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> FluentModel.AdminUserSession {
        try platformActor.systemOrAdmin()
        return try await FluentModel.AdminUserSession.update(
            id: sessionId,
            from: .init(),
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor,
            withOptions: .init(isActive: isActive)
        )
    }
    
    public func deleteSession(
        id sessionId: UUID,
        force: Bool = false,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws {
        try platformActor.systemOrAdmin()
        try await FluentModel.AdminUserSession.delete(
            force: force,
            id: sessionId,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
    }
}

