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
    public final class AdminUserPhone: KernelFluentNamespacedModel, @unchecked Sendable {
        public static let namespacedSchema = SchemaName.adminUserPhone
        
        @ID public var id: UUID?
        @Timestamp(key: "db_created_at", on: .create) public var dbCreatedAt: Date?
        @Timestamp(key: "db_updated_at", on: .update) public var dbUpdatedAt: Date?
        @Timestamp(key: "db_deleted_at", on: .delete) public var dbDeletedAt: Date?
        
        @Field(key: "phone_number_value") public var phoneNumberValue: String
        @Field(key: "is_whatsapp") public var isWhatsapp: Bool
        @Field(key: "is_sms") public var isSMS: Bool
        @Field(key: "is_voice") public var isVoice: Bool
        @Field(key: "is_whatsapp_verified") public var isWhatsappVerified: Bool
        @Field(key: "is_sms_verified") public var isSMSVerified: Bool
        @Field(key: "is_voice_verified") public var isVoiceVerified: Bool
        @KernelEnum(key: "preferred_contact_method") public var preferredContactMethod: KernelIdentity.Core.Model.PhoneContactMethod
        
        @Parent(key: "admin_user_id") public var adminUser: AdminUser
        
        public init() {}
    }
}

extension KernelIdentity.Fluent.Model.AdminUserPhone: CRUDModel {
    public typealias CreateDTO = KernelIdentity.Core.Model.CreateAdminUserPhoneRequest
    public typealias UpdateDTO = KernelIdentity.Core.Model.UpdateAdminUserPhoneRequest
    public typealias ResponseDTO = KernelIdentity.Core.Model.AdminUserPhoneResponse
    
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
        guard let options = options else { throw Abort(.badRequest, reason: "No create options provided") }
        let model = Self.init()
        model.phoneNumberValue = dto.phoneNumberValue
        model.isWhatsapp = dto.isWhatsapp
        model.isSMS = dto.isSMS
        model.isVoice = dto.isVoice
        model.isWhatsappVerified = dto.isWhatsappVerified
        model.isSMSVerified = dto.isSMSVerified
        model.isVoiceVerified = dto.isVoiceVerified
        model.preferredContactMethod = dto.preferredContactMethod
        model.$adminUser.id = options.adminUserId
        return model
    }
    
    public static func updateFields(
        for model: SelfModel,
        from dto: UpdateDTO,
        withOptions options: UpdateOptions? = nil
    ) throws {
        try model.updateIfChanged(\.phoneNumberValue, from: dto.phoneNumberValue)
        try model.updateIfChanged(\.isWhatsapp, from: dto.isWhatsapp)
        try model.updateIfChanged(\.isSMS, from: dto.isSMS)
        try model.updateIfChanged(\.isVoice, from: dto.isVoice)
        try model.updateIfChanged(\.isWhatsappVerified, from: dto.isWhatsappVerified)
        try model.updateIfChanged(\.isSMSVerified, from: dto.isSMSVerified)
        try model.updateIfChanged(\.isVoiceVerified, from: dto.isVoiceVerified)
        try model.updateIfChanged(\.preferredContactMethod, from: dto.preferredContactMethod)
    }
    
    public static func updateFromOptions(
        for model: KernelIdentity.Fluent.Model.AdminUserPhone,
        options: UpdateOptions
    ) throws {
        // No options to update
    }
    
    public func response(
        withOptions options: ResponseOptions? = nil
    ) throws -> ResponseDTO {
        ResponseDTO(
            id: try requireID(),
            dbCreatedAt: try require(\.$dbCreatedAt),
            dbUpdatedAt: try require(\.$dbUpdatedAt),
            dbDeletedAt: dbDeletedAt,
            phoneNumberValue: phoneNumberValue,
            isWhatsapp: isWhatsapp,
            isSMS: isSMS,
            isVoice: isVoice,
            isWhatsappVerified: isWhatsappVerified,
            isSMSVerified: isSMSVerified,
            isVoiceVerified: isVoiceVerified,
            preferredContactMethod: preferredContactMethod,
            adminUserId: $adminUser.id
        )
    }
}
