//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 19/09/2024.
//

import Vapor

extension KernelNetworking {
    public struct ClientHintMiddleware: AsyncMiddleware {
        public init() {}
        
        public func respond(to request: Request, chainingTo next: any AsyncResponder) async throws -> Response {
            let response = try await next.respond(to: request)
            let acceptCHString = [
                HTTPHeaders.Name.secClientHintUserAgent,
                HTTPHeaders.Name.secClientHintUserAgentArch,
                HTTPHeaders.Name.secClientHintUserAgentBitness,
                HTTPHeaders.Name.secClientHintUserAgentFullVersionList,
                HTTPHeaders.Name.secClientHintUserAgentMobile,
                HTTPHeaders.Name.secClientHintUserAgentModel,
                HTTPHeaders.Name.secClientHintUserAgentPlatform,
                HTTPHeaders.Name.secClientHintUserAgentPlatformVersion
            ].map { $0.description }.joined(separator: ",")
            response.headers.add(name: .acceptClientHints, value: acceptCHString)
            return response
        }
    }
}
