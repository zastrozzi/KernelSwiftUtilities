//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 27/06/2023.
//


@frozen @usableFromInline
internal struct ChampHash {
    // MARK: - Static Stored Properties
    
    // MARK: - Static Computed Properties
    @inlinable @inline(__always)
    internal static var bitWidth: Int { UInt.bitWidth }
    
    @inlinable
    internal static var emptyPath: ChampHash { .init(_value: 0) }
    
    // MARK: - Static Methods
    @inlinable @inline(__always)
    internal static func ==(left: Self, right: Self) -> Bool {
        left.value == right.value
    }
    
    // MARK: - Stored Properties
    @usableFromInline
    internal var value: UInt
    
    // MARK: - Computed Properties
    @usableFromInline
    internal var description: String {
        // Print hash values in radix 32 & reversed, so that the path in the hash
        // tree is readily visible.
        let p = String(value, radix: ChampBitmap.capacity, uppercase: true)
        let c = ChampHashLevel.limit
        let path = String(repeating: "0", count: Swift.max(0, c - p.count)) + p
        return String(path.reversed())
    }
    
    // MARK: - Initialisers
    @inlinable
    internal init<Key: Hashable>(_ key: Key) {
        let hashValue = key._rawHashValue(seed: 0)
        self.value = UInt(bitPattern: hashValue)
    }
    
    @inlinable
    internal init(_value: UInt) {
        self.value = _value
    }
    
    // MARK: - Subscripts
    @inlinable
    internal subscript(_ level: ChampHashLevel) -> ChampBucket {
        get {
            assert(!level.isAtBottom)
            return .init((value &>> level.shift) & ChampBucket.bitMask)
        }
        set {
            let mask = ChampBucket.bitMask &<< level.shift
            self.value &= ~mask
            self.value |= newValue.value &<< level.shift
        }
    }
    
    // MARK: - Nonmutating Methods
    @inlinable
    internal func appending(_ bucket: ChampBucket, at level: ChampHashLevel) -> Self {
        assert(value >> level.shift == 0)
        var copy = self
        copy[level] = bucket
        return copy
    }
    
    @inlinable
    internal func isEqual(to other: ChampHash, upTo level: ChampHashLevel) -> Bool {
        if level.isAtRoot { return true }
        if level.isAtBottom { return self == other }
        let s = UInt(UInt.bitWidth) - level.shift
        let v1 = self.value &<< s
        let v2 = self.value &<< s
        return v1 == v2
    }
    
    // MARK: - Mutating Methods

}
