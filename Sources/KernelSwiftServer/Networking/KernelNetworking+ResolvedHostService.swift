//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 14/06/2024.
//

import Vapor
import KernelSwiftCommon

extension KernelNetworking {
    public struct ResolvedHostService: AsyncMiddleware, Sendable {
        private let resolvedHostCache: KernelServerPlatform.SimpleMemoryCache<String, Model.ResolvedHostRecord>
        @KernelDI.Injected(\.vapor) public var app
        
        public init() {
            self.resolvedHostCache = .init()
        }
        
        public func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
            let host = retrieveHostFromHeaders(request.headers) ?? retrieveHostFromServerConfig()
            let record = createRecord(host)
            cacheRecord(record)
            return try await next.respond(to: request)
        }
        
        func retrieveHostFromHeaders(_ headers: HTTPHeaders) -> String? {
            let proto = headers.first(name: .xForwardedProto) ?? (app.http.server.configuration.tlsConfiguration == nil ? "http" : "https")
            guard let host = headers.first(name: .xForwardedHost) ?? headers.first(name: .host) else { return nil }
            return "\(proto)://\(host)"
        }
        
        func retrieveHostFromServerConfig() -> String {
            let configuration = app.http.server.configuration
            let scheme = configuration.tlsConfiguration == nil ? "http" : "https"
            let hostname = configuration.hostname
            let port = configuration.port
            let url = "\(scheme)://\(hostname):\(port)"
            return url
        }
        
        private func createRecord(_ name: String) -> Model.ResolvedHostRecord {
            .init(latestObservation: .now, totalObservations: 1, host: name)
        }
        
        @discardableResult
        public func cacheRecord(_ record: Model.ResolvedHostRecord) -> Model.ResolvedHostRecord {
            if self.resolvedHostCache.has(record.host) {
                self.resolvedHostCache.update(record.host) { recordToUpdate in
                    recordToUpdate.latestObservation = .now
                    recordToUpdate.totalObservations += 1
                }
            } else {
                self.resolvedHostCache.set(record.host, value: record)
            }
            return record
        }
//        
//        public func getLatestRecord() -> Model.ResolvedHostRecord? {
//            return self.resolvedHostCache.all().sorted { $0.latestObservation > $1.latestObservation }.first
//        }
//        
        public func getLatestRecord() throws -> Model.ResolvedHostRecord {
            guard let record = self.resolvedHostCache.all().sorted(by: { $0.latestObservation > $1.latestObservation }).first else {
                let record = createRecord(retrieveHostFromServerConfig())
                return cacheRecord(record)
            }
            return record
        }
        
        public func getLatestRecordHostURL() throws -> URL {
            let record = try getLatestRecord()
            guard let url = URL(string: record.host) else {
                throw Abort(.internalServerError, reason: "Unable to construct Host URL")
            }
            return url
        }
        
        public func getMostObservedRecord() -> Model.ResolvedHostRecord? {
            return self.resolvedHostCache.all().sorted { $0.totalObservations > $1.totalObservations }.first
        }
    }
}

