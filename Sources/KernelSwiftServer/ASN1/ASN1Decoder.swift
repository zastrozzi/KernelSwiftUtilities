//
//  File.swift
//
//
//  Created by Jonathan Forbes on 09/07/2023.
//
import Vapor

extension KernelASN1 {
    //    public class ASN1Decoder {
    ////        public init() {}
    //
    //        public func decode<D: ASN1Decodable>(_ type: D.Type, asn1Type: KernelASN1.ASN1Type) throws -> D {
    //            let decoder: KernelASN1._ASN1Decoder = .init(asn1Type: asn1Type, decoding: type)
    //            let decoded: D = try .init(from: decoder)
    //            return decoded
    //        }
    //
    //    }
    
    public struct ASN1Decoder: Decoder {
        
        public let codingPath: [CodingKey]
        nonisolated(unsafe) public var userInfo: [CodingUserInfoKey : Any] = [:]
        public var asn1Type: KernelASN1.ASN1Type
        public var rawType: ASN1Decodable.Type
        
        init<T: ASN1Decodable>(codingPath: [CodingKey] = [], asn1Type: ASN1Type, decoding asn1: T.Type) {
            self.asn1Type = asn1Type
            self.rawType = asn1
            self.codingPath = codingPath
        }
        
        init<T: ASN1Decodable>(codingPath: [CodingKey] = [], asn1Type: ASN1Type.VerboseTypeWithMetadata, decoding asn1: T.Type) {
            self.asn1Type = asn1Type.type.toASN1Type()
            self.rawType = asn1
            self.codingPath = codingPath
        }
        
        func decode<T: ASN1Decodable>() throws -> T {
            guard T.self == rawType else { throw T.decodingError(nil, asn1Type) }
            return try rawType.init(from: asn1Type) as! T
        }
        
        public static func decode<T: ASN1Decodable>(_ type: T.Type = T.self, from asn1Type: ASN1Type) throws -> T {
            let decoder = Self.init(asn1Type: asn1Type, decoding: type)
            return try decoder.decode()
        }
        
        public static func decode<T: ASN1Decodable>(_ type: T.Type = T.self, from asn1Type: ASN1Type.VerboseTypeWithMetadata) throws -> T {
            let decoder = Self.init(asn1Type: asn1Type, decoding: type)
            return try decoder.decode()
        }
        
        public static func decode<T: ASN1Decodable>(_ type: T.Type = T.self, from pemString: String) throws -> T {
            guard let parsedASN1 = try KernelASN1.ASN1Parser4.objectFromPEM(pemString: pemString) else { throw T.decodingError(nil, nil) }
            let decoder = Self.init(asn1Type: parsedASN1, decoding: type)
            return try decoder.decode()
        }
        
        public func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
            return KeyedDecodingContainer(KeyedContainer(codingPath: self.codingPath, asn1Type: self.asn1Type, decoding: rawType))
        }
        
        public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
            fatalError()
        }
        
        public func singleValueContainer() throws -> SingleValueDecodingContainer {
            return SingleValueContainer(codingPath: self.codingPath, asn1Type: self.asn1Type, decoding: rawType)
        }
    }
}

extension KernelASN1.ASN1Decoder: ContentDecoder {
    public func decode<D>(_ decodable: D.Type, from body: NIOCore.ByteBuffer, headers: NIOHTTP1.HTTPHeaders) throws -> D where D : Decodable {
        fatalError()
    }
    
    
}

extension KernelASN1.ASN1Decoder {
    public class KeyedContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
        public var codingPath: [CodingKey] = []
        public var allKeys: [Key] = []
        public var dictionary: [String: String] = [:]
        public var asn1Type: KernelASN1.ASN1Type
        public var index: Int = 0
        public var rawType: ASN1Decodable.Type
        
        public init<T: ASN1Decodable>(codingPath: [CodingKey], asn1Type: KernelASN1.ASN1Type, decoding: T.Type) {
            self.codingPath = codingPath
            //            self.allKeys = allKeys
            self.asn1Type = asn1Type
            self.rawType = decoding
        }
        
        public func contains(_ key: Key) -> Bool {
            return allKeys.contains { $0.stringValue == key.stringValue }
        }
        
        public func decodeNil(forKey key: Key) throws -> Bool {
            fatalError()
        }
        
        public func decode<T: Decodable>(_ type: T.Type, forKey key: Key) throws -> T {
            
            let x: ASN1Decodable.Type = type as! any ASN1Decodable.Type
            guard case let .sequence(sequenceItems) = asn1Type  else { throw x.decodingError(.sequence, asn1Type) }
            
            let asn1Subtype = sequenceItems[index]
            if (index + 1) < sequenceItems.endIndex {
                self.index += 1
            }
            return try x.init(from: asn1Subtype) as! T
            
        }
        
        
        public func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
            preconditionFailure("Not implemented")
        }
        
        public func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
            preconditionFailure("Not implemented")
        }
        
        public func superDecoder() throws -> Decoder {
            preconditionFailure("Not implemented")
        }
        
        public func superDecoder(forKey key: Key) throws -> Decoder {
            preconditionFailure("Not implemented")
        }
    }
    
    struct SingleValueContainer: SingleValueDecodingContainer {
        
        let codingPath: [CodingKey]
        public var asn1Type: KernelASN1.ASN1Type
        public var raw: ASN1Decodable.Type
        
        init<T: ASN1Decodable>(codingPath: [CodingKey], asn1Type: KernelASN1.ASN1Type, decoding: T.Type) {
            self.codingPath = codingPath
            self.asn1Type = asn1Type
            self.raw = decoding
        }
        
        func decodeNil() -> Bool { return Bool.random() }
        func decode(_ type: Bool.Type) throws -> Bool { return Bool.random() }
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
        
        func decode<T: Decodable>(_ type: T.Type) throws -> any ASN1Decodable {
            return try raw.init(from: asn1Type)
        }
        
        func decode<T: Decodable>(_ type: T.Type) throws -> T {
            preconditionFailure("Not implemented")
        }
        
        func decode<T: ASN1Decodable>(_ type: T.Type) throws -> T {
            preconditionFailure("Not implemented")
        }
    }
}

