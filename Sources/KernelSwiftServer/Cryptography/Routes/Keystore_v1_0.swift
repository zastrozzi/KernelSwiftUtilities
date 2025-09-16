//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 05/07/2023.
//

import Vapor
import Fluent
import KernelSwiftCommon

/// RouteCollection
extension KernelCryptography.Routes {
    
    public struct Keystore_v1_0: ContextSwitchingRouteCollection, FeatureRouteCollection {
        public typealias Feature = KernelCryptography.Routes
        public static let openAPITag: String = "Keystore V1.0"
        
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
                
                routeGroup = routes.versioned("1.0", "crypto").typeGrouped("keystore")
                    .developmentSecretProtectedRoutes()
                    .tags(Self.resolvedOpenAPITag)
                try bootRSARoutes(routes: routeGroup.typeGrouped("rsa"), tag: Self.resolvedOpenAPITag)
                try bootECRoutes(routes: routeGroup.typeGrouped("ec"), tag: Self.resolvedOpenAPITag)
            }
        }
    }
}
