//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 27/06/2023.
//

@frozen @usableFromInline
internal struct ChampHashSlot: Equatable, Comparable, Hashable, CustomStringConvertible, Strideable {
    // MARK: - Static Stored Properties
    
    // MARK: - Static Computed Properties
    @inlinable @inline(__always)
    internal static var zero: ChampHashSlot { .init(0) }
    
    // MARK: - Static Methods
    @inlinable @inline(__always)
    internal static func ==(left: Self, right: Self) -> Bool {
        left._value == right._value
    }
    
    @inlinable @inline(__always)
    internal static func <(left: Self, right: Self) -> Bool {
        left._value < right._value
    }
    
    // MARK: - Stored Properties
    @usableFromInline
    internal var _value: UInt32
    
    // MARK: - Computed Properties
    @inlinable @inline(__always)
    internal var value: Int { .init(truncatingIfNeeded: _value) }
    
    @usableFromInline
    internal var description: String { "\(_value)" }
    
    // MARK: - Initialisers
    @inlinable @inline(__always)
    internal init(_ value: UInt32) {
        self._value = value
    }
    
    @inlinable @inline(__always)
    internal init(_ value: UInt) {
        assert(value <= UInt32.max)
        self._value = .init(truncatingIfNeeded: value)
    }
    
    @inlinable @inline(__always)
    internal init(_ value: Int) {
        assert(value >= 0 && value <= UInt32.max)
        self._value = .init(truncatingIfNeeded: value)
    }
    
    // MARK: - Subscripts
    
    // MARK: - Nonmutating Methods
    @inlinable
    internal func hash(into hasher: inout Hasher) {
        hasher.combine(_value)
    }
    
    @inlinable @inline(__always)
    internal func advanced(by n: Int) -> ChampHashSlot {
        assert(n >= 0 || value + n >= 0)
        return .init(_value &+ UInt32(truncatingIfNeeded: n))
    }
    
    @inlinable @inline(__always)
    internal func distance(to other: ChampHashSlot) -> Int {
        if self < other {
            return .init(truncatingIfNeeded: other._value - self._value)
        }
        return -.init(truncatingIfNeeded: self._value - other._value)
    }
    
    @inlinable @inline(__always)
    internal func next() -> ChampHashSlot {
        assert(_value < .max)
        return .init(_value &+ 1)
    }
    
    @inlinable @inline(__always)
    internal func previous() -> ChampHashSlot {
        assert(_value > 0)
        return .init(_value &- 1)
    }
    
    // MARK: - Mutating Methods

}
