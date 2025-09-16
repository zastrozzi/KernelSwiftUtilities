//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 27/03/2025.
//

import Foundation
import HTTPTypes

@_documentation(visibility: private)
public protocol _KernelNetworking_ClientMiddleware: Sendable {
    func intercept(
        _ request: HTTPRequest,
        body: KernelNetworking.HTTPBody?,
        baseURL: URL,
        operationID: String,
        next: @Sendable (
            HTTPRequest,
            KernelNetworking.HTTPBody?,
            URL
        ) async throws -> (
            HTTPResponse,
            KernelNetworking.HTTPBody?
        )
    ) async throws -> (HTTPResponse, KernelNetworking.HTTPBody?)
}

extension KernelNetworking {
    public typealias ClientMiddleware = _KernelNetworking_ClientMiddleware
}
