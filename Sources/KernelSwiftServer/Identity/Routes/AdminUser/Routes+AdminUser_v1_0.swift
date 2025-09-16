//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 19/06/2024.
//

import KernelSwiftCommon
import Vapor

extension KernelIdentity.Routes {
    public struct AdminUser_v1_0: ContextSwitchingRouteCollection, FeatureRouteCollection, Sendable {
        public typealias Feature = KernelIdentity.Routes
        public static let openAPITag: String = "Admin User V1.0"
        
        public enum RouteCollectionContext: Sendable {
            case unprotected
            case accessTokenProtected
            case refreshTokenProtected
        }
        
        public var routeCollectionContext: RouteCollectionContext
        
        public init(forContext routeCollectionContext: RouteCollectionContext = .unprotected) {
            self.routeCollectionContext = routeCollectionContext
        }
        
        public func boot(routes: RoutesBuilder) throws {
            let routeGroup: TypedRoutesBuilder
            switch routeCollectionContext {
            case .unprotected:
                routeGroup = routes.versioned("1.0", "identity").typeGrouped("admin-users").tags(Self.resolvedOpenAPITag)
                try bootAdminUserAuthRoutes(routes: routeGroup.typeGrouped("auth"))
            case .accessTokenProtected:
                routeGroup = routes.versioned("1.0", "identity").typeGrouped("admin-users").tags(Self.resolvedOpenAPITag)
                try bootAccessTokenProtectedAuthRoutes(routes: routeGroup.typeGrouped("auth"))
                try bootAdminUserRoutes(routes: routeGroup)
                try bootEmailRoutes(routes: routeGroup.typeGrouped("email-accounts"))
                try bootEmailRoutesForAdminUser(routes: routeGroup.typeGrouped(":adminUserId".parameterType(UUID.self), "email-accounts"))
                try bootCredentialRoutes(routes: routeGroup.typeGrouped("credentials"))
                try bootCredentialRoutesForAdminUser(routes: routeGroup.typeGrouped(":adminUserId".parameterType(UUID.self), "credentials"))
                try bootDeviceRoutes(routes: routeGroup.typeGrouped("devices"))
                try bootDeviceRoutesForAdminUser(routes: routeGroup.typeGrouped(":adminUserId".parameterType(UUID.self), "devices"))
                try bootActivityRoutesForAdminUser(routes: routeGroup.typeGrouped(":adminUserId".parameterType(UUID.self), "activity"))
                try bootSessionRoutes(routes: routeGroup.typeGrouped("sessions"))
                try bootSessionRoutesForAdminUser(routes: routeGroup.typeGrouped(":adminUserId".parameterType(UUID.self), "sessions"))
            case .refreshTokenProtected:
                routeGroup = routes.versioned("1.0", "identity").typeGrouped("admin-users").tags(Self.resolvedOpenAPITag)
                try bootRefreshTokenProtectedAuthRoutes(routes: routeGroup.typeGrouped("auth"))
            }
        }
    }
}

