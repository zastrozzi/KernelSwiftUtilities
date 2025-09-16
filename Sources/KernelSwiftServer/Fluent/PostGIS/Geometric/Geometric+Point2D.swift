//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 24/09/2024.
//

import KernelSwiftCommon
import FluentKit

extension KernelFluentPostGIS.Geometric {
    public struct Point2D: PostGISCodable, PostGISCollectable, OpenAPIContent {
        public typealias GeometryType = KernelWellKnown.Point
        
        public var x: Double
        public var y: Double
        public let coordinateSystem: KernelFluentPostGIS.CoordinateSystem
        
        public init(
            x: Double,
            y: Double,
            coordinateSystem: KernelFluentPostGIS.CoordinateSystem
        ) {
            self.x = x
            self.y = y
            self.coordinateSystem = coordinateSystem
//            print("POINT \(coordinateSystem)")
        }
        
        public init(geometry point: GeometryType) {
            self.init(x: point.x, y: point.y, coordinateSystem: .init(rawValue: point.srid))
        }
        
        public var geometry: GeometryType {
            .init(vector: [x, y], srid: coordinateSystem.rawValue)
        }
        
        public enum CodingKeys: String, CodingKey {
            case x
            case y
            case coordinateSystem
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            x = try container.decode(Double.self, forKey: .x)
            y = try container.decode(Double.self, forKey: .y)
            coordinateSystem = try container.decode(KernelFluentPostGIS.CoordinateSystem.self, forKey: .coordinateSystem)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(x, forKey: .x)
            try container.encode(y, forKey: .y)
            try container.encode(coordinateSystem, forKey: .coordinateSystem)
        }
        
        public static func == (
            lhs: KernelFluentPostGIS.Geometric.Point2D,
            rhs: KernelFluentPostGIS.Geometric.Point2D
        ) -> Bool {
            lhs.x == rhs.x && lhs.y == rhs.y
        }
    }
}
