//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 10/09/2023.
//

import Foundation
import OSLog
import SwiftUI
import Collections
import KernelSwiftCommon

extension KernelDI.Injector {
    @available(iOS 17.0, macOS 14.0, *)
    public var oidcAuthService: KernelAppUtils.OIDC.AuthenticationService {
        get { self[KernelAppUtils.OIDC.AuthenticationService.Token.self] }
        set { self[KernelAppUtils.OIDC.AuthenticationService.Token.self] = newValue }
    }
}

extension KernelAppUtils.OIDC {
    @Observable
    @available(iOS 17.0, macOS 14.0, *)
    public final class AuthenticationService: KernelDI.Injectable, Sendable {
        @ObservationIgnored private let clientsCache: KernelAppUtils.SimpleMemoryCache<String, OIDCClient> = .init()
        
        public var clients: [OIDCClient] {
            get {
                self.access(keyPath: \.clients)
                return clientsCache.all()
            }
            set {}
        }
        
        required public init() {}
        
        public func createClient(clientId: String) async throws {
            KernelAppUtils.OIDC.logger.debug("Creating Auth Client", metadata: ["clientId": .stringConvertible(clientId)])
            guard !clientsCache.has(clientId) else { throw TypedError(.clientAlreadyExists) }
//            let newClient: OIDCClient = .init(clientId: clientId)
//            withAnimation(.smooth) {
            _ = try self.withMutation(keyPath: \.clients) {
                try MainActor.assumeIsolated {
                    clientsCache.set(clientId, value: try .init(clientId: clientId))
                }
            }
            
//            }
//            access(keyPath: \.clients)
            KernelAppUtils.OIDC.logger.debug("Created Auth Client", metadata: ["clientId": .stringConvertible(clientId)])
        }
        
        public func removeClient(clientId: String) {
            self.withMutation(keyPath: \.clients) {
                clientsCache.unset(clientId)
                KernelAppUtils.OIDC.logger.debug("Removed Auth Client", metadata: ["clientId": .stringConvertible(clientId)])
            }
        }
        
        public func printClientStatuses() {
            clients.forEach { client in
                MainActor.assumeIsolated {
                    KernelAppUtils.OIDC.logger.debug("Client Status \(client.id) \(client.status)")
                }
                
            }
        }
        
        
    }
}
