//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 24/09/2024.
//

import KernelSwiftCommon
import FluentKit

extension KernelFluentPostGIS.Geometric {
    public struct MultiPolygon2D: PostGISCodable, PostGISCollectable, OpenAPIContent {
        public typealias GeometryType = KernelWellKnown.MultiPolygon
        
        public var polygons: [Polygon2D]
        public let coordinateSystem: KernelFluentPostGIS.CoordinateSystem
        
        public init(
            polygons: [Polygon2D],
            coordinateSystem: KernelFluentPostGIS.CoordinateSystem
        ) {
            self.polygons = polygons
            self.coordinateSystem = coordinateSystem
        }
        
        public init(geometry multiPolygon: GeometryType) {
            self.init(
                polygons: multiPolygon.polygons.map { .init(geometry: $0) },
                coordinateSystem: .init(rawValue: multiPolygon.srid)
            )
        }
        
        public var geometry: GeometryType {
            .init(polygons: polygons.map(\.geometry), srid: coordinateSystem.rawValue)
        }
        
        public enum CodingKeys: String, CodingKey {
            case polygons
            case coordinateSystem
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            polygons = try container.decode([Polygon2D].self, forKey: .polygons)
            coordinateSystem = try container.decode(KernelFluentPostGIS.CoordinateSystem.self, forKey: .coordinateSystem)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(polygons, forKey: .polygons)
            try container.encode(coordinateSystem, forKey: .coordinateSystem)
        }
        
        public static func == (lhs: KernelFluentPostGIS.Geometric.MultiPolygon2D, rhs: KernelFluentPostGIS.Geometric.MultiPolygon2D) -> Bool {
            lhs.polygons == rhs.polygons
        }
    }
}
