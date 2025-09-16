//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 23/03/2022.
//

import Vapor
import Fluent
import KernelSwiftCommon

extension KernelIdentity.Fluent.Model {
    public final class AdminUserDevice: KernelFluentNamespacedModel, @unchecked Sendable {
        public static let namespacedSchema = SchemaName.adminUserDevice
        
        @ID(key: .id) public var id: UUID?
        @Timestamp(key: "db_created_at", on: .create) public var dbCreatedAt: Date?
        @Timestamp(key: "db_updated_at", on: .update) public var dbUpdatedAt: Date?
        @Timestamp(key: "db_deleted_at", on: .delete) public var dbDeletedAt: Date?
        
        @Field(key: "user_agent") public var userAgent: String
        @KernelEnum(key: "system") public var system: KernelIdentity.Core.Model.DeviceSystem
        @Field(key: "os_version") public var osVersion: String?
        @Field(key: "apns_push_token") public var apnsPushToken: String?
        @Field(key: "fcm_push_token") public var fcmPushToken: String?
        @Field(key: "channels") public var channels: String?
        @Field(key: "local_device_identifier") public var localDeviceIdentifier: String?
        @Field(key: "last_seen_at") public var lastSeenAt: Date
        
        @Parent(key: "admin_user_id") public var adminUser: AdminUser
        
        public init() {}
    }
}

extension KernelIdentity.Fluent.Model.AdminUserDevice: CRUDModel {
    public typealias CreateDTO = KernelIdentity.Core.Model.CreateAdminUserDeviceRequest
    public typealias UpdateDTO = KernelIdentity.Core.Model.UpdateAdminUserDeviceRequest
    public typealias ResponseDTO = KernelIdentity.Core.Model.AdminUserDeviceResponse
    
    public struct CreateOptions: Sendable {
        public var adminUserId: UUID
        
        public init(adminUserId: UUID) {
            self.adminUserId = adminUserId
        }
    }
    
    public typealias UpdateOptions = KernelFluentModel.EmptyUpdateOptions
    public typealias ResponseOptions = KernelFluentModel.EmptyResponseOptions
    
    public static func createFields(
        from dto: CreateDTO,
        withOptions options: CreateOptions? = nil
    ) throws -> Self {
        guard let options else { throw Abort(.badRequest, reason: "Options not provided") }
        guard dto.localDeviceIdentifier.count > 3 else { throw Abort(.badRequest, reason: "Invalid device identifier") }
        let model = self.init()
        let recognisedDeviceSystem: KernelIdentity.Core.Model.DeviceSystem = switch String(dto.localDeviceIdentifier.prefix(3)) {
        case "ios": .iOS
        case "and": .android
        case "web": .web
        default: .other
        }
        model.userAgent = ""
        model.system = recognisedDeviceSystem
        model.osVersion = ""
        model.apnsPushToken = nil
        model.fcmPushToken = nil
        model.channels = nil
        model.localDeviceIdentifier = dto.localDeviceIdentifier
        model.lastSeenAt = Date.now
        model.$adminUser.id = options.adminUserId
        return model
    }
    
    public static func updateFields(
        for model: SelfModel,
        from dto: UpdateDTO,
        withOptions options: UpdateOptions? = nil
    ) throws {
        if let deviceIdentifier = dto.localDeviceIdentifier {
            guard deviceIdentifier.count > 3 else { throw Abort(.badRequest, reason: "Invalid device identifier") }
            let recognisedDeviceSystem: KernelIdentity.Core.Model.DeviceSystem = switch String(deviceIdentifier.prefix(3)) {
            case "ios": .iOS
            case "and": .android
            case "web": .web
            default: .other
            }
            try model.updateIfChanged(\.system, from: recognisedDeviceSystem)
            try model.updateIfChanged(\.localDeviceIdentifier, from: deviceIdentifier)
        }
        model.lastSeenAt = Date.now
    }
    
    public func response(
        withOptions options: ResponseOptions? = nil
    ) throws -> ResponseDTO {
        return .init(
            id: try requireID(),
            dbCreatedAt: try require(\.$dbCreatedAt),
            dbUpdatedAt: try require(\.$dbUpdatedAt),
            dbDeletedAt: dbDeletedAt,
            userAgent: userAgent,
            system: system,
            osVersion: osVersion,
            apnsPushToken: apnsPushToken,
            fcmPushToken: fcmPushToken,
            channels: channels,
            localDeviceIdentifier: localDeviceIdentifier,
            lastSeenAt: lastSeenAt,
            adminUserId: $adminUser.id
        )
    }
}
