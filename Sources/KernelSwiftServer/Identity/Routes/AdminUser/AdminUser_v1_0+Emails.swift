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
    public func bootEmailRoutes(routes: TypedRoutesBuilder) throws {
        routes.get(":emailId".parameterType(UUID.self), use: getEmailHandler).summary("Get Admin User Email")
        routes.get(use: listEmailsHandler).summary("List Admin User Emails")
        routes.put(":emailId".parameterType(UUID.self), use: updateEmailHandler).summary("Update Admin User Email")
        routes.delete(":emailId".parameterType(UUID.self), use: deleteEmailHandler).summary("Delete Admin User Email")
    }
    
    public func bootEmailRoutesForAdminUser(routes: TypedRoutesBuilder) throws {
        routes.post(use: createEmailHandler).summary("Create Admin User Email")
        routes.get(use: listEmailsHandler).summary("List Emails for Admin User")
    }
}

extension KernelIdentity.Routes.AdminUser_v1_0 {
    public func createEmailHandler(_ req: TypedRequest<CreateAdminUserEmailContext>) async throws -> Response {
        let newEmail = try await req.kernelDI(KernelIdentity.self).adminUser.createEmail(
            forAdminUser: try req.parameters.require("adminUserId", as: UUID.self),
            from: try req.decodeBody(),
            as: req.platformActor
        )
        return try await req.response.success.encode(newEmail.response())
    }
    
    public func getEmailHandler(_ req: TypedRequest<GetAdminUserEmailContext>) async throws -> Response {
        let emailId = try req.parameters.require("emailId", as: UUID.self)
        let email = try await req.kernelDI(KernelIdentity.self).adminUser.getEmail(id: emailId, as: req.platformActor)
        return try await req.response.success.encode(email.response())
    }
    
    public func listEmailsHandler(_ req: TypedRequest<ListAdminUserEmailsContext>) async throws -> Response {
        let adminUserId = req.parameters.get("adminUserId", as: UUID.self)
        let pagedEmails = try await req.kernelDI(KernelIdentity.self).adminUser.listEmails(
            forAdminUser: adminUserId,
            withPagination: req.decodeDefaultPagination(),
            dbCreatedAtFilters: req.query.dbCreatedAt,
            dbUpdatedAtFilters: req.query.dbUpdatedAt,
            dbDeletedAtFilters: req.query.dbDeletedAt,
            emailAddressValueFilters: req.query.emailAddressValue,
            isVerified: req.query.isVerified,
            as: req.platformActor
        )
        return try await req.response.success.encode(pagedEmails.paginatedResponse())
    }
    
    public func updateEmailHandler(_ req: TypedRequest<UpdateAdminUserEmailContext>) async throws -> Response {
        let emailId = try req.parameters.require("emailId", as: UUID.self)
        let requestBody = try req.decodeBody()
        let email = try await req.kernelDI(KernelIdentity.self).adminUser.updateEmail(id: emailId, from: requestBody, as: req.platformActor)
        return try await req.response.success.encode(email.response())
    }
    
    public func deleteEmailHandler(_ req: TypedRequest<DeleteAdminUserEmailContext>) async throws -> Response {
        let emailId = try req.parameters.require("emailId", as: UUID.self)
        try await req.kernelDI(KernelIdentity.self).adminUser.deleteEmail(id: emailId, force: req.query.withDefault(\.force), as: req.platformActor)
        return try await req.response.success.encode(.init())
    }
}

extension KernelIdentity.Routes.AdminUser_v1_0 {
    public typealias CreateAdminUserEmailContext = PostRouteContext<KernelIdentity.Core.Model.CreateAdminUserEmailRequest, KernelIdentity.Core.Model.AdminUserEmailResponse>
    public typealias GetAdminUserEmailContext = GetRouteContext<KernelIdentity.Core.Model.AdminUserEmailResponse>
    
    public struct ListAdminUserEmailsContext: DefaultPaginationRouteContextDecodable {
        public init() {}
        public let success: ResponseContext<KPPaginatedResponse<KernelIdentity.Core.Model.AdminUserEmailResponse>> = .success(.ok)
        
        public let limit: QueryParam<Int> = .init(name: "limit", defaultValue: 30)
        public let offset: QueryParam<Int> = .init(name: "offset", defaultValue: 0)
        public let order: EnumQueryParam<KPPaginationOrder> = .init(name: "order", defaultValue: .init(.descending))
        public let orderBy: QueryParam<String> = .init(name: "order_by", defaultValue: "db_created_at")
        public let includeDeleted: QueryParam<Bool> = .init(name: "include_deleted", defaultValue: false)
        public let dbCreatedAt: DateFilterQueryParam = .init(name: "db_created_at")
        public let dbUpdatedAt: DateFilterQueryParam = .init(name: "db_updated_at")
        public let dbDeletedAt: DateFilterQueryParam = .init(name: "db_deleted_at")
        public let emailAddressValue: StringFilterQueryParam = .init(name: "email_address")
        public let isVerified: QueryParam<Bool> = .init(name: "is_verified")
    }
    
    public typealias UpdateAdminUserEmailContext = UpdateRouteContext<KernelIdentity.Core.Model.UpdateAdminUserEmailRequest, KernelIdentity.Core.Model.AdminUserEmailResponse>
    public typealias DeleteAdminUserEmailContext = DeleteRouteContext<KernelSwiftCommon.Networking.HTTP.EmptyResponse>
}

