//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 24/09/2024.
//

import KernelSwiftCommon

extension KernelWellKnown {
    public struct MultiPoint: Geometry, Equatable {
        public let srid: UInt
        public let points: [Point]
        
        public init(
            points: [Point] = [],
            srid: UInt? = nil
        ) {
            self.points = points
            self.srid = srid ?? 0
        }
    }
}
