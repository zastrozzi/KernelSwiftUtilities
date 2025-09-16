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
    public final class UKOrdnanceSurveyBoundaryLinePollingDistrictsEngland: KernelFluentNamespacedModel, @unchecked Sendable {
        public static let namespacedSchema = SchemaName.ukOrdnanceSurveyBoundaryLinePollingDistrictsEngland
        
        @ID public var id: UUID?
        @Timestamp(key: "db_created_at", on: .create) public var dbCreatedAt: Date?
        @Timestamp(key: "db_updated_at", on: .update) public var dbUpdatedAt: Date?
        @Timestamp(key: "db_deleted_at", on: .delete) public var dbDeletedAt: Date?
        
        @PostGISField(key: "geometry") public var geometry: KernelFluentPostGIS.Geometric.MultiPolygon2D
        @PostGISField(key: "geometry_wgs84") public var geometryWGS84: KernelFluentPostGIS.Geometric.MultiPolygon2D
        @Field(key: "pd_id") public var pdId: String
        @Field(key: "county") public var county: String?
        @Field(key: "distric_bo") public var districBo: String
        @Field(key: "ward") public var ward: String
        @Field(key: "parish") public var parish: String?
        
        public init() {}
    }
}

extension KernelLocation.Fluent.Model.UKOrdnanceSurveyBoundaryLinePollingDistrictsEngland: CRUDModel {
    public typealias ResponseDTO = KernelLocation.Core.UKOrdnanceSurvey.BoundaryLine.PollingDistrictsEnglandResponse
    
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
            pdId: pdId,
            county: county,
            districBo: districBo,
            ward: ward,
            parish: parish
        )
    }
}
