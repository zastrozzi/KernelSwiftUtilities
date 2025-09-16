//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 19/06/2024.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelIdentity.Services.EnduserService {
    public func createEmail(
        forEnduser enduserId: UUID,
        from requestBody: KernelIdentity.Core.Model.CreateEnduserEmailRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> FluentModel.EnduserEmail {
        try platformActor.checkEnduser(id: enduserId)
        let newEmail = try await FluentModel.EnduserEmail.create(
            from: requestBody, onDB: selectDB(db),
            withAudit: true, as: platformActor,
            withOptions: .init(enduserId: enduserId)
        )
        return newEmail
    }
    
    public func getEmail(
        id emailId: UUID,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> FluentModel.EnduserEmail {
        guard let email = try await FluentModel.EnduserEmail.find(emailId, on: selectDB(db)) else {
            throw Abort(.notFound, reason: "Email not found")
        }
        try platformActor.checkEnduser(id: email.$enduser.id)
        return email
    }
    
    public func listEmails(
        forEnduser enduserId: UUID? = nil,
        withPagination pagination: DefaultPaginatedQueryParams,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> PaginatedPgResult<FluentModel.EnduserEmail> {
        let enduserId = try platformActor.replaceEnduserId(enduserId)
        let emailCount = try await FluentModel.EnduserEmail.query(on: try selectDB(db))
            .includeDeleted(pagination.includeDeleted)
            .filterIfPresent(\.$enduser.$id, .equal, enduserId)
            .count()
        let emails = try await FluentModel.EnduserEmail.query(on: try selectDB(db))
            .includeDeleted(pagination.includeDeleted)
            .filterIfPresent(\.$enduser.$id, .equal, enduserId)
            .paginatedSort(pagination)
            .all()
        return .init(results: emails, total: emailCount)
    }
    
    public func updateEmail(
        id emailId: UUID,
        from requestBody: KernelIdentity.Core.Model.UpdateEnduserEmailRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> FluentModel.EnduserEmail {
        let _ = try await getEmail(id: emailId, on: db, as: platformActor)
        return try await FluentModel.EnduserEmail.update(
            id: emailId,
            from: requestBody,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
    }
    
    public func deleteEmail(
        id emailId: UUID,
        force: Bool = false,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws {
        let _ = try await getEmail(id: emailId, on: db, as: platformActor)
        try await FluentModel.EnduserEmail.delete(
            force: force,
            id: emailId,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
    }
}

