//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 22/09/2023.
//

import Foundation

extension KernelNumerics {
#if ((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
    public typealias UniversalFloat16 = X86Float16
#else
    public typealias UniversalFloat16 = Float16
#endif
}

extension KernelNumerics {
    public struct X86Float16: Hashable, Sendable {
        public static let zero: Self = .init(bitPattern: 0x0000)
        public static let nan: Self = .init(bitPattern: 0x7e01)
        public static let infinity: Self = .infinity(sign: 1)
        public static let negativeInfinity: Self = .infinity(sign: -1)
        
        public var bitPattern: UInt16
        
        public init(bitPattern: UInt16) {
            self.bitPattern = bitPattern
        }
        
        public init() {
            self.bitPattern = 0x0000
        }
        
        public init(_ other: Float) {
            self.bitPattern = Self.singleWidthToHalfWidthBits(other.bitPattern)
        }
        
        public init(_ other: Double) {
            self.init(Float(other))
        }
    }
}

extension Int64 {
    public init?(exactly other: KernelNumerics.X86Float16) {
        guard let result = Int64(exactly: Double(other)) else {
            return nil
        }
        self = result
    }
}

extension UInt64 {
    public init?(exactly other: KernelNumerics.X86Float16) {
        guard let result = UInt64(exactly: Double(other)) else {
            return nil
        }
        self = result
    }
}

extension KernelNumerics.X86Float16 {
    public init?(exactly other: UInt64) {
        guard let a = Double(exactly: other) else {
            return nil
        }
        let b = KernelNumerics.X86Float16(a)
        guard UInt64(exactly: Double(b)) == other else {
            return nil
        }
        self = b
    }
    
    public init?(exactly other: Int64) {
        guard let a = Double(exactly: other) else {
            return nil
        }
        let b = KernelNumerics.X86Float16(a)
        guard Int64(exactly: Double(b)) == other else {
            return nil
        }
        self = b
    }
    
    public init?(exactly other: Double) {
        let b = KernelNumerics.X86Float16(other)
        guard Double(exactly: other) == other else {
            return nil
        }
        self = b
    }
}

extension Float {
    public init(_ other: KernelNumerics.X86Float16) {
        self = Float(bitPattern: KernelNumerics.X86Float16.halfWidthToSingleWidthBits(other.bitPattern))
    }
}

extension Double {
    public init(_ other: KernelNumerics.X86Float16) {
        self = Double(Float(other))
    }
}

extension KernelNumerics.X86Float16 {
    public static func infinity(sign: Int) -> Self {
        if sign >= 0 { return .init(bitPattern: .ieee754.mask.exponent) }
        return .init(bitPattern: .ieee754.mask.sign | .ieee754.mask.exponent)
    }
    
    public func isInfinity(sign: Int) -> Bool {
        ((bitPattern == .ieee754.mask.exponent) && sign >= 0) ||
        (bitPattern == .ieee754.mask.negativeInfinity && sign <= 0)
    }
    
    public var isFinite: Bool {
        bitPattern & .ieee754.mask.exponent != .ieee754.mask.exponent
    }
    
    public var isQuietNaN: Bool {
        bitPattern.andEquals(0x7c00) && bitPattern.and(0x03ff, not: .zero) && bitPattern.and(0x0200, not: .zero)
    }
    
    public var isNaN: Bool {
        let exponentMask: UInt16 = 0b0111110000000000
        let significandMask: UInt16 = 0b0000001111111111
        
        let exponent = (bitPattern & exponentMask) >> 10
        let significand = bitPattern & significandMask
        
        return exponent == 0b11111 && significand != 0
    }
    
    public static prefix func -(rhs: Self) -> Self {
        .init(bitPattern: rhs.bitPattern ^ .ieee754.mask.sign)
    }
    
    public var isNegative: Bool { Float(self) < 0 }
    
    public var isNormal: Bool {
        let exp = bitPattern & .ieee754.mask.exponent
        return (exp != .ieee754.mask.exponent) && (exp != 0)
    }
    
    var signBit: Bool {
        bitPattern.and(.ieee754.mask.sign, not: .zero)
    }
    
    var toString: String {
        String(Float(self))
    }
}
