//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 27/03/2025.
//

import Foundation
import HTTPTypes

extension KernelNetworking {
    public struct UniversalClient: Sendable {
        public let serverURL: URL
        public let converter: Converter
        public var transport: any ClientTransport
        public var middlewares: [any ClientMiddleware]
        
        internal init(
            serverURL: URL,
            converter: Converter,
            transport: any ClientTransport,
            middlewares: [any ClientMiddleware]
        ) {
            self.serverURL = serverURL
            self.converter = converter
            self.transport = transport
            self.middlewares = middlewares
        }
        
        public init(
            serverURL: URL = .defaultServerURL,
            configuration: Configuration = .init(),
            transport: any ClientTransport,
            middlewares: [any ClientMiddleware] = []
        ) {
            self.init(
                serverURL: serverURL,
                converter: Converter(configuration: configuration),
                transport: transport,
                middlewares: middlewares
            )
        }
        
        public func send<OperationInput, OperationOutput>(
            input: OperationInput,
            forOperation operationID: String,
            serializer: @Sendable (OperationInput) throws -> (HTTPRequest, HTTPBody?),
            deserializer: @Sendable (HTTPResponse, HTTPBody?) async throws -> OperationOutput
        ) async throws -> OperationOutput where OperationInput: Sendable, OperationOutput: Sendable {
            @Sendable func wrappingErrors<R>(work: () async throws -> R, mapError: (any Error) -> any Error) async throws
            -> R
            {
                do { return try await work() } catch let error as ClientError { throw error } catch {
                    throw mapError(error)
                }
            }
            let baseURL = serverURL
            @Sendable func makeError(
                request: HTTPRequest? = nil,
                requestBody: HTTPBody? = nil,
                baseURL: URL? = nil,
                response: HTTPResponse? = nil,
                responseBody: HTTPBody? = nil,
                error: any Error
            ) -> any Error {
                if var error = error as? ClientError {
                    error.request = error.request ?? request
                    error.requestBody = error.requestBody ?? requestBody
                    error.baseURL = error.baseURL ?? baseURL
                    error.response = error.response ?? response
                    error.responseBody = error.responseBody ?? responseBody
                    return error
                }
                let causeDescription: String
                let underlyingError: any Error
                if let runtimeError = error as? RuntimeError {
                    causeDescription = runtimeError.prettyDescription
                    underlyingError = runtimeError.underlyingError ?? error
                } else {
                    causeDescription = "Unknown"
                    underlyingError = error
                }
                return ClientError(
                    operationID: operationID,
                    operationInput: input,
                    request: request,
                    requestBody: requestBody,
                    baseURL: baseURL,
                    response: response,
                    responseBody: responseBody,
                    causeDescription: causeDescription,
                    underlyingError: underlyingError
                )
            }
            let (request, requestBody): (HTTPRequest, HTTPBody?) = try await wrappingErrors {
                try serializer(input)
            } mapError: { error in
                makeError(error: error)
            }
            var next: @Sendable (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?) = {
                (_request, _body, _url) in
                try await wrappingErrors {
                    try await transport.send(_request, body: _body, baseURL: _url, operationID: operationID)
                } mapError: { error in
                    makeError(
                        request: request,
                        requestBody: requestBody,
                        baseURL: baseURL,
                        error: RuntimeError.transportFailed(error)
                    )
                }
            }
            for middleware in middlewares.reversed() {
                let tmp = next
                next = { (_request, _body, _url) in
                    try await wrappingErrors {
                        try await middleware.intercept(
                            _request,
                            body: _body,
                            baseURL: _url,
                            operationID: operationID,
                            next: tmp
                        )
                    } mapError: { error in
                        makeError(
                            request: request,
                            requestBody: requestBody,
                            baseURL: baseURL,
                            error: RuntimeError.middlewareFailed(middlewareType: type(of: middleware), error)
                        )
                    }
                }
            }
            let (response, responseBody): (HTTPResponse, HTTPBody?) = try await next(request, requestBody, baseURL)
            return try await wrappingErrors {
                try await deserializer(response, responseBody)
            } mapError: { error in
                makeError(
                    request: request,
                    requestBody: requestBody,
                    baseURL: baseURL,
                    response: response,
                    responseBody: responseBody,
                    error: error
                )
            }
        }
    }
}

extension URL {
    public static let defaultServerURL: Self = {
        guard let url = URL(string: "/") else { fatalError("Failed to create an URL with the string '/'.") }
        return url
    }()
    
    public init(validatingServerURL string: String) throws {
        guard let url = Self(string: string) else { throw KernelNetworking.TypedError.invalidServerURL(string) }
        self = url
    }
}
