//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 12/06/2024.
//

import FluentKit


extension DatabaseQuery.Value {
    public struct EnumValue: Codable {
        public var caseName: String
        
        public init(
            caseName: String
        ) {
            self.caseName = caseName
        }
    }
    
    public struct BindValue: Encodable, Decodable, @unchecked Sendable {
        public var value: any Encodable & Sendable
        
        public init(
            value: any Encodable & Sendable
        ) {
            self.value = value
        }
        
        public func encode(to encoder: Encoder) throws {
            try value.encode(to: encoder)
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            self.value = try container.decode(AnyJSONCodable.self) as any Encodable & Sendable
        }
    }
}

extension DatabaseQuery.Value: @retroactive Codable {
    public func encode(to encoder: Encoder) throws {
        switch self {
        case .bind(let bind):
            try BindValue(value: bind).encode(to: encoder)
        case .array(let array):
            try array.encode(to: encoder)
        case .dictionary(let dictionary):
            try dictionary.reduce(into: [:]) { $0[$1.key.description] = $1.value }.encode(to: encoder)
        case .enumCase(let enumCase):
            try EnumValue(caseName: enumCase).encode(to: encoder)
        case .default:
            try String("__default").encode(to: encoder)
        default:
            var container = encoder.singleValueContainer()
            try container.encodeNil()
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let array = try? container.decode([DatabaseQuery.Value].self) {
            self = .array(array)
        } else if let dictionary = try? container.decode([String: DatabaseQuery.Value].self) {
            self = .dictionary(dictionary.reduce(into: [:]) { $0[FieldKey(stringLiteral: $1.key)] = $1.value })
        } else if let enumCase = try? container.decode(EnumValue.self) {
            self = .enumCase(enumCase.caseName)
        } else if let string = try? container.decode(String.self), string == "__default" {
            self = .default
        } else if container.decodeNil() {
            self = .null
        } else if let bind = try? container.decode(BindValue.self) {
            self = .bind(bind.value)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid DatabaseQuery.Value")
        }
    }
}

extension DatabaseQuery.Value: @retroactive Equatable {
    public static func == (lhs: DatabaseQuery.Value, rhs: DatabaseQuery.Value) -> Bool {
        switch (lhs, rhs) {
        case (.bind(let l), .bind(let r)):
            do {
                return try l.encoded(.init()) == r.encoded(.init())
            } catch {
                return false
            }
        case (.array(let l), .array(let r)):
            return l == r
        case (.dictionary(let l), .dictionary(let r)):
            return l == r
        case (.enumCase(let l), .enumCase(let r)):
            return l == r
        case (.default, .default):
            return true
        default:
            return false
        }
    }
}

