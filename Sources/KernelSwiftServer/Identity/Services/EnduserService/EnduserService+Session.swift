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
    public func createSession(
        forEnduser enduserId: UUID,
        forDevice deviceId: UUID,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> FluentModel.EnduserSession {
        try platformActor.checkEnduser(id: enduserId)
        let newSession = try await FluentModel.EnduserSession.create(
            from: KernelSwiftCommon.Networking.HTTP.EmptyRequest(), onDB: selectDB(db),
            withAudit: true, as: platformActor,
            withOptions: .init(enduserId: enduserId, deviceId: deviceId)
        )
        return newSession
    }
    
    public func getSession(
        id sessionId: UUID,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> FluentModel.EnduserSession {
        guard let session = try await FluentModel.EnduserSession.find(sessionId, on: selectDB(db)) else {
            throw Abort(.notFound, reason: "Session not found")
        }
        try platformActor.checkEnduser(id: session.$enduser.id)
        return session
    }
    
    public func invalidateSessions(
        forEnduser enduserId: UUID,
        forDevice deviceId: UUID,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws {
        try platformActor.checkEnduser(id: enduserId)
        try await FluentModel.EnduserSession.query(on: try selectDB(db))
            .filterIfPresent(\.$enduser.$id, .equal, enduserId)
            .filterIfPresent(\.$device.$id, .equal, deviceId)
            .filter(\.$isActive, .equal, true)
            .set(\.$isActive, to: false)
            .update()
    }
    
    public func invalidateSessions(
        forEnduser enduserId: UUID,
        excludingDevice deviceId: UUID? = nil,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws {
        try platformActor.checkEnduser(id: enduserId)
        try await FluentModel.EnduserSession.query(on: try selectDB(db))
            .filterIfPresent(\.$enduser.$id, .equal, enduserId)
            .filterIfPresent(\.$device.$id, .notEqual, deviceId)
            .filter(\.$isActive, .equal, true)
            .set(\.$isActive, to: false)
            .update()
    }
    
    public func listSessions(
        forEnduser enduserId: UUID? = nil,
        forDevice deviceId: UUID? = nil,
        withPagination pagination: DefaultPaginatedQueryParams,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> PaginatedPgResult<FluentModel.EnduserSession> {
        let enduserId = try platformActor.replaceEnduserId(enduserId)
        let sessionCount = try await FluentModel.EnduserSession.query(on: try selectDB(db))
            .includeDeleted(pagination.includeDeleted)
            .filterIfPresent(\.$enduser.$id, .equal, enduserId)
            .filterIfPresent(\.$device.$id, .equal, deviceId)
            .count()
        let sessions = try await FluentModel.EnduserSession.query(on: try selectDB(db))
            .includeDeleted(pagination.includeDeleted)
            .filterIfPresent(\.$enduser.$id, .equal, enduserId)
            .filterIfPresent(\.$device.$id, .equal, deviceId)
            .paginatedSort(pagination)
            .all()
        return .init(results: sessions, total: sessionCount)
    }
    
    public func updateSession(
        id sessionId: UUID,
        isActive: Bool,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> FluentModel.EnduserSession {
        let _ = try await getSession(id: sessionId, on: db, as: platformActor)
        return try await FluentModel.EnduserSession.update(
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
        let _ = try await getSession(id: sessionId, on: db, as: platformActor)
        try await FluentModel.EnduserSession.delete(
            force: force,
            id: sessionId,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
    }
}

