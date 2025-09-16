//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 27/03/2025.
//

import Foundation
import HTTPTypes

@_documentation(visibility: private)
public protocol _KernelNetworking_ClientTransport: Sendable {
    func send(
        _ request: HTTPRequest,
        body: KernelNetworking.HTTPBody?,
        baseURL: URL,
        operationID: String
    ) async throws -> (HTTPResponse, KernelNetworking.HTTPBody?)
}

extension KernelNetworking {
    public typealias ClientTransport = _KernelNetworking_ClientTransport
}
