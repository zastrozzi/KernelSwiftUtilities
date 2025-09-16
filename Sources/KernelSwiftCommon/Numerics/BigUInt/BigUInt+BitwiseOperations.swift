//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/06/2023.
//

extension KernelNumerics.BigUInt {
//    @inlinable
    public static prefix func ~(a: KernelNumerics.BigUInt) -> KernelNumerics.BigUInt {
        return Self(words: a.words.map { ~$0 })
    }

//    @inlinable
    public static func |= (a: inout KernelNumerics.BigUInt, b: KernelNumerics.BigUInt) {
        a.reserveCapacity(b.count)
        for i in 0 ..< b.count {
            a[i] |= b[i]
        }
    }

//    @inlinable
    public static func &= (a: inout KernelNumerics.BigUInt, b: KernelNumerics.BigUInt) {
        for i in 0 ..< Swift.max(a.count, b.count) {
            a[i] &= b[i]
        }
    }

//    @inlinable
    public static func ^= (a: inout KernelNumerics.BigUInt, b: KernelNumerics.BigUInt) {
        a.reserveCapacity(b.count)
        for i in 0 ..< b.count {
            a[i] ^= b[i]
        }
    }
    
    public mutating func setBitAt(_ i: Int) {
        if i >= 0 {
            let wordIndex = i >> 6
            reserveCapacityAndZero(wordIndex + 1)
            self[wordIndex] |= UInt.leadingBitMasks[i & 0x3f]
        }
    }
    
    public func testBitAt(_ i: Int) -> Bool {
        if i < .zero { return false }
        let wordIndex = i >> 6
        return wordIndex < count ? self[wordIndex].and(UInt.leadingBitMasks[i & 0x3f], not: .zero) : false
    }
}
