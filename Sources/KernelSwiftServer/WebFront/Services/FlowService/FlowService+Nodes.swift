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
    public func createNode(
        for containerId: UUID,
        from requestBody: KernelWebFront.Model.Flows.CreateFlowNodeRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelWebFront.Fluent.Model.FlowNode {
        try platformActor.systemOrAdmin()
        let container = try await getContainerDB(id: containerId, as: platformActor)
        let newNode = try await KernelWebFront.Fluent.Model.FlowNode.create(
            from: requestBody,
            onDB: selectDB(db),
            withAudit: true, as: platformActor,
            withOptions: .init(containerId: container.requireID())
        )
        try await newNode.$continuations.load(on: selectDB(db))
        return newNode
    }
    
    public func getNode(
        id nodeId: UUID,
        withContinuations: Bool? = nil,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelWebFront.Fluent.Model.FlowNode {
        let withContinuations = withContinuations ?? true
        guard let node = try await KernelWebFront.Fluent.Model.FlowNode.find(nodeId, on: selectDB(db)) else {
            throw Abort(.notFound, reason: "Node not found")
        }
        if withContinuations { try await node.$continuations.load(on: selectDB(db)) }
        return node
    }
    
    public func listNodes(
        for containerId: UUID? = nil,
        withContinuations: Bool? = nil,
        withPagination pagination: DefaultPaginatedQueryParams,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> PaginatedPgResult<KernelWebFront.Fluent.Model.FlowNode> {
        let nodeCount = try await KernelWebFront.Fluent.Model.FlowNode.query(on: try selectDB(db))
            .includeDeleted(pagination.includeDeleted)
            .filterIfPresent(\.$container.$id, .equal, containerId)
            .count()
        let nodes = try await KernelWebFront.Fluent.Model.FlowNode.query(on: try selectDB(db))
            .includeDeleted(pagination.includeDeleted)
            .filterIfPresent(\.$container.$id, .equal, containerId)
            
            .with(\.$continuations, if: withContinuations ?? true)
            .paginatedSort(pagination)
            
            .all()
//        if withContinuations { try await nodes.}
        return .init(results: nodes, total: nodeCount)
    }
    
    public func updateNode(
        id nodeId: UUID,
        from requestBody: KernelWebFront.Model.Flows.UpdateFlowNodeRequest,
        withContinuations: Bool? = nil,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelWebFront.Fluent.Model.FlowNode {
        try platformActor.systemOrAdmin()
        let withContinuations = withContinuations ?? true
        let node = try await KernelWebFront.Fluent.Model.FlowNode.update(
            id: nodeId,
            from: requestBody,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
        if withContinuations { try await node.$continuations.load(on: selectDB(db)) }
        return node
    }
    
    public func deleteNode(
        id nodeId: UUID,
        force: Bool = false,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws {
        try platformActor.systemOrAdmin()
        try await KernelWebFront.Fluent.Model.FlowNode.delete(
            force: force,
            id: nodeId,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
    }
}
