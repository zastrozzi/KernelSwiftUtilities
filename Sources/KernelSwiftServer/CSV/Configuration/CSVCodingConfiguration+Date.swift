//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 13/05/2023.
//

import Foundation
import Vapor
import Collections

extension KernelCSV.CSVCodingConfiguration {
    public struct DateCodingStrategy: Codable, Equatable, Sendable {
        
        
        public let formatting: Format
        public let numericStrategy: NumericCodingStrategy
        public let dateFormat: String
        public let iso8601FormatOptions: [CustomISO8601FormatOptions]
        
        private let dateElementSeparator: UInt8.UTF8Grapheme?
        private let timeElementSeparator: UInt8.UTF8Grapheme?
        private let expectedByteLength: Int
        private let yearBytes: ClosedRange<Int>?
        private let monthBytes: ClosedRange<Int>?
        private let dayBytes: ClosedRange<Int>?
        private let hourBytes: ClosedRange<Int>?
        private let minuteBytes: ClosedRange<Int>?
        private let secondBytes: ClosedRange<Int>?
        private let millisecondBytes: ClosedRange<Int>?
//        internal lazy var customFormatter: DateFormatter = {
//            let formatter: DateFormatter = .init()
//            if let customDateFormat {
//                formatter.dateFormat = customDateFormat
//            } else {
//                formatter.isLenient = true
//            }
//            return formatter
//        }()
        
        public init(
            formatting: Format,
            numericStrategy: NumericCodingStrategy? = nil,
            dateFormat: String? = nil,
            iso8601FormatOptions: [CustomISO8601FormatOptions]? = nil
        ) {
            self.formatting = formatting
            self.numericStrategy = numericStrategy ?? .defaultStrategy
            self.iso8601FormatOptions = iso8601FormatOptions ?? []
            let _dateFormat: String
            let _dateElementSeparator: UInt8.UTF8Grapheme?
            let _timeElementSeparator: UInt8.UTF8Grapheme?
            let _expectedByteLength: Int
            let _yearBytes: ClosedRange<Int>?
            let _monthBytes: ClosedRange<Int>?
            let _dayBytes: ClosedRange<Int>?
            let _hourBytes: ClosedRange<Int>?
            let _minuteBytes: ClosedRange<Int>?
            let _secondBytes: ClosedRange<Int>?
            let _millisecondBytes: ClosedRange<Int>?
            switch formatting {
            case .custom:
                _dateFormat = dateFormat ?? ""
                let safeFormat = _dateFormat.replacingOccurrences(of: "'", with: "")
                _expectedByteLength = safeFormat.count
                if let yStart = safeFormat.firstIndex(of: "y"), let yEnd = safeFormat.lastIndex(of: "y") {
                    _yearBytes = safeFormat.distance(from: safeFormat.startIndex, to: yStart)...safeFormat.distance(from: safeFormat.startIndex, to: yEnd)
                } else { _yearBytes = nil }
                if let mStart = safeFormat.firstIndex(of: "M"), let mEnd = safeFormat.lastIndex(of: "M") {
                    _monthBytes = safeFormat.distance(from: safeFormat.startIndex, to: mStart)...safeFormat.distance(from: safeFormat.startIndex, to: mEnd)
                } else { _monthBytes = nil }
                if let dStart = safeFormat.firstIndex(of: "d"), let dEnd = safeFormat.lastIndex(of: "d") {
                    _dayBytes = safeFormat.distance(from: safeFormat.startIndex, to: dStart)...safeFormat.distance(from: safeFormat.startIndex, to: dEnd)
                } else { _dayBytes = nil }
                if let hStart = safeFormat.firstIndex(of: "H"), let hEnd = safeFormat.lastIndex(of: "H") {
                    _hourBytes = safeFormat.distance(from: safeFormat.startIndex, to: hStart)...safeFormat.distance(from: safeFormat.startIndex, to: hEnd)
                } else { _hourBytes = nil }
                if let minStart = safeFormat.firstIndex(of: "m"), let minEnd = safeFormat.lastIndex(of: "m") {
                    _minuteBytes = safeFormat.distance(from: safeFormat.startIndex, to: minStart)...safeFormat.distance(from: safeFormat.startIndex, to: minEnd)
                } else { _minuteBytes = nil }
                if let sStart = safeFormat.firstIndex(of: "s"), let sEnd = safeFormat.lastIndex(of: "s") {
                    _secondBytes = safeFormat.distance(from: safeFormat.startIndex, to: sStart)...safeFormat.distance(from: safeFormat.startIndex, to: sEnd)
                } else { _secondBytes = nil }
                if let msStart = safeFormat.firstIndex(of: "S"), let msEnd = safeFormat.lastIndex(of: "S") {
                    _millisecondBytes = safeFormat.distance(from: safeFormat.startIndex, to: msStart)...safeFormat.distance(from: safeFormat.startIndex, to: msEnd)
                } else { _millisecondBytes = nil }
                if let _yearBytes, let _monthBytes, let _dayBytes {
                    let mid1 = safeFormat[safeFormat.index(safeFormat.startIndex, offsetBy: min(_yearBytes.upperBound, _monthBytes.upperBound, _dayBytes.upperBound) + 1)]
                    let mid2 = safeFormat[safeFormat.index(safeFormat.startIndex, offsetBy: [_yearBytes.upperBound, _monthBytes.upperBound, _dayBytes.upperBound].sorted()[1] + 1)]
                    guard mid1 == mid2 else { fatalError("Mismatched delimiters")}
                    _dateElementSeparator = .oneByte(mid1.asciiValue!)
                } else { _dateElementSeparator = nil }
                
                if let _hourBytes, let _minuteBytes, let _secondBytes {
                    let mid1 = safeFormat[safeFormat.index(safeFormat.startIndex, offsetBy: min(_hourBytes.upperBound, _minuteBytes.upperBound, _secondBytes.upperBound) + 1)]
                    let mid2 = safeFormat[safeFormat.index(safeFormat.startIndex, offsetBy: [_hourBytes.upperBound, _minuteBytes.upperBound, _secondBytes.upperBound].sorted()[1] + 1)]
                    guard mid1 == mid2 else { fatalError("Mismatched delimiters")}
                    _timeElementSeparator = .oneByte(mid1.asciiValue!)
                } else { _timeElementSeparator = nil }
                let ranges = [_yearBytes, _monthBytes, _dayBytes, _hourBytes, _minuteBytes, _secondBytes, _millisecondBytes].compactMap { $0 }
                ranges.forEach { range in
                    guard ranges.filter({ $0 != range }).allSatisfy({ cand in !cand.overlaps(range) }) else { fatalError("Overlapping ranges!") }
                }
                
                
            case .iso8601:
                _dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                _dateElementSeparator = .oneByte(.ascii.hyphen)
                _timeElementSeparator = .oneByte(.ascii.colon)
                _expectedByteLength = 20
                _yearBytes = 0...3
                _monthBytes = 5...6
                _dayBytes = 8...9
                _hourBytes = 11...12
                _minuteBytes = 14...15
                _secondBytes = 17...18
                _millisecondBytes = nil
            case .iso8601DateOnly:
                _dateFormat = "yyyy-MM-dd"
                _dateElementSeparator = .oneByte(.ascii.hyphen)
                _timeElementSeparator = nil
                _expectedByteLength = 10
                _yearBytes = 0...3
                _monthBytes = 5...6
                _dayBytes = 8...9
                _hourBytes = nil
                _minuteBytes = nil
                _secondBytes = nil
                _millisecondBytes = nil
            case .millisecondsSince1970:
                _dateFormat = "SSSSSSSSSSSSS"
                _dateElementSeparator = nil
                _timeElementSeparator = nil
                _expectedByteLength = 13
                _yearBytes = nil
                _monthBytes = nil
                _dayBytes = nil
                _hourBytes = nil
                _minuteBytes = nil
                _secondBytes = nil
                _millisecondBytes = 0...12
            case .secondsSince1970:
                _dateFormat = "ssssssssss"
                _dateElementSeparator = nil
                _timeElementSeparator = nil
                _expectedByteLength = 10
                _yearBytes = nil
                _monthBytes = nil
                _dayBytes = nil
                _hourBytes = nil
                _minuteBytes = nil
                _secondBytes = nil
                _millisecondBytes = 0...9
            case .customISO8601:
                fatalError("Not Implemented")
            }
            
            self.dateFormat = _dateFormat
            self.dateElementSeparator = _dateElementSeparator
            self.timeElementSeparator = _timeElementSeparator
            self.expectedByteLength = _expectedByteLength
            self.yearBytes = _yearBytes
            self.monthBytes = _monthBytes
            self.dayBytes = _dayBytes
            self.hourBytes = _hourBytes
            self.minuteBytes = _minuteBytes
            self.secondBytes = _secondBytes
            self.millisecondBytes = _millisecondBytes
        }
        
        public enum CodingKeys: CodingKey {
            case formatting
            case numericStrategy
            case dateFormat
            case iso8601FormatOptions
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let _formatting: Format = try container.decode(Format.self, forKey: .formatting)
            let _numericStrategy: NumericCodingStrategy? = try container.decodeIfPresent(NumericCodingStrategy.self, forKey: .numericStrategy)
            let _dateFormat: String? = try container.decodeIfPresent(String.self, forKey: .dateFormat)
            let _iso8601FormatOptions: [CustomISO8601FormatOptions]? = try container.decodeIfPresent([CustomISO8601FormatOptions].self, forKey: .iso8601FormatOptions)
            self.init(
                formatting: _formatting,
                numericStrategy: _numericStrategy,
                dateFormat: _dateFormat,
                iso8601FormatOptions: _iso8601FormatOptions
            )
            
        }
        
        
        public static let defaultStrategy: DateCodingStrategy = .init(formatting: .iso8601, numericStrategy: .defaultStrategy)
        
        public static func == (lhs: KernelCSV.CSVCodingConfiguration.DateCodingStrategy, rhs: KernelCSV.CSVCodingConfiguration.DateCodingStrategy) -> Bool {
            lhs.formatting == rhs.formatting &&
            lhs.dateFormat == rhs.dateFormat &&
            lhs.iso8601FormatOptions == rhs.iso8601FormatOptions
        }
        
        public func bytes(from date: Date) -> [UInt8] {
            switch self.formatting {
            case .secondsSince1970:
                let seconds: Int32 = .init(date.timeIntervalSince1970.rounded())
                let numericStrategy = numericStrategy
                return numericStrategy.bytes(from: seconds)
            case .millisecondsSince1970:
                let milliseconds: Int64 = .init((date.timeIntervalSince1970 * 1000.0).rounded())
                let numericStrategy = numericStrategy
                return numericStrategy.bytes(from: milliseconds)
            case .iso8601: return DateFormatter.iso8601NoTimeZone.string(from: date).utf8Bytes
            default: fatalError("Unsupported DateFormattingStyle: \(self.formatting)")
//            case .iso8601DateOnly: return DateFormatter.noTime.string(from: date).utf8Bytes
//            case .custom:
//                let formatter: DateFormatter = .init()
//                if let customDateFormat {
//                    formatter.dateFormat = customDateFormat
//                } else {
//                    formatter.isLenient = true
//                }
//
//                return formatter.string(from: date).utf8Bytes
//            case .customISO8601:
//                let formatter: ISO8601DateFormatter = .init()
//                if let customISO8601FormatOptions {
//                    formatter.formatOptions = .init(customISO8601FormatOptions.map { $0.asOptionSetValue() })
//                } else {
//                    formatter.formatOptions = [.withInternetDateTime, .withColonSeparatorInTime, .withColonSeparatorInTimeZone]
//                }
//                return formatter.string(from: date).utf8Bytes
            }
        }
        
        public mutating func decodeDate(from bytes: Deque<UInt8>) throws -> Date {
//            let bytes = Array(bytes).copyBytes()
//            guard primitive.self is PrimitiveValue.Type else { throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Could not decode Date from CSV bytes '\(bytes)'")) }
//            fatalError()
//            return .now
            switch self.formatting {
            case .secondsSince1970:
                let numericStrategy = numericStrategy
                guard let seconds: Int32 = try? numericStrategy.decodeInt32(from: bytes) else {
                    throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Could not decode Date from CSV bytes '\(bytes)' using secondsSince1970 strategy"))
                }
                return Date(timeIntervalSince1970: .init(seconds))
            case .millisecondsSince1970:
                let numericStrategy = numericStrategy
                guard let milliseconds: Int64 = try? numericStrategy.decodeInt64(from: bytes) else {
                    throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Could not decode Date from CSV bytes '\(bytes)' using millisecondsSince1970 strategy"))
                }
                return Date(timeIntervalSince1970: .init(milliseconds) / 1000.0)
            case .iso8601:
                guard let date = DateFormatter.iso8601NoTimeZone.date(from: String(utf8EncodedBytes: bytes)) else {
                    throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Could not decode Date from CSV bytes '\(bytes)' using iso8601 strategy"))
                }
                return date
            case .iso8601DateOnly:
                guard let date = DateFormatter.iso8601NoTime.date(from: String(utf8EncodedBytes: bytes)) else {
                    throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Could not decode Date from CSV bytes '\(bytes)' using iso8601DateOnly strategy"))
                }
                return date
            default:
                throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Could not decode Date from CSV bytes '\(bytes)' using unknown strategy"))
//            case .custom:
//                let formatStyle = Date.FormatStyle().day().month().year()
//                guard let date = try? Date(String(utf8EncodedBytes: bytes), strategy: formatStyle) else {
//                    throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Could not decode Date from CSV bytes '\(bytes)' using custom strategy formatter \(customDateFormat ?? "")"))
//                }
//                let formatter: DateFormatter = .init()
//                if let customDateFormat {
//                    formatter.dateFormat = customDateFormat
//                } else {
//                    formatter.isLenient = true
//                }
//                guard let date = formatter.date(from: String(utf8EncodedBytes: bytes)) else {
//                    throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Could not decode Date from CSV bytes '\(bytes)' using custom strategy formatter \(formatter)"))
//                }
//                return date
//            case .customISO8601:
//                let formatter: ISO8601DateFormatter = .init()
//                if let customISO8601FormatOptions {
//                    formatter.formatOptions = .init(customISO8601FormatOptions.map { $0.asOptionSetValue() })
//                } else {
//                    formatter.formatOptions = [.withInternetDateTime, .withColonSeparatorInTime, .withColonSeparatorInTimeZone]
//                }
//                guard let date = formatter.date(from: String(utf8EncodedBytes: bytes)) else {
//                    throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Could not decode Date from CSV bytes '\(bytes)' using custom strategy formatter \(formatter)"))
//                }
//                return date
            }
        }
        
        
    }
}

extension KernelCSV.CSVCodingConfiguration.DateCodingStrategy {
    public enum Format: String, Codable, Equatable, CaseIterable, OpenAPIStringEnumSampleable, Sendable {
        case secondsSince1970 = "secondsSince1970"
        case millisecondsSince1970 = "millisecondsSince1970"
        case iso8601 = "iso8601"
        case iso8601DateOnly = "iso8601DateOnly"
        case custom = "custom"
        case customISO8601 = "customISO8601"
    }
    
    public enum CustomISO8601FormatOptions: String, Codable, Equatable, CaseIterable, OpenAPIStringEnumSampleable, OpenAPIEncodableSampleable, Sendable {
        
        
        case withYear = "withYear"
        case withMonth = "withMonth"
        case withWeekOfYear = "withWeekOfYear"
        case withDay = "withDay"
        case withTime = "withTime"
        case withTimeZone = "withTimeZone"
        case withSpaceBetweenDateAndTime = "withSpaceBetweenDateAndTime"
        case withDashSeparatorInDate = "withDashSeparatorInDate"
        case withColonSeparatorInTime = "withColonSeparatorInTime"
        case withColonSeparatorInTimeZone = "withColonSeparatorInTimeZone"
        case withFractionalSeconds = "withFractionalSeconds"
        case withFullDate = "withFullDate"
        case withFullTime = "withFullTime"
        case withInternetDateTime = "withInternetDateTime"
        
        public func asOptionSetValue() -> ISO8601DateFormatter.Options {
            switch self {
            case .withYear: return .withYear
            case .withMonth: return .withMonth
            case .withWeekOfYear: return .withWeekOfYear
            case .withDay: return .withDay
            case .withTime: return .withTime
            case .withTimeZone: return .withTimeZone
            case .withSpaceBetweenDateAndTime: return .withSpaceBetweenDateAndTime
            case .withDashSeparatorInDate: return .withDashSeparatorInDate
            case .withColonSeparatorInTime: return .withColonSeparatorInTime
            case .withColonSeparatorInTimeZone: return .withColonSeparatorInTimeZone
            case .withFractionalSeconds: return .withFractionalSeconds
            case .withFullDate: return .withFullDate
            case .withFullTime: return .withFullTime
            case .withInternetDateTime: return .withInternetDateTime
            }
        }
        
        public static let sample: KernelCSV.CSVCodingConfiguration.DateCodingStrategy.CustomISO8601FormatOptions = .withDay
        public static let samples: [KernelCSV.CSVCodingConfiguration.DateCodingStrategy.CustomISO8601FormatOptions] = [.withColonSeparatorInTime, .withColonSeparatorInTimeZone]
    }
}
