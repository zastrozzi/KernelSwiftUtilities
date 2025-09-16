//
//  StructuredQuery.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 04/02/2025.
//


import KernelSwiftCommon
import Vapor

extension KernelDynamicQuery.Routes {
    public struct StringFilter_v1_0: ContextSwitchingRouteCollection, FeatureRouteCollection, APIModelAccessible {
        public typealias Feature = KernelDynamicQuery.Routes
        public static let openAPITag: String = "StringFilter V1.0"
        
        public enum RouteCollectionContext {
            case stringFilter
            case filterGroup
            case structuredQuery
        }
        
        public var routeCollectionContext: RouteCollectionContext
        
        public init(forContext routeCollectionContext: RouteCollectionContext = .stringFilter) {
            self.routeCollectionContext = routeCollectionContext
        }
        
        public func boot(routes: RoutesBuilder) throws {
            let routeGroup: TypedRoutesBuilder
            switch routeCollectionContext {
            case .stringFilter:
                routeGroup = routes.versioned("1.0", "kdq").typeGrouped("string-filters").tags(Self.resolvedOpenAPITag)
                try bootStringFilterRoutes(routes: routeGroup)
            case .structuredQuery:
                routeGroup = routes.typeGrouped("string-filters")
                try bootStringFilterRoutesForStructuredQuery(routes: routeGroup, tag: Self.resolvedOpenAPITag)
            case .filterGroup:
                routeGroup = routes.typeGrouped("string-filters")
                try bootStringFilterRoutesForFilterGroup(routes: routeGroup, tag: Self.resolvedOpenAPITag)
            }
        }
    }
}
