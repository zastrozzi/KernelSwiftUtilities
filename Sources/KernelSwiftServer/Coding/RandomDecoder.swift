//
//  File.swift
//
//
//  Created by Jonathan Forbes on 04/04/2022.
//

import Foundation
import KernelSwiftCommon

extension Decodable {
    public static func randomInstance() throws -> Self {
//        let decoder = RandomDecoder()
        return try Self(from: randomDecoder)
    }
    
    private static var randomDecoder: RandomDecoder { .init() }
}

private class RandomDecoder: Decoder {
    let codingPath: [CodingKey] = []
    let userInfo: [CodingUserInfoKey: Any] = [:]
    
    init() { }
    
    func container<Key: CodingKey>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> {
        return .init(KeyedContainer<Key>())
    }
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        return UnkeyedContainer()
    }
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        return SingleValueContainer()
    }
    
    struct KeyedContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
        let allKeys: [Key] = []
        let codingPath: [CodingKey] = []
        
        init() { }
        
        func contains(_ key: Key) -> Bool {
            return true
        }
        func decodeNil(forKey key: Key) throws -> Bool {
            return false
        }
        
        func decode<T: Decodable>(_ type: T.Type, forKey key: Key) throws -> T {
            if T.self is Array<any OpenAPIStringEnumSampleable>.Type {
                return [] as! T
            }
            
            if T.self is Array<Any>.Type {
                return [] as! T
            }
            
            if let sampleableType = T.self as? any OpenAPIEncodableSampleable.Type {
                let sample = sampleableType.sample as! T
                return sample
            }
            
            if let sampleableEnumType = T.self as? any OpenAPIStringEnumSampleable.Type {
                let sample = sampleableEnumType.sample as! T
                return sample
            }
            
            if let iterableType = T.self as? any CaseIterable.Type, let caseType = (iterableType.allCases as any Collection).first {
                return caseType as! T
            } else {
                return try T.randomInstance()
            }
        }
        
        
        
        func nestedContainer<NestedKey: CodingKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> {
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
            if let sampleableEnumArrayType = T.self as? Array<any OpenAPIStringEnumSampleable>.Type, let sampleableEnumType = sampleableEnumArrayType.Element as? any OpenAPIStringEnumSampleable.Type {
                let sample = sampleableEnumType.sample
                return [sample] as! T
            } 
            else if let sampleableEnumType = T.self as? any OpenAPIStringEnumSampleable.Type {
                let sample = sampleableEnumType.sample as! T
                return sample
            } 
            else if T.self is Array<Any>.Type {
                return [] as! T
            } 
            else if T.self is UUID.Type {
                return UUID.zero as! T
            }
            else {
                return try T.randomInstance()
            }
        }
 
        mutating func decode<T: Decodable & CaseIterable & RawRepresentableAsString>(_ type: T.Type) throws -> T {
            defer { currentIndex += 1 }
            return T.allCases.first!
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
        let codingPath: [CodingKey] = []
        
        init() { }
        
        func decodeNil() -> Bool { return Bool.random() }
        func decode(_ type: Bool.Type) throws -> Bool { return Bool.random() }
        func decode(_ type: String.Type) throws -> String {
            return String.random(length: Int.random(in: 5...20)) }
        func decode(_ type: Double.Type) throws -> Double { return Double.random(in: 0...500) }
        func decode(_ type: Float.Type) throws -> Float { return Float.random(in: 0...500) }
        func decode(_ type: Int.Type) throws -> Int { return Int.random(in: 0...500) }
        func decode(_ type: Int8.Type) throws -> Int8 { return Int8.random(in: 0...100) }
        func decode(_ type: Int16.Type) throws -> Int16 { return Int16.random(in: 0...500) }
        func decode(_ type: Int32.Type) throws -> Int32 { return Int32.random(in: 0...500) }
        func decode(_ type: Int64.Type) throws -> Int64 { return Int64.random(in: 0...500) }
        func decode(_ type: UInt.Type) throws -> UInt { return UInt.random(in: 0...500) }
        func decode(_ type: UInt8.Type) throws -> UInt8 { return UInt8.random(in: 0...100) }
        func decode(_ type: UInt16.Type) throws -> UInt16 { return UInt16.random(in: 0...500) }
        func decode(_ type: UInt32.Type) throws -> UInt32 { return UInt32.random(in: 0...500) }
        func decode(_ type: UInt64.Type) throws -> UInt64 { return UInt64.random(in: 0...500) }
        func decode(_ type: UUID.Type) throws -> UUID { return .zero }
        func decode(_ type: Date.Type) throws -> Date { return .distantPast }
        func decode<T: Decodable>(_ type: T.Type) throws -> T {
            if T.self is Array<any OpenAPIStringEnumSampleable>.Type {
                return [] as! T
            }
            if T.self is Array<Any>.Type {
                return [] as! T
            }
            return try T.randomInstance()
        }
    }
}

extension String {
    private static let source = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
    private static let sourceAlpha = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    
    static func random<G: RandomNumberGenerator>(length: Int, using generator: inout G) -> String {
        let range = 0...length
        
        return range
            .compactMap { _ in String.source.randomElement() }
            .map(String.init)
            .joined()
    }
    
    public static func random(length: Int) -> String {
        var g = SystemRandomNumberGenerator()
        return String.random(length: length, using: &g)
    }
    
    public static func randomAlpha(length: Int) -> String {
        let range = 0...length
        return range
            .compactMap { _ in String.sourceAlpha.randomElement() }
            .map(String.init)
            .joined()
    }
}
