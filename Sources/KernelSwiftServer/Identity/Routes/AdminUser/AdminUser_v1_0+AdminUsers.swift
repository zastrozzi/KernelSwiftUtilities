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
    public func bootAdminUserRoutes(routes: TypedRoutesBuilder) throws {
        routes.post(use: createAdminUserHandler).summary("Create Admin User")
        routes.get(":adminUserId".parameterType(UUID.self), use: getAdminUserHandler).summary("Get Admin User")
        routes.get(use: listAdminUsersHandler).summary("List Admin Users")
        routes.put(":adminUserId".parameterType(UUID.self), use: updateAdminUserHandler).summary("Update Admin User")
        routes.delete(":adminUserId".parameterType(UUID.self), use: deleteAdminUserHandler).summary("Delete Admin User")
    }
}

extension KernelIdentity.Routes.AdminUser_v1_0 {
    public func createAdminUserHandler(_ req: TypedRequest<CreateAdminUserContext>) async throws -> Response {
        let requestBody = try req.decodeBody()
        let newAdminUser = try await req.kernelDI(KernelIdentity.self).adminUser.createAdminUser(from: requestBody, as: req.platformActor)
        return try await req.response.success.encode(newAdminUser.response())
    }
    
    public func getAdminUserHandler(_ req: TypedRequest<GetAdminUserContext>) async throws -> Response {
        let adminUserId = try req.parameters.require("adminUserId", as: UUID.self)
        let adminUser = try await req.kernelDI(KernelIdentity.self).adminUser.getAdminUser(id: adminUserId, as: req.platformActor)
        return try await req.response.success.encode(adminUser.response())
    }
    
    public func listAdminUsersHandler(_ req: TypedRequest<ListAdminUsersContext>) async throws -> Response {
        let pagedAdminUsers = try await req.kernelDI(KernelIdentity.self).adminUser.listAdminUsers(
            withPagination: req.decodeDefaultPagination(),
            dbCreatedAtFilters: req.query.dbCreatedAt,
            dbUpdatedAtFilters: req.query.dbUpdatedAt,
            dbDeletedAtFilters: req.query.dbDeletedAt,
            firstNameFilters: req.query.firstName,
            lastNameFilters: req.query.lastName,
            roleFilters: req.query.role,
            as: req.platformActor
        )
        return try await req.response.success.encode(pagedAdminUsers.paginatedResponse())
    }
    
    public func updateAdminUserHandler(_ req: TypedRequest<UpdateAdminUserContext>) async throws -> Response {
        let adminUserId = try req.parameters.require("adminUserId", as: UUID.self)
        let requestBody = try req.decodeBody()
        let adminUser = try await req.kernelDI(KernelIdentity.self).adminUser.updateAdminUser(id: adminUserId, from: requestBody, as: req.platformActor)
        return try await req.response.success.encode(adminUser.response())
    }
    
    public func deleteAdminUserHandler(_ req: TypedRequest<DeleteAdminUserContext>) async throws -> Response {
        let adminUserId = try req.parameters.require("adminUserId", as: UUID.self)
        try await req.kernelDI(KernelIdentity.self).adminUser.deleteAdminUser(id: adminUserId, force: req.query.withDefault(\.force), as: req.platformActor)
        return try await req.response.success.encode(.init())
    }
    
    
}

extension KernelIdentity.Routes.AdminUser_v1_0 {
    public typealias CreateAdminUserContext = PostRouteContext<KernelIdentity.Core.Model.CreateAdminUserRequest, KernelIdentity.Core.Model.AdminUserResponse>
    public typealias GetAdminUserContext = GetRouteContext<KernelIdentity.Core.Model.AdminUserResponse>
//    public typealias ListAdminUsersContext = PaginatedGetRouteContext<KernelIdentity.Core.Model.AdminUserResponse>
    
    public struct ListAdminUsersContext: DefaultPaginationRouteContextDecodable {
        public init() {}
        public let success: ResponseContext<KPPaginatedResponse<KernelIdentity.Core.Model.AdminUserResponse>> = .success(.ok)
        
        public let limit: QueryParam<Int> = .init(name: "limit", defaultValue: 30)
        public let offset: QueryParam<Int> = .init(name: "offset", defaultValue: 0)
        public let order: EnumQueryParam<KPPaginationOrder> = .init(name: "order", defaultValue: .init(.descending))
        public let orderBy: QueryParam<String> = .init(name: "order_by", defaultValue: "db_created_at")
        public let includeDeleted: QueryParam<Bool> = .init(name: "include_deleted", defaultValue: false)
        public let dbCreatedAt: DateFilterQueryParam = .init(name: "db_created_at")
        public let dbUpdatedAt: DateFilterQueryParam = .init(name: "db_updated_at")
        public let dbDeletedAt: DateFilterQueryParam = .init(name: "db_deleted_at")
        public let firstName: StringFilterQueryParam = .init(name: "first_name")
        public let lastName: StringFilterQueryParam = .init(name: "last_name")
        public let role: StringFilterQueryParam = .init(name: "role")
    }
    
    public typealias UpdateAdminUserContext = UpdateRouteContext<KernelIdentity.Core.Model.UpdateAdminUserRequest, KernelIdentity.Core.Model.AdminUserResponse>
    public typealias DeleteAdminUserContext = DeleteRouteContext<KernelSwiftCommon.Networking.HTTP.EmptyResponse>
}

