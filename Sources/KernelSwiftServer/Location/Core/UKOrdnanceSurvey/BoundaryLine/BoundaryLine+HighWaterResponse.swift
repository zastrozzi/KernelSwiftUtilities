//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/10/2024.
//

import KernelSwiftCommon
import Vapor

extension KernelLocation.Core.UKOrdnanceSurvey.BoundaryLine {
    public struct HighWaterResponse: OpenAPIContent {
        public var id: UUID
        
        public var dbCreatedAt: Date
        public var dbUpdatedAt: Date
        public var dbDeletedAt: Date?
        
        public var geometry: KernelFluentPostGIS.Geometric.MultiLineString2D
        public var geometryWGS84: KernelFluentPostGIS.Geometric.MultiLineString2D
        public var featureCode: String
        public var featureDescription: String
        public var fileName: String
        public var featureSerialNumber: Int32
        public var globalLinkId: Int32
        
        public init(
            id: UUID,
            dbCreatedAt: Date,
            dbUpdatedAt: Date,
            dbDeletedAt: Date? = nil,
            geometry: KernelFluentPostGIS.Geometric.MultiLineString2D,
            geometryWGS84: KernelFluentPostGIS.Geometric.MultiLineString2D,
            featureCode: String,
            featureDescription: String,
            fileName: String,
            featureSerialNumber: Int32,
            globalLinkId: Int32
        ) {
            self.id = id
            self.dbCreatedAt = dbCreatedAt
            self.dbUpdatedAt = dbUpdatedAt
            self.dbDeletedAt = dbDeletedAt
            self.geometry = geometry
            self.geometryWGS84 = geometryWGS84
            self.featureCode = featureCode
            self.featureDescription = featureDescription
            self.fileName = fileName
            self.featureSerialNumber = featureSerialNumber
            self.globalLinkId = globalLinkId
        }
    }
}
