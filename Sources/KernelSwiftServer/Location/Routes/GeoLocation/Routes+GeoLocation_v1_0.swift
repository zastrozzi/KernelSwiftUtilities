//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 01/10/2024.
//

import KernelSwiftCommon
import Vapor

extension KernelLocation.Routes {
    public struct GeoLocation_v1_0: ContextSwitchingRouteCollection, FeatureRouteCollection {
        public typealias Feature = KernelLocation.Routes
        public static let openAPITag: String = "GeoLocation V1.0"
        
        public enum RouteCollectionContext {
            case geolocation
        }
        
        public var routeCollectionContext: RouteCollectionContext
        
        public init(forContext routeCollectionContext: RouteCollectionContext = .geolocation) {
            self.routeCollectionContext = routeCollectionContext
        }
        
        public func boot(routes: RoutesBuilder) throws {
            let routeGroup: TypedRoutesBuilder
            switch routeCollectionContext {
            case .geolocation:
                routeGroup = routes.versioned("1.0", "location").typeGrouped("geolocations").tags(Self.resolvedOpenAPITag)
                try bootGeoLocationRoutes(routes: routeGroup)
            }
        }
    }
}

