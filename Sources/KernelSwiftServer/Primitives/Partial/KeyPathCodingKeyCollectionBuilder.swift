//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 28/04/2023.
//

import Foundation



extension KeyPathCodingKeyCollection {
    public typealias BuildPair<V: Codable> = (keyPath: WritableKeyPath<Root, V>, codingKey: CodingKeys)
    public typealias TypedBuildPair<R: PartialCodable, V: Codable> = (keyPath: WritableKeyPath<R, V>, codingKey: R.CodingKeys)
    
    @resultBuilder
    public final class Builder {
        public typealias _BP<V: _C> = BuildPair<V>
        public typealias _TBP<R: PartialCodable, V: _C> = TypedBuildPair<R, V>
        public typealias _C = Codable
    }

}

