//
//  StructuredQuery.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 04/02/2025.
//


import KernelSwiftCommon
import Vapor

extension KernelDynamicQuery.Routes {
    public struct FilterGroup_v1_0: ContextSwitchingRouteCollection, FeatureRouteCollection, APIModelAccessible {
        public typealias Feature = KernelDynamicQuery.Routes
        public static let openAPITag: String = "FilterGroup V1.0"
        
        public enum RouteCollectionContext {
            case filterGroup
            case structuredQuery
            case parentFilterGroup
            
        }
        
        public var routeCollectionContext: RouteCollectionContext
        
        public init(forContext routeCollectionContext: RouteCollectionContext = .filterGroup) {
            self.routeCollectionContext = routeCollectionContext
        }
        
        public func boot(routes: RoutesBuilder) throws {
            let routeGroup: TypedRoutesBuilder
            switch routeCollectionContext {
            case .filterGroup:
                routeGroup = routes.versioned("1.0", "kdq").typeGrouped("filter-groups").tags(Self.resolvedOpenAPITag)
                try bootFilterGroupRoutes(routes: routeGroup)
            case .structuredQuery:
                routeGroup = routes.typeGrouped("filter-groups")
                try bootFilterGroupRoutesForStructuredQuery(routes: routeGroup, tag: Self.resolvedOpenAPITag)
            case .parentFilterGroup:
                routeGroup = routes.typeGrouped("filter-groups")
                try bootFilterGroupRoutesForParentGroup(routes: routeGroup, tag: Self.resolvedOpenAPITag)
            }
        }
    }
}
