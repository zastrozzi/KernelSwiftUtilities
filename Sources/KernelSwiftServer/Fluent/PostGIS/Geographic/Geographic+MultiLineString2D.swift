//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 24/09/2024.
//

import KernelSwiftCommon
import FluentKit

extension KernelFluentPostGIS.Geographic {
    public struct MultiLineString2D: PostGISCodable, PostGISCollectable {
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
    }
}
