//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/10/2024.
//

import Vapor
import Fluent
import KernelSwiftCommon

extension KernelLocation.Fluent.Model {
    public final class UKOrdnanceSurveyBoundaryLineCommunityWard: KernelFluentNamespacedModel, @unchecked Sendable {
        public static let namespacedSchema = SchemaName.ukOrdnanceSurveyBoundaryLineCommunityWard
        
        @ID public var id: UUID?
        @Timestamp(key: "db_created_at", on: .create) public var dbCreatedAt: Date?
        @Timestamp(key: "db_updated_at", on: .update) public var dbUpdatedAt: Date?
        @Timestamp(key: "db_deleted_at", on: .delete) public var dbDeletedAt: Date?
        
        @PostGISField(key: "geometry") public var geometry: KernelFluentPostGIS.Geometric.MultiPolygon2D
        @PostGISField(key: "geometry_wgs84") public var geometryWGS84: KernelFluentPostGIS.Geometric.MultiPolygon2D
        @Field(key: "name") public var name: String
        @Field(key: "area_description") public var areaDescription: String
        @Field(key: "community") public var community: String
        @Field(key: "file_name") public var fileName: String
        
        public init() {}
    }
}

extension KernelLocation.Fluent.Model.UKOrdnanceSurveyBoundaryLineCommunityWard: CRUDModel {
    public typealias ResponseDTO = KernelLocation.Core.UKOrdnanceSurvey.BoundaryLine.CommunityWardResponse
    
    public func response(
        withOptions options: ResponseOptions? = nil
    ) throws -> ResponseDTO {
        .init(
            id: try requireID(),
            dbCreatedAt: try require(\.$dbCreatedAt),
            dbUpdatedAt: try require(\.$dbUpdatedAt),
            dbDeletedAt: dbDeletedAt,
            geometry: geometry,
            geometryWGS84: geometryWGS84,
            name: name,
            areaDescription: areaDescription,
            community: community,
            fileName: fileName
        )
    }
}
