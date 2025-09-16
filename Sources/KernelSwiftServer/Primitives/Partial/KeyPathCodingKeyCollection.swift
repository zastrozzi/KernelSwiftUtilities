//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 28/04/2023.
//

import Foundation
import Collections

@dynamicMemberLookup
public protocol PartialCodable: Codable {
    /// The `CodingKey` type used to encode and decode values.
    ///
    /// This type has the extra requirement of being `Hashable`. This conformance is
    /// synthesized when using a `Hashable` type as the `RawValue` of a `CodingKey` `enum`.
    associatedtype CodingKeys: CodingKey & Hashable & CaseIterable
    typealias CodingKeyCollection = KeyPathCodingKeyCollection<Self, CodingKeys>
    
    typealias BuildPair<V: Codable> = CodingKeyCollection.BuildPair<V>
    typealias _BP<V: Codable> = Self.BuildPair<V>
    typealias _C = CodingKeyCollection.Builder._C
    
    /// Generate and return a collection of key paths and coding key maps.
    ///
    /// The `KeyPathCodingKeyCollectionBuilder` result builder is provided to simplify the
    /// implementation of this property, for example:
    ///
    /// ```swift
    /// struct CodableType: Codable, PartialCodable, Hashable {
    ///    @KeyPathCodingKeyCollectionBuilder<Self, CodingKeys>
    ///    static var keyPathCodingKeyCollection: KeyPathCodingKeyCollection<Self, CodingKeys> {
    ///        (\Self.stringValue, CodingKeys.stringValue)
    ///        (\Self.intValue, CodingKeys.intValue)
    ///    }
    ///
    ///    let stringValue: String
    ///    let intValue: Int
    /// }
    /// ```
    static var keyPathCodingKeyCollection: CodingKeyCollection { get }
}

extension PartialCodable {
    subscript<V>(dynamicMember keyPath: KeyPath<Self, V>) -> V {
        return self[keyPath: keyPath]
    }
}


public struct KeyPathCodingKeyCollection<Root: Codable, CodingKeys: CodingKey & Hashable & CaseIterable> {
    public enum EncodeError: Error, @unchecked Sendable {
        case invalidType(value: Any, expectedType: Any.Type)
    }

    private typealias Encoder = (_ value: Any, _ container: inout KeyedEncodingContainer<CodingKeys>) throws -> Void
    private typealias Decoder = (_ codingKey: CodingKeys, _ container: KeyedDecodingContainer<CodingKeys>) throws -> (Any, PartialKeyPath<Root>)?

    private var encoders: TreeDictionary<PartialKeyPath<Root>, Encoder> = [:]
    private var decoders: TreeDictionary<CodingKeys, Decoder> = [:]

    func encode(_ value: Any, forKey keyPath: PartialKeyPath<Root>, to container: inout KeyedEncodingContainer<CodingKeys>) throws {
        try encoders[keyPath]?(value, &container)
    }

    func decode(_ codingKey: CodingKeys, in container: KeyedDecodingContainer<CodingKeys>) throws -> (Any, PartialKeyPath<Root>)? {
        return try decoders[codingKey]?(codingKey, container)
    }

    public mutating func addPair<Value: Codable>(keyPath: KeyPath<Root, Value>, codingKey: CodingKeys) {
        encoders[keyPath] = { value, container in
            guard let caseValue = value as? Value else {
                throw EncodeError.invalidType(value: value, expectedType: Value.self)
            }

            try container.encode(caseValue, forKey: codingKey)
        }

        decoders[codingKey] = { codingKey, container in
            if let decodedValue = try container.decodeIfPresent(Value.self, forKey: codingKey) {
                return (decodedValue, keyPath)
            } else {
                return nil
            }
        }
    }
    
    public mutating func addPair<V: Codable>(_ pair: BuildPair<V>) {
        self.addPair(keyPath: pair.keyPath, codingKey: pair.codingKey)
    }
    
//    public mutating func addPairs(_ pairs: [KeyPathBuildPair<Root, some Codable, CodingKeys>]) {
//        pairs.forEach { pair in
//            self.addPair(pair)
//        }
//
//    }
    
    public var keyPaths: [PartialKeyPath<Root>] { self.encoders.keys.map { $0 } }
    
    public init() {
        self.encoders = [:]
        self.decoders = [:]
    }

}
