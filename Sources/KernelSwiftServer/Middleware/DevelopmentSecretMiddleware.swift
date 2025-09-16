//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 21/10/2024.
//

import Vapor
import KernelSwiftCommon

public struct DevelopmentSecretMiddleware: AsyncMiddleware {
    public func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        guard let platformDevelopmentSecretHeader = request.headers.first(name: .xPlatformDevelopmentSecret) else { throw Abort(.unauthorized, reason: "These are not the droids you're looking for") }
        guard let envPlatformDevelopmentSecret = Environment.get("PLATFORM_DEVELOPMENT_SECRET") else { throw Abort(.internalServerError, reason: "Missing Development Secret Environment Variable") }
        guard platformDevelopmentSecretHeader == envPlatformDevelopmentSecret, !envPlatformDevelopmentSecret.isEmpty else { throw Abort(.unauthorized, reason: "These are not the droids you're looking for") }
        return try await next.respond(to: request)
    }
}

extension HTTPHeaders.Name {
    public static let xPlatformDevelopmentSecret = HTTPHeaders.Name.init("X-Platform-Development-Secret")
}

extension Application {
    public struct DevelopmentSecretMiddlewareStorageKey: StorageKey {
        public typealias Value = DevelopmentSecretMiddleware
    }

    public var developmentSecretMiddleware: DevelopmentSecretMiddleware {
        get {
            guard let middleware = storage[DevelopmentSecretMiddlewareStorageKey.self] else {
                let newMiddleware = DevelopmentSecretMiddleware()
                storage[DevelopmentSecretMiddlewareStorageKey.self] = newMiddleware
                return newMiddleware
            }
            return middleware
        }
    }
    
    public func developmentSecretProtectedRoutes() -> TypedRoutesBuilder {
        self.grouped(developmentSecretMiddleware).typeGrouped().headers(.xPlatformDevelopmentSecret)
    }
}

extension TypedRoutesBuilder {
    public func developmentSecretProtectedRoutes() -> TypedRoutesBuilder {
        let middleware = KernelDI.inject(\.vapor).developmentSecretMiddleware
        return self.grouped(middleware).typeGrouped().headers(.xPlatformDevelopmentSecret)
    }
}
