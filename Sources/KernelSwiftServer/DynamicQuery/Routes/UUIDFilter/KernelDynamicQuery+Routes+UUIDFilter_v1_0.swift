//
//  StructuredQuery.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 04/02/2025.
//


import KernelSwiftCommon
import Vapor

extension KernelDynamicQuery.Routes {
    public struct UUIDFilter_v1_0: ContextSwitchingRouteCollection, FeatureRouteCollection, APIModelAccessible {
        public typealias Feature = KernelDynamicQuery.Routes
        public static let openAPITag: String = "UUIDFilter V1.0"
        
        public enum RouteCollectionContext {
            case uuidFilter
            case filterGroup
            case structuredQuery
        }
        
        public var routeCollectionContext: RouteCollectionContext
        
        public init(forContext routeCollectionContext: RouteCollectionContext = .uuidFilter) {
            self.routeCollectionContext = routeCollectionContext
        }
        
        public func boot(routes: RoutesBuilder) throws {
            let routeGroup: TypedRoutesBuilder
            switch routeCollectionContext {
            case .uuidFilter:
                routeGroup = routes.versioned("1.0", "kdq").typeGrouped("uuid-filters").tags(Self.resolvedOpenAPITag)
                try bootUUIDFilterRoutes(routes: routeGroup)
            case .structuredQuery:
                routeGroup = routes.typeGrouped("uuid-filters")
                try bootUUIDFilterRoutesForStructuredQuery(routes: routeGroup, tag: Self.resolvedOpenAPITag)
            case .filterGroup:
                routeGroup = routes.typeGrouped("uuid-filters")
                try bootUUIDFilterRoutesForFilterGroup(routes: routeGroup, tag: Self.resolvedOpenAPITag)
            }
        }
    }
}
