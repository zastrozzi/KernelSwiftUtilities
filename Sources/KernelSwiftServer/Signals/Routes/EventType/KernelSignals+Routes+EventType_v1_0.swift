//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/02/2025.
//

import KernelSwiftCommon
import Vapor

extension KernelSignals.Routes {
    public struct EventType_v1_0: ContextSwitchingRouteCollection, FeatureRouteCollection, APIModelAccessible {
        public typealias Feature = KernelSignals.Routes
        public static let openAPITag: String = "EventType V1.0"
        
        public enum RouteCollectionContext {
            case eventType
        }
        
        public var routeCollectionContext: RouteCollectionContext
        
        public init(forContext routeCollectionContext: RouteCollectionContext = .eventType) {
            self.routeCollectionContext = routeCollectionContext
        }
        
        public func boot(routes: RoutesBuilder) throws {
            let routeGroup: TypedRoutesBuilder
            switch routeCollectionContext {
            case .eventType:
                routeGroup = routes.versioned("1.0", "signals").typeGrouped("event-types").tags(Self.resolvedOpenAPITag)
                try bootEventTypeRoutes(routes: routeGroup)
            }
        }
    }
}
