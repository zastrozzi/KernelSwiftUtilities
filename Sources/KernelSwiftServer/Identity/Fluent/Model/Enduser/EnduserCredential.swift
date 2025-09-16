//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 4/5/24.
//

import Vapor
import Fluent
import KernelSwiftCommon

extension KernelIdentity.Fluent.Model {
    public final class EnduserCredential: KernelFluentNamespacedModel, @unchecked Sendable {
        public static let namespacedSchema = SchemaName.enduserCredential
        
        @ID public var id: UUID?
        @Timestamp(key: "db_created_at", on: .create) public var dbCreatedAt: Date?
        @Timestamp(key: "db_updated_at", on: .update) public var dbUpdatedAt: Date?
        @Timestamp(key: "db_deleted_at", on: .delete) public var dbDeletedAt: Date?
        
        @KernelEnum(key: "credential_type") public var credentialType: KernelIdentity.Core.Model.CredentialType
        @Field(key: "oidc_user_identifier") public var oidcUserIdentifier: String?
        @Field(key: "password_hash") public var passwordHash: String?
        @Field(key: "is_valid") public var isValid: Bool
        
        @Parent(key: "enduser_id") public var enduser: Enduser
        
        public init() {}
    }
}

extension KernelIdentity.Fluent.Model.EnduserCredential: CRUDModel {
    public typealias CreateDTO = KernelIdentity.Core.Model.CreateEnduserCredentialRequest
    public typealias UpdateDTO = KernelIdentity.Core.Model.UpdateEnduserCredentialRequest
    public typealias ResponseDTO = KernelIdentity.Core.Model.EnduserCredentialResponse
    
    public struct CreateOptions: Sendable {
        public var enduserId: UUID
        
        public init(enduserId: UUID) {
            self.enduserId = enduserId
        }
    }
    
    public typealias UpdateOptions = KernelFluentModel.EmptyUpdateOptions
    public typealias ResponseOptions = KernelFluentModel.EmptyResponseOptions
    
    public static func createFields(
        from dto: CreateDTO,
        withOptions options: CreateOptions? = nil
    ) throws -> Self {
        guard let options else { throw Abort(.badRequest, reason: "No enduser id provided") }
        let model = self.init()
        model.credentialType = dto.credentialType
        model.oidcUserIdentifier = dto.oidcUserIdentifier
        switch dto.credentialType {
        case .emailPassword:
            guard
                let password = dto.password,
                let passwordHash = try? BCryptDigest().hash(password)
            else { throw Abort(.badRequest, reason: "Credential could not be hashed") }
            model.passwordHash = passwordHash
        default:
            model.passwordHash = nil
        }
        model.isValid = true
        model.$enduser.id = options.enduserId
        return model
    }
    
    public static func updateFields(
        for model: SelfModel,
        from dto: UpdateDTO,
        withOptions options: UpdateOptions? = nil
    ) throws {
        try model.updateIfChanged(\.isValid, from: dto.isValid)
    }
    
    public func response(
        withOptions options: ResponseOptions? = nil
    ) throws -> ResponseDTO {
        return .init(
            id: try requireID(),
            dbCreatedAt: try require(\.$dbCreatedAt),
            dbUpdatedAt: try require(\.$dbUpdatedAt),
            dbDeletedAt: dbDeletedAt,
            credentialType: credentialType,
            isValid: isValid,
            enduserId: $enduser.id
        )
    }
}
