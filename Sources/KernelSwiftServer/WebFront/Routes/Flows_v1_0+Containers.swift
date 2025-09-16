//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 1/5/24.
//

import Vapor
import Fluent
import KernelSwiftCommon

extension KernelWebFront.Routes.Flows_v1_0 {
    public func bootContainerRoutes(routes: TypedRoutesBuilder) throws {
        routes.post(use: createContainerHandler).summary("Create Flow Container")
        routes.get(":containerId".parameterType(UUID.self), use: getContainerHandler).summary("Get Flow Container")
        routes.get(use: listContainersHandler).summary("List Flow Containers")
        routes.put(":containerId".parameterType(UUID.self), use: updateContainerHandler).summary("Update Flow Container")
        routes.delete(":containerId".parameterType(UUID.self), use: deleteContainerHandler).summary("Delete Flow Container")
        try bootNestedNodeRoutes(routes: routes.typeGrouped(":containerId".parameterType(UUID.self), "nodes"))
    }
}

extension KernelWebFront.Routes.Flows_v1_0 {
    public func createContainerHandler(_ req: TypedRequest<CreateContainerContext>) async throws -> Response {
        let requestBody = try req.decodeBody()
        let newContainer = try await req.kernelDI(KernelWebFront.self).flows.createContainer(
            from: requestBody,
            as: req.platformActor
        )
        return try await req.response.success.encode(newContainer)
    }
    
    public func getContainerHandler(_ req: TypedRequest<GetContainerContext>) async throws -> Response {
        let containerId = try req.parameters.require("containerId", as: UUID.self)
        let container = try await req.kernelDI(KernelWebFront.self).flows.getContainer(
            id: containerId,
            as: req.platformActor
        )
        return try await req.response.success.encode(container)
    }
    
    public func listContainersHandler(_ req: TypedRequest<ListContainersContext>) async throws -> Response {
        let pagedContainers = try await req.kernelDI(KernelWebFront.self).flows.listContainers(
            withPagination: req.decodeDefaultPagination(),
            as: req.platformActor
        )
        return try await req.response.success.encode(pagedContainers)
    }
    
    public func updateContainerHandler(_ req: TypedRequest<UpdateContainerContext>) async throws -> Response {
        let containerId = try req.parameters.require("containerId", as: UUID.self)
        let requestBody = try req.decodeBody()
        let container = try await req.kernelDI(KernelWebFront.self).flows.updateContainer(
            id: containerId,
            from: requestBody,
            as: req.platformActor
        )
        return try await req.response.success.encode(container)
    }
    
    public func deleteContainerHandler(_ req: TypedRequest<DeleteContainerContext>) async throws -> Response {
        let containerId = try req.parameters.require("containerId", as: UUID.self)
        try await req.kernelDI(KernelWebFront.self).flows.deleteContainer(
            id: containerId,
            force: req.query.withDefault(\.force),
            as: req.platformActor
        )
        return try await req.response.success.encode(.init())
    }
}

extension KernelWebFront.Routes.Flows_v1_0 {
    public typealias CreateContainerContext = PostRouteContext<KernelWebFront.Model.Flows.CreateFlowContainerRequest, KernelWebFront.Model.Flows.FlowContainerResponse>
    public typealias GetContainerContext = GetRouteContext<KernelWebFront.Model.Flows.FlowContainerResponse>
    public typealias ListContainersContext = PaginatedGetRouteContext<KernelWebFront.Model.Flows.FlowContainerResponse>
    public typealias UpdateContainerContext = UpdateRouteContext<KernelWebFront.Model.Flows.UpdateFlowContainerRequest, KernelWebFront.Model.Flows.FlowContainerResponse>
    public typealias DeleteContainerContext = DeleteRouteContext<KernelSwiftCommon.Networking.HTTP.EmptyResponse>
}
