//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 27/06/2023.
//
import Collections

@frozen @usableFromInline
internal struct ChampBitmap: Equatable, CustomStringConvertible, Sequence {
    // MARK: - Typealiases
    @usableFromInline
    internal typealias Value = UInt32
    
    @usableFromInline
    internal typealias Element = (bucket: ChampBucket, slot: ChampHashSlot)
    
    @frozen @usableFromInline
    internal struct Iterator: IteratorProtocol {
        @usableFromInline
        internal var bitmap: ChampBitmap
        
        @usableFromInline
        internal var slot: ChampHashSlot
        
        @inlinable
        internal init(_ bitmap: ChampBitmap) {
            self.bitmap = bitmap
            self.slot = .zero
        }
        
        @inlinable
        internal mutating func next() -> Element? {
            guard let bucket = bitmap.popFirst() else { return nil }
            defer { slot = slot.next() }
            return (bucket, slot)
        }
    }
    
    // MARK: - Static Stored Properties
    
    // MARK: - Static Computed Properties
    @inlinable @inline(__always)
    internal static var empty: ChampBitmap { .init(value: 0) }
    
    @inlinable @inline(__always)
    internal static var capacity: Int { Value.bitWidth }
    
    @inlinable @inline(__always)
    internal static var bitWidth: Int { capacity.trailingZeroBitCount }
    
    // MARK: - Static Methods
    @inlinable @inline(__always)
    internal static func ==(left: ChampBitmap, right: ChampBitmap) -> Bool {
        left.value == right.value
    }
    
    
    
    // MARK: - Stored Properties
    @usableFromInline
    internal var value: Value
    
    // MARK: - Computed Properties
    @inlinable @inline(__always)
    internal var count: Int { value.nonzeroBitCount }
    
    @inlinable @inline(__always)
    internal var capacity: Int { Value.bitWidth }
    
    @inlinable @inline(__always)
    internal var isEmpty: Bool { value == 0 }
    
    @inlinable @inline(__always)
    internal var hasExactlyOneMember: Bool { value != 0 && value & (value &- 1) == 0 }
    
    @inlinable @inline(__always)
    internal var first: ChampBucket? { isEmpty ? nil : .init(value: .init(truncatingIfNeeded: value.trailingZeroBitCount)) }
    
    @inlinable
    internal var underestimatedCount: Int { count }
    
    @usableFromInline
    internal var description: String {
        let b = String(value, radix: 2)
        let bits = String(repeating: "0", count: ChampBitmap.capacity - b.count) + b
        return "\(String(bits.reversed())) (\(value))"
    }
    
    // MARK: - Initialisers
    @inlinable @inline(__always)
    init(value: Value) {
        self.value = value
    }
    
    @inlinable @inline(__always)
    init(bitPattern: Int) {
        self.value = Value(bitPattern)
    }
    
    @inlinable @inline(__always)
    internal init(_ bucket: ChampBucket) {
        assert(bucket.value < ChampBitmap.capacity)
        self.value = (1 &<< bucket.value)
    }
    
    @inlinable @inline(__always)
    internal init(_ bucket1: ChampBucket, _ bucket2: ChampBucket) {
        assert(bucket1.value < ChampBitmap.capacity && bucket2.value < ChampBitmap.capacity)
        assert(bucket1 != bucket2)
        self.value = (1 &<< bucket1.value) | (1 &<< bucket2.value)
    }
    
    @inlinable
    internal init(upTo bucket: ChampBucket) {
        assert(bucket.value < ChampBitmap.capacity)
        self.value = (1 &<< bucket.value) &- 1
    }
    
    // MARK: - Subscripts
    
    
    // MARK: - Nonmutating Methods
    @inlinable
    internal func makeIterator() -> Iterator { .init(self) }
    
    @inlinable @inline(__always)
    internal func contains(_ bucket: ChampBucket) -> Bool {
        assert(bucket.value < capacity)
        return value & (1 &<< bucket.value) != 0
    }
    
    @inlinable @inline(__always)
    internal mutating func insert(_ bucket: ChampBucket) {
        assert(bucket.value < capacity)
        value |= (1 &<< bucket.value)
    }
    
    @inlinable @inline(__always)
    internal func inserting(_ bucket: ChampBucket) -> ChampBitmap {
        assert(bucket.value < capacity)
        return ChampBitmap(value: value | (1 &<< bucket.value))
    }
    
    @inlinable @inline(__always)
    internal mutating func remove(_ bucket: ChampBucket) {
        assert(bucket.value < capacity)
        value &= ~(1 &<< bucket.value)
    }
    
    @inlinable @inline(__always)
    internal func removing(_ bucket: ChampBucket) -> ChampBitmap {
        assert(bucket.value < capacity)
        return ChampBitmap(value: value & ~(1 &<< bucket.value))
    }
    
    @inline(__always)
    internal func slot(of bucket: ChampBucket) -> ChampHashSlot {
        .init(value._rank(ofBit: bucket.value))
    }
    
    @inline(__always)
    internal func bucket(at slot: ChampHashSlot) -> ChampBucket {
        .init(value._bit(ranked: slot.value)!)
    }
    
    @inlinable @inline(__always)
    internal func isSubset(of other: ChampBitmap) -> Bool {
        value & ~other.value == 0
    }
    
    @inlinable @inline(__always)
    internal func isDisjoint(with other: ChampBitmap) -> Bool {
        value & other.value == 0
    }
    
    @inlinable @inline(__always)
    internal func union(_ other: ChampBitmap) -> ChampBitmap {
        .init(value: value | other.value)
    }
    
    @inlinable @inline(__always)
    internal func intersection(_ other: ChampBitmap) -> ChampBitmap {
        .init(value: value & other.value)
    }
    
    @inlinable @inline(__always)
    internal func symmetricDifference(_ other: ChampBitmap) -> ChampBitmap {
        .init(value: value & other.value)
    }
    
    @inlinable @inline(__always)
    internal func subtracting(_ other: ChampBitmap) -> ChampBitmap {
        .init(value: value & ~other.value)
    }
    
    // MARK: - Mutating Methods
    @inlinable @inline(__always)
    internal mutating func popFirst() -> ChampBucket? {
        guard let bucket = first else { return nil }
        value &= value &- 1
        return bucket
    }
}
