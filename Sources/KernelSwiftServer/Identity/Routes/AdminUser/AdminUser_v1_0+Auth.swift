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
    public func bootAdminUserAuthRoutes(routes: TypedRoutesBuilder) throws {
        routes.post("login", use: loginAdminUserHandler).summary("Login Admin User")
    }
    
    public func bootAccessTokenProtectedAuthRoutes(routes: TypedRoutesBuilder) throws {
        routes.post("logout", use: logoutAdminUserHandler).summary("Logout Admin User")
    }
    
    public func bootRefreshTokenProtectedAuthRoutes(routes: TypedRoutesBuilder) throws {
        routes.post("refresh-token", use: refreshAdminUserTokenHandler).summary("Refresh Admin User Token")
    }
}

extension KernelIdentity.Routes.AdminUser_v1_0 {
    public func loginAdminUserHandler(_ req: TypedRequest<LoginAdminUserContext>) async throws -> Response {
        let requestBody = try req.decodeBody()
        let authedAdminUser = try await req.kernelDI(KernelIdentity.self).adminUser.loginUser(
            credentials: requestBody,
            localDeviceIdentifier: req.headers.get(.xLocalDeviceIdentifier),
            as: .system
        )
        return try await req.response.success.encode(authedAdminUser)
    }
    
    public func refreshAdminUserTokenHandler(_ req: TypedRequest<RefreshAdminUserTokenContext>) async throws -> Response {
        let requestBody = try req.decodeBody()
        let reauthedAdminUser = try await req.kernelDI(KernelIdentity.self).adminUser.refreshUserToken(
            refreshToken: requestBody.refreshToken,
            localDeviceIdentifier: req.headers.get(.xLocalDeviceIdentifier),
            as: .system
        )
        return try await req.response.success.encode(reauthedAdminUser)
    }
    
    public func logoutAdminUserHandler(_ req: TypedRequest<LogoutAdminUserContext>) async throws -> Response {
        guard let sessionId = req.authed?.sessionId else { throw Abort(.unauthorized, reason: "no user id") }
        try await req.kernelDI(KernelIdentity.self).adminUser.logoutUser(
            sessionId: sessionId,
            deviceSet: req.query.devices,
            as: req.platformActor
        )
        return try await req.response.success.encode(.init())
    }
}

extension KernelIdentity.Routes.AdminUser_v1_0 {
    public typealias LoginAdminUserContext = PostRouteContext<
        KernelIdentity.Core.Model.LoginAdminUserEmailPasswordRequest,
        KernelIdentity.Core.Model.AuthedUserResponse<KernelIdentity.Core.Model.AdminUserResponse>
    >
    
    public typealias RefreshAdminUserTokenContext = PostRouteContext<
        KernelIdentity.Core.Model.RefreshAdminUserTokenRequest,
        KernelIdentity.Core.Model.AuthedUserResponse<KernelIdentity.Core.Model.AdminUserResponse>
    >
    
    public struct LogoutAdminUserContext: RouteContext {
        public init() {}
        public var success: ResponseContext<KernelSwiftCommon.Networking.HTTP.EmptyResponse> = .success(.ok)
        public var devices: QueryParam<KernelIdentity.Core.Model.DeviceSet> = .init(name: "devices")
    }
}
