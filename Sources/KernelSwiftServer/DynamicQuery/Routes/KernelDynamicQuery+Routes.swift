//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 04/02/2025.
//

import Vapor

extension KernelDynamicQuery {
    public enum Routes {}
}

extension KernelDynamicQuery.Routes: FeatureRoutes {
    public typealias FeatureContainer = KernelDynamicQuery
    public static var featureTag: String { "DynamicQuery" }
    
    public static func composed(_ routes: RoutesBuilder) -> RoutesBuilder {
        return routes.grouped("kdq")
    }
    
    public static func configureRoutes(for app: Application) throws {
//        let unprotectedRoutes = app.developmentSecretProtectedRoutes()
        let accessTokenProtectedRoutes = app.grouped(app.kernelDI(KernelIdentity.self).auth)
            .typeGrouped().security(.bearerJWT, .localDeviceIdentification)
        
        try accessTokenProtectedRoutes.register(collection: QueryableSchema_v1_0(forContext: .table))
        try accessTokenProtectedRoutes.register(collection: QueryableSchema_v1_0(forContext: .column))
        try accessTokenProtectedRoutes.register(collection: QueryableSchema_v1_0(forContext: .relationship))
        try accessTokenProtectedRoutes.register(collection: StructuredQuery_v1_0(forContext: .structuredQuery))
        try accessTokenProtectedRoutes.register(collection: FilterGroup_v1_0(forContext: .filterGroup))
        try accessTokenProtectedRoutes.register(collection: BooleanFilter_v1_0(forContext: .booleanFilter))
        try accessTokenProtectedRoutes.register(collection: DateFilter_v1_0(forContext: .dateFilter))
        try accessTokenProtectedRoutes.register(collection: EnumFilter_v1_0(forContext: .enumFilter))
        try accessTokenProtectedRoutes.register(collection: NumericFilter_v1_0(forContext: .numericFilter))
        try accessTokenProtectedRoutes.register(collection: StringFilter_v1_0(forContext: .stringFilter))
        try accessTokenProtectedRoutes.register(collection: UUIDFilter_v1_0(forContext: .uuidFilter))
    }
}
