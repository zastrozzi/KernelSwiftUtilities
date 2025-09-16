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
    public func createDevice(
        forEnduser enduserId: UUID,
        deviceIdentifier: String,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> FluentModel.EnduserDevice {
        try platformActor.checkEnduser(id: enduserId)
        guard deviceIdentifier.count > 3 else { throw Abort(.badRequest, reason: "Invalid device identifier") }
        let newDevice = try await FluentModel.EnduserDevice.create(
            from: .init(localDeviceIdentifier: deviceIdentifier),
            onDB: selectDB(db),
            withAudit: true, as: platformActor,
            withOptions: .init(enduserId: enduserId)
        )
        return newDevice
    }
    
    public func getDevice(
        id deviceId: UUID,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> FluentModel.EnduserDevice {
        guard let device = try await FluentModel.EnduserDevice.find(deviceId, on: selectDB(db)) else {
            throw Abort(.notFound, reason: "Device not found")
        }
        try platformActor.checkEnduser(id: device.$enduser.id)
        return device
    }
    
    public func listDevices(
        forEnduser enduserId: UUID? = nil,
        withPagination pagination: DefaultPaginatedQueryParams,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> PaginatedPgResult<FluentModel.EnduserDevice> {
        let enduserId = try platformActor.replaceEnduserId(enduserId)
        let deviceCount = try await FluentModel.EnduserDevice.query(on: try selectDB(db))
            .includeDeleted(pagination.includeDeleted)
            .filterIfPresent(\.$enduser.$id, .equal, enduserId)
            .count()
        let devices = try await FluentModel.EnduserDevice.query(on: try selectDB(db))
            .includeDeleted(pagination.includeDeleted)
            .filterIfPresent(\.$enduser.$id, .equal, enduserId)
            .paginatedSort(pagination)
            .all()
        return .init(results: devices, total: deviceCount)
    }
    
    public func updateDevice(
        id deviceId: UUID,
        deviceIdentifier: String? = nil,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> FluentModel.EnduserDevice {
        let _ = try await getDevice(id: deviceId, on: db, as: platformActor)
        return try await FluentModel.EnduserDevice.update(
            id: deviceId,
            from: .init(localDeviceIdentifier: deviceIdentifier),
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
    }
    
    public func deleteDevice(
        id deviceId: UUID,
        force: Bool = false,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws {
        let _ = try await getDevice(id: deviceId, on: db, as: platformActor)
        try await FluentModel.EnduserDevice.delete(
            force: force,
            id: deviceId,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
    }
    
    public func createOrUpdateDevice(
        forEnduser enduserId: UUID,
        deviceIdentifier: String,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> FluentModel.EnduserDevice {
        guard let existingDeviceId = try await FluentModel.EnduserDevice.query(on: try selectDB(db))
            .filter(\.$enduser.$id == enduserId)
            .filter(\.$localDeviceIdentifier == deviceIdentifier)
            .first()?.id
        else { return try await createDevice(forEnduser: enduserId, deviceIdentifier: deviceIdentifier, on: db, as: platformActor) }
        return try await updateDevice(id: existingDeviceId, deviceIdentifier: deviceIdentifier, on: db, as: platformActor)
    }
}

