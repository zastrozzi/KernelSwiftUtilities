//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 3/4/24.
//

import Vapor
import Fluent
import KernelSwiftCommon

extension KernelAuthFederation.Routes {
    public struct ServiceRegister_v1_0: ContextSwitchingRouteCollection, FeatureRouteCollection {
        public typealias Feature = KernelAuthFederation.Routes
        public static let openAPITag: String = "Services V1.0"
        
        public enum RouteCollectionContext {
            case root
        }
        
        public var routeCollectionContext: RouteCollectionContext
        
        public init(forContext routeCollectionContext: RouteCollectionContext = .root) {
            self.routeCollectionContext = routeCollectionContext
        }
        
        public func boot(routes: RoutesBuilder) throws {
            let routeGroup = KernelAuthFederation.Routes.composed(routes.versioned("1.0")).typeGrouped("services").tags(Self.resolvedOpenAPITag)
            
            routeGroup.get("add", use: addServices).summary("Add Services")
            routeGroup.get("list", use: listServices).summary("List All Services")
            routeGroup.get("remove", use: removeServices).summary("Remove Services")
            routeGroup.get(":id".parameterType(UUID.self), use: getServiceById).summary("Get Service By ID")
        }
        
        public func addServices(_ req: TypedRequest<ListServicesContext>) async throws -> Response {
            try req.authSession.set("session-test", to: String("added from list endpoint"))
            return try await req.response.success.encode(.init())
        }
        
        public func listServices(_ req: TypedRequest<ListServicesContext>) async throws -> Response {
            if let sessionTest = try? req.authSession.get("session-test", as: String.self) {
                KernelAuthFederation.logger.debug("From session: \(sessionTest)")
            } else {
                KernelAuthFederation.logger.debug("From session: null")
            }
            return try await req.response.success.encode(.init())
        }
        
        public func removeServices(_ req: TypedRequest<ListServicesContext>) async throws -> Response {
            req.authSession.invalidate()
            return try await req.response.success.encode(.init())
        }
        
        public func getServiceById(_ req: TypedRequest<GetServiceByIdContext>) async throws -> Response {
            return try await req.response.success.encode(.init())
        }
    }
}

extension KernelAuthFederation.Routes.ServiceRegister_v1_0 {
    public typealias ListServicesContext = GetRouteContext<KernelSwiftCommon.Networking.HTTP.EmptyResponse>
    public typealias GetServiceByIdContext = GetRouteContext<KernelSwiftCommon.Networking.HTTP.EmptyResponse>
}
