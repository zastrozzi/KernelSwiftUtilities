//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 10/09/2023.
//

import Foundation
import AuthenticationServices
import KernelSwiftCommon

extension KernelAppUtils.OIDC {
    @Observable
    @available(iOS 17.0, macOS 14.0, *)
    public class OIDCClient: NSObject, @preconcurrency Identifiable, ASWebAuthenticationPresentationContextProviding, @unchecked Sendable {
        @ObservationIgnored @KernelDI.Injected(\.oidcDiscoveryService) private var discoveryService
        @ObservationIgnored @KernelDI.Injected(\.oidcConfigService) private var configService
        @ObservationIgnored @KernelDI.Injected(\.oidcCodeGeneratorService) private var codeGeneratorService
        
        
        public var id: UUID
        public var clientId: String
        public var status: OIDCClientStatus
        public var uiDesign: OIDCClientUIDesign
        public var debugAlert: DebugAlert = .hidden
        
        public init(clientId: String) throws {
            self.id = .init()
            self.clientId = clientId
            self.status = .notAuthenticated
            self.uiDesign = try KernelDI.inject(\.oidcConfigService).getConfigurationValue(for: clientId, \.uiDesign)
        }
        
        public func getDiscoveryDocString() throws -> String {
            let doc = try discoveryService.getDiscoveryDocumentValue(forClient: clientId, keyPath: \OIDCProviderMetadata.self)
            return "\(doc)"
        }
        
        public func authenticate() throws {
            guard self.status == .notAuthenticated else { throw KernelAppUtils.OIDC.TypedError(.badClientStatus) }
            let newContext: UUID = .init()
            try updateStatus(.authenticationRequested(context: newContext))
            try codeGeneratorService.generate(for: newContext)
            let authUrl = try buildAuthenticationURL()
            let urlScheme = try configService.getConfigurationValue(for: clientId, \.customUrlScheme)?.resolve()
            let session = ASWebAuthenticationSession(url: authUrl, callbackURLScheme: urlScheme, completionHandler: sessionCallbackHandler(_:_:))
            session.presentationContextProvider = self
            session.prefersEphemeralWebBrowserSession = true
            session.start()
        }
        
        public func sessionCallbackHandler(_ url: URL?, _ error: Swift.Error?) -> Void {
            if let error { logger.error("Auth session failure: \(error.localizedDescription)") }
            guard let url else {
                logger.error("Auth session returned no callback url. Resetting.")
                reset()
                return
            }
            logger.debug("CALLBACK: \(url.absoluteString)")
            Task { try await executeTokenRequest(for: url) }
        }
        
        public func executeTokenRequest(for callbackURL: URL) async throws -> Void {
            guard let code = callbackURL.getQueryParam(value: "code"), let tokenRequest = try? buildTokenRequest(code: code) else {
                throw TypedError(.tokenRequestGenerationFailed)
            }
            guard let context = status.context else { throw TypedError(.badClientStatus) }
            try updateStatus(.tokenRequested(context: context))
            let (data, res) = try await URLSession.shared.data(for: tokenRequest)
            let decoder = JSONDecoder()
            let rawDecoded = data.utf8Description
            let resDecoded = try? decoder.decode(OIDCTokenResponse.self, from: data)
            logger.debug("Response: \(res)")
            if let resDecoded { logger.debug("RES", metadata: ["DATA": "\(resDecoded)", "RAW": .string(rawDecoded)]) }
            debugAlert.present(title: "Token Response", message: rawDecoded)
            reset()
        }
        
        public func updateStatus(_ status: OIDCClientStatus) throws {
            guard self.status != status else {
                logger.warning("OIDCClientStatus already updated", metadata: ["clientId": .stringConvertible(clientId), "status": .stringConvertible(status.debugDescription)])
                return
            }
            self.status = status
        }
        
        private func buildAuthenticationURL() throws -> URL {
            let document = try discoveryService.getDiscoveryDocumentValue(forClient: clientId, keyPath: \OIDCProviderMetadata.self)
            logger.debug("Discovery Doc", metadata: ["RAW": .string("\(document)")])
            let authEndpoint = try discoveryService.getDiscoveryDocumentValue(forClient: clientId, keyPath: \OIDCProviderMetadata.authorizationEndpoint)
            let responseType = try configService.getConfigurationValue(for: clientId, \.responseType)
            let scope = try configService.getConfigurationValue(for: clientId, \.scope)
            let redirectUri = try configService.getConfigurationValue(for: clientId, \.redirectUri)?.resolve()
            guard var components: URLComponents = .init(string: authEndpoint) else { throw TypedError(.urlGenerationFailed) }
            var queryItems: [URLQueryItem] = []
            queryItems.append(.oidc(.clientId, clientId))
            queryItems.append(.oidc(.redirectUri, redirectUri))
            queryItems.append(.oidc(.responseType, responseType.toString()))
            queryItems.append(.oidc(.scope, scope.toString()))
            if responseType.value.contains(.code) {
                guard let context = status.context else { throw TypedError(.badClientStatus) }
                let challenge = try codeGeneratorService.getChallenge(for: context)
                queryItems.append(.oidc(.codeChallenge, challenge))
                queryItems.append(.oidc(.codeChallengeMethod, "S256"))
            }
            if responseType.value.contains(.idToken) {
                guard let context = status.context else { throw TypedError(.badClientStatus) }
                queryItems.append(.oidc(.nonce, context.uuidString))
            }
            components.queryItems = queryItems
            guard let url = components.url else { throw TypedError(.urlGenerationFailed) }
            logger.debug("URL: \(url.absoluteString)")
            return url
        }
        
        private func buildTokenRequest(code: String) throws -> URLRequest {
            let tokenEndpoint = try discoveryService.getDiscoveryDocumentValue(forClient: clientId, keyPath: \OIDCProviderMetadata.tokenEndpoint)
            let responseType = try configService.getConfigurationValue(for: clientId, \.responseType)
            let redirectUri = try configService.getConfigurationValue(for: clientId, \.redirectUri)?.resolve()
            var components: URLComponents = .init()
            var queryItems: [URLQueryItem] = []
            queryItems.append(.oidc(.clientId, clientId))
            queryItems.append(.oidc(.redirectUri, redirectUri))
            if responseType.value.contains(.code) {
                guard let context = status.context else { throw TypedError(.badClientStatus) }
                let verifier = try codeGeneratorService.getVerifier(for: context)
                queryItems.append(.oidc(.code, code))
                queryItems.append(.oidc(.codeVerifier, verifier))
                queryItems.append(.oidc(.grantType, OIDCGrantType.authorizationCode.rawValue))
            }
            components.queryItems = queryItems
//            let headers: BKHttpHeaders = [ContentTypeHeader("application/x-www-form-urlencoded")]
            var req = URLRequest(url: .init(string: tokenEndpoint)!)
//            var request = try URLRequest(url: tokenEndpoint, method: .post, headers: headers.forAlamofire())
            req.httpMethod = "POST"
            req.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            req.httpBody = components.query?.data(using: .utf8)
            return req
        }
        
        public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
            return .init()
        }
        
        public func reset() {
            status = .notAuthenticated
        }
        
    }
}

