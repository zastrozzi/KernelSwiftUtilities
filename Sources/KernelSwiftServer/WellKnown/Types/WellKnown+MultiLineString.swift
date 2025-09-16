//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 24/09/2024.
//

import KernelSwiftCommon

extension KernelWellKnown {
    public struct MultiLineString: Geometry, Equatable {
        public let srid: UInt
        public let lineStrings: [LineString]
        
        public init(
            lineStrings: [LineString] = [],
            srid: UInt? = nil
        ) {
            self.lineStrings = lineStrings
            self.srid = srid ?? 0
        }
    }
}
