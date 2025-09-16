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
    public final class UKOrdnanceSurveyBoundaryLineEnglishRegion: KernelFluentNamespacedModel, @unchecked Sendable {
        public static let namespacedSchema = SchemaName.ukOrdnanceSurveyBoundaryLineEnglishRegion
        
        @ID public var id: UUID?
        @Timestamp(key: "db_created_at", on: .create) public var dbCreatedAt: Date?
        @Timestamp(key: "db_updated_at", on: .update) public var dbUpdatedAt: Date?
        @Timestamp(key: "db_deleted_at", on: .delete) public var dbDeletedAt: Date?
        
        @PostGISField(key: "geometry") public var geometry: KernelFluentPostGIS.Geometric.MultiPolygon2D
        @PostGISField(key: "geometry_wgs84") public var geometryWGS84: KernelFluentPostGIS.Geometric.MultiPolygon2D
        @Field(key: "name") public var name: String
        @Field(key: "area_code") public var areaCode: String
        @Field(key: "area_description") public var areaDescription: String
        @Field(key: "file_name") public var fileName: String
        @Field(key: "feature_serial_number") public var featureSerialNumber: Int32
        @Field(key: "collection_serial_number") public var collectionSerialNumber: Int32
        @Field(key: "global_polygon_id") public var globalPolygonId: Int32
        @Field(key: "admin_unit_id") public var adminUnitId: Int32
        @Field(key: "census_code") public var censusCode: String?
        @Field(key: "hectares") public var hectares: Float
        @Field(key: "non_inland_area") public var nonInlandArea: Float
        @Field(key: "area_type_code") public var areaTypeCode: String
        @Field(key: "area_type_description") public var areaTypeDescription: String
        @Field(key: "non_area_type_code") public var nonAreaTypeCode: String?
        @Field(key: "non_area_type_description") public var nonAreaTypeDescription: String?
        
        public init() {}
    }
}

extension KernelLocation.Fluent.Model.UKOrdnanceSurveyBoundaryLineEnglishRegion: CRUDModel {
    public typealias ResponseDTO = KernelLocation.Core.UKOrdnanceSurvey.BoundaryLine.EnglishRegionResponse
    
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
            areaCode: areaCode,
            areaDescription: areaDescription,
            fileName: fileName,
            featureSerialNumber: featureSerialNumber,
            collectionSerialNumber: collectionSerialNumber,
            globalPolygonId: globalPolygonId,
            adminUnitId: adminUnitId,
            censusCode: censusCode,
            hectares: hectares,
            nonInlandArea: nonInlandArea,
            areaTypeCode: areaTypeCode,
            areaTypeDescription: areaTypeDescription,
            nonAreaTypeCode: nonAreaTypeCode,
            nonAreaTypeDescription: nonAreaTypeDescription
        )
    }
}
