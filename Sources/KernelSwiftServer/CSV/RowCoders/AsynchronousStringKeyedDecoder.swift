//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 23/05/2023.
//

import Foundation

extension KernelCSV.CSVDecoder {
    internal final class AsynchronousStringKeyedDecoder<K>: KeyedDecodingContainerProtocol where K: CodingKey {
        internal var codingPath: [CodingKey]
        internal var decoder: AsynchronousDecoder
        private var data: [String: [UInt8]]

        internal init(path: [CodingKey], decoder: AsynchronousDecoder) throws {
            self.decoder = decoder
            self.codingPath = path
//
            guard case let .stringKeyedBytes(data) = decoder.data else {
                throw DecodingError.dataCorrupted(.init(codingPath: path, debugDescription: "Keyed data required to create a keyed decoder"))
            }
            self.data = data
            
//            fatalError()
        }

        public var allKeys: [K] {
            return self.data.keys.compactMap(K.init)
        }

        private func bytes<T>(for key: K, type: T.Type) throws -> [UInt8] {
            let keyString = key.stringValue
            let gotBytes = self.data[keyString] ?? []
            return gotBytes
        }

        public func contains(_ key: K) -> Bool {
            return self.data.keys.contains(key.stringValue)
        }

        public func decodeNil(forKey key: K) throws -> Bool {
            fatalError()
//            guard let bytes = self.data[key.stringValue] else { return true }
//            return self.decoder.configuration.nilStrategyForKey(key).isNil(bytes)
        }

        public func decode(_ type: Bool.Type, forKey key: K) throws -> Bool {
//            let bytes = try self.bytes(for: key, type: Bool.self)
            fatalError()
//            return try self.decoder.configuration.strategyForKey(key, type: .boolean, isNullable: false).decodeBool(from: bytes)
        }

        public func decode(_ type: String.Type, forKey key: K) throws -> String {
//            let bytes = try self.bytes(for: key, type: type)
            fatalError()
//            return try self.decoder.configuration.strategyForKey(key, type: .string, isNullable: false).decodeString(from: bytes)
        }
        
        public func decode(_ type: Date.Type, forKey key: K) throws -> Date {
//            let bytes = try self.bytes(for: key, type: type)
            fatalError()
//            return try self.decoder.configuration.strategyForKey(key, type: .date, isNullable: false).decodeDate(from: bytes)
        }

        public func decode(_ type: Double.Type, forKey key: K) throws -> Double {
//            let bytes = try self.bytes(for: key, type: type)
            fatalError()
//            return try self.decoder.configuration.strategyForKey(key, type: .number, isNullable: false).decodeDouble(from: bytes)
        }

        public func decode(_ type: Float.Type, forKey key: K) throws -> Float {
//            let bytes = try self.bytes(for: key, type: type)
            fatalError()
//            return try self.decoder.configuration.strategyForKey(key, type: .number, isNullable: false).decodeFloat(from: bytes)
        }

        public func decode(_ type: Int.Type, forKey key: K) throws -> Int {
//            let bytes = try self.bytes(for: key, type: type)
            fatalError()
//            return try self.decoder.configuration.strategyForKey(key, type: .number, isNullable: false).decodeInt(from: bytes)
        }
        
        public func decode(_ type: Int8.Type, forKey key: K) throws -> Int8 {
//            let bytes = try self.bytes(for: key, type: type)
            fatalError()
//            return try self.decoder.configuration.strategyForKey(key, type: .number, isNullable: false).decodeInt8(from: bytes)
        }
        
        public func decode(_ type: Int16.Type, forKey key: K) throws -> Int16 {
//            let bytes = try self.bytes(for: key, type: type)
            fatalError()
//            return try self.decoder.configuration.strategyForKey(key, type: .number, isNullable: false).decodeInt16(from: bytes)
        }
        
        public func decode(_ type: Int32.Type, forKey key: K) throws -> Int32 {
//            let bytes = try self.bytes(for: key, type: type)
            fatalError()
//            return try self.decoder.configuration.strategyForKey(key, type: .number, isNullable: false).decodeInt32(from: bytes)
        }
        
        public func decode(_ type: Int64.Type, forKey key: K) throws -> Int64 {
//            let bytes = try self.bytes(for: key, type: type)
            fatalError()
//            return try self.decoder.configuration.strategyForKey(key, type: .number, isNullable: false).decodeInt64(from: bytes)
        }
        
        public func decode(_ type: UInt.Type, forKey key: K) throws -> UInt {
//            let bytes = try self.bytes(for: key, type: type)
            fatalError()
//            return try self.decoder.configuration.strategyForKey(key, type: .number, isNullable: false).decodeUInt(from: bytes)
        }
        
        public func decode(_ type: UInt8.Type, forKey key: K) throws -> UInt8 {
//            let bytes = try self.bytes(for: key, type: type)
            fatalError()
//            return try self.decoder.configuration.strategyForKey(key, type: .number, isNullable: false).decodeUInt8(from: bytes)
        }
        
        public func decode(_ type: UInt16.Type, forKey key: K) throws -> UInt16 {
//            let bytes = try self.bytes(for: key, type: type)
            fatalError()
//            return try self.decoder.configuration.strategyForKey(key, type: .number, isNullable: false).decodeUInt16(from: bytes)
        }
        
        public func decode(_ type: UInt32.Type, forKey key: K) throws -> UInt32 {
//            let bytes = try self.bytes(for: key, type: type)
            fatalError()
//            return try self.decoder.configuration.strategyForKey(key, type: .number, isNullable: false).decodeUInt32(from: bytes)
        }
        
        public func decode(_ type: UInt64.Type, forKey key: K) throws -> UInt64 {
//            let bytes = try self.bytes(for: key, type: type)
            fatalError()
//            return try self.decoder.configuration.strategyForKey(key, type: .number, isNullable: false).decodeUInt64(from: bytes)
        }
        
        public func decode(_ type: UUID.Type, forKey key: K) throws -> UUID {
//            let bytes = try self.bytes(for: key, type: type)
            fatalError()
//            return try self.decoder.configuration.strategyForKey(key, type: .uuid, isNullable: false).decodeUUID(from: bytes)
            
        }
        
        

        public func decode<T>(_ type: T.Type, forKey key: K) throws -> T where T : Decodable {
            
            let bytes = try self.bytes(for: key, type: type)
            guard T.self != Date.self else {
                fatalError()
//                return try self.decoder.configuration.strategyForKey(key, type: .date, isNullable: false).decodeDate(from: bytes) as! T
            }
            let decoder = AsynchronousDecoder(
                decoding: self.decoder.decoding,
                path: self.codingPath + [key],
                data: .bytes(bytes),
                configuration: self.decoder.configuration,
                decodedObjectHandler: self.decoder.decodedObjectHandler
            )

            let t = try T.init(from: decoder)
            return t
//            fatalError()
        }

        public func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: K)
            throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey
        {
            throw DecodingError.dataCorruptedError(
                forKey: key,
                in: self,
                debugDescription: "CSV decoding does not support nested keyed decoders"
            )
        }

        public func nestedUnkeyedContainer(forKey key: K) throws -> UnkeyedDecodingContainer {
            throw DecodingError.dataCorruptedError(
                forKey: key,
                in: self,
                debugDescription: "CSV decoding does not support nested unkeyed decoders"
            )
        }

        public func superDecoder() throws -> Decoder {
            return self.decoder
        }

        public func superDecoder(forKey key: K) throws -> Decoder {
            return self.decoder
        }
    }
}
