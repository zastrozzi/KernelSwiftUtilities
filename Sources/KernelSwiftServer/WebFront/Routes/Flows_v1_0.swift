//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 1/5/24.
//

import Vapor
import Fluent
import KernelSwiftCommon

extension KernelWebFront.Routes {
    
    public struct Flows_v1_0: ContextSwitchingRouteCollection, FeatureRouteCollection {
        public typealias Feature = KernelWebFront.Routes
        public static let openAPITag: String = "Flows V1.0"
        
        public enum RouteCollectionContext {
            case root
        }
        
        public var routeCollectionContext: RouteCollectionContext
        
        public init(forContext routeCollectionContext: RouteCollectionContext = .root) {
            self.routeCollectionContext = routeCollectionContext
        }
        
        public func boot(routes: RoutesBuilder) throws {
            let routeGroup: TypedRoutesBuilder
            switch routeCollectionContext {
            case .root:
                routeGroup = routes.versioned("1.0", "webfront").typeGrouped("flows").tags(Self.resolvedOpenAPITag)
                try bootContainerRoutes(routes: routeGroup.typeGrouped("containers"))
                try bootRootNodeRoutes(routes: routeGroup.typeGrouped("nodes"))
//                try bootNodeRoutes(routes: routeGroup.typeGrouped("nodes"), tag: openApiTag)
            }
        }
    }
}
