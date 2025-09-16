//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 27/06/2023.
//

@usableFromInline @frozen
internal struct UnsafeChampPath {
    @usableFromInline
    internal var ancestors: AncestorChampHashSlots
    
    @usableFromInline
    internal var node: UnmanagedChampHashNode
    
    @usableFromInline
    internal var nodeSlot: ChampHashSlot
    
    @usableFromInline
    internal var level: ChampHashLevel
    
    @usableFromInline
    internal var isItem: Bool
    
    @inlinable
    internal init(root: __shared RawChampHashNode) {
        fatalError()
    }
}
