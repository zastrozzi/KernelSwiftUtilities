//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 03/12/2023.
//

import Vapor

extension KernelX509 {
    public enum Routes {}
}

extension KernelX509.Routes: FeatureRoutes {
    public typealias FeatureContainer = KernelX509
    public static var featureTag: String { "X509" }
    
    public static func composed(_ routes: RoutesBuilder) -> RoutesBuilder {
        return routes.grouped("x509")
    }
    
    public static func configureRoutes(for app: Application) throws {
        let accessTokenProtectedRoutes = app.grouped(app.kernelDI(KernelIdentity.self).auth)
            .typeGrouped().security(.bearerJWT, .localDeviceIdentification)
        try accessTokenProtectedRoutes.register(collection: CertificateStore_v1_0(forContext: .root))
    }
}
