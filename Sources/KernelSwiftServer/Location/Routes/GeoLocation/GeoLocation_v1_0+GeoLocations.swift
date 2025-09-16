//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 01/10/2024.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelLocation.Routes.GeoLocation_v1_0 {
    public func bootGeoLocationRoutes(routes: TypedRoutesBuilder) throws {
        routes.post(body: .collect(maxSize: "5mb"), use: createGeoLocationHandler).summary("Create GeoLocation")
    }
}

extension KernelLocation.Routes.GeoLocation_v1_0 {
    public func createGeoLocationHandler(_ req: TypedRequest<CreateGeoLocationContext>) async throws -> Response {
        let geoLocation = try await featureContainer.services.geolocation.createLocation(
            from: req.decodeBody(),
            as: req.platformActor
        )
        return try await req.response.success.encode(try geoLocation.response())
    }
}

extension KernelLocation.Routes.GeoLocation_v1_0 {
    public typealias CreateGeoLocationContext = PostRouteContext<
        KernelLocation.Core.GeoLocation.CreateGeoLocationRequest,
        KernelLocation.Core.GeoLocation.GeoLocationResponse
    >
}
