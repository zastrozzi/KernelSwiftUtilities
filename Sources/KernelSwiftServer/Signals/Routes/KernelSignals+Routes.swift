//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/02/2025.
//

import Vapor

extension KernelSignals {
    public enum Routes {}
}

extension KernelSignals.Routes: FeatureRoutes {
    public typealias FeatureContainer = KernelSignals
    public static var featureTag: String { "Signals" }
    
    public static func composed(_ routes: RoutesBuilder) -> RoutesBuilder {
        return routes.grouped("signals")
    }
    
    public static func configureRoutes(for app: Application) throws {
//        let unprotectedRoutes = app.developmentSecretProtectedRoutes()
        let accessTokenProtectedRoutes = app.grouped(app.kernelDI(KernelIdentity.self).auth)
            .typeGrouped().security(.bearerJWT, .localDeviceIdentification)
        
        try accessTokenProtectedRoutes.register(collection: Event_v1_0(forContext: .event))
        try accessTokenProtectedRoutes.register(collection: EventType_v1_0(forContext: .eventType))
    }
}
