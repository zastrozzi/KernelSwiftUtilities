//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 24/09/2024.
//

import KernelSwiftCommon
import FluentKit

extension KernelFluentPostGIS.Geographic {
    public struct Polygon2D: PostGISCodable, PostGISCollectable {
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
    }
}
