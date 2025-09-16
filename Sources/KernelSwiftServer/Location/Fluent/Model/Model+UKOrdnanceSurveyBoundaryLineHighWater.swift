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
    public final class UKOrdnanceSurveyBoundaryLineHighWater: KernelFluentNamespacedModel, @unchecked Sendable {
        public static let namespacedSchema = SchemaName.ukOrdnanceSurveyBoundaryLineHighWater
        
        @ID public var id: UUID?
        @Timestamp(key: "db_created_at", on: .create) public var dbCreatedAt: Date?
        @Timestamp(key: "db_updated_at", on: .update) public var dbUpdatedAt: Date?
        @Timestamp(key: "db_deleted_at", on: .delete) public var dbDeletedAt: Date?
        
        @PostGISField(key: "geometry") public var geometry: KernelFluentPostGIS.Geometric.MultiLineString2D
        @PostGISField(key: "geometry_wgs84") public var geometryWGS84: KernelFluentPostGIS.Geometric.MultiLineString2D
        @Field(key: "feature_code") public var featureCode: String
        @Field(key: "feature_description") public var featureDescription: String
        @Field(key: "file_name") public var fileName: String
        @Field(key: "feature_serial_number") public var featureSerialNumber: Int32
        @Field(key: "global_link_id") public var globalLinkId: Int32
        
        public init() {}
    }
}

extension KernelLocation.Fluent.Model.UKOrdnanceSurveyBoundaryLineHighWater: CRUDModel {
    public typealias ResponseDTO = KernelLocation.Core.UKOrdnanceSurvey.BoundaryLine.HighWaterResponse
    
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
            featureCode: featureCode,
            featureDescription: featureDescription,
            fileName: fileName,
            featureSerialNumber: featureSerialNumber,
            globalLinkId: globalLinkId
        )
    }
}
