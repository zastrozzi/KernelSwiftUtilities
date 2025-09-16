//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/10/2024.
//

import KernelSwiftCommon
import Vapor

extension KernelLocation.Core.UKOrdnanceSurvey.BoundaryLine {
    public struct PollingDistrictsEnglandResponse: OpenAPIContent {
        public var id: UUID
        
        public var dbCreatedAt: Date
        public var dbUpdatedAt: Date
        public var dbDeletedAt: Date?
        
        public var geometry: KernelFluentPostGIS.Geometric.MultiPolygon2D
        public var geometryWGS84: KernelFluentPostGIS.Geometric.MultiPolygon2D
        public var pdId: String
        public var county: String?
        public var districBo: String
        public var ward: String
        public var parish: String?
        
        public init(
            id: UUID,
            dbCreatedAt: Date,
            dbUpdatedAt: Date,
            dbDeletedAt: Date? = nil,
            geometry: KernelFluentPostGIS.Geometric.MultiPolygon2D,
            geometryWGS84: KernelFluentPostGIS.Geometric.MultiPolygon2D,
            pdId: String,
            county: String? = nil,
            districBo: String,
            ward: String,
            parish: String? = nil
        ) {
            self.id = id
            self.dbCreatedAt = dbCreatedAt
            self.dbUpdatedAt = dbUpdatedAt
            self.dbDeletedAt = dbDeletedAt
            self.geometry = geometry
            self.geometryWGS84 = geometryWGS84
            self.pdId = pdId
            self.county = county
            self.districBo = districBo
            self.ward = ward
            self.parish = parish
        }
    }
}
