//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 26/09/2024.
//

import Vapor
import KernelSwiftCommon

extension KernelLocation.Core.GeoLocation {
    public struct GeoLocationResponse: OpenAPIContent {
        public var id: UUID
        
        public var dbCreatedAt: Date
        public var dbUpdatedAt: Date
        public var dbDeletedAt: Date?
        
        public var name: String
        public var point: KernelFluentPostGIS.Geometric.Point2D
        
        public var enduserId: UUID?
        
        public init(
            id: UUID,
            dbCreatedAt: Date,
            dbUpdatedAt: Date,
            dbDeletedAt: Date? = nil,
            name: String,
            point: KernelFluentPostGIS.Geometric.Point2D,
            enduserId: UUID? = nil
        ) {
            self.id = id
            self.dbCreatedAt = dbCreatedAt
            self.dbUpdatedAt = dbUpdatedAt
            self.dbDeletedAt = dbDeletedAt
            self.name = name
            self.point = point
            self.enduserId = enduserId
        }
    }
}
