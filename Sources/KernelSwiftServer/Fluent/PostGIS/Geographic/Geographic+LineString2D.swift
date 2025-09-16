//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 24/09/2024.
//

import KernelSwiftCommon
import FluentKit

extension KernelFluentPostGIS.Geographic {
    public struct LineString2D: PostGISCodable, PostGISCollectable {
        public typealias GeometryType = KernelWellKnown.LineString
        
        public var points: [Point2D]
        public let coordinateSystem: KernelFluentPostGIS.CoordinateSystem
        
        public init(
            points: [Point2D],
            coordinateSystem: KernelFluentPostGIS.CoordinateSystem
        ) {
            self.points = points
            self.coordinateSystem = coordinateSystem
        }
        
        public init(geometry lineString: GeometryType) {
            self.init(
                points: lineString.points.map { .init(geometry: $0) },
                coordinateSystem: .init(rawValue: lineString.srid)
            )
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
    }
}
