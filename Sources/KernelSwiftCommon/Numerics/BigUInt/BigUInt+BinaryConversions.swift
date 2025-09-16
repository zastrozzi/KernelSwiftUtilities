//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/06/2023.
//

extension KernelNumerics.BigUInt {
//    @inlinable
    public init?<T: BinaryInteger>(exactly source: T) {
        guard source >= (0 as T) else { return nil }
        if source.bitWidth <= 2 * Word.bitWidth {
            var iter = source.words.makeIterator()
            self.init(low: iter.next() ?? 0, high: iter.next() ?? 0)
            precondition(iter.next() == nil, "Length of BinaryInteger.words is greater than its bitWidth")
        }
        else {
            self.init(words: source.words)
        }
    }
    
//    @inlinable
    public init<T: BinaryInteger>(_ source: T) {
        precondition(source >= (0 as T), "BigUInt cannot represent negative values")
        self.init(exactly: source)!
    }

//    @inlinable
    public init<T: BinaryInteger>(truncatingIfNeeded source: T) {
        self.init(words: source.words)
    }

//    @inlinable
    public init<T: BinaryInteger>(clamping source: T) {
        if source <= (0 as T) { self.init() }
        else { self.init(words: source.words) }
    }
    
//    @inlinable
    public init(integerLiteral value: UInt64) { self.init(value) }
    
//    @inlinable
    public init?<T: BinaryFloatingPoint>(exactly source: T) {
        guard source.isFinite else { return nil }
        guard !source.isZero else { self = 0; return }
        guard source.sign == .plus else { return nil }
        let value = source.rounded(.towardZero)
        guard value == source else { return nil }
        assert(value.floatingPointClass == .positiveNormal)
        assert(value.exponent >= 0)
        let significand = value.significandBitPattern
        self = (KernelNumerics.BigUInt(1) << value.exponent) + KernelNumerics.BigUInt(significand) >> (T.significandBitCount - Int(value.exponent))
    }

//    @inlinable
    public init<T: BinaryFloatingPoint>(_ source: T) {
        self.init(exactly: source.rounded(.towardZero))!
    }
}
