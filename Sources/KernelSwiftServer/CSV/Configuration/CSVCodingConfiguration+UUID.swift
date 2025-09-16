//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 14/05/2023.
//

import Foundation
import Vapor
import Collections

extension KernelCSV.CSVCodingConfiguration {
    public struct UUIDCodingStrategy: Codable, Equatable, Content, OpenAPIEncodableSampleable, Sendable {
        public var version: UUIDVersion
        public var lettercase: Lettercase
        
        public static let defaultStrategy: UUIDCodingStrategy = .init(
            version: .flexible,
            lettercase: .flexible
        )
        
        public init(
            version: UUIDVersion = .flexible,
            lettercase: Lettercase = .flexible
        ) {
            self.version = version
            self.lettercase = lettercase
        }
        
        func uuidASCIINibble(_ nibble: UInt8, lowercase: Bool) throws -> UInt8 {
            switch nibble {
            case 0x0: return .ascii.zero
            case 0x1: return .ascii.one
            case 0x2: return .ascii.two
            case 0x3: return .ascii.three
            case 0x4: return .ascii.four
            case 0x5: return .ascii.five
            case 0x6: return .ascii.six
            case 0x7: return .ascii.seven
            case 0x8: return .ascii.eight
            case 0x9: return .ascii.nine
            case 0xa: return lowercase ? UInt8.ascii.a : UInt8.ascii.A
            case 0xb: return lowercase ? UInt8.ascii.b : UInt8.ascii.B
            case 0xc: return lowercase ? UInt8.ascii.c : UInt8.ascii.C
            case 0xd: return lowercase ? UInt8.ascii.d : UInt8.ascii.D
            case 0xe: return lowercase ? UInt8.ascii.e : UInt8.ascii.E
            case 0xf: return lowercase ? UInt8.ascii.f : UInt8.ascii.F
            default: throw EncodingError.invalidValue(nibble, .init(codingPath: [], debugDescription: "Could not UUID Nibble is out of range 0x0 - 0xf"))
            }
        }

        func convertUInt8ByteToASCII(_ byte: UInt8, lowercase: Bool) throws -> [UInt8] {
            return [
                try uuidASCIINibble(byte >> 4, lowercase: lowercase),
                try uuidASCIINibble(byte & 0xf, lowercase: lowercase)
            ]
        }

        public func bytes(from uuid: UUID) throws -> [UInt8] {
            var byteArray: [UInt8] = try uuid.uuidByteArray.flatMap { try convertUInt8ByteToASCII($0, lowercase: lettercase == .lower ? true : false) }
            byteArray.insert(UInt8.ascii.hyphen, at: 8)
            byteArray.insert(UInt8.ascii.hyphen, at: 13)
            byteArray.insert(UInt8.ascii.hyphen, at: 18)
            byteArray.insert(UInt8.ascii.hyphen, at: 23)

            return byteArray
        }
        
        public func decodeUUID(from bytes: Deque<UInt8>) throws -> UUID {
//            guard primitive.self is PrimitiveValue.Type else { throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Could not decode UUID from CSV bytes '\(bytes)'")) }
            guard bytes.count == 36 else { throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Cannot decode UUID from bytes '\(bytes)'")) }
            return UUID(uuid: (
                UInt8.combineASCIIHexPair(bytes[0], bytes[1]),      UInt8.combineASCIIHexPair(bytes[2], bytes[3]),
                UInt8.combineASCIIHexPair(bytes[4], bytes[5]),      UInt8.combineASCIIHexPair(bytes[6], bytes[7]),
                UInt8.combineASCIIHexPair(bytes[9], bytes[10]),     UInt8.combineASCIIHexPair(bytes[11], bytes[12]),
                UInt8.combineASCIIHexPair(bytes[14], bytes[15]),    UInt8.combineASCIIHexPair(bytes[16], bytes[17]),
                UInt8.combineASCIIHexPair(bytes[19], bytes[20]),    UInt8.combineASCIIHexPair(bytes[21], bytes[22]),
                UInt8.combineASCIIHexPair(bytes[24], bytes[25]),    UInt8.combineASCIIHexPair(bytes[26], bytes[27]),
                UInt8.combineASCIIHexPair(bytes[28], bytes[29]),    UInt8.combineASCIIHexPair(bytes[30], bytes[31]),
                UInt8.combineASCIIHexPair(bytes[32], bytes[33]),    UInt8.combineASCIIHexPair(bytes[34], bytes[35])
            ))
        }
    }
}

extension KernelCSV.CSVCodingConfiguration.UUIDCodingStrategy {
    public enum UUIDVersion: String, Codable, Equatable, CaseIterable, OpenAPIStringEnumSampleable, Sendable {
        case v1 = "v1"
        case v2 = "v2"
        case v3 = "v3"
        case v4 = "v4"
        case v5 = "v5"
        case v6 = "v6"
        case flexible = "flexible"
    }
}

extension KernelCSV.CSVCodingConfiguration.UUIDCodingStrategy {
    public enum Lettercase: String, Codable, Equatable, CaseIterable, OpenAPIStringEnumSampleable, Sendable {
        case lower = "lower"
        case upper = "upper"
        case flexible = "flexible"
    }
}

