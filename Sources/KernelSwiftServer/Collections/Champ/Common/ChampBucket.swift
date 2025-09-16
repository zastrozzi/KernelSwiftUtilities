//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 27/06/2023.
//

@frozen @usableFromInline
internal struct ChampBucket: Equatable, Comparable, CustomStringConvertible {
    // MARK: - Static Computed Properties
    @inlinable @inline(__always)
    internal static var bitWidth: Int { ChampBitmap.capacity.trailingZeroBitCount }
    
    @inlinable @inline(__always)
    internal static var bitMask: UInt { .init(bitPattern: ChampBitmap.capacity) &- 1 }
    
    @inlinable @inline(__always)
    internal static var invalid: ChampBucket { .init(value: .max) }
    
    // MARK: - Static Methods
    @inlinable @inline(__always)
    internal static func ==(left: ChampBucket, right: ChampBucket) -> Bool {
        left._value == right._value
    }
    
    @inlinable @inline(__always)
    internal static func <(left: ChampBucket, right: ChampBucket) -> Bool {
        left._value < right._value
    }
    
    // MARK: - Stored Properties
    @usableFromInline
    internal var _value: UInt8
    
    // MARK: - Computed Properties
    @inlinable @inline(__always)
    internal var value: UInt { .init(truncatingIfNeeded: _value) }
    
    @usableFromInline
    internal var description: String { .init(_value, radix: ChampBitmap.capacity) }
    
    // MARK: - Initialisers
    @inlinable @inline(__always)
    internal init(value: UInt8) {
        assert(value < ChampBitmap.capacity || value == .max)
        self._value = value
    }
    
    @inlinable @inline(__always)
    internal init(_ value: UInt) {
        assert(value < ChampBitmap.capacity || value == .max)
        self._value = .init(truncatingIfNeeded: value)
    }
    
    
    // MARK: - Subscripts
    
    // MARK: - Nonmutating Methods
    
    // MARK: - Mutating Methods

}
