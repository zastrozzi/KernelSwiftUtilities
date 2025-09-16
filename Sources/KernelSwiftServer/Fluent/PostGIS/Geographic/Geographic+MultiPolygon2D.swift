//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 24/09/2024.
//

import KernelSwiftCommon
import FluentKit

extension KernelFluentPostGIS.Geographic {
    public struct MultiPolygon2D: PostGISCodable, PostGISCollectable {
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
    }
}
