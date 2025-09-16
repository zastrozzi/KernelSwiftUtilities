//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/10/2024.
//

import KernelSwiftCommon
import Vapor

extension KernelLocation.Core.UKOrdnanceSurvey {
    public struct CodePointResponse: OpenAPIContent {
        public var id: UUID
        
        public var dbCreatedAt: Date
        public var dbUpdatedAt: Date
        public var dbDeletedAt: Date?
        
        public var geometry: KernelFluentPostGIS.Geometric.Point2D
        public var geometryWGS84: KernelFluentPostGIS.Geometric.Point2D
        public var postcode: String
        public var positionalQualityIndicator: Int
        public var countryCode: String?
        public var nhsRegionalHealthAuthorityCode: String?
        public var nhsHealthAuthorityCode: String?
        public var adminCountyCode: String?
        public var adminDistrictCode: String?
        public var adminWardCode: String?
        
        public init(
            id: UUID,
            dbCreatedAt: Date,
            dbUpdatedAt: Date,
            dbDeletedAt: Date? = nil,
            geometry: KernelFluentPostGIS.Geometric.Point2D,
            geometryWGS84: KernelFluentPostGIS.Geometric.Point2D,
            postcode: String,
            positionalQualityIndicator: Int,
            countryCode: String? = nil,
            nhsRegionalHealthAuthorityCode: String? = nil,
            nhsHealthAuthorityCode: String? = nil,
            adminCountyCode: String? = nil,
            adminDistrictCode: String? = nil,
            adminWardCode: String? = nil
        ) {
            self.id = id
            self.dbCreatedAt = dbCreatedAt
            self.dbUpdatedAt = dbUpdatedAt
            self.dbDeletedAt = dbDeletedAt
            self.geometry = geometry
            self.geometryWGS84 = geometryWGS84
            self.postcode = postcode
            self.positionalQualityIndicator = positionalQualityIndicator
            self.countryCode = countryCode
            self.nhsRegionalHealthAuthorityCode = nhsRegionalHealthAuthorityCode
            self.nhsHealthAuthorityCode = nhsHealthAuthorityCode
            self.adminCountyCode = adminCountyCode
            self.adminDistrictCode = adminDistrictCode
            self.adminWardCode = adminWardCode
        }
    }
}
