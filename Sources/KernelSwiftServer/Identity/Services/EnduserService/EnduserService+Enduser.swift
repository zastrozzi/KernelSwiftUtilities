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
    public func createEnduser(
        from requestBody: KernelIdentity.Core.Model.CreateEnduserRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> FluentModel.Enduser {
        let newEnduser = try await FluentModel.Enduser.create(
            from: requestBody,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
        return newEnduser
    }
    
    public func getEnduser(
        id enduserId: UUID,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> FluentModel.Enduser {
        try platformActor.checkEnduser(id: enduserId)
        guard let enduser = try await FluentModel.Enduser.find(enduserId, on: selectDB(db)) else {
            throw Abort(.notFound, reason: "Enduser not found")
        }
        return enduser
    }
    
    public func listEndusers(
        withPagination pagination: DefaultPaginatedQueryParams,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> PaginatedPgResult<FluentModel.Enduser> {
        try platformActor.systemOrAdmin()
        let enduserCount = try await FluentModel.Enduser.query(on: try selectDB(db))
            .includeDeleted(pagination.includeDeleted)
            .count()
        let endusers = try await FluentModel.Enduser.query(on: try selectDB(db))
            .includeDeleted(pagination.includeDeleted)
            .paginatedSort(pagination)
            .all()
        return .init(results: endusers, total: enduserCount)
    }
    
    public func updateEnduser(
        id enduserId: UUID,
        from requestBody: KernelIdentity.Core.Model.UpdateEnduserRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> FluentModel.Enduser {
        try platformActor.checkEnduser(id: enduserId)
        return try await FluentModel.Enduser.update(
            id: enduserId,
            from: requestBody,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
    }
    
    public func deleteEnduser(
        id enduserId: UUID,
        force: Bool = false,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws {
        try platformActor.checkEnduser(id: enduserId)
        try await FluentModel.Enduser.delete(
            force: force,
            id: enduserId,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
    }
}

