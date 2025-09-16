//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 23/08/2024.
//

import Vapor
import Fluent
import KernelSwiftCommon

extension KernelIdentity.Routes.Enduser_v1_0 {
    public func bootEnduserRoutes(routes: TypedRoutesBuilder) throws {
        routes.post(use: createEnduserHandler).summary("Create Enduser")
        routes.get(":enduserId".parameterType(UUID.self), use: getEnduserHandler).summary("Get Enduser")
        routes.get(use: listEndusersHandler).summary("List Endusers")
        routes.put(":enduserId".parameterType(UUID.self), use: updateEnduserHandler).summary("Update Enduser")
        routes.delete(":enduserId".parameterType(UUID.self), use: deleteEnduserHandler).summary("Delete Enduser")
    }
}

extension KernelIdentity.Routes.Enduser_v1_0 {
    public func createEnduserHandler(_ req: TypedRequest<CreateEnduserContext>) async throws -> Response {
        guard req.authedAsAdminUser else { throw Abort(.unauthorized, reason: "Insufficient permissions") }
        let requestBody = try req.decodeBody()
        let newEnduser = try await req.kernelDI(KernelIdentity.self).enduser.createEnduser(from: requestBody, as: req.platformActor)
        return try await req.response.success.encode(newEnduser.response())
    }
    
    public func getEnduserHandler(_ req: TypedRequest<GetEnduserContext>) async throws -> Response {
        let enduserId = try req.parameters.require("enduserId", as: UUID.self)
        if req.authedAsEnduser { guard req.authed?.userId == enduserId else { throw Abort(.unauthorized, reason: "Insufficient permissions") } }
        let enduser = try await req.kernelDI(KernelIdentity.self).enduser.getEnduser(id: enduserId, as: req.platformActor)
        return try await req.response.success.encode(enduser.response())
    }
    
    public func listEndusersHandler(_ req: TypedRequest<ListEndusersContext>) async throws -> Response {
        guard req.authedAsAdminUser else { throw Abort(.unauthorized, reason: "Insufficient permissions") }
        let pagedEndusers = try await req.kernelDI(KernelIdentity.self).enduser.listEndusers(withPagination: req.decodeDefaultPagination(), as: req.platformActor)
        return try await req.response.success.encode(pagedEndusers.paginatedResponse())
    }
    
    public func updateEnduserHandler(_ req: TypedRequest<UpdateEnduserContext>) async throws -> Response {
        let enduserId = try req.parameters.require("enduserId", as: UUID.self)
        if req.authedAsEnduser { guard req.authed?.userId == enduserId else { throw Abort(.unauthorized, reason: "Insufficient permissions") } }
        let requestBody = try req.decodeBody()
        let enduser = try await req.kernelDI(KernelIdentity.self).enduser.updateEnduser(id: enduserId, from: requestBody, as: req.platformActor)
        return try await req.response.success.encode(enduser.response())
    }
    
    public func deleteEnduserHandler(_ req: TypedRequest<DeleteEnduserContext>) async throws -> Response {
        let enduserId = try req.parameters.require("enduserId", as: UUID.self)
        if req.authedAsEnduser { guard req.authed?.userId == enduserId else { throw Abort(.unauthorized, reason: "Insufficient permissions") } }
        try await req.kernelDI(KernelIdentity.self).enduser.deleteEnduser(id: enduserId, force: req.query.withDefault(\.force), as: req.platformActor)
        return try await req.response.success.encode(.init())
    }
}

extension KernelIdentity.Routes.Enduser_v1_0 {
    public typealias CreateEnduserContext = PostRouteContext<KernelIdentity.Core.Model.CreateEnduserRequest, KernelIdentity.Core.Model.EnduserResponse>
    public typealias GetEnduserContext = GetRouteContext<KernelIdentity.Core.Model.EnduserResponse>
    public typealias ListEndusersContext = PaginatedGetRouteContext<KernelIdentity.Core.Model.EnduserResponse>
    public typealias UpdateEnduserContext = UpdateRouteContext<KernelIdentity.Core.Model.UpdateEnduserRequest, KernelIdentity.Core.Model.EnduserResponse>
    public typealias DeleteEnduserContext = DeleteRouteContext<KernelSwiftCommon.Networking.HTTP.EmptyResponse>
}
