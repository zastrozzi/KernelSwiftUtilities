//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 05/06/2023.
//

import Foundation
import NIOConcurrencyHelpers
import Collections
import KernelSwiftCommon

extension KernelCSV.CSVCodingConfiguration.ResolvedConfiguration {
    public final class CSVRowDecoder<DecodedCSVRow: KernelCSV.CSVCodable>: Decoder, @unchecked Sendable {
        
        @inlinable
        public func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
            return self.keyedContainer as! KeyedDecodingContainer<Key>
        }
        
        public typealias Key = DecodedCSVRow.CodingKeys.Type
        public let codingPath: [CodingKey] = []
        
        public let userInfo: [CodingUserInfoKey : Any] = [:]
        
        public var byteDictionary: OrderedByteDictionary = [:]
        public let resolvedConfiguration: KernelCSV.CSVCodingConfiguration.ResolvedConfiguration<DecodedCSVRow>
//        private var lock: NIOLock = .init()
        
        @usableFromInline
        lazy var keyedContainer: KeyedDecodingContainer<DecodedCSVRow.CodingKeys> = {
            let container = KeyedContainer<DecodedCSVRow>(codingPath: codingPath, for: self)
            return KeyedDecodingContainer(container)
        }()
        
        public init(
            for configuration: KernelCSV.CSVCodingConfiguration.ResolvedConfiguration<DecodedCSVRow>
        ) {
            self.resolvedConfiguration = configuration
        }
        
        
        @inlinable
        public func container(keyedBy type: DecodedCSVRow.CodingKeys.Type) throws -> KeyedDecodingContainer<DecodedCSVRow.CodingKeys> {
            let container = KeyedContainer<DecodedCSVRow>(codingPath: codingPath, for: self)
            return KeyedDecodingContainer(container)
        }
        
        public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
            fatalError()
        }
        
        public func singleValueContainer() throws -> SingleValueDecodingContainer {
            fatalError()
        }
        
        @inlinable
        public func decode(fromByteDict byteDict: OrderedByteDictionary) throws -> DecodedCSVRow? {
            self.byteDictionary = byteDict
            return try DecodedCSVRow.init(from: self)
        }
    }
}

extension KernelCSV.CSVCodingConfiguration.ResolvedConfiguration {
    @usableFromInline
    final class KeyedContainer<DecodedCSVRow: KernelCSV.CSVCodable>: KeyedDecodingContainerProtocol {
        @usableFromInline typealias Key = DecodedCSVRow.CodingKeys
        
        
        
        
        @usableFromInline var codingPath: [CodingKey] = []
        @usableFromInline var allKeys: [Key] { DecodedCSVRow.codingKeySet.compactMap { .init(stringValue: $0.stringValue) } }
        
        @usableFromInline
        let allResolvedKeys: [String: KernelCSV.CSVCodingTransformableCodingKey] = DecodedCSVRow.codingKeySet.reduce(into: [String:KernelCSV.CSVCodingTransformableCodingKey]()) { partialResult, key in
            partialResult[key.stringValue] = key
        }

//        @inline(__always)
        @inlinable
        func getResolvedKey(_ codingKey: Key) -> KernelCSV.CSVCodingTransformableCodingKey? {
            return allResolvedKeys[codingKey.stringValue]
        }
        
//        let resolvedConfiguration: CSVCodingConfiguration.ResolvedConfiguration<DecodedCSVRow>
//        let byteDictionary: OrderedByteDictionary
        @inlinable
        init(codingPath: [CodingKey], for decoder: CSVRowDecoder<DecodedCSVRow>) {
            self.codingPath = codingPath
//            self.resolvedConfiguration = configuration
            self.decoder = decoder
        }
        
        @usableFromInline internal var decoder: CSVRowDecoder<DecodedCSVRow>
        
//        @inline(__always)
        @inlinable
        func contains(_ key: Key) -> Bool {
            do {
                guard let resolvedKey = getResolvedKey(key),
                      let position = decoder.resolvedConfiguration.codableKeyRowPosition(key: resolvedKey) else {
                    throw DecodingError.keyNotFound(key, .init(codingPath: codingPath, debugDescription: "Could not find position for key \(key)"))
                }
                return decoder.byteDictionary.keys.contains(position)
            } catch let error {
                KernelCSV.logger.error("CSVRowDecoder:KeyedContainer:Error - \(error.localizedDescription)")
                return false
            }
        }
        
//        @inline(__always)
        @inlinable
        func decodeNil(forKey key: Key) throws -> Bool {
            guard let resolvedKey = getResolvedKey(key), let position = decoder.resolvedConfiguration.codableKeyRowPosition(key: resolvedKey) else {
                throw DecodingError.typeMismatch(Void.self, .init(codingPath: codingPath, debugDescription: "Could not find position for key \(key)"))
            }
            guard let bytes = decoder.byteDictionary[position] else {
                guard case .blank = decoder.resolvedConfiguration.nilCodingStrategy else {
                    throw DecodingError.typeMismatch(Void.self, .init(codingPath: codingPath, debugDescription: "Could not find data for key \(key)"))
                }
                return true
            }
            return decoder.resolvedConfiguration.nilCodingStrategy.isNil(bytes)
        }
        
//        @inline(__always)
        @inlinable
        func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
            guard let resolvedKey = getResolvedKey(key), case let .boolean(booleanStrategy) = decoder.resolvedConfiguration.codableCodingKeyStrategies[resolvedKey] else {
                throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find boolean strategy for key \(key)"))
            }
            guard let position = decoder.resolvedConfiguration.codableKeyRowPosition(key: resolvedKey) else {
                throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find position for key \(key)"))
            }
            guard let bytes = decoder.byteDictionary[position] else {
                throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find data for key \(key)"))
            }
            return try booleanStrategy.decodeBool(from: bytes)
        }
        
//        @inline(__always)
        @inlinable
        func decode(_ type: String.Type, forKey key: Key) throws -> String {
            guard let resolvedKey = getResolvedKey(key), case let .string(strategy) = decoder.resolvedConfiguration.codableCodingKeyStrategies[resolvedKey] else {
                throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find strategy for key \(key) with type \(type)"))
            }
            guard let position = decoder.resolvedConfiguration.codableKeyRowPosition(key: resolvedKey) else {
                throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find position for key \(key)"))
            }
            guard let bytes = decoder.byteDictionary[position] else {
                throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find data for key \(key)"))
            }
            return try strategy.decodeString(from: bytes)
        }
        
//        @inline(__always)
        @inlinable
        func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
            guard let resolvedKey = getResolvedKey(key), case let .number(strategy) = decoder.resolvedConfiguration.codableCodingKeyStrategies[resolvedKey] else {
                throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find strategy for key \(key) with type \(type)"))
            }
            guard let position = decoder.resolvedConfiguration.codableKeyRowPosition(key: resolvedKey) else {
                throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find position for key \(key)"))
            }
            guard let bytes = decoder.byteDictionary[position] else {
                throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find data for key \(key)"))
            }
            return try strategy.decodeDouble(from: bytes)
        }
        
//        @inline(__always)
        @inlinable
        func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
            guard let resolvedKey = getResolvedKey(key), case let .number(strategy) = decoder.resolvedConfiguration.codableCodingKeyStrategies[resolvedKey] else {
                throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find strategy for key \(key) with type \(type)"))
            }
            guard let position = decoder.resolvedConfiguration.codableKeyRowPosition(key: resolvedKey) else {
                throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find position for key \(key)"))
            }
            guard let bytes = decoder.byteDictionary[position] else {
                throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find data for key \(key)"))
            }
            return try strategy.decodeFloat(from: bytes)
        }
        
//        @inline(__always)
        @inlinable
        func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
            guard let resolvedKey = getResolvedKey(key), case let .number(strategy) = decoder.resolvedConfiguration.codableCodingKeyStrategies[resolvedKey] else {
                throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find strategy for key \(key) with type \(type)"))
            }
            guard let position = decoder.resolvedConfiguration.codableKeyRowPosition(key: resolvedKey) else {
                throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find position for key \(key)"))
            }
            guard let bytes = decoder.byteDictionary[position] else {
                throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find data for key \(key)"))
            }
            return try strategy.decodeInt(from: bytes)
        }
        
//        @inline(__always)
        @inlinable
        func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
            guard let resolvedKey = getResolvedKey(key), case let .number(strategy) = decoder.resolvedConfiguration.codableCodingKeyStrategies[resolvedKey] else {
                throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find strategy for key \(key) with type \(type)"))
            }
            guard let position = decoder.resolvedConfiguration.codableKeyRowPosition(key: resolvedKey) else {
                throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find position for key \(key)"))
            }
            guard let bytes = decoder.byteDictionary[position] else {
                throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find data for key \(key)"))
            }
            return try strategy.decodeInt8(from: bytes)
        }
        
//        @inline(__always)
        @inlinable
        func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
            guard let resolvedKey = getResolvedKey(key), case let .number(strategy) = decoder.resolvedConfiguration.codableCodingKeyStrategies[resolvedKey] else {
                throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find strategy for key \(key) with type \(type)"))
            }
            guard let position = decoder.resolvedConfiguration.codableKeyRowPosition(key: resolvedKey) else {
                throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find position for key \(key)"))
            }
            guard let bytes = decoder.byteDictionary[position] else {
                throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find data for key \(key)"))
            }
            return try strategy.decodeInt16(from: bytes)
        }
        
//        @inline(__always)
        @inlinable
        func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
            guard let resolvedKey = getResolvedKey(key), case let .number(strategy) = decoder.resolvedConfiguration.codableCodingKeyStrategies[resolvedKey] else {
                throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find strategy for key \(key) with type \(type)"))
            }
            guard let position = decoder.resolvedConfiguration.codableKeyRowPosition(key: resolvedKey) else {
                throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find position for key \(key)"))
            }
            guard let bytes = decoder.byteDictionary[position] else {
                throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find data for key \(key)"))
            }
            return try strategy.decodeInt32(from: bytes)
        }
        
//        @inline(__always)
        @inlinable
        func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
            guard let resolvedKey = getResolvedKey(key), case let .number(strategy) = decoder.resolvedConfiguration.codableCodingKeyStrategies[resolvedKey] else {
                throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find strategy for key \(key) with type \(type)"))
            }
            guard let position = decoder.resolvedConfiguration.codableKeyRowPosition(key: resolvedKey) else {
                throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find position for key \(key)"))
            }
            guard let bytes = decoder.byteDictionary[position] else {
                throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find data for key \(key)"))
            }
            return try strategy.decodeInt64(from: bytes)
        }
        
//        @inline(__always)
        @inlinable
        func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
            guard let resolvedKey = getResolvedKey(key), case let .number(strategy) = decoder.resolvedConfiguration.codableCodingKeyStrategies[resolvedKey] else {
                throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find strategy for key \(key) with type \(type)"))
            }
            guard let position = decoder.resolvedConfiguration.codableKeyRowPosition(key: resolvedKey) else {
                throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find position for key \(key)"))
            }
            guard let bytes = decoder.byteDictionary[position] else {
                throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find data for key \(key)"))
            }
            return try strategy.decodeUInt(from: bytes)
        }
        
//        @inline(__always)
        @inlinable
        func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
            guard let resolvedKey = getResolvedKey(key), case let .number(strategy) = decoder.resolvedConfiguration.codableCodingKeyStrategies[resolvedKey] else {
                throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find strategy for key \(key) with type \(type)"))
            }
            guard let position = decoder.resolvedConfiguration.codableKeyRowPosition(key: resolvedKey) else {
                throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find position for key \(key)"))
            }
            guard let bytes = decoder.byteDictionary[position] else {
                throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find data for key \(key)"))
            }
            return try strategy.decodeUInt8(from: bytes)
        }
        
        @inlinable
        func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
            guard let resolvedKey = getResolvedKey(key), case let .number(strategy) = decoder.resolvedConfiguration.codableCodingKeyStrategies[resolvedKey] else {
                throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find strategy for key \(key) with type \(type)"))
            }
            guard let position = decoder.resolvedConfiguration.codableKeyRowPosition(key: resolvedKey) else {
                throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find position for key \(key)"))
            }
            guard let bytes = decoder.byteDictionary[position] else {
                throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find data for key \(key)"))
            }
            return try strategy.decodeUInt16(from: bytes)
        }
        
//        @inline(__always)
        @inlinable
        func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
            guard let resolvedKey = getResolvedKey(key), case let .number(strategy) = decoder.resolvedConfiguration.codableCodingKeyStrategies[resolvedKey] else {
                throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find strategy for key \(key) with type \(type)"))
            }
            guard let position = decoder.resolvedConfiguration.codableKeyRowPosition(key: resolvedKey) else {
                throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find position for key \(key)"))
            }
            guard let bytes = decoder.byteDictionary[position] else {
                throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find data for key \(key)"))
            }
            return try strategy.decodeUInt32(from: bytes)
        }
        
//        @inline(__always)
        @inlinable
        func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
            guard let resolvedKey = getResolvedKey(key), case let .number(strategy) = decoder.resolvedConfiguration.codableCodingKeyStrategies[resolvedKey] else {
                throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find strategy for key \(key) with type \(type)"))
            }
            guard let position = decoder.resolvedConfiguration.codableKeyRowPosition(key: resolvedKey) else {
                throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find position for key \(key)"))
            }
            guard let bytes = decoder.byteDictionary[position] else {
                throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find data for key \(key)"))
            }
            return try strategy.decodeUInt64(from: bytes)
        }
        
//        func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : RawRepresentableAsString {
//            guard
//        }
//
//        func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : RawRepresentableAsInt {
//            fatalError()
//        }
//        func decode(_ type: Date.Type, forKey key: Key) throws -> Date {
//
//        }
//        @inline(__always)
        @inlinable
        func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
            switch type {
            case is UUID.Type:
                guard let resolvedKey = getResolvedKey(key), case let .uuid(strategy) = decoder.resolvedConfiguration.codableCodingKeyStrategies[resolvedKey] else {
                    throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find strategy for key \(key) with type \(type)"))
                }
                guard let position = decoder.resolvedConfiguration.codableKeyRowPosition(key: resolvedKey) else {
                    throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find position for key \(key)"))
                }
                guard let bytes = decoder.byteDictionary[position] else {
                    throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find data for key \(key)"))
                }
                do {
                    return try strategy.decodeUUID(from: bytes) as! T
                } catch let error {
                    throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not decode data for key \(key) with type \(type). Underlying error: \(error.localizedDescription)"))
                }
            case is Date.Type:
                guard let resolvedKey = getResolvedKey(key), case var .date(strategy) = decoder.resolvedConfiguration.codableCodingKeyStrategies[resolvedKey] else {
                    throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find strategy for key \(key) with type \(type)"))
                }
                guard let position = decoder.resolvedConfiguration.codableKeyRowPosition(key: resolvedKey) else {
                    throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find position for key \(key)"))
                }
                guard let bytes = decoder.byteDictionary[position] else {
                    throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find data for key \(key)"))
                }
                do {
                    return try strategy.decodeDate(from: bytes) as! T
                } catch let error {
                    throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not decode data for key \(key) with type \(type). Underlying error: \(error.localizedDescription)"))
                }
            default:
                break
            }
            if let resolvedKey = getResolvedKey(key), case let .stringEnum(underlyingType, strategy) = decoder.resolvedConfiguration.codableCodingKeyStrategies[resolvedKey], type == underlyingType {
                guard let position = decoder.resolvedConfiguration.codableKeyRowPosition(key: resolvedKey) else {
                    throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find position for key \(key)"))
                }
                guard let bytes = decoder.byteDictionary[position] else {
                    throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find data for key \(key)"))
                }
                do {
                    let raw = try strategy.decodeString(from: bytes)
                    return underlyingType.init(rawValue: raw)! as! T
                } catch let error {
                    throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not decode data for key \(key) with type \(type). Underlying error: \(error.localizedDescription)"))
                }
            }
            
            if let resolvedKey = getResolvedKey(key), case let .intEnum(underlyingType, strategy) = decoder.resolvedConfiguration.codableCodingKeyStrategies[resolvedKey], type == underlyingType {
                guard let position = decoder.resolvedConfiguration.codableKeyRowPosition(key: resolvedKey) else {
                    throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find position for key \(key)"))
                }
                guard let bytes = decoder.byteDictionary[position] else {
                    throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not find data for key \(key)"))
                }
                do {
                    let raw = try strategy.decodeInt(from: bytes)
                    return underlyingType.init(rawValue: raw) as! T
                } catch let error {
                    throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not decode data for key \(key) with type \(type). Underlying error: \(error.localizedDescription)"))
                }
            }
            throw DecodingError.typeMismatch(type, .init(codingPath: codingPath, debugDescription: "Could not decode data for key \(key) with type \(type)"))
        }
        
        @inlinable
        func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
            throw DecodingError.dataCorruptedError(
                forKey: key,
                in: self,
                debugDescription: "CSV decoding does not support nested keyed containers"
            )
        }
        
        @inlinable
        func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
            throw DecodingError.dataCorruptedError(
                forKey: key,
                in: self,
                debugDescription: "CSV decoding does not support nested unkeyed containers"
            )
        }
        
        @inlinable
        func superDecoder(forKey key: Key) throws -> Decoder {
            fatalError()
        }
        
        
        @inlinable
        func superDecoder() throws -> Decoder {
            fatalError()
        }
        
        
    }
}
