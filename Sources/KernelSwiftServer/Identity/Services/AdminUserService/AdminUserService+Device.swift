//
//  File.swift
//
//
//  Created by Jonathan Forbes on 19/6/24.
//

import Vapor
import KernelSwiftCommon
import Fluent

extension KernelIdentity.Services.AdminUserService {
    public func createDevice(
        forAdminUser adminUserId: UUID,
        deviceIdentifier: String,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> FluentModel.AdminUserDevice {
        try platformActor.systemOrAdmin()
        guard deviceIdentifier.count > 3 else { throw Abort(.badRequest, reason: "Invalid device identifier") }
        let newDevice = try await FluentModel.AdminUserDevice.create(
            from: .init(localDeviceIdentifier: deviceIdentifier),
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor,
            withOptions: .init(adminUserId: adminUserId)
        )
        return newDevice
    }
    
    public func getDevice(
        id deviceId: UUID,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> FluentModel.AdminUserDevice {
        try platformActor.systemOrAdmin()
        guard let device = try await FluentModel.AdminUserDevice.find(deviceId, on: selectDB(db)) else {
            throw Abort(.notFound, reason: "Device not found")
        }
        return device
    }
    
    public func listDevices(
        forAdminUser adminUserId: UUID? = nil,
        withPagination pagination: DefaultPaginatedQueryParams,
        dbCreatedAtFilters: DateFilterQueryParamObject? = nil,
        dbUpdatedAtFilters: DateFilterQueryParamObject? = nil,
        dbDeletedAtFilters: DateFilterQueryParamObject? = nil,
        userAgentFilters: StringFilterQueryParamObject? = nil,
        systemFilters: FluentEnumFilterQueryParamObject<KernelIdentity.Core.Model.DeviceSystem>? = nil,
        osVersionFilters: StringFilterQueryParamObject? = nil,
        apnsPushTokenFilters: StringFilterQueryParamObject? = nil,
        fcmPushTokenFilters: StringFilterQueryParamObject? = nil,
        localDeviceIdentifierFilters: StringFilterQueryParamObject? = nil,
        lastSeenAtFilters: DateFilterQueryParamObject? = nil,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> PaginatedPgResult<FluentModel.AdminUserDevice> {
        try platformActor.systemOrAdmin()
        let selectedDB: Database = try selectDB(db)
        let dateFilters = FluentModel.AdminUserDevice.query(on: selectedDB)
            .filterIfPresent(\.$dbCreatedAt, dateFilters: dbCreatedAtFilters)
            .filterIfPresent(\.$dbUpdatedAt, dateFilters: dbUpdatedAtFilters)
            .filterIfPresent(\.$dbDeletedAt, dateFilters: dbDeletedAtFilters)
            .filterIfPresent(\.$lastSeenAt, dateFilters: lastSeenAtFilters)
        
        let stringFilters = FluentModel.AdminUserDevice.query(on: selectedDB)
            .filterIfPresent(\.$userAgent, stringFilters: userAgentFilters)
            .filterIfPresent(\.$osVersion, stringFilters: osVersionFilters)
            .filterIfPresent(\.$apnsPushToken, stringFilters: apnsPushTokenFilters)
            .filterIfPresent(\.$fcmPushToken, stringFilters: fcmPushTokenFilters)
            .filterIfPresent(\.$localDeviceIdentifier, stringFilters: localDeviceIdentifierFilters)
        
        let enumFilters = FluentModel.AdminUserDevice.query(on: selectedDB)
            .filterIfPresent(\.$system, enumFilters: systemFilters)
        
        let relationFilters = FluentModel.AdminUserDevice.query(on: selectedDB)
            .filterIfPresent(\.$adminUser.$id, .equal, adminUserId)
        
        let deviceCount = try await FluentModel.AdminUserDevice.query(on: selectedDB)
            .includeDeleted(pagination.includeDeleted)
            .addFilters(dateFilters, stringFilters, enumFilters, relationFilters)
            .count()
        
        let devices = try await FluentModel.AdminUserDevice.query(on: selectedDB)
            .includeDeleted(pagination.includeDeleted)
            .addFilters(dateFilters, stringFilters, enumFilters, relationFilters)
            .paginatedSort(pagination)
            .all()
        
        return .init(results: devices, total: deviceCount)
    }
    
    public func updateDevice(
        id deviceId: UUID,
        deviceIdentifier: String? = nil,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> FluentModel.AdminUserDevice {
        try platformActor.systemOrAdmin()
        return try await FluentModel.AdminUserDevice.update(
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
        try platformActor.systemOrAdmin()
        try await FluentModel.AdminUserDevice.delete(
            force: force,
            id: deviceId,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
    }
    
    public func createOrUpdateDevice(
        forAdminUser adminUserId: UUID,
        deviceIdentifier: String,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> FluentModel.AdminUserDevice {
        try platformActor.systemOrAdmin()
        guard let existingDeviceId = try await FluentModel.AdminUserDevice.query(on: try selectDB(db))
            .filter(\.$adminUser.$id == adminUserId)
            .filter(\.$localDeviceIdentifier == deviceIdentifier)
            .first()?.id
        else {
            return try await createDevice(
                forAdminUser: adminUserId,
                deviceIdentifier: deviceIdentifier,
                on: db,
                as: platformActor
            )
        }
        return try await updateDevice(
            id: existingDeviceId,
            deviceIdentifier: deviceIdentifier,
            on: db,
            as: platformActor
        )
    }
}
