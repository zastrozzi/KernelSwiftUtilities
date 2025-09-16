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
    public func createAddress(
        forEnduser enduserId: UUID,
        from requestBody: KernelIdentity.Core.Model.CreateEnduserAddressRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> FluentModel.EnduserAddress {
        try platformActor.checkEnduser(id: enduserId)
        let newAddress = try await FluentModel.EnduserAddress.create(
            from: requestBody,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor,
            withOptions: .init(enduserId: enduserId)
        )
        return newAddress
    }
    
    public func getAddress(
        id addressId: UUID,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> FluentModel.EnduserAddress {
        guard let address = try await FluentModel.EnduserAddress.find(addressId, on: selectDB(db)) else {
            throw Abort(.notFound, reason: "Address not found")
        }
        try platformActor.checkEnduser(id: address.$enduser.id)
        return address
    }
    
    public func listAddresses(
        forEnduser enduserId: UUID? = nil,
        withPagination pagination: DefaultPaginatedQueryParams,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> PaginatedPgResult<FluentModel.EnduserAddress> {
        let enduserId = try platformActor.replaceEnduserId(enduserId)
        let addressCount = try await FluentModel.EnduserAddress.query(on: try selectDB(db))
            .includeDeleted(pagination.includeDeleted)
            .filterIfPresent(\.$enduser.$id, .equal, enduserId)
            .count()
        let addresses = try await FluentModel.EnduserAddress.query(on: try selectDB(db))
            .includeDeleted(pagination.includeDeleted)
            .filterIfPresent(\.$enduser.$id, .equal, enduserId)
            .paginatedSort(pagination)
            .all()
        return .init(results: addresses, total: addressCount)
    }
    
    public func updateAddress(
        id addressId: UUID,
        from requestBody: KernelIdentity.Core.Model.UpdateEnduserAddressRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> FluentModel.EnduserAddress {
        let _ = try await getAddress(id: addressId, on: db, as: platformActor)
        return try await FluentModel.EnduserAddress.update(
            id: addressId,
            from: requestBody,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
    }
    
    public func deleteAddress(
        id addressId: UUID,
        force: Bool = false,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws {
        let _ = try await getAddress(id: addressId, on: db, as: platformActor)
        try await FluentModel.EnduserAddress.delete(
            force: force,
            id: addressId,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
    }
}

