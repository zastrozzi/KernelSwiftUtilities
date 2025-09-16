//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/04/2022.
//

import Foundation
import Vapor
import NIO
import KernelSwiftCommon

@dynamicMemberLookup
public struct TypedRequest<Context: RouteContext>: Sendable {
    private unowned let request: Request
    
    public let query: Query
    public let response: ResponseBuilder<Context>
    
    public subscript<T>(dynamicMember path: KeyPath<Request, T>) -> T {
        return request[keyPath: path]
    }
    
    public var underlyingRequest: Request { return request }
    
    public init(underlyingRequest: Request) {
        request = underlyingRequest
        query = .init(request: underlyingRequest)
        response = .init(request: underlyingRequest)
    }
    
    public func decodeBody(using decoder: ContentDecoder) throws -> Context.RequestBodyType {
        return try request.content.decode(Context.RequestBodyType.self, using: decoder)
    }
    
    public func decodeBody() throws -> Context.RequestBodyType {
        if request.content.contentType == nil {
            request.headers.contentType = Context.defaultContentType
        }
        guard let contentType = request.content.contentType else { throw Abort(.unsupportedMediaType, reason: "No content type provided") }
        return try decodeBody(for: contentType)
    }
    
    public func decodeBody(for contentType: HTTPMediaType) throws -> Context.RequestBodyType {
        switch contentType {
        case .json:
            return try request.content.decode(Context.RequestBodyType.self, using: KernelServerPlatform.defaultJSONDecoder)
        case .urlEncodedForm:
            return try request.content.decode(Context.RequestBodyType.self, using: KernelServerPlatform.defaultURLQueryDecoder)
        default:
            if let nonJsonDecoder = try? ContentConfiguration.global.requireDecoder(for: contentType) {
                return try request.content.decode(Context.RequestBodyType.self, using: nonJsonDecoder)
            } else if let fallbackContentType = contentType.fallback {
                return try decodeBody(for: fallbackContentType)
            } else {
                throw Abort(.unsupportedMediaType, reason: "Support for reading media type '\(contentType) has not been configured.")
            }
        }
    }
    
    public func decodeQueryParams(using decoder: URLQueryDecoder) throws -> Context.QueryParamsType {
        return try request.query.decode(Context.QueryParamsType.self, using: decoder)
    }
    
    public func decodeQueryParams() throws -> Context.QueryParamsType {
        print("decoding query params")
        let safeDecoder: URLEncodedFormDecoder = .init(
            configuration: .init(dateDecodingStrategy: .flexible)
        )

        return try request.query.decode(Context.QueryParamsType.self, using: safeDecoder)
    }
    
    public func decodePathParams() throws -> Context.PathParamsType {
        let pathParamDecoder = PathParamDecoder()
        return try pathParamDecoder.decode(Context.PathParamsType.self, from: request.parameters)
    }
}

public extension TypedRequest where Context: RouteContextWithKernelPlatformAction {
    func createAction() throws -> Context.PlatformActionType {
        guard let decodedRequestBody: Context.PlatformActionType.KPActionRequestBody =
            Context.RequestBodyType.self == KernelSwiftCommon.Networking.HTTP.EmptyRequest.self ?
                KernelSwiftCommon.Networking.HTTP.EmptyRequest() as? Context.PlatformActionType.KPActionRequestBody :
            try decodeBody() as? Context.PlatformActionType.KPActionRequestBody
        else {
            throw Abort(.badRequest, reason: "Could not decode request body")
        }
        
        guard let decodedPathParams: Context.PlatformActionType.KPActionPathParams =
            Context.PathParamsType.self == KernelSwiftCommon.Networking.HTTP.EmptyPath.self ?
                KernelSwiftCommon.Networking.HTTP.EmptyPath() as? Context.PlatformActionType.KPActionPathParams :
            try decodePathParams() as? Context.PlatformActionType.KPActionPathParams
        else {
            throw Abort(.badRequest, reason: "Could not decode path params")
        }
        
        guard let decodedQueryParams: Context.PlatformActionType.KPActionQueryParams =
        Context.QueryParamsType.self == KernelSwiftCommon.Networking.HTTP.EmptyQuery.self ?
                KernelSwiftCommon.Networking.HTTP.EmptyQuery() as? Context.PlatformActionType.KPActionQueryParams :
            try decodeQueryParams() as? Context.PlatformActionType.KPActionQueryParams
        else {
            throw Abort(.badRequest, reason: "Could not decode query params")
        }
        return .init(
            pathParams: decodedPathParams,
            queryParams: decodedQueryParams,
            requestBody: decodedRequestBody,
            activePlatformApplicationId: request.activePlatformApplicationId
        )
    }
    
    func performActionFromRouteController() async throws -> Response {
        let action = try createAction()
        let responseBody = try await action.execute(on: request.application)
//        try await request.application.jobPipelineService.performNextJobOutsideQueue(type(of: action), responseBody, activePlatformApplicationId: action.activePlatformApplicationId)
        return try await responseBody.encodeResponse(for: request)
    }
}

public typealias PlatformActionTypedRequest<A: KernelPlatformAction> = TypedRequest<PlatformActionRouteContext<A>>


