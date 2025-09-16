//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 19/06/2024.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelIdentity.Services.AuthService: AsyncMiddleware {
    public func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        guard let token = request.headers.bearerAuthorization?.token else {
            throw Abort(.unauthorized, reason: "No Auth Header")
        }
        
        do {
            request.authed = try KernelIdentity.Core.Model.AccessTokenPayload.verify(token, on: request.application)
        } catch {
            throw Abort(.unauthorized, reason: "Please try logging in again. If you're using biometric login, you may need to try again with your username and password.")
        }
        
        guard let authed = request.authed else { throw Abort(.unauthorized, reason: "Failed to find auth") }
        
        switch authed.platformRole {
        case .enduser:
            guard let _ = try await FluentModel.Enduser.find(authed.userId, on: request.db) else {
                throw Abort(.unauthorized, reason: "Enduser not recognised")
            }
            guard let device = try await FluentModel.EnduserDevice.find(authed.deviceId, on: request.db) else {
                throw Abort(.unauthorized, reason: "Device not recognised")
            }
            guard let deviceIdentifier = device.localDeviceIdentifier else { throw Abort(.unauthorized, reason: "Device not recognised") }
            guard deviceIdentifier == request.headers.localDeviceIdentifier else { throw Abort(.unauthorized, reason: "Device not recognised") }
            guard let session = try await FluentModel.EnduserSession.find(authed.sessionId, on: request.db) else {
                throw Abort(.unauthorized, reason: "Session not found")
            }
            guard session.isActive else { throw Abort(.unauthorized, reason: "Session has been logged out") }
            request.authedAsEnduser = true
            
            return try await next.respond(to: request)
            
        case .adminUser:
            guard let _ = try await FluentModel.AdminUser.find(authed.userId, on: request.db) else {
                throw Abort(.unauthorized, reason: "Admin User not recognised")
            }
            guard let device = try await FluentModel.AdminUserDevice.find(authed.deviceId, on: request.db) else {
                throw Abort(.unauthorized, reason: "Device not recognised")
            }
            guard let deviceIdentifier = device.localDeviceIdentifier else { throw Abort(.unauthorized, reason: "Device not recognised") }
            guard deviceIdentifier == request.headers.localDeviceIdentifier else { throw Abort(.unauthorized, reason: "Device not recognised") }
            guard let session = try await FluentModel.AdminUserSession.find(authed.sessionId, on: request.db) else {
                throw Abort(.unauthorized, reason: "Session not found")
            }
            guard session.isActive else { throw Abort(.unauthorized, reason: "Session has been logged out") }
            request.authedAsAdminUser = true
            
            return try await next.respond(to: request)
        }
    }
}
