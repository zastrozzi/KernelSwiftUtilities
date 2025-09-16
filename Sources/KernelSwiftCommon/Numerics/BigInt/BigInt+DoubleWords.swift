//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 13/10/2023.
//

import Foundation

extension KernelNumerics.BigInt {
    public typealias DoubleWord = KernelNumerics.DoubleWord
    public typealias DoubleWords = KernelNumerics.DoubleWords
    
    public static func fromSigned(_ dw: inout DoubleWords) -> Self {
        if dw.last!.and(.mask.bit.little.b63, not: .zero) {
            DoubleWords.invert(&dw)
            return .init(dw, .negative)
        }
        return .init(dw, .positive)
    }
}

extension KernelNumerics.BigInt.DoubleWords {
    @_documentation(visibility: private)
    public typealias BigInt = KernelNumerics.BigInt
}

extension KernelNumerics.BigInt.DoubleWords {
    @inlinable
    public static func signed(_ h: KernelNumerics.BigInt, _ l: KernelNumerics.BigInt) -> (hdw: Self, ldw: Self) {
        var hdw = h.storage, ldw = l.storage
        if h.isNegative {
            invert(&hdw)
            if hdw.last!.and(.mask.bit.little.b63, equals: .zero) { hdw.append(.max) }
        }
        else { if hdw.last!.and(.mask.bit.little.b63, not: .zero) { hdw.append(.zero) } }
        if l.isNegative {
            invert(&ldw)
            if ldw.last!.and(.mask.bit.little.b63, equals: .zero) { ldw.append(.max) }
        }
        else { if ldw.last!.and(.mask.bit.little.b63, not: .zero) { ldw.append(.zero) } }
        let h0: UInt64 = hdw.last!.and(.mask.bit.little.b63, equals: .zero) ? .zero : .max
        let l0: UInt64 = ldw.last!.and(.mask.bit.little.b63, equals: .zero) ? .zero : .max
        while hdw.count < ldw.count { hdw.append(h0) }
        while ldw.count < hdw.count { ldw.append(l0) }
        return (hdw, ldw)
    }
    
    @inlinable
    public static func invert(_ dw: inout Self) {
        for i in .zero..<dw.count { dw[i] ^= .max }
        var i = Int.zero, c = true
        while c && i < dw.count {
            dw[i] = dw[i] &+ .mask.bit.little.b0
            c = dw[i] == .zero
            i += 1
        }
        if c { dw.append(1) }
    }
    
    @inlinable
    public mutating func ensureSize(_ size: Int) {
        reserveCapacity(size)
        while count < size { append(.zero) }
    }
    
    @inlinable
    public mutating func normalise() {
        if count == Int.zero { self = [.zero] }
        else {
            var n = Int.zero, i = count - 1
            while i > .zero && self[i] == .zero {
                n += 1; i -= 1
            }
            removeLast(n)
        }
    }
    
    @inlinable
    public func copy() -> Self { self }
}
