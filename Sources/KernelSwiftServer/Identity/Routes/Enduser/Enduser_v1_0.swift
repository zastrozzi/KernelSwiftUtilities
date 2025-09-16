//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 23/08/2024.
//

import Vapor
import Fluent
import KernelSwiftCommon

extension KernelIdentity.Routes {
    
    public struct Enduser_v1_0: ContextSwitchingRouteCollection, FeatureRouteCollection {
        public typealias Feature = KernelIdentity.Routes
        public static let openAPITag: String = "Enduser V1.0"
        
        public enum RouteCollectionContext: Sendable {
            case unprotected
            case accessTokenProtected
            case refreshTokenProtected
        }
        
        public let routeCollectionContext: RouteCollectionContext
        
        public init(forContext routeCollectionContext: RouteCollectionContext = .unprotected) {
            self.routeCollectionContext = routeCollectionContext
        }
        
        public func boot(routes: RoutesBuilder) throws {
            let routeGroup: TypedRoutesBuilder
            switch routeCollectionContext {
            case .unprotected:
                routeGroup = routes.versioned("1.0", "identity").typeGrouped("endusers")
                    .tags(Self.resolvedOpenAPITag)
                try bootEnduserAuthRoutes(routes: routeGroup.typeGrouped("auth"))
            case .accessTokenProtected:
                routeGroup = routes.versioned("1.0", "identity").typeGrouped("endusers").tags(Self.resolvedOpenAPITag)
                try bootAccessTokenProtectedAuthRoutes(routes: routeGroup.typeGrouped("auth"))
                try bootEnduserRoutes(routes: routeGroup)
                try bootEmailRoutes(routes: routeGroup.typeGrouped("email-accounts"))
                try bootEmailRoutesForEnduser(routes: routeGroup.typeGrouped(":enduserId".parameterType(UUID.self), "email-accounts"))
                try bootCredentialRoutes(routes: routeGroup.typeGrouped("credentials"))
                try bootCredentialRoutesForEnduser(routes: routeGroup.typeGrouped(":enduserId".parameterType(UUID.self), "credentials"))
                try bootAddressRoutes(routes: routeGroup.typeGrouped("addresses"))
                try bootAddressRoutesForEnduser(routes: routeGroup.typeGrouped(":enduserId".parameterType(UUID.self), "addresses"))
                try bootPhoneRoutes(routes: routeGroup.typeGrouped("phone-numbers"))
                try bootPhoneRoutesForEnduser(routes: routeGroup.typeGrouped(":enduserId".parameterType(UUID.self), "phone-numbers"))
                try bootDeviceRoutes(routes: routeGroup.typeGrouped("devices"))
                try bootDeviceRoutesForEnduser(routes: routeGroup.typeGrouped(":enduserId".parameterType(UUID.self), "devices"))
                try bootActivityRoutesForEnduser(routes: routeGroup.typeGrouped(":enduserId".parameterType(UUID.self), "activity"))
                try bootSessionRoutes(routes: routeGroup.typeGrouped("sessions"))
                try bootSessionRoutesForEnduser(routes: routeGroup.typeGrouped(":enduserId".parameterType(UUID.self), "sessions"))
                
            case .refreshTokenProtected:
                routeGroup = routes.versioned("1.0", "identity").typeGrouped("endusers").tags(Self.resolvedOpenAPITag)
                try bootRefreshTokenProtectedAuthRoutes(routes: routeGroup.typeGrouped("auth"))
            }
        }
    }
}
