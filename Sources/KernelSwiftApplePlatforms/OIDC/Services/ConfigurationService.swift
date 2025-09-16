//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 08/09/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelDI.Injector {
    @available(iOS 17.0, macOS 14.0, *)
    public var oidcConfigService: KernelAppUtils.OIDC.ConfigurationService {
        get { self[KernelAppUtils.OIDC.ConfigurationService.Token.self] }
        set { self[KernelAppUtils.OIDC.ConfigurationService.Token.self] = newValue }
    }
}

extension KernelAppUtils.OIDC {
    @Observable
    @available(iOS 17.0, macOS 14.0, *)
    public class ConfigurationService: KernelDI.Injectable, @unchecked Sendable {
        
//        @ObservationIgnored
        private var storage: KernelAppUtils.SimpleMemoryCache<String, OIDCClientConfiguration> = .init()
        
        required public init() {}
        
        public func loadConfiguration(_ clientConfiguration: OIDCClientConfiguration) async throws {
            logger.debug("Loading Configuration \(clientConfiguration.clientId)")
            guard !storage.has(clientConfiguration.clientId) else { throw TypedError(.clientAlreadyExists) }
            storage.set(clientConfiguration.clientId, value: clientConfiguration)
            try await KernelDI.inject(\.oidcDiscoveryService).fetchDiscoveryDocument(for: clientConfiguration.wellKnownResourceIdentifier, forceRefresh: false)
            let scopesSupported = try KernelDI.inject(\.oidcDiscoveryService).getDiscoveryDocumentValue(for: clientConfiguration.wellKnownResourceIdentifier, keyPath: \OIDCProviderMetadata.scopesSupported)
            let responseTypesSupported = try KernelDI.inject(\.oidcDiscoveryService).getDiscoveryDocumentValue(for: clientConfiguration.wellKnownResourceIdentifier, keyPath: \OIDCProviderMetadata.responseTypesSupported)
            if let scopesSupported {
                guard scopesSupported.contains(clientConfiguration.scope.value) else { throw TypedError(.scopesNotSupported) }
            } else {
                logger.warning("Supported Scopes not defined in Discovery Document")
            }
            guard responseTypesSupported.contains(clientConfiguration.responseType) else { throw TypedError(.responseTypeNotSupported) }
            
            logger.debug("Loaded Configuration \(clientConfiguration.clientId)")
            try await KernelDI.inject(\.oidcAuthService).createClient(clientId: clientConfiguration.clientId)
        }
        
        public func loadConfigurations(_ configurations: OIDCClientConfiguration...) async throws {
            try await configurations.asyncForEach { configuration in
                try await loadConfiguration(configuration)
            }
        }
        
        public func clearConfiguration(clientId: String) {
            storage.unset(clientId)
            KernelDI.inject(\.oidcAuthService).removeClient(clientId: clientId)
        }
        
        public func clearAllConfigurations() {
            storage.keys().forEach {
                clearConfiguration(clientId: $0)
            }
        }
        
        public func getConfigurationValue<V>(for id: String, _ path: KeyPath<OIDCClientConfiguration, V>) throws -> V {
            guard let config = storage.get(id) else { throw TypedError(.configurationMissing) }
            return config[keyPath: path]
        }
        
        public func getConfigurationValue<V>(for id: String, _ path: KeyPath<OIDCClientConfiguration, V?>, fallback: KeyPath<OIDCClientConfiguration, V>) throws -> V {
            guard let config = storage.get(id) else { throw TypedError(.configurationMissing) }
            if let value = config[keyPath: path] { return value }
            else { return config[keyPath: fallback] }
        }
    }
}
