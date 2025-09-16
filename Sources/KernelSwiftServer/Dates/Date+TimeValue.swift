//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 06/02/2025.
//

import Vapor
import Fluent
import PostgresKit

extension Date {
    public struct TimeValue: Codable, PostgresNonThrowingEncodable, PostgresDecodable, CustomStringConvertible, Hashable, Sendable, OpenAPIEncodableSampleable, RawOpenAPISchemaType {
        public static let psqlFormat: PostgresNIO.PostgresFormat = .binary
        public static let psqlType: PostgresNIO.PostgresDataType = .time
        
        let microseconds: Int64
        
        init(microseconds: Int64) {
            self.microseconds = microseconds
        }
        
//        public init(from decoder: any Decoder) throws {
//            self.init(microseconds: try decoder.singleValueContainer().decode(Int64.self))
//        }
        init(string: String) {
            let hmsComponents = string.split(separator: ":")
            guard hmsComponents.count == 3 else {
                self.init(microseconds: 0)
                return
                //                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Invalid time format \(string)"))
            }
            let hours = Int64(hmsComponents[0]) ?? 0
            let minutes = Int64(hmsComponents[1]) ?? 0
            let secondsAndFractionalPart = hmsComponents[2].split(separator: ".")
            let seconds = Int64(secondsAndFractionalPart[0]) ?? 0
            let microseconds: Int64 = secondsAndFractionalPart.count > 1 ? (Int64(secondsAndFractionalPart[1]) ?? 0) : 0
            
            let fullMicroseconds = (hours * 3_600_000_000) + (minutes * 60_000_000) + (seconds * 1_000_000) + microseconds
            self.init(microseconds: fullMicroseconds)
        }
        
        public init(
            from buffer: inout ByteBuffer, type: PostgresDataType, format: PostgresFormat,
            context: PostgresDecodingContext<some PostgresJSONDecoder>
        ) throws {
            switch type {
            case .timetz, .time:
                guard let value = buffer.readInteger(as: Int64.self) else { throw PostgresDecodingError.Code.missingData }
                self.microseconds = value
            default:
                throw PostgresDecodingError.Code.typeMismatch
            }
        }
        
        public init(from decoder: any Decoder) throws {
            self.init(string: try decoder.singleValueContainer().decode(String.self))
        }
        
        
        public func encode(to encoder: Encoder) throws {
            let hours   =     "0\(self.microseconds / 3_600_000_000)".suffix(2),
                minutes =     "0\(self.microseconds % 3_600_000_000 / 60_000_000)".suffix(2),
                seconds =     "0\(self.microseconds % 3_600_000_000 % 60_000_000 / 1_000_000)".suffix(2),
                us      = "00000\(self.microseconds % 3_600_000_000 % 60_000_000 % 1_000_000)".suffix(6),
                string  = "\(hours):\(minutes):\(seconds).\(us)"
            
            var container = encoder.singleValueContainer()
            try container.encode(string)
        }
        
        public func encode(into byteBuffer: inout ByteBuffer, context: PostgresEncodingContext<some PostgresJSONEncoder>) {
            byteBuffer.writeInteger(self.microseconds)
        }
        
        public var description: String {
            let hours   =     "0\(self.microseconds / 3_600_000_000)".suffix(2),
                minutes =     "0\(self.microseconds % 3_600_000_000 / 60_000_000)".suffix(2),
                seconds =     "0\(self.microseconds % 3_600_000_000 % 60_000_000 / 1_000_000)".suffix(2),
                us      = "00000\(self.microseconds % 3_600_000_000 % 60_000_000 % 1_000_000)".suffix(6)
            
            return "\(hours):\(minutes):\(seconds).\(us)"
        }
        
        public static func rawOpenAPISchema() throws -> JSONSchema {
            .string
        }
        
        public static var sample: Date.TimeValue { .init(string: "12:00:00.000000") }
        
//        public func toTimeValue() -> TimeValue {
//            return TimeValue(microseconds: self.microseconds)
//        }
    }
    
//    public struct TimeValue: Codable, CustomStringConvertible, Hashable, Sendable, OpenAPIEncodableSampleable, RawOpenAPISchemaType {
//        let microseconds: Int64
//        
//        init(microseconds: Int64) {
//            self.microseconds = microseconds
//        }
//        
//        init(string: String) {
//            let hmsComponents = string.split(separator: ":")
//            guard hmsComponents.count == 3 else {
//                self.init(microseconds: 0)
//                return
//                //                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Invalid time format \(string)"))
//            }
//            let hours = Int64(hmsComponents[0]) ?? 0
//            let minutes = Int64(hmsComponents[1]) ?? 0
//            let secondsAndFractionalPart = hmsComponents[2].split(separator: ".")
//            let seconds = Int64(secondsAndFractionalPart[0]) ?? 0
//            let microseconds: Int64 = secondsAndFractionalPart.count > 1 ? (Int64(secondsAndFractionalPart[1]) ?? 0) : 0
//            
//            let fullMicroseconds = (hours * 3_600_000_000) + (minutes * 60_000_000) + (seconds * 1_000_000) + microseconds
//            self.init(microseconds: fullMicroseconds)
//        }
//        
//        
//
//        
//        public var description: String {
//            let hours   =     "0\(self.microseconds / 3_600_000_000)".suffix(2),
//                minutes =     "0\(self.microseconds % 3_600_000_000 / 60_000_000)".suffix(2),
//                seconds =     "0\(self.microseconds % 3_600_000_000 % 60_000_000 / 1_000_000)".suffix(2),
//                us      = "00000\(self.microseconds % 3_600_000_000 % 60_000_000 % 1_000_000)".suffix(6)
//            
//            return "\(hours):\(minutes):\(seconds).\(us)"
//        }
//        
//        public func forSQL() -> SQLTimeValue {
//            .init(microseconds: microseconds)
//        }
//        
//        public static func rawOpenAPISchema() throws -> JSONSchema {
//            .string
//        }
//        
//        public static var sample: Date.TimeValue { .init(string: "12:00:00.000000") }
//    }
}
