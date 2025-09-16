//
//  File.swift
//
//
//  Created by Jonathan Forbes on 31/05/2022.
//

import Vapor
import Fluent
import KernelSwiftCommon

extension KernelIdentity.Fluent.Model {
    public final class EnduserEmail: KernelFluentNamespacedModel, @unchecked Sendable {
        public static let namespacedSchema = SchemaName.enduserEmail
        
        @ID public var id: UUID?
        @Timestamp(key: "db_created_at", on: .create) public var dbCreatedAt: Date?
        @Timestamp(key: "db_updated_at", on: .update) public var dbUpdatedAt: Date?
        @Timestamp(key: "db_deleted_at", on: .delete) public var dbDeletedAt: Date?
        
        @Field(key: "email_address_value") public var emailAddressValue: String
        @Field(key: "is_verified") public var isVerified: Bool
        
        @Parent(key: "enduser_id") public var enduser: Enduser
        
        public init() {}
    }
}

extension KernelIdentity.Fluent.Model.EnduserEmail: CRUDModel {
    public typealias CreateDTO = KernelIdentity.Core.Model.CreateEnduserEmailRequest
    public typealias UpdateDTO = KernelIdentity.Core.Model.UpdateEnduserEmailRequest
    public typealias ResponseDTO = KernelIdentity.Core.Model.EnduserEmailResponse
    
    public struct CreateOptions: Sendable {
        public var enduserId: UUID
        
        public init(enduserId: UUID) {
            self.enduserId = enduserId
        }
    }
    
    public typealias UpdateOptions = KernelFluentModel.EmptyUpdateOptions
    public typealias ResponseOptions = KernelFluentModel.EmptyResponseOptions
    
    public static func createFields(
        from dto: KernelIdentity.Core.Model.CreateEnduserEmailRequest,
        withOptions options: CreateOptions? = nil
    ) throws -> Self {
        guard let options else { throw Abort(.badRequest, reason: "No enduser id provided") }
        let model = self.init()
        model.emailAddressValue = dto.emailAddressValue
        model.isVerified = dto.isVerified
        model.$enduser.id = options.enduserId
        return model
    }
    
    public static func updateFields(
        for model: SelfModel,
        from dto: KernelIdentity.Core.Model.UpdateEnduserEmailRequest,
        withOptions options: UpdateOptions? = nil
    ) throws {
        try model.updateIfChanged(\.emailAddressValue, from: dto.emailAddressValue)
        try model.updateIfChanged(\.isVerified, from: dto.isVerified)
    }
    
    public func response(
        withOptions options: ResponseOptions? = nil
    ) throws -> ResponseDTO {
        return .init(
            id: try requireID(),
            dbCreatedAt: try require(\.$dbCreatedAt),
            dbUpdatedAt: try require(\.$dbUpdatedAt),
            dbDeletedAt: dbDeletedAt,
            emailAddressValue: emailAddressValue,
            isVerified: isVerified,
            enduserId: $enduser.id
        )
    }
}
