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
    public func bootNestedNodeRoutes(routes: TypedRoutesBuilder) throws {
        routes.post(use: createNodeHandler).summary("Create Flow Node")
        routes.get(use: listNodesHandler).summary("List Flow Nodes for Container")
    }
    
    public func bootRootNodeRoutes(routes: TypedRoutesBuilder) throws {
        routes.get(":nodeId", use: getNodeHandler).summary("Get Flow Node")
        routes.get(use: listNodesHandler).summary("List Flow Nodes")
        routes.put(":nodeId", use: updateNodeHandler).summary("Update Flow Node")
        routes.delete(":nodeId", use: deleteNodeHandler).summary("Delete Flow Node")
        
        try bootNestedContinuationRoutes(routes: routes.typeGrouped(":nodeId".parameterType(UUID.self), "continuations"))
    }
}

extension KernelWebFront.Routes.Flows_v1_0 {
    public func createNodeHandler(_ req: TypedRequest<CreateNodeContext>) async throws -> Response {
        let containerId = try req.parameters.require("containerId", as: UUID.self)
        let requestBody = try req.decodeBody()
        let newNode = try await req.kernelDI(KernelWebFront.self).flows.createNode(
            for: containerId,
            from: requestBody,
            as: req.platformActor
        )
        return try await req.response.success.encode(newNode.response())
    }
    
    public func getNodeHandler(_ req: TypedRequest<GetNodeContext>) async throws -> Response {
        let nodeId = try req.parameters.require("nodeId", as: UUID.self)
        let node = try await req.kernelDI(KernelWebFront.self).flows.getNode(
            id: nodeId,
            withContinuations: req.query.withContinuations,
            as: req.platformActor
        )
        return try await req.response.success.encode(node.response())
    }
    
    public func listNodesHandler(_ req: TypedRequest<ListNodesContext>) async throws -> Response {
        let containerId = req.parameters.get("containerId", as: UUID.self)
        let pagedNodes = try await req.kernelDI(KernelWebFront.self).flows.listNodes(
            for: containerId,
            withContinuations: req.query.withContinuations,
            withPagination: req.decodeDefaultPagination(),
            as: req.platformActor
        )
        return try await req.response.success.encode(.init(results: pagedNodes.results.map { try $0.response() }, total: pagedNodes.total))
    }
    
    public func updateNodeHandler(_ req: TypedRequest<UpdateNodeContext>) async throws -> Response {
        let node = try await req.kernelDI(KernelWebFront.self).flows.updateNode(
            id: try req.parameters.require("nodeId", as: UUID.self),
            from: try req.decodeBody(),
            withContinuations: req.query.withContinuations,
            as: req.platformActor
        )
        return try await req.response.success.encode(node.response())
    }
    
    public func deleteNodeHandler(_ req: TypedRequest<DeleteNodeContext>) async throws -> Response {
        let nodeId = try req.parameters.require("nodeId", as: UUID.self)
        let force = try req.query.withDefault(\.force)
        try await req.kernelDI(KernelWebFront.self).flows.deleteNode(
            id: nodeId,
            force: force,
            as: req.platformActor
        )
        return try await req.response.success.encode(.init())
    }
}

extension KernelWebFront.Routes.Flows_v1_0 {
    public typealias CreateNodeContext = PostRouteContext<KernelWebFront.Model.Flows.CreateFlowNodeRequest, KernelWebFront.Model.Flows.FlowNodeResponse>
    public typealias GetNodeContext = GetRouteContext<KernelWebFront.Model.Flows.FlowNodeResponse>
    public typealias ListNodesContext = PaginatedGetRouteContext<KernelWebFront.Model.Flows.FlowNodeResponse>
    public typealias UpdateNodeContext = UpdateRouteContext<KernelWebFront.Model.Flows.UpdateFlowNodeRequest, KernelWebFront.Model.Flows.FlowNodeResponse>
    public typealias DeleteNodeContext = DeleteRouteContext<KernelSwiftCommon.Networking.HTTP.EmptyResponse>
}

extension KernelWebFront.Routes.Flows_v1_0.GetNodeContext {
    public var withContinuations: QueryParam<Bool> { .init(name: "with_continuations", defaultValue: true) }
}

extension KernelWebFront.Routes.Flows_v1_0.ListNodesContext {
    public var withContinuations: QueryParam<Bool> { .init(name: "with_continuations", defaultValue: true) }
}

extension KernelWebFront.Routes.Flows_v1_0.UpdateNodeContext {
    public var withContinuations: QueryParam<Bool> { .init(name: "with_continuations", defaultValue: true) }
}
