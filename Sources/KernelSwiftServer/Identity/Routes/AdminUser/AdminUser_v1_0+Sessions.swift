//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 19/06/2024.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelIdentity.Routes.AdminUser_v1_0 {
    public func bootSessionRoutes(routes: TypedRoutesBuilder) throws {
        routes.get(":sessionId".parameterType(UUID.self), use: getSessionHandler).summary("Get Admin User Session")
        routes.get(use: listSessionsHandler).summary("List Admin User Sessions")
        routes.put(":sessionId".parameterType(UUID.self), "invalidate", use: invalidateSessionHandler).summary("Invalidate Admin User Session")
    }
    
    public func bootSessionRoutesForAdminUser(routes: TypedRoutesBuilder) throws {
        routes.get(use: listSessionsHandler).summary("List Sessions for Admin User")
    }
}

extension KernelIdentity.Routes.AdminUser_v1_0 {
    public func getSessionHandler(_ req: TypedRequest<GetAdminUserSessionContext>) async throws -> Response {
        let sessionId = try req.parameters.require("sessionId", as: UUID.self)
        let session = try await req.kernelDI(KernelIdentity.self).adminUser.getSession(id: sessionId, as: req.platformActor)
        return try await req.response.success.encode(session.response())
    }
    
    public func listSessionsHandler(_ req: TypedRequest<ListAdminUserSessionsContext>) async throws -> Response {
        let pagedSessions = try await req.kernelDI(KernelIdentity.self).adminUser
            .listSessions(
                forAdminUser: req.parameters.get("adminUserId"),
                withPagination: req.decodeDefaultPagination(),
                dbCreatedAtFilters: req.query.dbCreatedAt,
                dbUpdatedAtFilters: req.query.dbUpdatedAt,
                dbDeletedAtFilters: req.query.dbDeletedAt,
                isActive: req.query.isActive,
                as: req.platformActor
            )
        return try await req.response.success.encode(pagedSessions.paginatedResponse())
    }
    
    public func invalidateSessionHandler(_ req: TypedRequest<InvalidateAdminUserSessionContext>) async throws -> Response {
        let sessionId = try req.parameters.require("sessionId", as: UUID.self)
        let session = try await req.kernelDI(KernelIdentity.self).adminUser.updateSession(id: sessionId, isActive: false, as: req.platformActor)
        return try await req.response.success.encode(session.response())
    }
}

extension KernelIdentity.Routes.AdminUser_v1_0 {
    public typealias GetAdminUserSessionContext = GetRouteContext<KernelIdentity.Core.Model.AdminUserSessionResponse>
    
    public struct ListAdminUserSessionsContext: DefaultPaginationRouteContextDecodable {
        public init() {}
        public let success: ResponseContext<KPPaginatedResponse<KernelIdentity.Core.Model.AdminUserSessionResponse>> = .success(.ok)
        
        public let limit: QueryParam<Int> = .init(name: "limit", defaultValue: 30)
        public let offset: QueryParam<Int> = .init(name: "offset", defaultValue: 0)
        public let order: EnumQueryParam<KPPaginationOrder> = .init(name: "order", defaultValue: .init(.descending))
        public let orderBy: QueryParam<String> = .init(name: "order_by", defaultValue: "db_created_at")
        public let includeDeleted: QueryParam<Bool> = .init(name: "include_deleted", defaultValue: false)
        public let dbCreatedAt: DateFilterQueryParam = .init(name: "db_created_at")
        public let dbUpdatedAt: DateFilterQueryParam = .init(name: "db_updated_at")
        public let dbDeletedAt: DateFilterQueryParam = .init(name: "db_deleted_at")
        public let isActive: QueryParam<Bool> = .init(name: "is_active")
    }
    
    public typealias InvalidateAdminUserSessionContext = UpdateRouteContext<KernelSwiftCommon.Networking.HTTP.EmptyRequest, KernelIdentity.Core.Model.AdminUserSessionResponse>
}

