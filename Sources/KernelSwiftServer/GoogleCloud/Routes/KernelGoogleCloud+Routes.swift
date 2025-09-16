//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 09/04/2025.
//

import Vapor

extension KernelGoogleCloud {
    public enum Routes {}
}

extension KernelGoogleCloud.Routes: FeatureRoutes {
    public typealias FeatureContainer = KernelGoogleCloud
    public static var featureTag: String { "GoogleCloud" }
    
    public static func composed(_ routes: RoutesBuilder) -> RoutesBuilder {
        return routes.grouped("kgc")
    }
    
    public static func configureRoutes(for app: Application) throws {
        let accessTokenProtectedRoutes = app.grouped(app.kernelDI(KernelIdentity.self).auth)
            .typeGrouped().security(.bearerJWT, .localDeviceIdentification)
//                let accessTokenProtectedRoutes = app.developmentSecretProtectedRoutes()
        
        try accessTokenProtectedRoutes.register(collection: StorageBucket_v1_0(forContext: .storageBucket))
        try accessTokenProtectedRoutes.register(collection: StorageObject_v1_0(forContext: .storageObject))
    }
}
