//
//  File.swift
//
//
//  Created by Jonathan Forbes on 4/5/24.
//

import Vapor

extension KernelIdentity {
    public enum Routes {}
}

extension KernelIdentity.Routes: FeatureRoutes {
    public typealias FeatureContainer = KernelIdentity
    public static var featureTag: String { "Identity" }
    
    public static func composed(_ routes: RoutesBuilder) -> RoutesBuilder {
        return routes.grouped("identity")
    }
    
    public static func configureRoutes(for app: Application) throws {
        let unprotectedRoutes = app.typeGrouped().security(.localDeviceIdentification)
        try unprotectedRoutes.register(collection: AdminUser_v1_0(forContext: .unprotected))
        try unprotectedRoutes.register(collection: Enduser_v1_0(forContext: .unprotected))
        
        
        let refreshTokenProtectedRoutes = app.typeGrouped().security(.localDeviceIdentification)
        try refreshTokenProtectedRoutes.register(collection: AdminUser_v1_0(forContext: .refreshTokenProtected))
        try refreshTokenProtectedRoutes.register(collection: Enduser_v1_0(forContext: .refreshTokenProtected))
        
        let accessTokenProtectedRoutes = app.grouped(app.kernelDI(KernelIdentity.self).auth)
            .typeGrouped().security(.bearerJWT, .localDeviceIdentification)
        try accessTokenProtectedRoutes.register(collection: AdminUser_v1_0(forContext: .accessTokenProtected))
        try accessTokenProtectedRoutes.register(collection: Enduser_v1_0(forContext: .accessTokenProtected))
    }
}
