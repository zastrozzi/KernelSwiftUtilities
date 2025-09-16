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
    public func bootAddressRoutesForEnduser(routes: TypedRoutesBuilder) throws {
        routes.post(use: createAddressHandler).summary("Create Address")
        routes.get(use: listAddressesHandler).summary("List Addresses for Enduser")
    }
    
    public func bootAddressRoutes(routes: TypedRoutesBuilder) throws {
        routes.get(":addressId".parameterType(UUID.self), use: getAddressHandler).summary("Get Address")
        routes.get(use: listAddressesHandler).summary("List Addresses")
        routes.put(":enduserId".parameterType(UUID.self), use: updateAddressHandler).summary("Update Address")
        routes.delete(":enduserId".parameterType(UUID.self), use: deleteAddressHandler).summary("Delete Address")
    }
}

extension KernelIdentity.Routes.Enduser_v1_0 {
    public func createAddressHandler(_ req: TypedRequest<CreateEnduserAddressContext>) async throws -> Response {
        let enduserId = try req.parameters.require("enduserId", as: UUID.self)
        let requestBody = try req.decodeBody()
        let newAddress = try await req.kernelDI(KernelIdentity.self).enduser.createAddress(forEnduser: enduserId, from: requestBody, as: req.platformActor)
        return try await req.response.success.encode(newAddress.response())
    }
    
    public func getAddressHandler(_ req: TypedRequest<GetEnduserAddressContext>) async throws -> Response {
        let addressId = try req.parameters.require("addressId", as: UUID.self)
        let address = try await req.kernelDI(KernelIdentity.self).enduser.getAddress(id: addressId, as: req.platformActor)
        return try await req.response.success.encode(address.response())
    }
    
    public func listAddressesHandler(_ req: TypedRequest<ListEnduserAddresssContext>) async throws -> Response {
        let pagedAddresses = try await req.kernelDI(KernelIdentity.self).enduser
            .listAddresses(
                forEnduser: req.parameters.get("enduserId", as: UUID.self),
                withPagination: req.decodeDefaultPagination(),
                as: req.platformActor
            )
        return try await req.response.success.encode(pagedAddresses.paginatedResponse())
    }
    
    public func updateAddressHandler(_ req: TypedRequest<UpdateEnduserAddressContext>) async throws -> Response {
        let addressId = try req.parameters.require("addressId", as: UUID.self)
        let requestBody = try req.decodeBody()
        let address = try await req.kernelDI(KernelIdentity.self).enduser.updateAddress(id: addressId, from: requestBody, as: req.platformActor)
        return try await req.response.success.encode(address.response())
    }
    
    public func deleteAddressHandler(_ req: TypedRequest<DeleteEnduserAddressContext>) async throws -> Response {
        let addressId = try req.parameters.require("addressId", as: UUID.self)
        try await req.kernelDI(KernelIdentity.self).enduser.deleteAddress(id: addressId, force: req.query.withDefault(\.force), as: req.platformActor)
        return try await req.response.success.encode(.init())
    }
}

extension KernelIdentity.Routes.Enduser_v1_0 {
    public typealias CreateEnduserAddressContext = PostRouteContext<KernelIdentity.Core.Model.CreateEnduserAddressRequest, KernelIdentity.Core.Model.EnduserAddressResponse>
    public typealias GetEnduserAddressContext = GetRouteContext<KernelIdentity.Core.Model.EnduserAddressResponse>
    public typealias ListEnduserAddresssContext = PaginatedGetRouteContext<KernelIdentity.Core.Model.EnduserAddressResponse>
    public typealias UpdateEnduserAddressContext = UpdateRouteContext<KernelIdentity.Core.Model.UpdateEnduserAddressRequest, KernelIdentity.Core.Model.EnduserAddressResponse>
    public typealias DeleteEnduserAddressContext = DeleteRouteContext<KernelSwiftCommon.Networking.HTTP.EmptyResponse>
}
