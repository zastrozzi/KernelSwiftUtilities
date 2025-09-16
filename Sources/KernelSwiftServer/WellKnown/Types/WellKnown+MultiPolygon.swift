//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 24/09/2024.
//

import KernelSwiftCommon

extension KernelWellKnown {
    public struct MultiPolygon: Geometry, Equatable {
        public let srid: UInt
        public let polygons: [Polygon]
        
        public init(
            polygons: [Polygon] = [],
            srid: UInt? = nil
        ) {
            self.polygons = polygons
            self.srid = srid ?? 0
        }
    }
}
