//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 06/11/2024.
//

import Vapor
import Queues
import AsyncHTTPClient
import KernelSwiftCommon

public typealias OAuth2HTTPHeadersFactory<Context, AuthorisationType> = @Sendable (_ context: Context, _ authorisationType: AuthorisationType) async throws -> HTTPHeaders

extension PlatformAction.ClientAPI {
    public struct OAuth2Context<ErrorType: Codable & Sendable, AuthorisationType: Codable & Sendable>: Sendable {
        @KernelDI.Injected(\.vapor) private var app: Application
        
        public func kernelDI<Container: KernelServerPlatform.FeatureContainer>(
            _ containerType: Container.Type
        ) -> Container {
            app.kernelDI(containerType)
        }
        
        public var client: Client
        public var contentDecoder: ContentDecoder
        public var queryEncoder: URLQueryEncoder?
        public var hostUrl: HostURLFactory<Self>
        public var errorDecoder: ErrorFactory<ErrorType>
        private var headers: HTTPHeadersFactory<Self>
        private var oauthHeaders: OAuth2HTTPHeadersFactory<Self, AuthorisationType>
        
        public func makeHeaders() async throws -> HTTPHeaders {
            try await self.headers(self)
        }
        
        public func makeOAuthHeaders(
            authorisationType: AuthorisationType
        ) async throws -> HTTPHeaders {
            try await self.oauthHeaders(self, authorisationType)
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
            oauthHeaders: @escaping OAuth2HTTPHeadersFactory<Self, AuthorisationType>,
            errorDecoder: @escaping ErrorFactory<ErrorType> = { clientResponse in try clientResponse.content.decode(ErrorType.self)}
        ) {
            self.client = client
            self.contentDecoder = contentDecoder
            self.queryEncoder = queryEncoder
            self.hostUrl = hostUrl
            self.headers = headers
            self.oauthHeaders = oauthHeaders
            self.errorDecoder = errorDecoder
        }
    }
}
