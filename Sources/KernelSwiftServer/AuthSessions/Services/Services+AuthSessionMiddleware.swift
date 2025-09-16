//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 6/4/24.
//

import Vapor
import Fluent
import KernelSwiftCommon

extension KernelAuthSessions.Services {
    public struct AuthSessionMiddleware: AsyncMiddleware, Sendable {
        @KernelDI.Injected(\.sessionStoreService) var sessionStore: SessionStore
        let cookieConfig: KernelAuthSessions.Model.CookieConfiguration
        
        public init(
            cookieConfig: KernelAuthSessions.Model.CookieConfiguration = .default()
        ) {
            self.cookieConfig = cookieConfig
        }
        
        public func respond(
            to request: Request,
            chainingTo next: any AsyncResponder
        ) async throws -> Response {
            request._authSessionCache.middlewareFlag.withLockedValue { $0 = true }
            if let cookie = request.cookies[cookieConfig.name] {
                let id: KernelAuthSessions.Model.SessionID = .init(string: cookie.string)
                if let sessionData = try await sessionStore.readSession(id, for: request) {
                    request._authSessionCache.session.withLockedValue { $0 = .init(id: id, data: sessionData) }
                } else {
                    request._authSessionCache.session.withLockedValue { $0 = .init() }
                }
                let response = try await next.respond(to: request)
                return try await addCookies(to: response, for: request)
            }
            let response = try await next.respond(to: request)
            return try await addCookies(to: response, for: request)
        }
        
        private func addCookies(
            to response: Response,
            for request: Request
        ) async throws -> Response {
            if
                let session = request._authSessionCache.session.withLockedValue({ $0 }),
                session.isValid.withLockedValue({ $0 })
            {
                let upsertId: KernelAuthSessions.Model.SessionID
                if let id = session.id {
                    upsertId = try await sessionStore.updateSession(id, data: session.data, for: request)
//                    KernelAuthSessions.logger.debug("Updating cookie")
                } else {
                    upsertId = try await sessionStore.createSession(session.data, for: request)
//                    KernelAuthSessions.logger.debug("Creating cookie")
                }
                
                response.cookies[cookieConfig.name] = cookieConfig.factory(upsertId)
                
                return response
            } else if let cookie = request.cookies[cookieConfig.name] {
                let id: KernelAuthSessions.Model.SessionID = .init(string: cookie.string)
                try await sessionStore.deleteSession(id, for: request)
                response.cookies[cookieConfig.name] = .expired
//                KernelAuthSessions.logger.debug("Expiring cookie")
                return response
            } else {
//                KernelAuthSessions.logger.debug("Not adding cookie")
                return response
            }
        }
    }
}
