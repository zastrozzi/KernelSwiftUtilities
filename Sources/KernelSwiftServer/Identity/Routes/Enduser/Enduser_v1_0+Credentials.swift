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
    public func bootCredentialRoutes(routes: TypedRoutesBuilder) throws {
        routes.get(":credentialId".parameterType(UUID.self), use: getCredentialHandler).summary("Get Enduser Credential")
        routes.get(use: listCredentialsHandler).summary("List Enduser Credentials")
        routes.put(":credentialId".parameterType(UUID.self), use: updateCredentialHandler).summary("Update Enduser Credential")
        routes.delete(":credentialId".parameterType(UUID.self), use: deleteCredentialHandler).summary("Delete Enduser Credential")
    }
    
    public func bootCredentialRoutesForEnduser(routes: TypedRoutesBuilder) throws {
        routes.post(use: createCredentialHandler).summary("Create Enduser Credential")
        routes.get(use: listCredentialsHandler).summary("List Credentials for Enduser")
    }
}

extension KernelIdentity.Routes.Enduser_v1_0 {
    public func createCredentialHandler(_ req: TypedRequest<CreateEnduserCredentialContext>) async throws -> Response {
        let newCredential = try await req.kernelDI(KernelIdentity.self).enduser.createCredential(
            forEnduser: try req.parameters.require("enduserId", as: UUID.self),
            from: try req.decodeBody(),
            as: req.platformActor
        )
        return try await req.response.success.encode(newCredential.response())
    }
    
    public func getCredentialHandler(_ req: TypedRequest<GetEnduserCredentialContext>) async throws -> Response {
        let credentialId = try req.parameters.require("credentialId", as: UUID.self)
        let credential = try await req.kernelDI(KernelIdentity.self).enduser.getCredential(id: credentialId, as: req.platformActor)
        return try await req.response.success.encode(credential.response())
    }
    
    public func listCredentialsHandler(_ req: TypedRequest<ListEnduserCredentialsContext>) async throws -> Response {
        let pagedCredentials = try await req.kernelDI(KernelIdentity.self).enduser
            .listCredentials(
                forEnduser: req.parameters.get("enduserId", as: UUID.self),
                withPagination: req.decodeDefaultPagination(),
                as: req.platformActor
            )
        return try await req.response.success.encode(pagedCredentials.paginatedResponse())
    }
    
    public func updateCredentialHandler(_ req: TypedRequest<UpdateEnduserCredentialContext>) async throws -> Response {
        let credentialId = try req.parameters.require("credentialId", as: UUID.self)
        let requestBody = try req.decodeBody()
        let credential = try await req.kernelDI(KernelIdentity.self).enduser.updateCredential(id: credentialId, from: requestBody, as: req.platformActor)
        return try await req.response.success.encode(credential.response())
    }
    
    public func deleteCredentialHandler(_ req: TypedRequest<DeleteEnduserCredentialContext>) async throws -> Response {
        let credentialId = try req.parameters.require("credentialId", as: UUID.self)
        try await req.kernelDI(KernelIdentity.self).enduser.deleteCredential(id: credentialId, force: req.query.withDefault(\.force), as: req.platformActor)
        return try await req.response.success.encode(.init())
    }
}

extension KernelIdentity.Routes.Enduser_v1_0 {
    public typealias CreateEnduserCredentialContext = PostRouteContext<KernelIdentity.Core.Model.CreateEnduserCredentialRequest, KernelIdentity.Core.Model.EnduserCredentialResponse>
    public typealias GetEnduserCredentialContext = GetRouteContext<KernelIdentity.Core.Model.EnduserCredentialResponse>
    public typealias ListEnduserCredentialsContext = PaginatedGetRouteContext<KernelIdentity.Core.Model.EnduserCredentialResponse>
    public typealias UpdateEnduserCredentialContext = UpdateRouteContext<KernelIdentity.Core.Model.UpdateEnduserCredentialRequest, KernelIdentity.Core.Model.EnduserCredentialResponse>
    public typealias DeleteEnduserCredentialContext = DeleteRouteContext<KernelSwiftCommon.Networking.HTTP.EmptyResponse>
}
