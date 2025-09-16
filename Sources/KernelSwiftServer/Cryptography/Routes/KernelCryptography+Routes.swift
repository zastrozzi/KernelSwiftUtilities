//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 05/07/2023.
//

import Vapor
//import KernelOpenBanking

extension KernelCryptography {
    public enum Routes {}
}

extension KernelCryptography.Routes: FeatureRoutes {
    public typealias FeatureContainer = KernelCryptography
    public static var featureTag: String { "Cryptography" }
    
    public static func composed(_ routes: RoutesBuilder) -> RoutesBuilder {
        return routes.grouped("crypto")
    }
    
    public static func configureRoutes(for app: Application) throws {
        let accessTokenProtectedRoutes = app.grouped(app.kernelDI(KernelIdentity.self).auth)
            .typeGrouped().security(.bearerJWT, .localDeviceIdentification)
        try accessTokenProtectedRoutes.register(collection: Keystore_v1_0(forContext: .root))
    }
}
