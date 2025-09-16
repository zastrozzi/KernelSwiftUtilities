//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/02/2025.
//

import KernelSwiftCommon
import Vapor

extension KernelSignals.Routes {
    public struct Event_v1_0: ContextSwitchingRouteCollection, FeatureRouteCollection, APIModelAccessible {
        public typealias Feature = KernelSignals.Routes
        public static let openAPITag: String = "Event V1.0"
        
        public enum RouteCollectionContext {
            case event
            case eventType
        }
        
        public var routeCollectionContext: RouteCollectionContext
        
        public init(forContext routeCollectionContext: RouteCollectionContext = .event) {
            self.routeCollectionContext = routeCollectionContext
        }
        
        public func boot(routes: RoutesBuilder) throws {
            let routeGroup: TypedRoutesBuilder
            switch routeCollectionContext {
            case .event:
                routeGroup = routes.versioned("1.0", "signals").typeGrouped("events").tags(Self.resolvedOpenAPITag)
                try bootEventRoutes(routes: routeGroup)
            case .eventType:
                routeGroup = routes.typeGrouped("events")
                try bootEventRoutesForEventType(routes: routeGroup, tag: Self.resolvedOpenAPITag)
            }
        }
    }
}
