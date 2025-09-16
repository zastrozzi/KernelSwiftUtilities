//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 3/4/24.
//

import Vapor
import Fluent
import KernelSwiftCommon

extension KernelDI.Injector {
    public var sessionStoreService: KernelAuthSessions.Services.SessionStore {
        get { self[KernelAuthSessions.Services.SessionStore.Token.self] }
        set { self[KernelAuthSessions.Services.SessionStore.Token.self] = newValue }
    }
}

extension KernelAuthSessions.Services {
    public struct SessionStore: KernelDI.Injectable, Sendable {
        @KernelDI.Injected(\.vapor) var app: Application
        
        public init() {
            self.sessionCache = .init()
        }
        
        private let sessionCache: KernelServerPlatform.SimpleMemoryCache<KernelAuthSessions.Model.SessionID, KernelAuthSessions.Model.SessionData>
        
        public func createSession(
            _ data: KernelAuthSessions.Model.SessionData,
            for request: Request
        ) async throws -> KernelAuthSessions.Model.SessionID {
            let id = generateID()
            self.sessionCache.set(id, value: data)
            return try await request.eventLoop.makeSucceededFuture(id).get()
        }
        
        public func readSession(
            _ id: KernelAuthSessions.Model.SessionID,
            for request: Request
        ) async throws -> KernelAuthSessions.Model.SessionData? {
            let data = self.sessionCache.get(id)
            return try await request.eventLoop.makeSucceededFuture(data).get()
        }
        
        public func updateSession(
            _ id: KernelAuthSessions.Model.SessionID,
            data: KernelAuthSessions.Model.SessionData,
            for request: Request
        ) async throws -> KernelAuthSessions.Model.SessionID {
            self.sessionCache.set(id, value: data)
            return try await request.eventLoop.makeSucceededFuture(id).get()
        }
        
        public func deleteSession(
            _ id: KernelAuthSessions.Model.SessionID,
            for request: Request
        ) async throws -> Void {
            self.sessionCache.unset(id)
            return try await request.eventLoop.makeSucceededFuture(()).get()
        }
        
        private func generateID() -> KernelAuthSessions.Model.SessionID {
            return .init(string: UUID.generateRandom().uuidString)
        }
    }
}
