//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 29/03/2025.
//

import Foundation
import KernelSwiftCommon
import HTTPTypes

//@dynamicMemberLookup
public protocol ClientApplicationAPIAction: Sendable {
    associatedtype PathParams: Codable & Sendable = KernelNetworking.HTTP.EmptyPath
    associatedtype QueryParams: Codable & Sendable = KernelNetworking.HTTP.EmptyQuery
    associatedtype RequestBody: Codable & Sendable = KernelNetworking.HTTP.EmptyRequest
    associatedtype ResponseBody: Codable & Sendable = KernelNetworking.HTTP.EmptyResponse
    associatedtype ErrorResponseBody: Codable & Sendable = KernelNetworking.HTTP.DefaultErrorResponse
    
    static var operationName: String { get }
    static var method: HTTPRequest.Method { get }
    var pathParams: PathParams { get }
    var queryParams: QueryParams { get }
    var requestBody: RequestBody { get }
    var partialPath: String { get }
    static var requestContentType: KernelNetworking.HTTP.MediaType { get }
    static var responseContentType: KernelNetworking.HTTP.MediaType { get }
//    subscript<T>(dynamicMember path: KeyPath<Self, T>) -> T { get }
    
    
//    init(pathParams: PathParams, queryParams: QueryParams, requestBody: RequestBody)
}

extension ClientApplicationAPIAction {
    public static var requestContentType: KernelNetworking.HTTP.MediaType { .json }
    public static var responseContentType: KernelNetworking.HTTP.MediaType { .json }
    public static var method: HTTPRequest.Method { .get }
    public var partialPath: String { return "" }
//    public var responseBuilder: ClientResponseBuilder<Self> { .init(context: self) }
}

public enum _ClientApplicationAPI_ClientResponse<Action: ClientApplicationAPIAction>: Sendable {
    case success(Action.ResponseBody)
    case error(Action.ErrorResponseBody)
    case unknownError(String)
    case invalid
    case informational
    case redirection
    case other
}

extension ClientApplicationAPIAction {
    public typealias ClientResponse = _ClientApplicationAPI_ClientResponse<Self>
}


@dynamicMemberLookup
public struct ClientResponseBuilder<Context: ClientApplicationAPIAction>: Sendable {
    public let context: Context
    
    public subscript<T: Decodable>(dynamicMember path: KeyPath<Context, ClientResponseContext<T>>) -> T? {
        fatalError("non implemented")
//        return .init(request: request, modifiers: [context[keyPath: path].configure])
    }
//    
//    public func makeDecoder<T>(path: KeyPath<Context, ClientResponseContext<T>>) -> ResponseEncoder<T> {
//        return .init(request: request, modifiers: [context[keyPath: path].configure])
//    }
//    
    public init(context: Context) {
        self.context = context
    }
}

public protocol AbstractClientResponseContextType {
    var responseBodyType: Any.Type { get }
}

public protocol ClientResponseContextType: AbstractClientResponseContextType {
    associatedtype ResponseBodyType: Decodable
}

extension ClientResponseContextType {
    public var responseBodyType: Any.Type { return ResponseBodyType.self }
}

public struct ClientResponseContext<ResponseBodyType: Decodable>: ClientResponseContextType, Sendable {
    public let responseStatus: KernelNetworking.HTTP.ResponseStatus
    
    public init(
        _ responseStatus: KernelNetworking.HTTP.ResponseStatus
    ) {
        self.responseStatus = responseStatus
    }
}

extension ClientResponseContext {
    public static func success(_ status: KernelNetworking.HTTP.ResponseStatus) -> Self {
        return .init(status)
    }
    
    public static func error(_ status: KernelNetworking.HTTP.ResponseStatus) -> Self {
        return .init(status)
    }
}

public struct ClientApplicationAPIDefaults {
    public static let emptyPath: KernelNetworking.HTTP.EmptyPath = .init()
    public static let emptyQuery: KernelNetworking.HTTP.EmptyQuery = .init()
    public static let emptyRequest: KernelNetworking.HTTP.EmptyRequest = .init()
    public static let emptyResponse: KernelNetworking.HTTP.EmptyResponse = .init()
}
//
extension ClientApplicationAPIAction where
PathParams == KernelSwiftCommon.Networking.HTTP.EmptyPath
{
    public var pathParams: PathParams { .init() }
}

extension ClientApplicationAPIAction where
QueryParams == KernelSwiftCommon.Networking.HTTP.EmptyQuery
{
    public var queryParams: QueryParams { .init() }
}

extension ClientApplicationAPIAction where
RequestBody == KernelSwiftCommon.Networking.HTTP.EmptyRequest
{
    public var requestBody: RequestBody { .init() }
}

extension ClientApplicationAPIAction where
PathParams == KernelSwiftCommon.Networking.HTTP.EmptyPath,
QueryParams == KernelSwiftCommon.Networking.HTTP.EmptyQuery
{
    
    public var pathParams: PathParams { .init() }
    public var queryParams: QueryParams { .init() }
}

extension ClientApplicationAPIAction where
PathParams == KernelSwiftCommon.Networking.HTTP.EmptyPath,
RequestBody == KernelSwiftCommon.Networking.HTTP.EmptyRequest
{
    public var pathParams: PathParams { .init() }
    public var requestBody: RequestBody { .init() }
}

extension ClientApplicationAPIAction where
QueryParams == KernelSwiftCommon.Networking.HTTP.EmptyQuery,
RequestBody == KernelSwiftCommon.Networking.HTTP.EmptyRequest
{
    public var queryParams: QueryParams { .init() }
    public var requestBody: RequestBody { .init() }
}



extension ClientApplicationAPIAction where
PathParams == KernelSwiftCommon.Networking.HTTP.EmptyPath,
QueryParams == KernelSwiftCommon.Networking.HTTP.EmptyQuery,
RequestBody == KernelSwiftCommon.Networking.HTTP.EmptyRequest
{
    
    public var pathParams: PathParams { .init() }
    public var queryParams: QueryParams { .init() }
    public var requestBody: RequestBody { .init() }
}

extension ClientApplicationAPIAction {
    public func perform(with client: KernelNetworking.UniversalClient) async throws -> ClientResponse {
        try await client.send(input: self, forOperation: Self.operationName) { input in
            var request: HTTPRequest = .init(path: input.partialPath, method: Self.method)
            if QueryParams.self != KernelSwiftCommon.Networking.HTTP.EmptyQuery.self {
                try client.converter.setQueryItemAsURI(
                    in: &request,
                    style: .deepObject,
                    explode: true,
                    name: "",
                    value: input.queryParams
                )
            }
            if ResponseBody.self != KernelSwiftCommon.Networking.HTTP.EmptyResponse.self {
                client.converter.setAcceptHeader(in: &request.headerFields, contentTypes: [Self.responseContentType])
            }
            
            if Self.method != .get || RequestBody.self != KernelSwiftCommon.Networking.HTTP.EmptyRequest.self {
                let body = try client.converter.setRequiredRequestBodyAsJSON(
                    input.requestBody,
                    headerFields: &request.headerFields,
                    contentType: Self.requestContentType.serialize()
                )
                return (request, body)
            } else {
                return (request, nil)
            }
        } deserializer: { response, responseBody in
//            let contentType = client.converter.extractContentTypeIfPresent(from: response.headerFields) ?? .json
            guard let status: KernelNetworking.HTTP.ResponseStatus = .init(status: response.status) else {
                return .invalid
            }
            switch status.category {
            case .clientError, .serverError:
                return try await client.converter.getResponseBodyAsJSON(ErrorResponseBody.self, from: responseBody) { value in
                    .error(value)
                }
            case .success:
                return try await client.converter.getResponseBodyAsJSON(ResponseBody.self, from: responseBody) { value in
                    .success(value)
                }
            case .informational: return .informational
            case .redirection: return .redirection
            case .other: return .other
                
            }
        }
    }
}
