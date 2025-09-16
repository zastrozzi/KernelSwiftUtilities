//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 25/09/2024.
//

import Vapor
import Fluent
import KernelSwiftCommon

extension KernelLocation.Fluent.Model {
    public final class GeoLocation: KernelFluentNamespacedModel, @unchecked Sendable {
        public static let namespacedSchema = SchemaName.geoLocation
        
        @ID public var id: UUID?
        @Timestamp(key: "db_created_at", on: .create) public var dbCreatedAt: Date?
        @Timestamp(key: "db_updated_at", on: .update) public var dbUpdatedAt: Date?
        @Timestamp(key: "db_deleted_at", on: .delete) public var dbDeletedAt: Date?
        
        @Field(key: "name") public var name: String
        @PostGISField(key: "point") public var point: KernelFluentPostGIS.Geometric.Point2D
        
        @OptionalParent(key: "enduser_id") public var enduser: KernelIdentity.Fluent.Model.Enduser?
        
        public init() {}
    }
}

extension KernelLocation.Fluent.Model.GeoLocation: CRUDModel {
    public typealias CreateDTO = KernelLocation.Core.GeoLocation.CreateGeoLocationRequest
    public typealias UpdateDTO = KernelLocation.Core.GeoLocation.UpdateGeoLocationRequest
    public typealias ResponseDTO = KernelLocation.Core.GeoLocation.GeoLocationResponse
    
    public struct CreateOptions: Sendable {
        public var enduserId: UUID?
        
        public init(
            enduserId: UUID? = nil
        ) {
            self.enduserId = enduserId
        }
    }
    
    public struct UpdateOptions: Sendable {
        public var enduserId: UUID?
        
        public init(
            enduserId: UUID? = nil
        ) {
            self.enduserId = enduserId
        }
    }
    
    public static func createFields(
        from dto: CreateDTO,
        withOptions options: CreateOptions? = nil
    ) throws -> Self {
        let model = self.init()
        model.name = dto.name
        model.point = dto.point
        model.$enduser.id = options?.enduserId
        return model
    }
    
    public static func updateFields(
        for model: SelfModel,
        from dto: UpdateDTO,
        withOptions options: UpdateOptions? = nil
    ) throws {
        try model.updateIfChanged(\.name, from: dto.name)
        try model.updateIfChanged(\.point, from: dto.point)
        try model.updateIfChanged(\.$enduser.id, from: options?.enduserId)
    }
    
    public func response(
        withOptions options: ResponseOptions? = nil
    ) throws -> ResponseDTO {
        return .init(
            id: try requireID(),
            dbCreatedAt: try require(\.$dbCreatedAt),
            dbUpdatedAt: try require(\.$dbUpdatedAt),
            dbDeletedAt: dbDeletedAt,
            name: name,
            point: point,
            enduserId: $enduser.id
        )
    }
}
