//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 09/04/2025.
//

import Vapor
import Fluent
import KernelSwiftCommon

extension KernelGoogleCloud.Routes {
    
    public struct StorageBucket_v1_0: ContextSwitchingRouteCollection, FeatureRouteCollection {
        public typealias Feature = KernelGoogleCloud.Routes
        public static let openAPITag: String = "StorageBucket V1.0"
        
        public enum RouteCollectionContext {
            case storageBucket
        }
        
        public var routeCollectionContext: RouteCollectionContext
        
        public init(forContext routeCollectionContext: RouteCollectionContext = .storageBucket) {
            self.routeCollectionContext = routeCollectionContext
        }
        
        public func boot(routes: RoutesBuilder) throws {
            let routeGroup: TypedRoutesBuilder
            switch routeCollectionContext {
            case .storageBucket:
                routeGroup = routes.versioned("1.0", "kgc").typeGrouped("storage-buckets").tags(Self.resolvedOpenAPITag)
                try bootStorageBucketRoutes(routes: routeGroup)
            }
        }
    }
}
