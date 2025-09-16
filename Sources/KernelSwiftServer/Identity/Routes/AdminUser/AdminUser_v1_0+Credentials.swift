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
    public func bootCredentialRoutes(routes: TypedRoutesBuilder) throws {
        routes.get(":credentialId".parameterType(UUID.self), use: getCredentialHandler).summary("Get Admin User Credential")
        routes.get(use: listCredentialsHandler).summary("List Admin User Credentials")
        routes.put(":credentialId".parameterType(UUID.self), use: updateCredentialHandler).summary("Update Admin User Credential")
        routes.delete(":credentialId".parameterType(UUID.self), use: deleteCredentialHandler).summary("Delete Admin User Credential")
    }
    
    public func bootCredentialRoutesForAdminUser(routes: TypedRoutesBuilder) throws {
        routes.post(use: createCredentialHandler).summary("Create Admin User Credential")
        routes.get(use: listCredentialsHandler).summary("List Credentials for Admin User")
    }
}

extension KernelIdentity.Routes.AdminUser_v1_0 {
    public func createCredentialHandler(_ req: TypedRequest<CreateAdminUserCredentialContext>) async throws -> Response {
        let newCredential = try await req.kernelDI(KernelIdentity.self).adminUser.createCredential(
            forAdminUser: try req.parameters.require("adminUserId", as: UUID.self),
            from: try req.decodeBody(),
            as: req.platformActor
        )
        return try await req.response.success.encode(newCredential.response())
    }
    
    public func getCredentialHandler(_ req: TypedRequest<GetAdminUserCredentialContext>) async throws -> Response {
        let credentialId = try req.parameters.require("credentialId", as: UUID.self)
        let credential = try await req.kernelDI(KernelIdentity.self).adminUser.getCredential(id: credentialId, as: req.platformActor)
        return try await req.response.success.encode(credential.response())
    }
    
    public func listCredentialsHandler(_ req: TypedRequest<ListAdminUserCredentialsContext>) async throws -> Response {
        let pagedCredentials = try await req.kernelDI(KernelIdentity.self).adminUser
            .listCredentials(
                forAdminUser: req.parameters.get("adminUserId"),
                withPagination: req.decodeDefaultPagination(),
                dbCreatedAtFilters: req.query.dbCreatedAt,
                dbUpdatedAtFilters: req.query.dbUpdatedAt,
                dbDeletedAtFilters: req.query.dbDeletedAt,
                credentialTypeFilters: req.query.credentialType,
                isValid: req.query.isValid,
                as: req.platformActor
            )
        return try await req.response.success.encode(pagedCredentials.paginatedResponse())
    }
    
    public func updateCredentialHandler(_ req: TypedRequest<UpdateAdminUserCredentialContext>) async throws -> Response {
        let credentialId = try req.parameters.require("credentialId", as: UUID.self)
        let requestBody = try req.decodeBody()
        let credential = try await req.kernelDI(KernelIdentity.self).adminUser.updateCredential(id: credentialId, from: requestBody, as: req.platformActor)
        return try await req.response.success.encode(credential.response())
    }
    
    public func deleteCredentialHandler(_ req: TypedRequest<DeleteAdminUserCredentialContext>) async throws -> Response {
        let credentialId = try req.parameters.require("credentialId", as: UUID.self)
        try await req.kernelDI(KernelIdentity.self).adminUser.deleteCredential(id: credentialId, force: req.query.withDefault(\.force), as: req.platformActor)
        return try await req.response.success.encode(.init())
    }
}

extension KernelIdentity.Routes.AdminUser_v1_0 {
    public typealias CreateAdminUserCredentialContext = PostRouteContext<KernelIdentity.Core.Model.CreateAdminUserCredentialRequest, KernelIdentity.Core.Model.AdminUserCredentialResponse>
    public typealias GetAdminUserCredentialContext = GetRouteContext<KernelIdentity.Core.Model.AdminUserCredentialResponse>
    
    public struct ListAdminUserCredentialsContext: DefaultPaginationRouteContextDecodable {
        public init() {}
        public let success: ResponseContext<KPPaginatedResponse<KernelIdentity.Core.Model.AdminUserCredentialResponse>> = .success(.ok)
        
        public let limit: QueryParam<Int> = .init(name: "limit", defaultValue: 30)
        public let offset: QueryParam<Int> = .init(name: "offset", defaultValue: 0)
        public let order: EnumQueryParam<KPPaginationOrder> = .init(name: "order", defaultValue: .init(.descending))
        public let orderBy: QueryParam<String> = .init(name: "order_by", defaultValue: "db_created_at")
        public let includeDeleted: QueryParam<Bool> = .init(name: "include_deleted", defaultValue: false)
        public let dbCreatedAt: DateFilterQueryParam = .init(name: "db_created_at")
        public let dbUpdatedAt: DateFilterQueryParam = .init(name: "db_updated_at")
        public let dbDeletedAt: DateFilterQueryParam = .init(name: "db_deleted_at")
        public let credentialType: FluentEnumFilterQueryParam<KernelIdentity.Core.Model.CredentialType> = .init(name: "credential_type")
        public let isValid: QueryParam<Bool> = .init(name: "is_valid")
    }
    
    public typealias UpdateAdminUserCredentialContext = UpdateRouteContext<KernelIdentity.Core.Model.UpdateAdminUserCredentialRequest, KernelIdentity.Core.Model.AdminUserCredentialResponse>
    public typealias DeleteAdminUserCredentialContext = DeleteRouteContext<KernelSwiftCommon.Networking.HTTP.EmptyResponse>
}

