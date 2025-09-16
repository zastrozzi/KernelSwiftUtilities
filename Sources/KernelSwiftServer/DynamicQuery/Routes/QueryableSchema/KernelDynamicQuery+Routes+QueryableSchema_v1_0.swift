//
//  StructuredQuery.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 04/02/2025.
//


import KernelSwiftCommon
import Vapor

extension KernelDynamicQuery.Routes {
    public struct QueryableSchema_v1_0: ContextSwitchingRouteCollection, FeatureRouteCollection, APIModelAccessible {
        public typealias Feature = KernelDynamicQuery.Routes
        public static let openAPITag: String = "QueryableSchema V1.0"
        
        public enum RouteCollectionContext {
            case table
            case column
            case relationship
        }
        
        public var routeCollectionContext: RouteCollectionContext
        
        public init(forContext routeCollectionContext: RouteCollectionContext = .table) {
            self.routeCollectionContext = routeCollectionContext
        }
        
        public func boot(routes: RoutesBuilder) throws {
            let routeGroup: TypedRoutesBuilder
            switch routeCollectionContext {
            case .table:
                routeGroup = routes.versioned("1.0", "kdq").typeGrouped("schemas", "tables").tags(Self.resolvedOpenAPITag)
                try bootTableRoutes(routes: routeGroup)
            case .column:
                routeGroup = routes.versioned("1.0", "kdq").typeGrouped("schemas", "columns").tags(Self.resolvedOpenAPITag)
                try bootColumnRoutes(routes: routeGroup)
            case .relationship:
                routeGroup = routes.versioned("1.0", "kdq").typeGrouped("schemas", "relationships").tags(Self.resolvedOpenAPITag)
                try bootRelationshipRoutes(routes: routeGroup)
            }
        }
    }
}
