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
    public final class Enduser: KernelFluentNamespacedModel, @unchecked Sendable {
        public static let namespacedSchema = SchemaName.enduser
        
        @ID public var id: UUID?
        @Timestamp(key: "db_created_at", on: .create) public var dbCreatedAt: Date?
        @Timestamp(key: "db_updated_at", on: .update) public var dbUpdatedAt: Date?
        @Timestamp(key: "db_deleted_at", on: .delete) public var dbDeletedAt: Date?
        @Field(key: "first_name") public var firstName: String
        @Field(key: "last_name") public var lastName: String
        @OptionalField(key: "dob") public var dateOfBirth: Date?
        @KernelEnum(key: "gender_pronoun") public var genderPronoun: KernelIdentity.Core.Model.GenderPronoun
        @Field(key: "onboarding_complete") public var onboardingComplete: Bool
        @OptionalField(key: "allow_insurance_call") public var allowInsuranceCall: Bool?
        @OptionalField(key: "allow_tracking") public var allowTracking: Bool?
        
        @Children(for: \.$enduser) public var credentials: [EnduserCredential]
        @Children(for: \.$enduser) public var devices: [EnduserDevice]
        @Children(for: \.$enduser) public var emailAddresses: [EnduserEmail]
        @Children(for: \.$enduser) public var phoneNumbers: [EnduserPhone]
        
        public init() {}
    }
}

extension KernelIdentity.Fluent.Model.Enduser: CRUDModel {
    public typealias CreateDTO = KernelIdentity.Core.Model.CreateEnduserRequest
    public typealias UpdateDTO = KernelIdentity.Core.Model.UpdateEnduserRequest
    public typealias ResponseDTO = KernelIdentity.Core.Model.EnduserResponse
    public typealias CreateOptions = KernelFluentModel.EmptyCreateOptions
    public typealias UpdateOptions = KernelFluentModel.EmptyUpdateOptions
    public typealias ResponseOptions = KernelFluentModel.EmptyResponseOptions
    
    public static func createFields(
        from dto: KernelIdentity.Core.Model.CreateEnduserRequest,
        withOptions options: CreateOptions? = nil
    ) throws -> Self {
        let model = self.init()
        model.firstName = dto.firstName
        model.lastName = dto.lastName
        model.genderPronoun = dto.genderPronoun
        model.dateOfBirth = dto.dateOfBirth
        model.onboardingComplete = dto.onboardingComplete
        model.allowInsuranceCall = dto.allowInsuranceCall
        model.allowTracking = dto.allowTracking
        return model
    }
    
    public static func updateFields(
        for model: SelfModel,
        from dto: KernelIdentity.Core.Model.UpdateEnduserRequest,
        withOptions options: UpdateOptions? = nil
    ) throws {
        try model.updateIfChanged(\.firstName, from: dto.firstName)
        try model.updateIfChanged(\.lastName, from: dto.lastName)
        try model.updateIfChanged(\.genderPronoun, from: dto.genderPronoun)
        try model.updateIfChanged(\.dateOfBirth, from: dto.dateOfBirth)
        try model.updateIfChanged(\.onboardingComplete, from: dto.onboardingComplete)
        try model.updateIfChanged(\.allowInsuranceCall, from: dto.allowInsuranceCall)
        try model.updateIfChanged(\.allowTracking, from: dto.allowTracking)
        
    }
    
    public func response(
        withOptions options: ResponseOptions? = nil
    ) throws -> KernelIdentity.Core.Model.EnduserResponse {
        return .init(
            id: try requireID(),
            dbCreatedAt: try require(\.$dbCreatedAt),
            dbUpdatedAt: try require(\.$dbUpdatedAt),
            dbDeletedAt: dbDeletedAt,
            firstName: firstName,
            lastName: lastName,
            genderPronoun: genderPronoun,
            dateOfBirth: dateOfBirth,
            onboardingComplete: onboardingComplete,
            allowInsuranceCall: allowInsuranceCall,
            allowTracking: allowTracking
        )
    }
}
