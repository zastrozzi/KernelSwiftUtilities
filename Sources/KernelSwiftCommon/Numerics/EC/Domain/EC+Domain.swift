//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 30/09/2023.
//

import Foundation

extension KernelNumerics.EC {
    public struct Domain: Sendable, Equatable, Hashable {
        public static let windowWidth: Int = 0x04
        public static let windowWidthExp: Int = 0x10
        public static let windowWidthMask: KernelNumerics.BigInt.DoubleWord = 0x0f
        
        public let oid: KernelSwiftCommon.ObjectID
        public let p: KernelNumerics.BigInt
        public let a: KernelNumerics.BigInt
        public let b: KernelNumerics.BigInt
        public let g: KernelNumerics.EC.Point
        public let order: KernelNumerics.BigInt
        public let cofactor: Int
        
        // Barrett Reduction Algorithm
        // barrettMu is the inverse of mod with regard to the next power of 2
        public let mu: KernelNumerics.BigInt
        public let shifts: Int
        
        // Montgomery Modular Inverse Algorithm
        public let radixSize: Int
        public let radixSize64Bit: Int
        
        public var mod: Vector
        public var modPrime: Vector
        
        public var genPoints: [KernelNumerics.EC.Point] = []
        
        public init(
            oid: KernelSwiftCommon.ObjectID,
            p: KernelNumerics.BigInt,
            a: KernelNumerics.BigInt,
            b: KernelNumerics.BigInt,
            g: KernelNumerics.EC.Point,
            order: KernelNumerics.BigInt,
            cofactor: Int
        ) {
            self.oid = oid
            self.p = p
            self.a = a
            self.b = b
            self.g = g
            self.order = order
            self.cofactor = cofactor
            self.mod = Vector(p)
            self.shifts = p.count * 0x80
            self.mu = (.one << shifts) / p
            self.radixSize = mod.count
            self.radixSize64Bit = radixSize * 0x40
            var mPrime: KernelNumerics.BigInt = .zero
            var radixInverse: KernelNumerics.BigInt = .one
            for _ in .zero ..< radixSize64Bit {
                if radixInverse.isEven {
                    radixInverse >>= 1
                    mPrime >>= 1
                } else {
                    radixInverse += p
                    radixInverse >>= 1
                    mPrime >>= 1
                    mPrime.setBit(radixSize64Bit - 1)
                }
            }
            self.modPrime = .init(mPrime)
            self.genPoints = KernelNumerics.EC.Arithmetic.Windowing.compute(g, d: self)
        }
        
        public func generateSecret() -> KernelNumerics.BigInt { .randomLessThan(order - KernelNumerics.BigInt.one) + KernelNumerics.BigInt.one }
        public func generatePointForSecret(_ secret: KernelNumerics.BigInt) -> Point {
            Arithmetic.Windowing.multiplyGen(secret, d: self)
        }
        
        public func generateSecretAndPoint() -> (secret: KernelNumerics.BigInt, point: Point) {
            let secret = generateSecret()
            let point = generatePointForSecret(secret)
            return (secret, point)
        }
        
        public func negate(_ point: Point) -> Point { Arithmetic.Affine.negate(point, d: self) }
        public func double(_ point: Point) -> Point { Arithmetic.Affine.double(point, d: self) }
        public func add(_ p1: Point, _ p2: Point) -> Point { Arithmetic.Affine.add(p1, p2, d: self) }
        public func subtract(_ p1: Point, _ p2: Point) -> Point { Arithmetic.Affine.subtract(p1, p2, d: self) }
        public func contains(_ point: Point) -> Bool { SetOperations.contains(point, d: self) }
        
        public func multiply(_ p: Point, _ n: KernelNumerics.BigInt) -> Point {
            Arithmetic.Affine.multiply(p, n, d: self)
        }
        
        public func encode(_ p: Point, _ compressed: Bool = false) -> [UInt8] {
            CodingOperations.encode(p, compressed, d: self)
        }
        
        public func decode(_ bytes: [UInt8]) throws -> Point { try CodingOperations.decode(bytes, d: self) }
    }
}
