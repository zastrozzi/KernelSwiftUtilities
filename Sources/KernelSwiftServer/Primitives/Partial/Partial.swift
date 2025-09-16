//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 17/04/2023.
//

import Foundation
import Collections

public struct Partial<Wrapped>: PartialProtocol, CustomStringConvertible {

    public enum Error<V>: Swift.Error, @unchecked Sendable {
        case keyPathNotSet(KeyPath<Wrapped, V>)
        case invalidType(value: Any, keyPath: KeyPath<Wrapped, V>)
    }
    
    public var description: String {
        return "\(type(of: self))(values: \(String(describing: values)))"
    }

    fileprivate var values: TreeDictionary<PartialKeyPath<Wrapped>, Any> = [:]

    public init() {}

    public func value<V>(for keyPath: KeyPath<Wrapped, V>) throws -> V {
        guard let value = values[keyPath] else {
            throw Error.keyPathNotSet(keyPath)
        }

        if let value = value as? V {
            return value
        }

//        preconditionFailure("Value has been set, but is not of type \(V.self): \(value)")
        throw Error.invalidType(value: value, keyPath: keyPath)
    }

    public mutating func setValue<V>(_ value: V, for keyPath: KeyPath<Wrapped, V>) {
        values[keyPath] = value
    }
    
    public mutating func setValue<V>(_ value: V, for keyPath: PartialKeyPath<Wrapped>) {
        values[keyPath] = value
    }

    public mutating func removeValue<V>(for keyPath: KeyPath<Wrapped, V>) {
        values.removeValue(forKey: keyPath)
    }
    
    public mutating func removeValue(for keyPath: PartialKeyPath<Wrapped>) {
        values.removeValue(forKey: keyPath)
    }
    
    public mutating func update(from partial: Self) {
        partial.values.forEach { (key: PartialKeyPath<Wrapped>, val: Any) in
            self.setValue(val, for: key)
        }
    }

}

extension Partial: Codable where Wrapped: PartialCodable {
     public init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: Wrapped.CodingKeys.self)
         let collection = Wrapped.keyPathCodingKeyCollection
         values = try container
             .allKeys
             .reduce(into: TreeDictionary<PartialKeyPath<Wrapped>, Any>(), { values, codingKey in
                 guard let (value, keyPath) = try collection.decode(codingKey, in: container) else { return }
                 values[keyPath] = value
             })
     }

     public func encode(to encoder: Encoder) throws {
         var container = encoder.container(keyedBy: Wrapped.CodingKeys.self)

         let collection = Wrapped.keyPathCodingKeyCollection

         try values.forEach { pair in
             let (keyPath, value) = pair

             try collection.encode(value, forKey: keyPath, to: &container)
         }
     }
 }

 extension Partial where Wrapped: PartialCodable & Codable {
     public func decoded() throws -> Wrapped {
         let encoder = JSONEncoder()
         let data = try encoder.encode(self)
         let decoder = JSONDecoder()
         return try decoder.decode(Wrapped.self, from: data)
     }
 }

extension PartialCodable {
    public func asPartial() throws -> Partial<Self> {
        var partial = Partial<Self>.init()
        Self.keyPathCodingKeyCollection.keyPaths.forEach { keyPath in
            let selfValue = self[keyPath: keyPath]
            partial.setValue(selfValue, for: keyPath)
        }
        return partial
    }
}
