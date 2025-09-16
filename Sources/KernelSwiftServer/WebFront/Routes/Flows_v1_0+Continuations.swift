//
//  File.swift
//
//
//  Created by Jonathan Forbes on 4/5/24.
//

import Vapor
import Fluent
import KernelSwiftCommon

extension KernelWebFront.Routes.Flows_v1_0 {
    public func bootNestedContinuationRoutes(routes: TypedRoutesBuilder) throws {
        routes.put("create", use: createContinuationHandler).summary("Create Flow Continuation")
        routes.put("update", use: updateContinuationHandler).summary("Update Flow Continuation")
        routes.put("remove", use: removeContinuationHandler).summary("Remove Flow Continuation")
    }
}

extension KernelWebFront.Routes.Flows_v1_0 {
    public func createContinuationHandler(_ req: TypedRequest<CreateContinuationContext>) async throws -> Response {
        let nodeId = try req.parameters.require("nodeId", as: UUID.self)
        let requestBody = try req.decodeBody()
        let updatedNode = try await req.kernelDI(KernelWebFront.self).flows.createContinuation(
            for: nodeId,
            from: requestBody,
            as: req.platformActor
        )
        return try await req.response.success.encode(updatedNode.response())
    }
    
    public func updateContinuationHandler(_ req: TypedRequest<UpdateContinuationContext>) async throws -> Response {
        let nodeId = try req.parameters.require("nodeId", as: UUID.self)
        let requestBody = try req.decodeBody()
        let updatedNode = try await req.kernelDI(KernelWebFront.self).flows.updateContinuation(
            for: nodeId,
            from: requestBody,
            as: req.platformActor
        )
        return try await req.response.success.encode(updatedNode.response())
    }
    
    public func removeContinuationHandler(_ req: TypedRequest<RemoveContinuationContext>) async throws -> Response {
        let nodeId = try req.parameters.require("nodeId", as: UUID.self)
        let requestBody = try req.decodeBody()
        let updatedNode = try await req.kernelDI(KernelWebFront.self).flows.removeContinuation(
            for: nodeId,
            from: requestBody,
            as: req.platformActor
        )
        return try await req.response.success.encode(updatedNode.response())
    }
}

extension KernelWebFront.Routes.Flows_v1_0 {
    public typealias CreateContinuationContext = UpdateRouteContext<KernelWebFront.Model.Flows.CreateFlowContinuationRequest, KernelWebFront.Model.Flows.FlowNodeResponse>
    public typealias UpdateContinuationContext = UpdateRouteContext<KernelWebFront.Model.Flows.UpdateFlowContinuationRequest, KernelWebFront.Model.Flows.FlowNodeResponse>
    public typealias RemoveContinuationContext = UpdateRouteContext<KernelWebFront.Model.Flows.RemoveFlowContinuationRequest, KernelWebFront.Model.Flows.FlowNodeResponse>
}
