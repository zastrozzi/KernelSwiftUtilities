//
//  StructuredQuery.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 04/02/2025.
//


import KernelSwiftCommon
import Vapor

extension KernelDynamicQuery.Routes {
    public struct EnumFilter_v1_0: ContextSwitchingRouteCollection, FeatureRouteCollection, APIModelAccessible {
        public typealias Feature = KernelDynamicQuery.Routes
        public static let openAPITag: String = "EnumFilter V1.0"
        
        public enum RouteCollectionContext {
            case enumFilter
            case filterGroup
            case structuredQuery
        }
        
        public var routeCollectionContext: RouteCollectionContext
        
        public init(forContext routeCollectionContext: RouteCollectionContext = .enumFilter) {
            self.routeCollectionContext = routeCollectionContext
        }
        
        public func boot(routes: RoutesBuilder) throws {
            let routeGroup: TypedRoutesBuilder
            switch routeCollectionContext {
            case .enumFilter:
                routeGroup = routes.versioned("1.0", "kdq").typeGrouped("enum-filters").tags(Self.resolvedOpenAPITag)
                try bootEnumFilterRoutes(routes: routeGroup)
            case .structuredQuery:
                routeGroup = routes.typeGrouped("enum-filters")
                try bootEnumFilterRoutesForStructuredQuery(routes: routeGroup, tag: Self.resolvedOpenAPITag)
            case .filterGroup:
                routeGroup = routes.typeGrouped("enum-filters")
                try bootEnumFilterRoutesForFilterGroup(routes: routeGroup, tag: Self.resolvedOpenAPITag)
            }
        }
    }
}
