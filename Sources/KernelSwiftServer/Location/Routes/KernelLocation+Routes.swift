//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/06/2024.
//

import Vapor

extension KernelLocation {
    public enum Routes {}
}

extension KernelLocation.Routes: FeatureRoutes {
    public typealias FeatureContainer = KernelLocation
    public static var featureTag: String { "Location" }
    
    public static func composed(_ routes: RoutesBuilder) -> RoutesBuilder {
        return routes.grouped("location")
    }
    
    public static func configureRoutes(for app: Application) throws {
//        let unprotectedRoutes = app.developmentSecretProtectedRoutes()
        
        
        
        let accessTokenProtectedRoutes = app.grouped(app.kernelDI(KernelIdentity.self).auth)
            .typeGrouped().security(.bearerJWT, .localDeviceIdentification)
        try accessTokenProtectedRoutes.register(collection: GeoLocation_v1_0(forContext: .geolocation))
        
    }
}

