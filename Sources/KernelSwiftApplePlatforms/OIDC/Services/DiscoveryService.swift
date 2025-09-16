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
    public var oidcDiscoveryService: KernelAppUtils.OIDC.DiscoveryService {
        get { self[KernelAppUtils.OIDC.DiscoveryService.Token.self] }
        set { self[KernelAppUtils.OIDC.DiscoveryService.Token.self] = newValue }
    }
}


extension KernelAppUtils.OIDC {
    @Observable
    @available(iOS 17.0, macOS 14.0, *)
    public class DiscoveryService: KernelDI.Injectable, @unchecked Sendable {
        @ObservationIgnored
        private var storage: KernelAppUtils.LabelledMemoryCache<WellKnownResourceIdentifier> = .init()
        
        @ObservationIgnored @KernelDI.Injected(\.oidcConfigService)
        private var configService
        
        required public init() {}
        
        public func fetchDiscoveryDocument(for resource: WellKnownResourceIdentifier, forceRefresh: Bool = false) async throws {
            guard forceRefresh || !storage.has(resource) else {
                KernelAppUtils.logger.debug("Discovery Document \(resource.label) already in cache")
                return
            }
            KernelAppUtils.logger.debug("Fetching Discovery Document \(resource.label)")
            guard let url = URL(string: resource.label) else { throw URLError(.badURL) }
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let metadata = try decoder.decode(resource.documentType, from: data)
            storage.set(resource, value: metadata)
            KernelAppUtils.logger.debug("Fetched Discovery Document \(resource.label)")
        }
        
        public func getDiscoveryDocument(for resource: WellKnownResourceIdentifier) async throws -> some Sendable {
            if let document = storage.get(resource) { return document }
            else {
                try await fetchDiscoveryDocument(for: resource)
                guard let document = storage.get(resource) else { throw KernelAppUtils.OIDC.TypedError(.discoveryDocumentMissing) }
                return document
            }
        }
        
        public func getDiscoveryDocumentValue<D, V>(for resource: WellKnownResourceIdentifier, keyPath: KeyPath<D, V?>) throws -> V? {
            guard let document = storage.get(resource) as? D else { return nil }
            if let value = document[keyPath: keyPath] {
                return value
            } else {
                return nil
            }
        }
        
        public func getDiscoveryDocumentValue<D, V>(for resource: WellKnownResourceIdentifier, keyPath: KeyPath<D, V>) throws -> V {
            guard let document = storage.get(resource) as? D else { throw TypedError(.discoveryDocumentMissing) }
            return document[keyPath: keyPath]
        }
        
        public func getDiscoveryDocumentValue<D, V>(forClient clientId: String, keyPath: KeyPath<D, V?>) throws -> V? {
            let resource = try configService.getConfigurationValue(for: clientId, \.wellKnownResourceIdentifier)
            return try getDiscoveryDocumentValue(for: resource, keyPath: keyPath)
        }
        
        public func getDiscoveryDocumentValue<D, V>(forClient clientId: String, keyPath: KeyPath<D, V>) throws -> V {
            let resource = try configService.getConfigurationValue(for: clientId, \.wellKnownResourceIdentifier)
            return try getDiscoveryDocumentValue(for: resource, keyPath: keyPath)
        }
    }
}
