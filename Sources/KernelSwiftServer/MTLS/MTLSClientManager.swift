//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 26/10/2022.
//

import Foundation
import Vapor
import NIO
import NIOSSL

struct MTLSClientManagerKey: StorageKey {
    typealias Value = MTLSClientManager
}

extension Application {
    public var mtls: MTLSClientManager {
        get {
            guard let service = self.storage[MTLSClientManagerKey.self] else {
                fatalError("MTLSClientManager not initialized")
            }
            return service
        }
        
        set {
            self.storage[MTLSClientManagerKey.self] = newValue
        }
    }
}

public final class MTLSClientManager: Sendable {
    let rootCertificateFile: String
    let application: Application
    
    public init(rootCertificateFile: String, application: Application) {
        self.rootCertificateFile = rootCertificateFile
        self.application = application
    }
    
    nonisolated(unsafe) private var clients = [ClientMTLSConfiguration: MTLSHTTPClient]()
    
    public func createClient(mtlsConfiguration: ClientMTLSConfiguration, transportKey: String, transportCertificate: String) async throws -> MTLSHTTPClient {
//        let softwareStatementProfile = try await self.application.dynamicClientManagementService.getSoftwareStatementProfileFromDb(softwareStatementProfileId: mtlsConfiguration.softwareStatementId)
        let transportKey = try NIOSSLPrivateKey(bytes: Array(transportKey.utf8), format: .pem)
        let transportCertificates = try NIOSSLCertificate.fromPEMBytes(Array(transportCertificate.utf8))
        var tlsConfig = TLSConfiguration.makeClientConfiguration()
        tlsConfig.trustRoots = .file(self.rootCertificateFile)
        tlsConfig.privateKey = .privateKey(transportKey)
        tlsConfig.certificateChain = [.certificate(transportCertificates[0])]
        tlsConfig.certificateVerification = mtlsConfiguration.tlsCertificateVerification.normalized
        tlsConfig.renegotiationSupport = mtlsConfiguration.tlsRenegotiationSupport.normalized
//        tlsConfig.certificateVerification = .none
//        tlsConfig.renegotiationSupport = .none
        
        let httpClientConfig = HTTPClient.Configuration(tlsConfiguration: tlsConfig)
        let newClient = MTLSHTTPClient(application: self.application, httpClientConfiguration: httpClientConfig)
        
        self.clients[mtlsConfiguration] = newClient
        return newClient
    }
    
    public func createClient(mtlsConfiguration: ClientMTLSConfiguration, tlsConfig: TLSConfiguration) async throws -> MTLSHTTPClient {
        let httpClientConfig = HTTPClient.Configuration(tlsConfiguration: tlsConfig)
        let newClient = MTLSHTTPClient(application: self.application, httpClientConfiguration: httpClientConfig)
        self.clients[mtlsConfiguration] = newClient
        return newClient
    }
    
    public func getClient(mtlsConfiguration: ClientMTLSConfiguration, transportKey: String, transportCertificate: String) async throws -> MTLSHTTPClient {
        if let client = self.clients[mtlsConfiguration] {
            
            return client
        }
        else { return try await createClient(mtlsConfiguration: mtlsConfiguration, transportKey: transportKey, transportCertificate: transportCertificate) }
    }
    
    func shutdownAllClients() async throws {
        try await clients.values.asyncForEach { client in
            try await client.http.shutdown()
        }
    }
    
    
}

public struct MTLSLifecycleHandler: LifecycleHandler {
    public func shutdown(_ application: Application) {
        
        application.logger.debug("mtls shutdown")
        Task {
            try await application.mtls.shutdownAllClients()
        }
        
    }
    
    public init() {}
}
