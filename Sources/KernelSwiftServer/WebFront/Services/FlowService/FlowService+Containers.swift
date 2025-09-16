//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 4/5/24.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelWebFront.Services.FlowService {
    public func createContainerDB(
        from requestBody: KernelWebFront.Model.Flows.CreateFlowContainerRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelWebFront.Fluent.Model.FlowContainer {
        try platformActor.systemOrAdmin()
        let newContainer = try await KernelWebFront.Fluent.Model.FlowContainer.create(
            from: requestBody,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
        return newContainer
    }
    
    public func getContainerDB(
        id containerId: UUID,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelWebFront.Fluent.Model.FlowContainer {
        guard let container = try await KernelWebFront.Fluent.Model.FlowContainer.find(containerId, on: selectDB(db)) else {
            throw Abort(.notFound, reason: "Container not found")
        }
        return container
    }
    
    public func listContainersDB(
        withPagination pagination: DefaultPaginatedQueryParams,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> PaginatedPgResult<KernelWebFront.Fluent.Model.FlowContainer> {
        let containerCount = try await KernelWebFront.Fluent.Model.FlowContainer.query(on: try selectDB(db))
            .includeDeleted(pagination.includeDeleted)
            .count()
        let containers = try await KernelWebFront.Fluent.Model.FlowContainer.query(on: try selectDB(db))
            .includeDeleted(pagination.includeDeleted)
            .paginatedSort(pagination)
            .all()
        return .init(results: containers, total: containerCount)
    }
    
    public func updateContainerDB(
        id containerId: UUID,
        from requestBody: KernelWebFront.Model.Flows.UpdateFlowContainerRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelWebFront.Fluent.Model.FlowContainer {
        try platformActor.systemOrAdmin()
        return try await KernelWebFront.Fluent.Model.FlowContainer.update(
            id: containerId,
            from: requestBody,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
    }
    
    public func deleteContainer(
        id containerId: UUID,
        force: Bool = false,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws {
        try platformActor.systemOrAdmin()
        try await KernelWebFront.Fluent.Model.FlowContainer.delete(
            force: force,
            id: containerId,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
    }
    
    public func createContainer(
        from requestBody: KernelWebFront.Model.Flows.CreateFlowContainerRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelWebFront.Model.Flows.FlowContainerResponse {
        try platformActor.systemOrAdmin()
        return try await createContainerDB(from: requestBody, on: db, as: platformActor).response()
    }
    
    public func getContainer(
        id containerId: UUID,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelWebFront.Model.Flows.FlowContainerResponse {
        try await getContainerDB(id: containerId, on: db, as: platformActor).response()
    }
    
    public func listContainers(
        withPagination pagination: DefaultPaginatedQueryParams,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KPPaginatedResponse<KernelWebFront.Model.Flows.FlowContainerResponse> {
        let paginated = try await listContainersDB(withPagination: pagination, on: db, as: platformActor)
        return try .init(results: paginated.results.map { try $0.response() }, total: paginated.total)
    }
    
    public func updateContainer(
        id containerId: UUID,
        from requestBody: KernelWebFront.Model.Flows.UpdateFlowContainerRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelWebFront.Model.Flows.FlowContainerResponse {
        try platformActor.systemOrAdmin()
        return try await updateContainerDB(id: containerId, from: requestBody, on: db, as: platformActor).response()
    }
}
