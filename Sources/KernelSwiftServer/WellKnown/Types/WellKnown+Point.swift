//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 24/09/2024.
//

import KernelSwiftCommon

extension KernelWellKnown {
    public struct Point: Geometry, Equatable {
        public let srid: UInt
        public let vector: [Double]
        
        public init(
            vector: [Double],
            srid: UInt? = nil
        ) {
            self.vector = vector
            self.srid = srid ?? 0
        }
        
        public init(
            x: Double,
            y: Double
        ) {
            self.init(vector: [x, y])
        }
        
        public var x: Double { vector[0] }
        public var y: Double { vector[1] }
        
        public var z: Double? {
            guard vector.count > 2 else { return nil }
            return vector[2]
        }
        
        public var m: Double? {
            guard vector.count > 3 else { return nil }
            return vector[3]
        }
        
    }
}
