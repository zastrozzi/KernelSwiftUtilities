//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 05/11/2023.
//

import Foundation

extension KernelNumerics.UInt128: BinaryInteger, UnsignedInteger {
    public static var isSigned: Bool { false }
    
    public var bitWidth: Int { 128 }
    
    public var words: [DoubleWord.Words.Element] { .init(lo.words) + .init(hi.words) }
    public var trailingZeroBitCount: Int {
        lo == .zero ? (DoubleWord.bitWidth + hi.trailingZeroBitCount) : lo.trailingZeroBitCount
    }
    
    public init?<T: BinaryFloatingPoint>(exactly source: T) {
        if source.isZero { self.init(); return }
        if source.exponent < .zero || source.rounded() != source { return nil }
        self.init(DoubleWord(source))
    }
    
    public init<T: BinaryFloatingPoint>(_ source: T) { self.init(DoubleWord(source)) }
    
    public static func / (lhs: Self, rhs: Self) -> Self { lhs.dividedReportingOverflow(by: rhs).partialValue }
    public static func /= (lhs: inout Self, rhs: Self) { lhs = lhs / rhs }
    public static func % (lhs: Self, rhs: Self) -> Self { lhs.remainderReportingOverflow(dividingBy: rhs).partialValue }
    public static func %= (lhs: inout Self, rhs: Self) { lhs = lhs % rhs }
    public static func &= (lhs: inout Self, rhs: Self) { lhs = .init(lhs.hi & rhs.hi, lhs.lo & rhs.lo) }
    public static func |= (lhs: inout Self, rhs: Self) { lhs = .init(lhs.hi | rhs.hi, lhs.lo | rhs.lo) }
    public static func ^= (lhs: inout Self, rhs: Self) { lhs = .init(lhs.hi ^ rhs.hi, lhs.lo ^ rhs.lo) }
    
    public static func &>>= (lhs: inout Self, rhs: Self) {
        let w = rhs.lo & 127
        
        switch w {
        case .zero: return
        case 1...63: lhs = .init(lhs.hi >> w, (lhs.lo >> w) + (lhs.hi << (64 - w)))
        case 64: lhs = .init(.zero, lhs.hi)
        default: lhs = .init(.zero, lhs.hi >> (w - 64))
        }
    }
    
    public static func &<<= (lhs: inout Self, rhs: Self) {
        let w = rhs.lo & 127
        
        switch w {
        case .zero: return
        case 1...63: lhs = .init((lhs.hi << w) + (lhs.hi >> (64 - w)), lhs.lo << w)
        case 64: lhs = .init(lhs.lo, .zero)
        default: lhs = .init(lhs.lo << (w - 64), .zero)
        }
    }
}

extension KernelNumerics.UInt128: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(lo)
        hasher.combine(hi)
    }
}

extension KernelNumerics.UInt128: Numeric {
    public init?<T>(exactly source: T) where T : BinaryInteger {
        self.init(DoubleWord(source))
    }
    
    public var magnitude: KernelNumerics.UInt128 { self }
    
    public static func + (lhs: Self, rhs: Self) -> Self {
        precondition(~lhs >= rhs, "Addition overflow")
        let result = lhs.addingReportingOverflow(rhs)
        return result.partialValue
    }
    public static func += (lhs: inout Self, rhs: Self) { lhs = lhs + rhs }
    
    public static func - (lhs: Self, rhs: Self) -> Self {
        precondition(lhs >= rhs, "Integer underflow")
        let result = lhs.subtractingReportingOverflow(rhs)
        return result.partialValue
    }
    public static func -= (lhs: inout Self, rhs: Self) { lhs = lhs - rhs }
    public static func * (lhs: Self, rhs: Self) -> Self {
        let result = lhs.multipliedReportingOverflow(by: rhs)
        precondition(!result.overflow, "Multiplication overflow")
        return result.partialValue
    }
    public static func *= (lhs: inout Self, rhs: Self) { lhs = lhs * rhs }
    
    public typealias Magnitude = KernelNumerics.UInt128
}

extension KernelNumerics.UInt128: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(.zero, .init(value))
    }
}

extension KernelNumerics.UInt128: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool { lhs.lo == rhs.lo && lhs.hi == rhs.hi }
}
