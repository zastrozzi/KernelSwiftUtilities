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
    public func bootPhoneRoutes(routes: RoutesBuilder) throws {
        routes.get(":phoneId".parameterType(UUID.self), use: getPhoneHandler).summary("Get Enduser Phone")
        routes.get(use: listPhonesHandler).summary("List Enduser Phones")
        routes.put(":phoneId".parameterType(UUID.self), use: updatePhoneHandler).summary("Update Enduser Phone")
        routes.delete(":phoneId".parameterType(UUID.self), use: deletePhoneHandler).summary("Delete Enduser Phone")
    }
    
    public func bootPhoneRoutesForEnduser(routes: RoutesBuilder) throws {
        routes.post(use: createPhoneHandler).summary("Create Enduser Phone")
        routes.get(use: listPhonesHandler).summary("List Phones for Enduser")
    }
}

extension KernelIdentity.Routes.Enduser_v1_0 {
    public func createPhoneHandler(_ req: TypedRequest<CreateEnduserPhoneContext>) async throws -> Response {
        let enduserId = try req.parameters.require("enduserId", as: UUID.self)
        let newPhone = try await req.kernelDI(KernelIdentity.self).enduser.createPhone(
            forEnduser: enduserId,
            from: try req.decodeBody(),
            as: req.platformActor
        )
        return try await req.response.success.encode(newPhone.response())
    }
    
    public func getPhoneHandler(_ req: TypedRequest<GetEnduserPhoneContext>) async throws -> Response {
        let phoneId = try req.parameters.require("phoneId", as: UUID.self)
        let phone = try await req.kernelDI(KernelIdentity.self).enduser.getPhone(id: phoneId, as: req.platformActor)
        return try await req.response.success.encode(phone.response())
    }
    
    public func listPhonesHandler(_ req: TypedRequest<ListEnduserPhonesContext>) async throws -> Response {
        let enduserId = req.parameters.get("enduserId", as: UUID.self)
        let phones = try await req.kernelDI(KernelIdentity.self).enduser.listPhones(
            forEnduser: enduserId,
            withPagination: req.decodeDefaultPagination(),
            as: req.platformActor
        )
        return try await req.response.success.encode(phones.paginatedResponse())
    }
    
    public func updatePhoneHandler(_ req: TypedRequest<UpdateEnduserPhoneContext>) async throws -> Response {
        let phoneId = try req.parameters.require("phoneId", as: UUID.self)
        let updatedPhone = try await req.kernelDI(KernelIdentity.self).enduser.updatePhone(
            id: phoneId,
            from: try req.decodeBody(),
            as: req.platformActor
        )
        return try await req.response.success.encode(updatedPhone.response())
    }
    
    public func deletePhoneHandler(_ req: TypedRequest<DeleteEnduserPhoneContext>) async throws -> Response {
        let phoneId = try req.parameters.require("phoneId", as: UUID.self)
        try await req.kernelDI(KernelIdentity.self).enduser.deletePhone(id: phoneId, as: req.platformActor)
        return try await req.response.success.encode(.init())
    }
}

extension KernelIdentity.Routes.Enduser_v1_0 {
    public typealias CreateEnduserPhoneContext = PostRouteContext<KernelIdentity.Core.Model.CreateEnduserPhoneRequest, KernelIdentity.Core.Model.EnduserPhoneResponse>
    public typealias GetEnduserPhoneContext = GetRouteContext<KernelIdentity.Core.Model.EnduserPhoneResponse>
    public typealias ListEnduserPhonesContext = PaginatedGetRouteContext<KernelIdentity.Core.Model.EnduserPhoneResponse>
    public typealias UpdateEnduserPhoneContext = UpdateRouteContext<KernelIdentity.Core.Model.UpdateEnduserPhoneRequest, KernelIdentity.Core.Model.EnduserPhoneResponse>
    public typealias DeleteEnduserPhoneContext = DeleteRouteContext<KernelSwiftCommon.Networking.HTTP.EmptyResponse>
}
