//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 24/09/2024.
//

import KernelSwiftCommon

extension KernelWellKnown {
    public struct Polygon: Geometry, Equatable {
        public let srid: UInt
        public let exteriorRing: LineString
        public let interiorRings: [LineString]
        
        public init(
            exteriorRing: LineString = .init(),
            interiorRings: [LineString] = [],
            srid: UInt? = nil
        ) {
            self.exteriorRing = exteriorRing
            self.interiorRings = interiorRings
            self.srid = srid ?? 0
        }
        
        public init(rings: [LineString], srid: UInt? = nil) {
            let exteriorRing = rings.first ?? .init()
            self.init(exteriorRing: exteriorRing, interiorRings: .init(rings.dropFirst()), srid: srid)
            
        }
        
        public var lineStrings: [LineString] {
            [exteriorRing] + interiorRings
        }
    }
}
