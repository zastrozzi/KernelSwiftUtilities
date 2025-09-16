//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 05/11/2023.
//

import Foundation

extension KernelNumerics.UInt128: FixedWidthInteger {
    public static var bitWidth: Int { 128 }
    
    nonisolated(unsafe) public static var max: KernelNumerics.UInt128 = .init(.max, .max)
    nonisolated(unsafe) public static var min: KernelNumerics.UInt128 = .init(.zero, .zero)
    
    public var nonzeroBitCount: Int {lo.nonzeroBitCount + hi.nonzeroBitCount }
    public var leadingZeroBitCount: Int { hi == .zero ? (DoubleWord.bitWidth + lo.leadingZeroBitCount) : hi.leadingZeroBitCount }
    public var byteSwapped: Self { .init(lo, hi) }
    
    public var bigEndian: Self {
#if arch(i386) || arch(x86_64) || arch(arm) || arch(arm64)
        return self.byteSwapped
#else
        return self
#endif
    }
    
    public var littleEndian: Self {
#if arch(i386) || arch(x86_64) || arch(arm) || arch(arm64)
        return self
#else
        return self.byteSwapped
#endif
    }
    
    public init(_truncatingBits bits: UInt) { self.init(.zero, .init(bits)) }
    public init(_ doubleWord: DoubleWord) { self.init(.zero, doubleWord) }
    public init(bigEndian value: Self) { self = value.bigEndian }
    public init(littleEndian value: Self) { self = value.littleEndian }
    public init(_ pair: (high: DoubleWord, low: DoubleWord)) { self.init(pair.high, pair.low) }
    
    public func addingReportingOverflow(_ rhs: Self) -> (partialValue: Self, overflow: Bool) {
        var ro = false
        let (lob, loo) = lo.addingReportingOverflow(rhs.lo)
        var (hib, hio) = hi.addingReportingOverflow(rhs.hi)
        
        if loo { (hib, ro) = hib.addingReportingOverflow(1) }
        
        return (partialValue: .init(hib, lob), overflow: hio || ro)
    }
    
    public func subtractingReportingOverflow(_ rhs: Self) -> (
        partialValue: Self, overflow: Bool
    ) {
        var ro = false
        let (lob, loo) = lo.subtractingReportingOverflow(rhs.lo)
        var (hib, hio) = hi.subtractingReportingOverflow(rhs.hi)
        if loo { (hib, ro) = hib.subtractingReportingOverflow(1) }
        
        return (partialValue: .init(hib, lob), overflow: hio || ro)
    }
    
    public func multipliedReportingOverflow(by rhs: Self) -> (
        partialValue: Self, overflow: Bool
    ) {
        let multiplicationResult = self.multipliedFullWidth(by: rhs)
        return (partialValue: multiplicationResult.low, overflow: multiplicationResult.high > .zero)
    }
    
    public func multipliedFullWidth(by other: Self) -> (high: Self, low: Self.Magnitude) {
        let m = UInt64(UInt32.max)
        
        let lhs = [hi >> 32, hi & m, lo >> 32, lo & m]
        let rhs = [other.hi >> 32, other.hi & m, other.lo >> 32, other.lo & m]
        var rb = [[UInt64]](repeating: .zeroes(4), count: 4)

        for rhsi in .zero..<rhs.count {
            for lhsi in .zero..<lhs.count { rb[lhsi][rhsi] = lhs[lhsi] * rhs[rhsi] }
        }
        
        let b8 = rb[3][3] & m
        let b7 = Self.addVariadic(rb[2][3] & m, rb[3][2] & m, rb[3][3] >> 32)
        let b6 = Self.addVariadic(rb[1][3] & m, rb[2][2] & m, rb[3][1] & m, rb[2][3] >> 32, rb[3][2] >> 32, b7.oc)
        let b5 = Self.addVariadic(rb[0][3] & m, rb[1][2] & m, rb[2][1] & m, rb[3][0] & m, rb[1][3] >> 32, rb[2][2] >> 32, rb[3][1] >> 32, b6.oc)
        let b4 = Self.addVariadic(rb[0][2] & m, rb[1][1] & m, rb[2][0] & m, rb[0][3] >> 32, rb[1][2] >> 32, rb[2][1] >> 32, rb[3][0] >> 32, b5.oc)
        let b3 = Self.addVariadic(rb[0][1] & m, rb[1][0] & m, rb[0][2] >> 32, rb[1][1] >> 32, rb[2][0] >> 32, b4.oc)
        let b1 = Self.addVariadic(rb[0][0], rb[0][1] >> 32, rb[1][0] >> 32, b3.oc)
        let lolo = Self.addVariadic(b8, b7.tv << 32)
        let hilo = Self.addVariadic(b7.tv >> 32, b6.tv, b5.tv << 32, lolo.oc)
        let lohi = Self.addVariadic(b5.tv >> 32, b4.tv, b3.tv << 32, hilo.oc)
        let hihi = Self.addVariadic(b3.tv >> 32, b1.tv, lohi.oc)
        return (high: .init(hihi.tv, lohi.tv), low: .init(hilo.tv, lolo.tv))
    }
    
    private static func addVariadic(_ addends: UInt64...) -> (tv: UInt64, oc: UInt64) {
        var sum: UInt64 = .zero
        var oc: UInt64 = .zero
        
        addends.forEach { addend in
            let interimSum = sum.addingReportingOverflow(addend)
            if interimSum.overflow {oc += 1 }
            sum = interimSum.partialValue
        }
        
        return (tv: sum, oc: oc)
    }
    
    public func dividedReportingOverflow(by rhs: Self) -> (partialValue: Self, overflow: Bool) {
        guard rhs != .zero else { return (self, true) }
        let quotient = self.quotientAndRemainder(dividingBy: rhs).quotient
        return (quotient, false)
    }
    
    public func dividingFullWidth(_ dividend: (high: Self, low: Self)) -> (quotient: Self, remainder: Self) {
        self._quotientAndRemainderFullWidth(dividingBy: dividend)
    }
    
    public func remainderReportingOverflow(dividingBy rhs: Self) -> (partialValue: Self, overflow: Bool) {
        guard rhs != .zero else { return (self, true) }
        return (self.quotientAndRemainder(dividingBy: rhs).remainder, false)
    }
    
    public func quotientAndRemainder(dividingBy rhs: Self) -> (quotient: Self, remainder: Self) {
        return rhs._quotientAndRemainderFullWidth(dividingBy: (high: .zero, low: self) )
    }
    
    internal func _quotientAndRemainderFullWidth(dividingBy dividend: (high: Self, low: Self)) -> (quotient: Self, remainder: Self) {
        let divisor = self
        let numeratorBitsToWalk: Self
        
        if dividend.high > .zero { numeratorBitsToWalk = dividend.high.significantBits + 128 - 1 }
        else if dividend.low == .zero { return (.zero, .zero) }
        else { numeratorBitsToWalk = dividend.low.significantBits - 1 }
        precondition(self != .zero, "Division by 0")
        var quotient = Self.min
        var remainder = Self.min
        
        for numeratorShiftWidth in (.zero...numeratorBitsToWalk).reversed() {
            remainder <<= 1
            remainder |= Self._bitFromDoubleWidth(at: numeratorShiftWidth, for: dividend)
            
            if remainder >= divisor {
                remainder -= divisor
                quotient |= 1 << numeratorShiftWidth
            }
        }
        
        return (quotient, remainder)
    }
    
    internal static func _bitFromDoubleWidth(at bitPosition: Self, for input: (high: Self, low: Self)) -> Self {
        switch bitPosition {
        case .zero: input.low & 1
        case 1...127: input.low >> bitPosition & 1
        case 128: input.high & 1
        default: input.high >> (bitPosition - 128) & 1
        }
    }
}
