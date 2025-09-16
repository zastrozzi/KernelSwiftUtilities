//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 04/02/2025.
//

import KernelSwiftCommon
import Vapor

extension KernelDynamicQuery.Routes {
    public struct StructuredQuery_v1_0: ContextSwitchingRouteCollection, FeatureRouteCollection, APIModelAccessible {
        public typealias Feature = KernelDynamicQuery.Routes
        public static let openAPITag: String = "StructuredQuery V1.0"
        
        public enum RouteCollectionContext {
            case structuredQuery
            
        }
        
        public var routeCollectionContext: RouteCollectionContext
        
        public init(forContext routeCollectionContext: RouteCollectionContext = .structuredQuery) {
            self.routeCollectionContext = routeCollectionContext
        }
        
        public func boot(routes: RoutesBuilder) throws {
            let routeGroup: TypedRoutesBuilder
            switch routeCollectionContext {
            case .structuredQuery:
                routeGroup = routes.versioned("1.0", "kdq").typeGrouped("structured-queries").tags(Self.resolvedOpenAPITag)
                try bootStructuredQueryRoutes(routes: routeGroup)
            
            }
        }
    }
}
