//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 01/10/2024.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelLocation.Fluent.Migrations {
    public struct UKPostcode_Create_v1_0: AsyncMigration {
        public func prepare(on database: any Database) async throws {
            try await database.schema(SchemaName.ukPostcode)
                .id()
                .timestamps()
                .field("point", .geometricPoint2D(.osgb36BritishNationalGrid), .required)
                .field("area", .geometricPolygon2D(.osgb36BritishNationalGrid))
                .field("postcode", .string, .required)
                .field("positional_quality_indicator", .int, .required)
                .field("country_code", .string)
                .field("nhs_regional_ha_code", .string)
                .field("nhs_ha_code", .string)
                .field("admin_county_code", .string)
                .field("admin_district_code", .string)
                .field("admin_ward_code", .string)
                .create()
        }
        
        public func revert(on database: any Database) async throws {
            try await database.schema(SchemaName.ukPostcode).delete()
        }
    }
}
