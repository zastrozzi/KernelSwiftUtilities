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
    public func createContinuation(
        for parentNodeId: UUID,
        from requestBody: KernelWebFront.Model.Flows.CreateFlowContinuationRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelWebFront.Fluent.Model.FlowNode {
        try platformActor.systemOrAdmin()
        let _ = try await KernelWebFront.Fluent.Model.FlowContinuation.create(
            from: requestBody,
            onDB: selectDB(db),
            withAudit: true, as: platformActor,
            withOptions: .init(parentNodeId: parentNodeId)
        )
        return try await getNode(id: parentNodeId, withContinuations: true, as: platformActor)
    }
    
    public func updateContinuation(
        for parentNodeId: UUID,
        from requestBody: KernelWebFront.Model.Flows.UpdateFlowContinuationRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelWebFront.Fluent.Model.FlowNode {
        try platformActor.systemOrAdmin()
        let node = try await getNode(id: parentNodeId, withContinuations: false, as: platformActor)
        guard let continuationId = try await node.$continuations.query(on: selectDB())
            .filter(\.$childNode.$id, .equal, requestBody.childNodeId).first()?.id
        else {
            throw Abort(.notFound, reason: "Continuation not found")
        }
        let _ = try await KernelWebFront.Fluent.Model.FlowContinuation.update(
            id: continuationId,
            from: requestBody,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
        return try await getNode(id: parentNodeId, withContinuations: true, as: platformActor)
    }
    
    public func removeContinuation(
        for parentNodeId: UUID,
        from requestBody: KernelWebFront.Model.Flows.RemoveFlowContinuationRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelWebFront.Fluent.Model.FlowNode {
        try platformActor.systemOrAdmin()
        let node = try await getNode(
            id: parentNodeId,
            withContinuations: false,
            as: platformActor
        )
        guard let continuationId = try await node.$continuations.query(on: selectDB())
            .filter(\.$childNode.$id, .equal, requestBody.childNodeId).first()?.id
        else {
            throw Abort(.notFound, reason: "Continuation not found")
        }
        try await KernelWebFront.Fluent.Model.FlowContinuation.delete(
            id: continuationId,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
        return try await getNode(
            id: parentNodeId,
            withContinuations: true,
            as: platformActor
        )
    }
}
