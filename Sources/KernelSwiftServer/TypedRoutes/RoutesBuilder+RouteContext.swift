//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/04/2022.
//

import Foundation
import Vapor
import Collections

public final class TypedRoutesBuilder: RoutesBuilder {
    let root: RoutesBuilder
    
    let path: [TypedPathComponent]
    public var userInfo: Dictionary<AnyHashable, Any>

    public init(root: RoutesBuilder, path: [TypedPathComponent]) {
        self.root = root
        self.path = path
        self.userInfo = [:]
    }
    
    public func add(_ route: Route) {
        route.path = self.path.map(\.vaporPathComponent) + route.path
        if
            userInfo.keys.contains("openapi:group_tags"), let groupTags = userInfo["openapi:group_tags"] as? [String]
        {
            if route.userInfo.keys.contains("openapi:tags"), let routeTags = userInfo["openapi:tags"] as? [String] {
                route.userInfo["openapi:tags"] = (groupTags + routeTags).uniqued(on: { tagName in
                    tagName
                })
            } else {
                route.userInfo["openapi:tags"] = groupTags
            }
        }
        if
            userInfo.keys.contains("openapi:group_headers"), let groupHeaders = userInfo["openapi:group_headers"] as? [HTTPHeaders.Name]
        {
            if route.userInfo.keys.contains("openapi:headers"), let routeHeaders = userInfo["openapi:headers"] as? [HTTPHeaders.Name] {
                route.userInfo["openapi:headers"] = (groupHeaders + routeHeaders).uniqued(on: { headerName in
                    headerName.capitalized()
                })
            } else {
                route.userInfo["openapi:headers"] = groupHeaders
            }
        }
        if
            userInfo.keys.contains("openapi:group_security"), let groupSecuritySchemes = userInfo["openapi:group_security"] as? [SecuritySchemeName]
        {
            if route.userInfo.keys.contains("openapi:security"), let routeSecuritySchemes = userInfo["openapi:security"] as? [SecuritySchemeName] {
                route.userInfo["openapi:security"] = (groupSecuritySchemes + routeSecuritySchemes).uniqued(on: { name in
                    name.rawValue
                })
            } else {
                route.userInfo["openapi:security"] = groupSecuritySchemes
            }
        }
        for pathComponent in path {
            if case let .parameter(name, meta) = pathComponent {
                route.userInfo["typed_parameter:\(name)"] = meta
            }
        }
        self.root.add(route)
    }
}


extension RoutesBuilder {
    
    public func typeGrouped(_ path: TypedPathComponent...) -> TypedRoutesBuilder {
        return self.typeGrouped(path)
    }
    
    public func typeGrouped(_ path: [TypedPathComponent]) -> TypedRoutesBuilder {
        return TypedRoutesBuilder(root: self, path: path)
    }

    @discardableResult
    public func get<Context, Response>(
        _ path: TypedPathComponent...,
        use closure: @escaping (TypedRequest<Context>) throws -> Response
    ) -> Route
        where Context: RouteContext, Response: ResponseEncodable & Sendable
    {
        return self.on(.GET, path, use: closure)
    }
    
    @discardableResult
    public func get<Context, Response>(
        _ path: TypedPathComponent...,
        use closure: @escaping (TypedRequest<Context>) async throws -> Response
    ) -> Route
        where Context: RouteContext, Response: AsyncResponseEncodable
    {
        return self.on(.GET, path, use: closure)
    }

    @discardableResult
    public func post<Context, Response>(
        _ path: TypedPathComponent...,
        body: HTTPBodyStreamStrategy = .collect,
        use closure: @escaping (TypedRequest<Context>) throws -> Response
    ) -> Route
        where Context: RouteContext, Response: ResponseEncodable
    {
        return self.on(.POST, path, body: body, use: closure)
    }
    
    @discardableResult
    public func post<Context, Response>(
        _ path: TypedPathComponent...,
        body: HTTPBodyStreamStrategy = .collect,
        use closure: @escaping (TypedRequest<Context>) async throws -> Response
    ) -> Route
        where Context: RouteContext, Response: AsyncResponseEncodable
    {
        return self.on(.POST, path, body: body, use: closure)
    }

    @discardableResult
    public func patch<Context, Response>(
        _ path: TypedPathComponent...,
        use closure: @escaping (TypedRequest<Context>) throws -> Response
    ) -> Route
        where Context: RouteContext, Response: ResponseEncodable
    {
        return self.on(.PATCH, path, use: closure)
    }
    
    @discardableResult
    public func patch<Context, Response>(
        _ path: TypedPathComponent...,
        use closure: @escaping (TypedRequest<Context>) async throws -> Response
    ) -> Route
        where Context: RouteContext, Response: AsyncResponseEncodable
    {
        return self.on(.PATCH, path, use: closure)
    }

    @discardableResult
    public func put<Context, Response>(
        _ path: TypedPathComponent...,
        use closure: @escaping (TypedRequest<Context>) throws -> Response
    ) -> Route
        where Context: RouteContext, Response: ResponseEncodable
    {
        return self.on(.PUT, path, use: closure)
    }
    
    @discardableResult
    public func put<Context, Response>(
        _ path: TypedPathComponent...,
        use closure: @escaping (TypedRequest<Context>) async throws -> Response
    ) -> Route
        where Context: RouteContext, Response: AsyncResponseEncodable
    {
        return self.on(.PUT, path, use: closure)
    }

    @discardableResult
    public func delete<Context, Response>(
        _ path: TypedPathComponent...,
        use closure: @escaping (TypedRequest<Context>) throws -> Response
    ) -> Route
        where Context: RouteContext, Response: ResponseEncodable
    {
        return self.on(.DELETE, path, use: closure)
    }
    
    @discardableResult
    public func delete<Context, Response>(
        _ path: TypedPathComponent...,
        use closure: @escaping (TypedRequest<Context>) async throws -> Response
    ) -> Route
        where Context: RouteContext, Response: AsyncResponseEncodable
    {
        return self.on(.DELETE, path, use: closure)
    }

    @discardableResult
    public func on<Context, Response>(
        _ method: HTTPMethod,
        _ path: [TypedPathComponent],
        body: HTTPBodyStreamStrategy = .collect,
        use closure: @escaping (TypedRequest<Context>) throws -> Response
    ) -> Route
    where Context: RouteContext, Response: ResponseEncodable
    {
        nonisolated(unsafe) let wrappingClosure = { (request: Vapor.Request) -> Response in
            return try closure(.init(underlyingRequest: request))
        }

        let responder = BasicResponder { request in
            if case .collect(let max) = body, request.body.data == nil {
                return request.body.collect(max: max?.value ?? request.application.routes.defaultMaxBodySize.value).flatMapThrowing { _ in
                    return try wrappingClosure(request)
                }.encodeResponse(for: request)
            } else {
                return try wrappingClosure(request)
                    .encodeResponse(for: request)
            }
        }
        
        for comp in path {
            guard case let .constant(compStr) = comp else { continue }
            guard !compStr.isEmpty && compStr.removingCharacters(in: .urlPathAllowed).isEmpty else {
                preconditionFailure("illegal path parameter: \(comp) in \(path)")
            }
        }

        let route = Route(
            method: method,
            path: path.map(\.vaporPathComponent),
            responder: responder,
            requestType: Context.RequestBodyType.self,
            responseType: Context.self
        )

        for pathComponent in path {
            if case let .parameter(name, meta) = pathComponent {
                route.userInfo["typed_parameter:\(name)"] = meta
            }
        }

        self.add(route)

        return route
    }
    
    @discardableResult
    public func on<Context, Response>(
        _ method: HTTPMethod,
        _ path: [TypedPathComponent],
        body: HTTPBodyStreamStrategy = .collect,
        use closure: @escaping (TypedRequest<Context>) async throws -> Response
    ) -> Route
    where Context: RouteContext, Response: AsyncResponseEncodable
    {
        nonisolated(unsafe) let wrappingClosure = { (request: Vapor.Request) -> Response in
            return try await closure(.init(underlyingRequest: request))
        }
        
        let responder = AsyncBasicResponder { request in
            if case .collect(let max) = body, request.body.data == nil {
                _ = try await request.body.collect(max: max?.value ?? request.application.routes.defaultMaxBodySize.value).get()
                return try await wrappingClosure(request).encodeResponse(for: request)
            }
            return try await wrappingClosure(request).encodeResponse(for: request)
        }
        
        for comp in path {
            guard case let .constant(compStr) = comp else { continue }
            guard !compStr.isEmpty && compStr.removingCharacters(in: .urlPathAllowed).isEmpty else {
                print("illegal path parameter: \(comp) in \(path)")
                preconditionFailure("illegal path parameter: \(comp) in \(path)")
            }
        }
        
        let route = Route(
            method: method,
            path: path.map(\.vaporPathComponent),
            responder: responder,
            requestType: Context.RequestBodyType.self,
            responseType: Context.self
        )
        
        for pathComponent in path {
            if case let .parameter(name, meta) = pathComponent {
                route.userInfo["typed_parameter:\(name)"] = meta
            }
        }
        
        self.add(route)
        return route
    }
}
