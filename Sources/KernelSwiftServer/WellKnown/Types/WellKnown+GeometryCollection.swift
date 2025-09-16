//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 24/09/2024.
//

extension KernelWellKnown {
    public struct GeometryCollection: Geometry, Equatable {
        public let srid: UInt
        public let geometries: [any Geometry]
        
        public init(
            geometries: [any Geometry] = [],
            srid: UInt? = nil
        ) {
            self.geometries = geometries
            self.srid = srid ?? 0
        }
        
        public static func == (lhs: GeometryCollection, rhs: GeometryCollection) -> Bool {
                guard lhs.srid == rhs.srid else {
                    return false
                }
                guard lhs.geometries.count == rhs.geometries.count else {
                    return false
                }
                for i in 0..<lhs.geometries.count {
                    guard lhs.geometries[i].equals(rhs.geometries[i]) else {
                        return false
                    }
                }
                return true
            }
    }
}
