//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 24/09/2024.
//

import KernelSwiftCommon
import FluentKit

extension KernelFluentPostGIS.Geometric {
    public struct Polygon2D: PostGISCodable, PostGISCollectable, OpenAPIContent {
        public typealias GeometryType = KernelWellKnown.Polygon
        
        public let exteriorRing: LineString2D
        public let interiorRings: [LineString2D]
        public let coordinateSystem: KernelFluentPostGIS.CoordinateSystem
        
        public init(
            exteriorRing: LineString2D,
            interiorRings: [LineString2D] = [],
            coordinateSystem: KernelFluentPostGIS.CoordinateSystem
        ) {
            self.exteriorRing = exteriorRing
            self.interiorRings = interiorRings
            self.coordinateSystem = coordinateSystem
//            print("POLYGON \(coordinateSystem)")
        }
        
        public init(geometry polygon: GeometryType) {
            self.init(
                exteriorRing: .init(geometry: polygon.exteriorRing),
                interiorRings: polygon.interiorRings.map { .init(geometry: $0) },
                coordinateSystem: .init(rawValue: polygon.srid)
            )
        }
        
        public var geometry: GeometryType {
            .init(
                exteriorRing: exteriorRing.geometry,
                interiorRings: interiorRings.map(\.geometry),
                srid: coordinateSystem.rawValue
            )
        }
        
        public enum CodingKeys: String, CodingKey {
            case exteriorRing
            case interiorRings
            case coordinateSystem
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            exteriorRing = try container.decode(LineString2D.self, forKey: .exteriorRing)
            interiorRings = try container.decode([LineString2D].self, forKey: .interiorRings)
            coordinateSystem = try container.decode(KernelFluentPostGIS.CoordinateSystem.self, forKey: .coordinateSystem)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(exteriorRing, forKey: .exteriorRing)
            try container.encode(interiorRings, forKey: .interiorRings)
            try container.encode(coordinateSystem, forKey: .coordinateSystem)
        }
        
        public static func == (
            lhs: KernelFluentPostGIS.Geometric.Polygon2D,
            rhs: KernelFluentPostGIS.Geometric.Polygon2D
        ) -> Bool {
            lhs.exteriorRing == rhs.exteriorRing &&
            lhs.interiorRings == rhs.interiorRings
        }
    }
}
