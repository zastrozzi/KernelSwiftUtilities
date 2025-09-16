//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 24/09/2024.
//

import KernelSwiftCommon
import FluentKit
import Vapor

extension KernelFluentPostGIS.Geographic {
    public struct Point2D: PostGISCodable, PostGISCollectable, OpenAPIContent {
        public typealias GeometryType = KernelWellKnown.Point
        
        public var longitude: Double
        public var latitude: Double
        public let coordinateSystem: KernelFluentPostGIS.CoordinateSystem
        
        public init(
            longitude: Double,
            latitude: Double,
            coordinateSystem: KernelFluentPostGIS.CoordinateSystem
        ) {
            self.longitude = longitude
            self.latitude = latitude
            self.coordinateSystem = coordinateSystem
        }
        
        public init(geometry point: GeometryType) {
            self.init(longitude: point.x, latitude: point.y, coordinateSystem: .init(rawValue: point.srid))
        }
        
        public var geometry: GeometryType {
            .init(vector: [longitude, latitude], srid: coordinateSystem.rawValue)
        }
        
        public enum CodingKeys: String, CodingKey {
            case longitude
            case latitude
            case coordinateSystem
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            longitude = try container.decode(Double.self, forKey: .longitude)
            latitude = try container.decode(Double.self, forKey: .latitude)
            coordinateSystem = try container.decode(KernelFluentPostGIS.CoordinateSystem.self, forKey: .coordinateSystem)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(longitude, forKey: .longitude)
            try container.encode(latitude, forKey: .latitude)
            try container.encode(coordinateSystem, forKey: .coordinateSystem)
        }
    }
}
