//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 05/11/2023.
//

import Foundation

extension KernelNumerics {
    public struct UInt128 {
        public typealias DoubleWord = KernelNumerics.DoubleWord
        
        public let hi: DoubleWord
        public let lo: DoubleWord
        
        public var significantBits: Self {
            return .init(Self.bitWidth - leadingZeroBitCount)
        }
        
        public init(_ hi: DoubleWord, _ lo: DoubleWord) {
            self.hi = hi
            self.lo = lo
        }
        
        public init() { self.init(.zero, .zero) }
        
        public init(_ pair: (hi: DoubleWord, lo: DoubleWord)) { self.init(pair.hi, pair.lo) }
        
        
        
        public func add(_ x: KernelNumerics.UInt128) -> KernelNumerics.UInt128 {
            var l = lo, h = hi, o: Bool
            (l, o) = l.addingReportingOverflow(x.lo)
            if o { h &+= 1; assert(h != .zero) }
            (h, o) = h.addingReportingOverflow(x.hi)
            assert(!o)
            return .init(h, l)
        }
        
        public func shiftedRightTwo() -> Self { .init(hi >> 2, lo >> 2 | hi << 62) }
        
    }
}



