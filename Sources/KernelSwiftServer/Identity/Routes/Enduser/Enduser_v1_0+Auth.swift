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
    public func bootEnduserAuthRoutes(routes: TypedRoutesBuilder) throws {
        routes.post("login", use: loginEnduserHandler).summary("Login Enduser")
        routes.post("register", use: registerEnduserHandler).summary("Register Enduser")
    }
    
    public func bootAccessTokenProtectedAuthRoutes(routes: TypedRoutesBuilder) throws {
        routes.post("logout", use: logoutEnduserHandler).summary("Logout Enduser")
    }
    
    public func bootRefreshTokenProtectedAuthRoutes(routes: TypedRoutesBuilder) throws {
        routes.post("refresh-token", use: refreshEnduserTokenHandler).summary("Refresh Enduser Token")
    }
}

extension KernelIdentity.Routes.Enduser_v1_0 {
    public func loginEnduserHandler(_ req: TypedRequest<LoginEnduserContext>) async throws -> Response {
        let requestBody = try req.decodeBody()
        let authedEnduser = try await req.kernelDI(KernelIdentity.self).enduser.loginUser(
            credentials: requestBody,
            localDeviceIdentifier: req.headers.get(.xLocalDeviceIdentifier),
            as: .system
        )
        return try await req.response.success.encode(authedEnduser)
    }
    
    public func registerEnduserHandler(_ req: TypedRequest<RegisterEnduserContext>) async throws -> Response {
        let requestBody = try req.decodeBody()
        let newEnduser = try await req.kernelDI(KernelIdentity.self).enduser.registerUser(
            from: requestBody,
            localDeviceIdentifier: req.headers.get(.xLocalDeviceIdentifier),
            as: .system
        )
        return try await req.response.success.encode(newEnduser)
    }
    
    public func refreshEnduserTokenHandler(_ req: TypedRequest<RefreshEnduserTokenContext>) async throws -> Response {
        let requestBody = try req.decodeBody()
        let reauthedEnduser = try await req.kernelDI(KernelIdentity.self).enduser.refreshUserToken(
            refreshToken: requestBody.refreshToken,
            localDeviceIdentifier: req.headers.get(.xLocalDeviceIdentifier),
            as: .system
        )
        return try await req.response.success.encode(reauthedEnduser)
    }
    
    public func logoutEnduserHandler(_ req: TypedRequest<LogoutEnduserContext>) async throws -> Response {
        guard let sessionId = req.authed?.sessionId else { throw Abort(.unauthorized, reason: "no user id") }
        try await req.kernelDI(KernelIdentity.self).enduser.logoutUser(
            sessionId: sessionId,
            deviceSet: req.query.devices,
            as: req.platformActor
        )
        return try await req.response.success.encode(.init())
    }
}

extension KernelIdentity.Routes.Enduser_v1_0 {
    public typealias LoginEnduserContext = PostRouteContext<
        KernelIdentity.Core.Model.LoginEnduserEmailPasswordRequest,
        KernelIdentity.Core.Model.AuthedUserResponse<KernelIdentity.Core.Model.EnduserResponse>
    >
    
    public typealias RegisterEnduserContext = PostRouteContext<
        KernelIdentity.Core.Model.CreateEnduserRequest,
        KernelIdentity.Core.Model.AuthedUserResponse<KernelIdentity.Core.Model.EnduserResponse>
    >
    
    public typealias RefreshEnduserTokenContext = PostRouteContext<
        KernelIdentity.Core.Model.RefreshEnduserTokenRequest,
        KernelIdentity.Core.Model.AuthedUserResponse<KernelIdentity.Core.Model.EnduserResponse>
    >
    
    public struct LogoutEnduserContext: RouteContext {
        public init() {}
        public var success: ResponseContext<KernelSwiftCommon.Networking.HTTP.EmptyResponse> = .success(.ok)
        public var devices: QueryParam<KernelIdentity.Core.Model.DeviceSet> = .init(name: "devices")
    }
}
