//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 23/08/2024.
//

import Vapor
import Fluent
import KernelSwiftCommon

extension KernelIdentity.Routes.Enduser_v1_0 {
    public func bootDeviceRoutes(routes: TypedRoutesBuilder) throws {
        routes.get(":deviceId".parameterType(UUID.self), use: getDeviceHandler).summary("Get Admin User Device")
        routes.get(use: listDevicesHandler).summary("List Admin User Devices")
    }
    
    public func bootDeviceRoutesForEnduser(routes: TypedRoutesBuilder) throws {
        routes.get(use: listDevicesHandler).summary("List Devices for Admin User")
    }
}

extension KernelIdentity.Routes.Enduser_v1_0 {
    public func getDeviceHandler(_ req: TypedRequest<GetEnduserDeviceContext>) async throws -> Response {
        let deviceId = try req.parameters.require("deviceId", as: UUID.self)
        let device = try await req.kernelDI(KernelIdentity.self).enduser.getDevice(id: deviceId, as: req.platformActor)
        return try await req.response.success.encode(device.response())
    }
    
    public func listDevicesHandler(_ req: TypedRequest<ListEnduserDevicesContext>) async throws -> Response {
        let pagedDevices = try await req.kernelDI(KernelIdentity.self).enduser
            .listDevices(
                forEnduser: req.parameters.get("enduserId"),
                withPagination: req.decodeDefaultPagination(),
                as: req.platformActor
            )
        return try await req.response.success.encode(pagedDevices.paginatedResponse())
    }
}

extension KernelIdentity.Routes.Enduser_v1_0 {
    public typealias GetEnduserDeviceContext = GetRouteContext<KernelIdentity.Core.Model.EnduserDeviceResponse>
    public typealias ListEnduserDevicesContext = PaginatedGetRouteContext<KernelIdentity.Core.Model.EnduserDeviceResponse>
    public typealias DeleteEnduserDeviceContext = DeleteRouteContext<KernelSwiftCommon.Networking.HTTP.EmptyResponse>
}
