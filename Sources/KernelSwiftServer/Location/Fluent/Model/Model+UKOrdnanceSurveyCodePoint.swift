//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 02/10/2024.
//

import Vapor
import Fluent
import KernelSwiftCommon

extension KernelLocation.Fluent.Model {
    public final class UKOrdnanceSurveyCodePoint: KernelFluentNamespacedModel, @unchecked Sendable {
        public static let namespacedSchema = SchemaName.ukOrdnanceSurveyCodePoint
        
        @ID public var id: UUID?
        @Timestamp(key: "db_created_at", on: .create) public var dbCreatedAt: Date?
        @Timestamp(key: "db_updated_at", on: .update) public var dbUpdatedAt: Date?
        @Timestamp(key: "db_deleted_at", on: .delete) public var dbDeletedAt: Date?
        
        @PostGISField(key: "geometry") public var geometry: KernelFluentPostGIS.Geometric.Point2D
        @PostGISField(key: "geometry_wgs84") public var geometryWGS84: KernelFluentPostGIS.Geometric.Point2D
        @Field(key: "postcode") public var postcode: String
        @Field(key: "positional_quality_indicator") public var positionalQualityIndicator: Int
        @Field(key: "country_code") public var countryCode: String?
        @Field(key: "nhs_regional_ha_code") public var nhsRegionalHealthAuthorityCode: String?
        @Field(key: "nhs_ha_code") public var nhsHealthAuthorityCode: String?
        @Field(key: "admin_county_code") public var adminCountyCode: String?
        @Field(key: "admin_district_code") public var adminDistrictCode: String?
        @Field(key: "admin_ward_code") public var adminWardCode: String?
        
        public init() {}
    }
}

extension KernelLocation.Fluent.Model.UKOrdnanceSurveyCodePoint: CRUDModel {
    public typealias ResponseDTO = KernelLocation.Core.UKOrdnanceSurvey.CodePointResponse
    
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
            postcode: postcode,
            positionalQualityIndicator: positionalQualityIndicator,
            countryCode: countryCode,
            nhsRegionalHealthAuthorityCode: nhsRegionalHealthAuthorityCode,
            nhsHealthAuthorityCode: nhsHealthAuthorityCode,
            adminCountyCode: adminCountyCode,
            adminDistrictCode: adminDistrictCode,
            adminWardCode: adminWardCode
        )
    }
}
