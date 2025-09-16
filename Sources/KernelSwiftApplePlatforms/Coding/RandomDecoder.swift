//
//  RandomDecoder.swift
//  
//
//  Created by Jonathan Forbes on 08/03/2022.
//

import Foundation

public enum RandomDecoderError: Error, LocalizedError, CustomStringConvertible {
    case failure
    case end
    
    public var errorDescription: String? {
        self.description
    }
    
    public var description: String {
        let caseDescription: String = switch self {
        case .failure: "FAILURE"
        case .end: "END"
        }
        return "RandomDecoderError: \(caseDescription)"
    }
}

extension UUID {
    public init(from: RandomDecoder) throws {
        self = .init()
    }
}

extension Decodable {
    public static func randomInstance() throws -> Self {
        let decoder = RandomDecoder()
        return try Self(from: decoder)
    }
}

public class RandomDecoder: Decoder {
    public var codingPath: [CodingKey] = []
    public var userInfo: [CodingUserInfoKey: Any] = [:]

    public func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        return KeyedDecodingContainer(KeyedContainer())
    }
    
    public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        return UnkeyedContainer()
    }
    
    public func singleValueContainer() throws -> SingleValueDecodingContainer {
        return SingleValueContainer()
    }
    
    public init() {}

    struct KeyedContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
        var codingPath: [CodingKey] = []
        var allKeys: [Key] = []

        func contains(_ key: Key) -> Bool {
            return allKeys.contains { $0.stringValue == key.stringValue }
        }

        func decodeNil(forKey key: Key) throws -> Bool {
            return false
        }

        func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
            return try T(from: RandomDecoder())
        }
        
        func decode(_ type: UUID.Type) throws -> UUID {
//            print("TRYING")
            return .init()
        }

        func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
            return .init(KeyedContainer<NestedKey>())
        }

        func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
            return UnkeyedContainer()
        }

        func superDecoder() throws -> Decoder {
            return RandomDecoder()
        }

        func superDecoder(forKey key: Key) throws -> Decoder {
            return RandomDecoder()
        }
    }

    struct UnkeyedContainer: UnkeyedDecodingContainer {
        let codingPath: [CodingKey] = []
        let count: Int? = (0...5).randomElement()
        var isAtEnd: Bool { return currentIndex == (count ?? 0) }
        private(set) var currentIndex = 0
        
        init() { }
        
        mutating func decodeNil() throws -> Bool {
            return true
        }
        mutating func decode<T: Decodable>(_ type: T.Type) throws -> T {
            defer { currentIndex += 1 }
            if T.self is Array<Any>.Type {
//                print("UNKEYED ARRAY", T.self)
                return [] as! T
            }
//            print("HELLO")
            return try T.randomInstance()
        }
        
        mutating func decode<T: Decodable & CaseIterable & InteractionFlowElementIdentifiable>(_ type: T.Type) throws -> T {
            defer { currentIndex += 1 }
            return T.allCases.first!
        }
        
        func decode(_ type: UUID.Type) throws -> UUID {
//            print("TRYING")
            return .init()
        }
        
        mutating func nestedContainer<NestedKey: CodingKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> {
            return .init(KeyedContainer<NestedKey>())
        }
        mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
            return UnkeyedContainer()
        }
        mutating func superDecoder() throws -> Decoder {
            return RandomDecoder()
        }
    }

    struct SingleValueContainer: SingleValueDecodingContainer {
        var codingPath: [CodingKey] = []

        func decodeNil() -> Bool {
            return .random()
        }

        func decode(_ type: UUID.Type) throws -> UUID {
//            print("TRYING")
            return .init()
        }
        
        func decode(_ type: Bool.Type) throws -> Bool {
            return .random()
        }

        func decode(_ type: String.Type) throws -> String {
//            print("DID STRING")
            return UUID().uuidString
        }

        func decode(_ type: Double.Type) throws -> Double {
            return .random(in: -1_000_000_000...1_000_000_000)
        }

        func decode(_ type: Float.Type) throws -> Float {
            return .random(in: 0...1)
        }

        func decode(_ type: Int.Type) throws -> Int {
            return .random(in: .min ... .max)
        }

        func decode(_ type: Int8.Type) throws -> Int8 {
            return .random(in: .min ... .max)
        }

        func decode(_ type: Int16.Type) throws -> Int16 {
            return .random(in: .min ... .max)
        }

        func decode(_ type: Int32.Type) throws -> Int32 {
            return .random(in: .min ... .max)
        }

        func decode(_ type: Int64.Type) throws -> Int64 {
            return .random(in: .min ... .max)
        }

        func decode(_ type: UInt.Type) throws -> UInt {
            return .random(in: .min ... .max)
        }

        func decode(_ type: UInt8.Type) throws -> UInt8 {
            return .random(in: .min ... .max)
        }

        func decode(_ type: UInt16.Type) throws -> UInt16 {
            return .random(in: .min ... .max)
        }

        func decode(_ type: UInt32.Type) throws -> UInt32 {
            return .random(in: .min ... .max)
        }

        func decode(_ type: UInt64.Type) throws -> UInt64 {
            return .random(in: .min ... .max)
        }

        func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
//            print("TRYING")
            return try T.randomInstance()
        }
        
        func decode(_ type: Data.Type) throws -> Data {
            return Data()
        }
    }
}
