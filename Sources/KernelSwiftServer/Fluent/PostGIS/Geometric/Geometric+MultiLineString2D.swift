//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 24/09/2024.
//

import KernelSwiftCommon
import FluentKit

extension KernelFluentPostGIS.Geometric {
    public struct MultiLineString2D: PostGISCodable, PostGISCollectable, OpenAPIContent {
        public typealias GeometryType = KernelWellKnown.MultiLineString
        
        public var lineStrings: [LineString2D]
        public var coordinateSystem: KernelFluentPostGIS.CoordinateSystem
        
        public init(
            lineStrings: [LineString2D],
            coordinateSystem: KernelFluentPostGIS.CoordinateSystem
        ) {
            self.lineStrings = lineStrings
            self.coordinateSystem = coordinateSystem
        }
        
        public init(geometry multiLineString: GeometryType) {
            self.init(
                lineStrings: multiLineString.lineStrings.map { .init(geometry: $0) },
                coordinateSystem: .init(rawValue: multiLineString.srid)
            )
        }
        
        public var geometry: GeometryType {
            .init(
                lineStrings: lineStrings.map(\.geometry),
                srid: coordinateSystem.rawValue
            )
        }
        
        public enum CodingKeys: String, CodingKey {
            case lineStrings
            case coordinateSystem
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.lineStrings = try container.decode([LineString2D].self, forKey: .lineStrings)
            self.coordinateSystem = try container.decode(KernelFluentPostGIS.CoordinateSystem.self, forKey: .coordinateSystem)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(lineStrings, forKey: .lineStrings)
            try container.encode(coordinateSystem, forKey: .coordinateSystem)
        }
        
        public static func == (
            lhs: KernelFluentPostGIS.Geometric.MultiLineString2D,
            rhs: KernelFluentPostGIS.Geometric.MultiLineString2D
        ) -> Bool {
            lhs.lineStrings == rhs.lineStrings
        }
    }
}
