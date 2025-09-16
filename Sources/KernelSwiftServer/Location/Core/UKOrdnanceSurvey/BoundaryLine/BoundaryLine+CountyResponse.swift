//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/10/2024.
//

import KernelSwiftCommon
import Vapor

extension KernelLocation.Core.UKOrdnanceSurvey.BoundaryLine {
    public struct CountyResponse: OpenAPIContent {
        public var id: UUID
        
        public var dbCreatedAt: Date
        public var dbUpdatedAt: Date
        public var dbDeletedAt: Date?
        
        public var geometry: KernelFluentPostGIS.Geometric.MultiPolygon2D
        public var geometryWGS84: KernelFluentPostGIS.Geometric.MultiPolygon2D
        public var name: String
        public var areaCode: String
        public var areaDescription: String
        public var fileName: String
        public var featureSerialNumber: Int32
        public var collectionSerialNumber: Int32
        public var globalPolygonId: Int32
        public var adminUnitId: Int32
        public var censusCode: String?
        public var hectares: Float
        public var nonInlandArea: Float
        public var areaTypeCode: String
        public var areaTypeDescription: String
        public var nonAreaTypeCode: String?
        public var nonAreaTypeDescription: String?
        
        public init(
            id: UUID,
            dbCreatedAt: Date,
            dbUpdatedAt: Date,
            dbDeletedAt: Date? = nil,
            geometry: KernelFluentPostGIS.Geometric.MultiPolygon2D,
            geometryWGS84: KernelFluentPostGIS.Geometric.MultiPolygon2D,
            name: String,
            areaCode: String,
            areaDescription: String,
            fileName: String,
            featureSerialNumber: Int32,
            collectionSerialNumber: Int32,
            globalPolygonId: Int32,
            adminUnitId: Int32,
            censusCode: String? = nil,
            hectares: Float,
            nonInlandArea: Float,
            areaTypeCode: String,
            areaTypeDescription: String,
            nonAreaTypeCode: String? = nil,
            nonAreaTypeDescription: String? = nil
        ) {
            self.id = id
            self.dbCreatedAt = dbCreatedAt
            self.dbUpdatedAt = dbUpdatedAt
            self.dbDeletedAt = dbDeletedAt
            self.geometry = geometry
            self.geometryWGS84 = geometryWGS84
            self.name = name
            self.areaCode = areaCode
            self.areaDescription = areaDescription
            self.fileName = fileName
            self.featureSerialNumber = featureSerialNumber
            self.collectionSerialNumber = collectionSerialNumber
            self.globalPolygonId = globalPolygonId
            self.adminUnitId = adminUnitId
            self.censusCode = censusCode
            self.hectares = hectares
            self.nonInlandArea = nonInlandArea
            self.areaTypeCode = areaTypeCode
            self.areaTypeDescription = areaTypeDescription
            self.nonAreaTypeCode = nonAreaTypeCode
            self.nonAreaTypeDescription = nonAreaTypeDescription
        }
    }
}
