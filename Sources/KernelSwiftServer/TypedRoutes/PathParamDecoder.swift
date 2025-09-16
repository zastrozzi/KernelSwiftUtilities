//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 31/05/2022.
//

import Foundation
import Vapor

internal struct PathParamCodingKey: CodingKey {
    public var stringValue: String
    public var intValue: Int?
    
    public init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }
    
    public init?(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }
}

final public class PathParamDecoder {
    func decode<T>(_ type: T.Type, from params: Parameters) throws -> T where T : Decodable {
        let decoder = _PathParamDecoder(params: params)
        return try T(from: decoder)
    }
}

final class _PathParamDecoder {
    var codingPath: [CodingKey] = []
    
    var userInfo: [CodingUserInfoKey : Any] = [:]
    
    fileprivate var params: Parameters
    
    init(params: Parameters) {
        self.params = params
    }
}

extension _PathParamDecoder: Decoder {

    func container<Key>(keyedBy type: Key.Type) -> KeyedDecodingContainer<Key> where Key : CodingKey {
        return KeyedDecodingContainer(KeyedContainer(codingPath: self.codingPath, params: self.params))
    }
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        fatalError()
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        fatalError()
    }
    
    struct KeyedContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
        var codingPath: [CodingKey] = []
        var allKeys: [Key] = []
        var params: Parameters

        func contains(_ key: Key) -> Bool {
            return allKeys.contains { $0.stringValue == key.stringValue }
        }

        func decodeNil(forKey key: Key) throws -> Bool {
            fatalError()
        }

        func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
            if type == UUID.self {
                guard let uuidStr = params.get(key.stringValue) else { throw Abort(.badRequest, reason: "Could not decode path parameters") }
                guard let uuid = UUID(uuidString: uuidStr) else { throw Abort(.badRequest, reason: "Could not decode path parameters") }
                return uuid as! T
            } else if type == String.self {
                guard let str = params.get(key.stringValue) else { throw Abort(.badRequest, reason: "Could not decode path parameters") }
                return str as! T
            } else {
                throw Abort(.badRequest, reason: "Could not decode path parameters")
            }
        }

        func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
            fatalError()
        }

        func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
            fatalError()
        }

        func superDecoder() throws -> Decoder {
            fatalError()
        }

        func superDecoder(forKey key: Key) throws -> Decoder {
            fatalError()
        }
    }
}
