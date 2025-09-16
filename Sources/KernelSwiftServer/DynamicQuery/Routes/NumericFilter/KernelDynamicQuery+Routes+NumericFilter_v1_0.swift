//
//  StructuredQuery.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 04/02/2025.
//


import KernelSwiftCommon
import Vapor

extension KernelDynamicQuery.Routes {
    public struct NumericFilter_v1_0: ContextSwitchingRouteCollection, FeatureRouteCollection, APIModelAccessible {
        public typealias Feature = KernelDynamicQuery.Routes
        public static let openAPITag: String = "NumericFilter V1.0"
        
        public enum RouteCollectionContext {
            case numericFilter
            case filterGroup
            case structuredQuery
        }
        
        public var routeCollectionContext: RouteCollectionContext
        
        public init(forContext routeCollectionContext: RouteCollectionContext = .numericFilter) {
            self.routeCollectionContext = routeCollectionContext
        }
        
        public func boot(routes: RoutesBuilder) throws {
            let routeGroup: TypedRoutesBuilder
            switch routeCollectionContext {
            case .numericFilter:
                routeGroup = routes.versioned("1.0", "kdq").typeGrouped("numeric-filters").tags(Self.resolvedOpenAPITag)
                try bootNumericFilterRoutes(routes: routeGroup)
            case .structuredQuery:
                routeGroup = routes.typeGrouped("numeric-filters")
                try bootNumericFilterRoutesForStructuredQuery(routes: routeGroup, tag: Self.resolvedOpenAPITag)
            case .filterGroup:
                routeGroup = routes.typeGrouped("numeric-filters")
                try bootNumericFilterRoutesForFilterGroup(routes: routeGroup, tag: Self.resolvedOpenAPITag)
            }
        }
    }
}
