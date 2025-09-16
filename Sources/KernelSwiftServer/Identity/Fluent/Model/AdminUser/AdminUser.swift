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
    public final class AdminUser: KernelFluentNamespacedModel, @unchecked Sendable {
        public static let namespacedSchema = SchemaName.adminUser
        
        @ID public var id: UUID?
        @Timestamp(key: "db_created_at", on: .create) public var dbCreatedAt: Date?
        @Timestamp(key: "db_updated_at", on: .update) public var dbUpdatedAt: Date?
        @Timestamp(key: "db_deleted_at", on: .delete) public var dbDeletedAt: Date?
        @Field(key: "first_name") public var firstName: String
        @Field(key: "last_name") public var lastName: String
        @Field(key: "role") public var role: String
        
        @Children(for: \.$adminUser) public var credentials: [AdminUserCredential]
        @Children(for: \.$adminUser) public var devices: [AdminUserDevice]
        @Children(for: \.$adminUser) public var emailAddresses: [AdminUserEmail]
        @Children(for: \.$adminUser) public var phoneNumbers: [AdminUserPhone]
        
        public init() {}
    }
}

extension KernelIdentity.Fluent.Model.AdminUser: CRUDModel {
    public typealias CreateDTO = KernelIdentity.Core.Model.CreateAdminUserRequest
    public typealias UpdateDTO = KernelIdentity.Core.Model.UpdateAdminUserRequest
    public typealias ResponseDTO = KernelIdentity.Core.Model.AdminUserResponse
    public typealias CreateOptions = KernelFluentModel.EmptyCreateOptions
    public typealias UpdateOptions = KernelFluentModel.EmptyUpdateOptions
    public typealias ResponseOptions = KernelFluentModel.EmptyResponseOptions
    
    public static func createFields(
        from dto: CreateDTO,
        withOptions options: CreateOptions? = nil
    ) throws -> Self {
        let model = self.init()
        model.firstName = dto.firstName
        model.lastName = dto.lastName
        model.role = dto.role
        return model
    }
    
    public static func updateFields(
        for model: SelfModel,
        from dto: UpdateDTO,
        withOptions options: UpdateOptions? = nil
    ) throws {
        try model.updateIfChanged(\.firstName, from: dto.firstName)
        try model.updateIfChanged(\.lastName, from: dto.lastName)
        try model.updateIfChanged(\.role, from: dto.role)
    }
    
    public func response(
        withOptions options: ResponseOptions? = nil
    ) throws -> ResponseDTO {
        return .init(
            id: try requireID(),
            dbCreatedAt: try require(\.$dbCreatedAt),
            dbUpdatedAt: try require(\.$dbUpdatedAt),
            dbDeletedAt: dbDeletedAt,
            firstName: firstName,
            lastName: lastName,
            role: role
        )
    }
}
