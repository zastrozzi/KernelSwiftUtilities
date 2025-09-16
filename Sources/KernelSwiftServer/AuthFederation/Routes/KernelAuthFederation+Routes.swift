//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 3/4/24.
//

import Vapor

extension KernelAuthFederation {
    public enum Routes {}
}

extension KernelAuthFederation.Routes: FeatureRoutes {
    public typealias FeatureContainer = KernelAuthFederation
    public static var featureTag: String { "AuthFederation" }
    
    public static func composed(_ routes: RoutesBuilder) -> RoutesBuilder {
        return routes.grouped("auth", "federated")
    }
    
    public static func configureRoutes(for app: Application) throws {
        // register route controllers here
        
        try app.register(collection: ServiceRegister_v1_0(forContext: .root))
    }
}
