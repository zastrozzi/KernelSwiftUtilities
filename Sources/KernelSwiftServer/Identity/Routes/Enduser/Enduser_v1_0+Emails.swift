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
    public func bootEmailRoutes(routes: TypedRoutesBuilder) throws {
        routes.get(":emailId".parameterType(UUID.self), use: getEmailHandler).summary("Get Enduser Email")
        routes.get(use: listEmailsHandler).summary("List Enduser Emails")
        routes.put(":emailId".parameterType(UUID.self), use: updateEmailHandler).summary("Update Enduser Email")
        routes.delete(":emailId".parameterType(UUID.self), use: deleteEmailHandler).summary("Delete Enduser Email")
    }
    
    public func bootEmailRoutesForEnduser(routes: TypedRoutesBuilder) throws {
        routes.post(use: createEmailHandler).summary("Create Enduser Email")
        routes.get(use: listEmailsHandler).summary("List Emails for Enduser")
    }
}

extension KernelIdentity.Routes.Enduser_v1_0 {
    public func createEmailHandler(_ req: TypedRequest<CreateEnduserEmailContext>) async throws -> Response {
        let enduserId = try req.parameters.require("enduserId", as: UUID.self)
        let newEmail = try await req.kernelDI(KernelIdentity.self).enduser.createEmail(
            forEnduser: enduserId,
            from: try req.decodeBody(),
            as: req.platformActor
        )
        return try await req.response.success.encode(newEmail.response())
    }
    
    public func getEmailHandler(_ req: TypedRequest<GetEnduserEmailContext>) async throws -> Response {
        let emailId = try req.parameters.require("emailId", as: UUID.self)
        let email = try await req.kernelDI(KernelIdentity.self).enduser.getEmail(id: emailId, as: req.platformActor)
        return try await req.response.success.encode(email.response())
    }
    
    public func listEmailsHandler(_ req: TypedRequest<ListEnduserEmailsContext>) async throws -> Response {
        let enduserId = req.parameters.get("enduserId", as: UUID.self)
        let pagedEmails = try await req.kernelDI(KernelIdentity.self).enduser.listEmails(forEnduser: enduserId, withPagination: req.decodeDefaultPagination(), as: req.platformActor)
        return try await req.response.success.encode(pagedEmails.paginatedResponse())
    }
    
    public func updateEmailHandler(_ req: TypedRequest<UpdateEnduserEmailContext>) async throws -> Response {
        let emailId = try req.parameters.require("emailId", as: UUID.self)
        let requestBody = try req.decodeBody()
        let email = try await req.kernelDI(KernelIdentity.self).enduser.updateEmail(id: emailId, from: requestBody, as: req.platformActor)
        return try await req.response.success.encode(email.response())
    }
    
    public func deleteEmailHandler(_ req: TypedRequest<DeleteEnduserEmailContext>) async throws -> Response {
        let emailId = try req.parameters.require("emailId", as: UUID.self)
        try await req.kernelDI(KernelIdentity.self).enduser.deleteEmail(id: emailId, force: req.query.withDefault(\.force), as: req.platformActor)
        return try await req.response.success.encode(.init())
    }
}

extension KernelIdentity.Routes.Enduser_v1_0 {
    public typealias CreateEnduserEmailContext = PostRouteContext<KernelIdentity.Core.Model.CreateEnduserEmailRequest, KernelIdentity.Core.Model.EnduserEmailResponse>
    public typealias GetEnduserEmailContext = GetRouteContext<KernelIdentity.Core.Model.EnduserEmailResponse>
    public typealias ListEnduserEmailsContext = PaginatedGetRouteContext<KernelIdentity.Core.Model.EnduserEmailResponse>
    public typealias UpdateEnduserEmailContext = UpdateRouteContext<KernelIdentity.Core.Model.UpdateEnduserEmailRequest, KernelIdentity.Core.Model.EnduserEmailResponse>
    public typealias DeleteEnduserEmailContext = DeleteRouteContext<KernelSwiftCommon.Networking.HTTP.EmptyResponse>
}
