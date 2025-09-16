//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 27/10/2022.
//

import Foundation
import Fluent
import Vapor

public final class PlatformApplicationConfigMiddleware: AsyncMiddleware {
    public func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
//        guard let applicationId = request.headers.platformApplicationId else {
//            throw Abort(.badRequest, reason: "Missing Platform Application Header")
//        }
        
//        let activePlatformApplication = try await request.application.platformApplicationService.getPlatformApplicationDetails(applicationId: applicationId)
//        request.activePlatformApplicationId = activePlatformApplication.id
        return try await next.respond(to: request)
    }
}

public final class PlatformAdminAccessMiddleware: AsyncMiddleware {
    public func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        guard let accessKey = request.headers.platformAdminAccessKey else { throw Abort(.unauthorized, reason: "These are not the droids you're looking for") }
        guard let envAccessKey = Environment.get("PLATFORM_ACCESS_KEY") else { throw Abort(.internalServerError, reason: "Missing Platform Access Key") }
        guard accessKey == envAccessKey else { throw Abort(.unauthorized, reason: "May the force be with you") }
        return try await next.respond(to: request)
    }
}

extension HTTPHeaders {
    public var platformApplicationId: UUID? {
        get {
            guard let uuidStr = self.first(name: .xKernelPlatformApplication) else { return nil }
            guard let uuid = UUID(uuidString: uuidStr) else { return nil }
            return uuid
        }
        set {
            if let uuid = newValue {
                replaceOrAdd(name: .xKernelPlatformApplication, value: uuid.uuidString)
            } else {
                remove(name: .xKernelPlatformApplication)
            }
        }
    }
    
    public var platformApplicationInterfaceId: UUID? {
        get {
            guard let uuidStr = self.first(name: .xKernelPlatformApplicationInterface) else { return nil }
            guard let uuid = UUID(uuidString: uuidStr) else { return nil }
            return uuid
        }
        set {
            if let uuid = newValue {
                replaceOrAdd(name: .xKernelPlatformApplicationInterface, value: uuid.uuidString)
            } else {
                remove(name: .xKernelPlatformApplicationInterface)
            }
        }
    }
    
    public var platformAdminAccessKey: String? {
        get {
            guard let str = self.first(name: .xKernelPlatformAdminAccessKey) else { return nil }
            return str
        }
        set {
            if let str = newValue {
                replaceOrAdd(name: .xKernelPlatformAdminAccessKey, value: str)
            } else {
                remove(name: .xKernelPlatformAdminAccessKey)
            }
        }
    }
}

extension HTTPHeaders.Name {
    public static let xKernelPlatformApplication = HTTPHeaders.Name.init("X-Kernel-Platform-Application")
    public static let xKernelPlatformApplicationInterface = HTTPHeaders.Name.init("X-Kernel-Platform-Application-Interface")
    public static let xKernelPlatformAdminAccessKey = HTTPHeaders.Name.init("X-Kernel-Platform-Admin-Access-Key")
}

extension Request {
    var activePlatformApplicationId: UUID? {
        get { self.storage[ActivePlatformApplicationIdKey.self] ?? nil }
        set { self.storage[ActivePlatformApplicationIdKey.self] = newValue }
    }
}

struct ActivePlatformApplicationIdKey: StorageKey {
    typealias Value = UUID?
}
