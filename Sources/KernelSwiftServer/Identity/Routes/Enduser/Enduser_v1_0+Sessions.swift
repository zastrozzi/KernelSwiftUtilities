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
    public func bootSessionRoutes(routes: TypedRoutesBuilder) throws {
        routes.get(":sessionId".parameterType(UUID.self), use: getSessionHandler).summary("Get Enduser Session")
        routes.get(use: listSessionsHandler).summary("List Enduser Sessions")
        routes.put(":sessionId".parameterType(UUID.self), "invalidate", use: invalidateSessionHandler).summary("Invalidate Enduser Session")
    }
    
    public func bootSessionRoutesForEnduser(routes: TypedRoutesBuilder) throws {
        routes.get(use: listSessionsHandler).summary("List Sessions for Enduser")
    }
}

extension KernelIdentity.Routes.Enduser_v1_0 {
    public func getSessionHandler(_ req: TypedRequest<GetEnduserSessionContext>) async throws -> Response {
        let sessionId = try req.parameters.require("sessionId", as: UUID.self)
        let session = try await req.kernelDI(KernelIdentity.self).enduser.getSession(id: sessionId, as: req.platformActor)
        return try await req.response.success.encode(session.response())
    }
    
    public func listSessionsHandler(_ req: TypedRequest<ListEnduserSessionsContext>) async throws -> Response {
        let pagedSessions = try await req.kernelDI(KernelIdentity.self).enduser
            .listSessions(
                forEnduser: req.parameters.get("enduserId"),
                withPagination: req.decodeDefaultPagination(),
                as: req.platformActor
            )
        return try await req.response.success.encode(pagedSessions.paginatedResponse())
    }
    
    public func invalidateSessionHandler(_ req: TypedRequest<InvalidateEnduserSessionContext>) async throws -> Response {
        let sessionId = try req.parameters.require("sessionId", as: UUID.self)
        let session = try await req.kernelDI(KernelIdentity.self).enduser.updateSession(id: sessionId, isActive: false, as: req.platformActor)
        return try await req.response.success.encode(session.response())
    }
}

extension KernelIdentity.Routes.Enduser_v1_0 {
    public typealias GetEnduserSessionContext = GetRouteContext<KernelIdentity.Core.Model.EnduserSessionResponse>
    public typealias ListEnduserSessionsContext = PaginatedGetRouteContext<KernelIdentity.Core.Model.EnduserSessionResponse>
    public typealias InvalidateEnduserSessionContext = UpdateRouteContext<KernelSwiftCommon.Networking.HTTP.EmptyRequest, KernelIdentity.Core.Model.EnduserSessionResponse>
}
