//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 28/04/2023.
//

import Foundation

//@dynamicMemberLookup
//public protocol PartialCodable {
//    /// The `CodingKey` type used to encode and decode values.
//    ///
//    /// This type has the extra requirement of being `Hashable`. This conformance is
//    /// synthesized when using a `Hashable` type as the `RawValue` of a `CodingKey` `enum`.
//    associatedtype CodingKeys: CodingKey & Hashable & CaseIterable & Codable
//    typealias CodingKeyCollection = KeyPathCodingKeyCollection<Self, Self.CodingKeys>
//
//    typealias BuildPair<V: Codable> = CodingKeyCollection.BuildPair<V>
//    typealias _BP<V: Codable> = Self.BuildPair<V>
//    typealias _C = CodingKeyCollection.Builder._C
//
//    /// Generate and return a collection of key paths and coding key maps.
//    ///
//    /// The `KeyPathCodingKeyCollectionBuilder` result builder is provided to simplify the
//    /// implementation of this property, for example:
//    ///
//    /// ```swift
//    /// struct CodableType: Codable, PartialCodable, Hashable {
//    ///    @KeyPathCodingKeyCollectionBuilder<Self, CodingKeys>
//    ///    static var keyPathCodingKeyCollection: KeyPathCodingKeyCollection<Self, CodingKeys> {
//    ///        (\Self.stringValue, CodingKeys.stringValue)
//    ///        (\Self.intValue, CodingKeys.intValue)
//    ///    }
//    ///
//    ///    let stringValue: String
//    ///    let intValue: Int
//    /// }
//    /// ```
//    static var keyPathCodingKeyCollection: CodingKeyCollection { get }
//}
//
//extension PartialCodable {
//    subscript<V>(dynamicMember keyPath: KeyPath<Self, V>) -> V {
//        return self[keyPath: keyPath]
//    }
//}
