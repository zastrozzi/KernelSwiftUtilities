//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 1/5/24.
//

import Vapor

extension KernelWebFront {
    public enum Routes {}
}

extension KernelWebFront.Routes: FeatureRoutes {
    public typealias FeatureContainer = KernelWebFront
    public static var featureTag: String { "WebFront" }
    
    public static func composed(_ routes: RoutesBuilder) -> RoutesBuilder {
        return routes.grouped("webfront")
    }
    
    public static func configureRoutes(for app: Application) throws {
        let accessTokenProtectedRoutes = app.grouped(app.kernelDI(KernelIdentity.self).auth)
            .typeGrouped().security(.bearerJWT, .localDeviceIdentification)
        try accessTokenProtectedRoutes.register(collection: Flows_v1_0(forContext: .root))
    }
}
