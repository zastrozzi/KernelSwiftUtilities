//
//  StructuredQuery.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 04/02/2025.
//


import KernelSwiftCommon
import Vapor

extension KernelDynamicQuery.Routes {
    public struct BooleanFilter_v1_0: ContextSwitchingRouteCollection, FeatureRouteCollection, APIModelAccessible {
        public typealias Feature = KernelDynamicQuery.Routes
        public static let openAPITag: String = "BooleanFilter V1.0"
        
        public enum RouteCollectionContext {
            case booleanFilter
            case filterGroup
            case structuredQuery
        }
        
        public var routeCollectionContext: RouteCollectionContext
        
        public init(forContext routeCollectionContext: RouteCollectionContext = .booleanFilter) {
            self.routeCollectionContext = routeCollectionContext
        }
        
        public func boot(routes: RoutesBuilder) throws {
            let routeGroup: TypedRoutesBuilder
            switch routeCollectionContext {
            case .booleanFilter:
                routeGroup = routes.versioned("1.0", "kdq").typeGrouped("boolean-filters").tags(Self.resolvedOpenAPITag)
                try bootBooleanFilterRoutes(routes: routeGroup)
            case .structuredQuery:
                routeGroup = routes.typeGrouped("boolean-filters")
                try bootBooleanFilterRoutesForStructuredQuery(routes: routeGroup, tag: Self.resolvedOpenAPITag)
            case .filterGroup:
                routeGroup = routes.typeGrouped("boolean-filters")
                try bootBooleanFilterRoutesForFilterGroup(routes: routeGroup, tag: Self.resolvedOpenAPITag)
            }
        }
    }
}
