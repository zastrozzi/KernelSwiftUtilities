//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 23/05/2023.
//

import Foundation

extension KernelCSV.CSVDecoder {
    internal final class AsynchronousSingleValueDecoder: SingleValueDecodingContainer {
        var codingPath: [CodingKey]
        var decoder: AsynchronousDecoder
        var bytes: [UInt8]

        internal init(path: [CodingKey], decoder: AsynchronousDecoder) throws {
            self.decoder = decoder
            self.codingPath = path

            guard case let .bytes(bytes) = decoder.data else {
                throw DecodingError.dataCorrupted(.init(
                    codingPath: path,
                    debugDescription: "Single value required to create a single value decoder"
                ))
            }
            self.bytes = bytes
        }

        func decodeNil() -> Bool {
            fatalError()
//            return self.decoder.configuration.nilStrategyForKey(codingPath.last!).isNil(self.bytes)
        }

        func decode(_ type: Bool.Type) throws -> Bool {
            fatalError()
//            return try self.decoder.configuration.strategyForKey(codingPath.last!, type: .boolean, isNullable: false).decodeBool(from: self.bytes)
        }

        func decode(_ type: String.Type) throws -> String {
            fatalError()
//            return try self.decoder.configuration.strategyForKey(codingPath.last!, type: .string, isNullable: false).decodeString(from: self.bytes)
        }
        
        func decode(_ type: UUID.Type) throws -> UUID {
            fatalError()
//            return try self.decoder.configuration.strategyForKey(codingPath.last!, type: .uuid, isNullable: false).decodeUUID(from: self.bytes)
        }
        
        func decode(_ type: Date.Type) throws -> Date {
            fatalError()
//            return try self.decoder.configuration.strategyForKey(codingPath.last!, type: .date, isNullable: false).decodeDate(from: self.bytes)
        }

        func decode(_ type: Double.Type) throws -> Double {
            fatalError()
//            return try self.decoder.configuration.strategyForKey(codingPath.last!, type: .number, isNullable: false).decodeDouble(from: self.bytes)
        }

        func decode(_ type: Float.Type) throws -> Float {
            fatalError()
//            return try self.decoder.configuration.strategyForKey(codingPath.last!, type: .number, isNullable: false).decodeFloat(from: self.bytes)
        }

        func decode(_ type: Int.Type) throws -> Int {
            fatalError()
//            return try self.decoder.configuration.strategyForKey(codingPath.last!, type: .number, isNullable: false).decodeInt(from: self.bytes)
        }
        
        func decode(_ type: Int8.Type) throws -> Int8 {
            fatalError()
//            return try self.decoder.configuration.strategyForKey(codingPath.last!, type: .number, isNullable: false).decodeInt8(from: self.bytes)
        }
        
        func decode(_ type: Int16.Type) throws -> Int16 {
            fatalError()
//            return try self.decoder.configuration.strategyForKey(codingPath.last!, type: .number, isNullable: false).decodeInt16(from: self.bytes)
        }
        
        func decode(_ type: Int32.Type) throws -> Int32 {
            fatalError()
//            return try self.decoder.configuration.strategyForKey(codingPath.last!, type: .number, isNullable: false).decodeInt32(from: self.bytes)
        }
        
        func decode(_ type: Int64.Type) throws -> Int64 {
            fatalError()
//            return try self.decoder.configuration.strategyForKey(codingPath.last!, type: .number, isNullable: false).decodeInt64(from: self.bytes)
        }
        
        func decode(_ type: UInt.Type) throws -> UInt {
            fatalError()
//            return try self.decoder.configuration.strategyForKey(codingPath.last!, type: .number, isNullable: false).decodeUInt(from: self.bytes)
        }
        
        func decode(_ type: UInt8.Type) throws -> UInt8 {
            fatalError()
//            return try self.decoder.configuration.strategyForKey(codingPath.last!, type: .number, isNullable: false).decodeUInt8(from: self.bytes)
        }
        
        func decode(_ type: UInt16.Type) throws -> UInt16 {
            fatalError()
//            return try self.decoder.configuration.strategyForKey(codingPath.last!, type: .number, isNullable: false).decodeUInt16(from: self.bytes)
        }
        
        func decode(_ type: UInt32.Type) throws -> UInt32 {
            fatalError()
//            return try self.decoder.configuration.strategyForKey(codingPath.last!, type: .number, isNullable: false).decodeUInt32(from: self.bytes)
        }
        
        func decode(_ type: UInt64.Type) throws -> UInt64 {
            fatalError()
//            return try self.decoder.configuration.strategyForKey(codingPath.last!, type: .number, isNullable: false).decodeUInt64(from: self.bytes)
        }

        func decode<T>(_ type: T.Type) throws -> T where T : Decodable, T: Sendable {
            let decoder = AsynchronousDecoder(
                decoding: self.decoder.decoding,
                path: self.codingPath,
                data: .bytes(self.bytes),
                configuration: self.decoder.configuration,
                decodedObjectHandler: self.decoder.decodedObjectHandler
            )

            let t = try T.init(from: decoder)
            return t
        }
    }
}
