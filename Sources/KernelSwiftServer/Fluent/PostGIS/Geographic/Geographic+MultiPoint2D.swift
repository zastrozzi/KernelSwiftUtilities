//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 24/09/2024.
//

import KernelSwiftCommon
import FluentKit

extension KernelFluentPostGIS.Geographic {
    public struct MultiPoint2D: PostGISCodable, PostGISCollectable {
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
    }
}
