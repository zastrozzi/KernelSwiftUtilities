//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/10/2024.
//

import KernelSwiftCommon
import Vapor

extension KernelLocation.Core.UKOrdnanceSurvey.BoundaryLine {
    public struct HistoricEuropeanRegionResponse: OpenAPIContent {
        public var id: UUID
        
        public var dbCreatedAt: Date
        public var dbUpdatedAt: Date
        public var dbDeletedAt: Date?
        
        public var geometry: KernelFluentPostGIS.Geometric.MultiPolygon2D
        public var geometryWGS84: KernelFluentPostGIS.Geometric.MultiPolygon2D
        public var name: String
        public var areaDescription: String
        
        public init(
            id: UUID,
            dbCreatedAt: Date,
            dbUpdatedAt: Date,
            dbDeletedAt: Date? = nil,
            geometry: KernelFluentPostGIS.Geometric.MultiPolygon2D,
            geometryWGS84: KernelFluentPostGIS.Geometric.MultiPolygon2D,
            name: String,
            areaDescription: String
        ) {
            self.id = id
            self.dbCreatedAt = dbCreatedAt
            self.dbUpdatedAt = dbUpdatedAt
            self.dbDeletedAt = dbDeletedAt
            self.geometry = geometry
            self.geometryWGS84 = geometryWGS84
            self.name = name
            self.areaDescription = areaDescription
        }
    }
}
