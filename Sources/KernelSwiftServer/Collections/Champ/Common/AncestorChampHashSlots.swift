//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 27/06/2023.
//

@frozen @usableFromInline
struct AncestorChampHashSlots: Equatable {
    // MARK: - Static Computed Properties
    @inlinable @inline(__always)
    internal static var empty: AncestorChampHashSlots { .init(0) }
    
    // MARK: - Stored Properties
    @usableFromInline
    internal var path: UInt
    
    // MARK: - Initialisers
    @inlinable @inline(__always)
    internal init(_ path: UInt) {
        self.path = path
    }
    
    // MARK: - Static Methods
    @inlinable @inline(__always)
    internal static func == (lhs: AncestorChampHashSlots, rhs: AncestorChampHashSlots) -> Bool {
        return lhs.path == rhs.path
    }
    
    // MARK: - Nonmutating Methods
    @inlinable @inline(__always)
    internal func appending(_ slot: ChampHashSlot, at level: ChampHashLevel) -> AncestorChampHashSlots {
        var res = self
        res[level] = slot
        return res
    }
    
    // MARK: - Mutating Methods
    
    
    
    // MARK: - Subscripts
    @inlinable @inline(__always)
    internal subscript(_ level: ChampHashLevel) -> ChampHashSlot {
        get {
            fatalError()
        }
        set {
            fatalError()
        }
    }
}


// MARK: - Static Computed Properties
// MARK: - Stored Properties
// MARK: - Initialisers
// MARK: - Static Methods
// MARK: - Subscripts
// MARK: - Nonmutating Methods
// MARK: - Mutating Methods
