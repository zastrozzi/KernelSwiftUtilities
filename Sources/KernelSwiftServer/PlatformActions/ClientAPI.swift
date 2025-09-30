//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 27/04/2023.
//

import Vapor
import Queues
import AsyncHTTPClient
import KernelSwiftCommon

extension PlatformAction {
    public struct ClientAPI {
        public static let emptyPath: KernelSwiftCommon.Networking.HTTP.EmptyPath = .init()
        public static let emptyQuery: KernelSwiftCommon.Networking.HTTP.EmptyQuery = .init()
        public static let emptyRequest: KernelSwiftCommon.Networking.HTTP.EmptyRequest = .init()
        public static let emptyResponse: KernelSwiftCommon.Networking.HTTP.EmptyResponse = .init()
    }
}

public typealias HTTPHeadersFactory<Context> = @Sendable (_ context: Context) async throws -> HTTPHeaders
public typealias HostURLFactory<Context> = @Sendable (_ context: Context) async throws -> String
public typealias ErrorFactory<ErrorType: Codable> = @Sendable (_ clientResponse: ClientResponse) throws -> ErrorType

extension PlatformAction.ClientAPI {
    public struct Context<ErrorType: Codable & Sendable>: Sendable {
        @KernelDI.Injected(\.vapor) private var app: Application
        
        public func kernelDI<Container: KernelServerPlatform.FeatureContainer>(_ containerType: Container.Type) -> Container {
            app.kernelDI(containerType)
        }
        
        public var client: Client
        public var contentDecoder: ContentDecoder
        public var queryEncoder: URLQueryEncoder?
        public var hostUrl: HostURLFactory<Self>
        public var errorDecoder: ErrorFactory<ErrorType>
        private var headers: HTTPHeadersFactory<Self>
        
        public func makeHeaders() async throws -> HTTPHeaders {
            try await self.headers(self)
        }
        
        public func getHostUrl() async throws -> String {
            try await self.hostUrl(self)
        }
        
        public init(
            client: Client,
            contentDecoder: ContentDecoder,
            queryEncoder: URLQueryEncoder? = nil,
            hostUrl: @escaping HostURLFactory<Self>,
            headers: @escaping HTTPHeadersFactory<Self>,
            errorDecoder: @escaping ErrorFactory<ErrorType> = { clientResponse in try clientResponse.content.decode(ErrorType.self)}
        ) {
            self.client = client
            self.contentDecoder = contentDecoder
            self.queryEncoder = queryEncoder
            self.hostUrl = hostUrl
            self.headers = headers
            self.errorDecoder = errorDecoder
        }
    }
}

extension Content {
    public func allPropertiesAreNil() -> Bool {
        let mirror = Mirror(reflecting: self)
        return !mirror.children.contains { child in
            if case Optional<Any>.some(_) = child.value {
                return true
            }
            return false
        }
    }
}
