//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 24/09/2024.
//

import KernelSwiftCommon
import FluentKit

extension KernelFluentPostGIS.Geometric {
    public struct MultiPoint2D: PostGISCodable, PostGISCollectable, OpenAPIContent {
        public typealias GeometryType = KernelWellKnown.MultiPoint
        
        public var points: [Point2D]
        public let coordinateSystem: KernelFluentPostGIS.CoordinateSystem
        
        public init(
            points: [Point2D],
            coordinateSystem: KernelFluentPostGIS.CoordinateSystem
        ) {
            self.points = points
            self.coordinateSystem = coordinateSystem
        }
        
        public init(geometry multiPoint: GeometryType) {
            self.init(points: multiPoint.points.map { .init(geometry: $0) }, coordinateSystem: .init(rawValue: multiPoint.srid))
        }
        
        public var geometry: GeometryType {
            .init(points: points.map(\.geometry), srid: coordinateSystem.rawValue)
        }
        
        public enum CodingKeys: String, CodingKey {
            case points
            case coordinateSystem
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            points = try container.decode([Point2D].self, forKey: .points)
            coordinateSystem = try container.decode(KernelFluentPostGIS.CoordinateSystem.self, forKey: .coordinateSystem)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(points, forKey: .points)
            try container.encode(coordinateSystem, forKey: .coordinateSystem)
        }
        
        public static func == (lhs: KernelFluentPostGIS.Geometric.MultiPoint2D, rhs: KernelFluentPostGIS.Geometric.MultiPoint2D) -> Bool {
            lhs.points == rhs.points
        }
    }
}
