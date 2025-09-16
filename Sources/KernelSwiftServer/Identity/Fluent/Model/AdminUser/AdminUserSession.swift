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
    public final class AdminUserSession: KernelFluentNamespacedModel, @unchecked Sendable {
        public static let namespacedSchema = SchemaName.adminUserSession
        
        @ID public var id: UUID?
        @Timestamp(key: "db_created_at", on: .create) public var dbCreatedAt: Date?
        @Timestamp(key: "db_updated_at", on: .update) public var dbUpdatedAt: Date?
        @Timestamp(key: "db_deleted_at", on: .delete) public var dbDeletedAt: Date?
        @Field(key: "is_active") public var isActive: Bool
        
        @Parent(key: "admin_user_id") public var adminUser: AdminUser
        @Parent(key: "device_id") public var device: AdminUserDevice
        
        public init() {}
    }
}

extension KernelIdentity.Fluent.Model.AdminUserSession: CRUDModel {
    public typealias CreateDTO = KernelSwiftCommon.Networking.HTTP.EmptyRequest
    public typealias UpdateDTO = KernelSwiftCommon.Networking.HTTP.EmptyRequest
    public typealias ResponseDTO = KernelIdentity.Core.Model.AdminUserSessionResponse
    
    public struct CreateOptions: Sendable {
        public var adminUserId: UUID
        public var deviceId: UUID
        
        public init(
            adminUserId: UUID,
            deviceId: UUID
        ) {
            self.adminUserId = adminUserId
            self.deviceId = deviceId
        }
    }
    
    public struct UpdateOptions: Sendable {
        public var isActive: Bool
        
        public init(
            isActive: Bool
        ) {
            self.isActive = isActive
        }
    }
    
    public typealias ResponseOptions = KernelFluentModel.EmptyResponseOptions
    
    public static func createFields(
        from dto: CreateDTO,
        withOptions options: CreateOptions? = nil
    ) throws -> Self {
        guard let options else { throw Abort(.badRequest, reason: "No create options provided") }
        let model = Self.init()
        model.isActive = true
        model.$adminUser.id = options.adminUserId
        model.$device.id = options.deviceId
        return model
    }
    
    public static func updateFields(
        for model: SelfModel,
        from dto: KernelSwiftCommon.Networking.HTTP.EmptyRequest,
        withOptions options: UpdateOptions? = nil
    ) throws {
        guard let options else { throw Abort(.badRequest, reason: "No update options provided") }
        try model.updateIfChanged(\.isActive, from: options.isActive)
    }
    
    public func response(
        withOptions options: ResponseOptions? = nil
    ) throws -> ResponseDTO {
        return .init(
            id: try requireID(),
            dbCreatedAt: try require(\.$dbCreatedAt),
            dbUpdatedAt: try require(\.$dbUpdatedAt),
            dbDeletedAt: dbDeletedAt,
            isActive: isActive,
            adminUserId: $adminUser.id,
            deviceId: $device.id
        )
    }
}
