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
    
    public struct StorageObject_v1_0: ContextSwitchingRouteCollection, FeatureRouteCollection {
        public typealias Feature = KernelGoogleCloud.Routes
        public static let openAPITag: String = "StorageObject V1.0"
        
        public enum RouteCollectionContext {
            case storageObject
            case storageBucket
        }
        
        public var routeCollectionContext: RouteCollectionContext
        
        public init(forContext routeCollectionContext: RouteCollectionContext = .storageObject) {
            self.routeCollectionContext = routeCollectionContext
        }
        
        public func boot(routes: RoutesBuilder) throws {
            let routeGroup: TypedRoutesBuilder
            switch routeCollectionContext {
            case .storageObject:
                routeGroup = routes.versioned("1.0", "kgc").typeGrouped("storage-objects").tags(Self.resolvedOpenAPITag)
                try bootStorageObjectRoutes(routes: routeGroup)
            case .storageBucket:
                routeGroup = routes.typeGrouped("storage-objects")
                try bootStorageObjectRoutesForStorageBucket(routes: routeGroup, tag: Self.resolvedOpenAPITag)
            }
        }
    }
}
