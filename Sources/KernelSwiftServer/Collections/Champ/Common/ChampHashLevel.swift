//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 27/06/2023.
//

@frozen @usableFromInline
internal struct ChampHashLevel {
    // MARK: - Static Stored Properties
    
    // MARK: - Static Computed Properties
    @inlinable @inline(__always)
    internal static var limit: Int { (ChampHash.bitWidth + ChampBitmap.bitWidth - 1) / ChampBitmap.bitWidth }
    
    @inlinable @inline(__always)
    internal static var _step: UInt8 { .init(truncatingIfNeeded: ChampBitmap.bitWidth) }
    
    @inlinable @inline(__always)
    internal static var top: ChampHashLevel { .init(shift: 0) }
    
    // MARK: - Static Methods
    @inlinable @inline(__always)
    internal static func ==(left: Self, right: Self) -> Bool {
        left._shift == right._shift
    }
    
    @inlinable @inline(__always)
    internal static func <(left: Self, right: Self) -> Bool {
        left._shift < right._shift
    }
    
    // MARK: - Stored Properties
    @usableFromInline
    internal var _shift: UInt8
    
    // MARK: - Computed Properties
    @inlinable @inline(__always)
    internal var shift: UInt { UInt(truncatingIfNeeded: _shift) }
    
    @inlinable @inline(__always)
    internal var isAtRoot: Bool { _shift == 0 }
    
    @inlinable @inline(__always)
    internal var isAtBottom: Bool { _shift >= UInt.bitWidth }
    
    @inlinable @inline(__always)
    internal var depth: Int {
        (Int(bitPattern: shift) + ChampBitmap.bitWidth - 1) / ChampBitmap.bitWidth
    }
    
    // MARK: - Initialisers
    @inlinable @inline(__always)
    init(_shift: UInt8) {
        self._shift = _shift
    }
    
    @inlinable @inline(__always)
    init(shift: UInt) {
        assert(shift <= UInt8.max)
        self._shift = .init(truncatingIfNeeded: shift)
    }
    
    @inlinable @inline(__always)
    init(depth: Int) {
        assert(depth > 0 && depth < ChampHashLevel.limit)
        self.init(shift: UInt(bitPattern: depth * ChampBitmap.bitWidth))
    }
    
    // MARK: - Subscripts
    
    // MARK: - Nonmutating Methods
    @inlinable @inline(__always)
    internal func descend() -> ChampHashLevel {
        // FIXME: Consider returning nil when we run out of bits
        ChampHashLevel(_shift: _shift &+ Self._step)
    }
    
    @inlinable @inline(__always)
    internal func ascend() -> ChampHashLevel {
        assert(!isAtRoot)
        return ChampHashLevel(_shift: _shift &- Self._step)
    }
    
    // MARK: - Mutating Methods

}
