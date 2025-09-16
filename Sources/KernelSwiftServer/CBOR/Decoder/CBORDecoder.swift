//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 26/09/2023.
//

import Foundation

extension KernelCBOR {
    final public class CBORDecoder: Decoder {
        public var userInfo: [CodingUserInfoKey : Any] = [:]
        
//        public init() {}
        
        public func decode<D: Decodable>(_ type: D.Type, from data: Data) throws -> D {
            try decode(type, from: [UInt8](data))
        }
        
        public func decode<D: Decodable>(_ type: D.Type, from bytes: [UInt8]) throws -> D {
//            let decoder: CBORDecoderImpl =
            preconditionFailure("not implemented")
        }
        public let codingPath: [CodingKey]
        public var cborType: CBORType
        public var decodingType: CBORDecodable.Type
//        
        init<D: CBORDecodable>(codingPath: [CodingKey] = [], userInfo: [CodingUserInfoKey : Any] = [:], cborType: CBORType, decoding decodingType: D.Type) {
            self.codingPath = codingPath
            self.userInfo = userInfo
            self.cborType = cborType
            self.decodingType = decodingType
        }
        
        func decode<D: CBORDecodable>() throws -> D {
            guard D.self == decodingType else { throw D.decodingError(nil, cborType) }
            return try decodingType.init(from: cborType) as! D
        }
        
        public static func decode<D: CBORDecodable>(_ type: D.Type = D.self, from cborType: CBORType) throws -> D {
            try Self.init(cborType: cborType, decoding: type).decode()
        }
        
        public static func decode<D: CBORDecodable>(_ type: D.Type = D.self, from bytes: [UInt8]) throws -> D {
            let cbor = try KernelCBOR.CBORParser.objectFromBytes(bytes)
            return try Self.init(cborType: cbor, decoding: type).decode()
        }
        
        public func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
            return KeyedDecodingContainer(KeyedContainer(codingPath: codingPath, cborType: cborType, decoding: decodingType))
        }
        
        public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
            fatalError()
        }
        
        public func singleValueContainer() throws -> SingleValueDecodingContainer {
            return SingleValueContainer(codingPath: codingPath, cborType: cborType, decoding: decodingType)
        }
        
    }
}
