//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 19/06/2024.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelIdentity.Fluent.Model {
    public final class EnduserAddress: KernelFluentNamespacedModel, @unchecked Sendable {
        public static let namespacedSchema = SchemaName.enduserAddress
        
        @ID public var id: UUID?
        @Timestamp(key: "db_created_at", on: .create) public var dbCreatedAt: Date?
        @Timestamp(key: "db_updated_at", on: .update) public var dbUpdatedAt: Date?
        @Timestamp(key: "db_deleted_at", on: .delete) public var dbDeletedAt: Date?
        @Field(key: "refinement") public var refinement: String?
        @Field(key: "number") public var number: String?
        @Field(key: "street") public var street: String?
        @Field(key: "city") public var city: String?
        @Field(key: "region") public var region: String?
        @Field(key: "postal_code") public var postalCode: String
        @KernelEnum(key: "country") public var country: ISO3166CountryAlpha2Code
        @Parent(key: "enduser_id") public var enduser: Enduser
        
        public init() {}
    }
}

extension KernelIdentity.Fluent.Model.EnduserAddress: CRUDModel {
    public typealias CreateDTO = KernelIdentity.Core.Model.CreateEnduserAddressRequest
    public typealias UpdateDTO = KernelIdentity.Core.Model.UpdateEnduserAddressRequest
    public typealias ResponseDTO = KernelIdentity.Core.Model.EnduserAddressResponse
    
    public struct CreateOptions: Sendable {
        public var enduserId: UUID
        
        public init(enduserId: UUID) {
            self.enduserId = enduserId
        }
    }
    
    public typealias UpdateOptions = KernelFluentModel.EmptyUpdateOptions
    public typealias ResponseOptions = KernelFluentModel.EmptyResponseOptions
    
    public static func createFields(
        from dto: KernelIdentity.Core.Model.CreateEnduserAddressRequest,
        withOptions options: CreateOptions? = nil
    ) throws -> Self {
        guard let options else { throw Abort(.badRequest, reason: "No enduser id provided") }
        let model = self.init()
        model.refinement = dto.refinement
        model.number = dto.number
        model.street = dto.street
        model.city = dto.city
        model.region = dto.region
        model.postalCode = dto.postalCode
        model.country = dto.country
        model.$enduser.id = options.enduserId
        return model
    }
    
    public static func updateFields(
        for model: SelfModel,
        from dto: KernelIdentity.Core.Model.UpdateEnduserAddressRequest,
        withOptions options: UpdateOptions? = nil
    ) throws {
        try model.updateIfChanged(\.refinement, from: dto.refinement)
        try model.updateIfChanged(\.number, from: dto.number)
        try model.updateIfChanged(\.street, from: dto.street)
        try model.updateIfChanged(\.city, from: dto.city)
        try model.updateIfChanged(\.region, from: dto.region)
        try model.updateIfChanged(\.postalCode, from: dto.postalCode)
        try model.updateIfChanged(\.country, from: dto.country)
    }
    
    public func response(
        withOptions options: ResponseOptions? = nil
    ) throws -> KernelIdentity.Core.Model.EnduserAddressResponse {
        return .init(
            id: try requireID(),
            dbCreatedAt: try require(\.$dbCreatedAt),
            dbUpdatedAt: try require(\.$dbUpdatedAt),
            dbDeletedAt: dbDeletedAt,
            refinement: refinement,
            number: number,
            street: street,
            city: city,
            region: region,
            postalCode: postalCode,
            country: country,
            enduserId: $enduser.id
        )
    }
}

