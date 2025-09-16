//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 18/06/2025.
//

import Foundation

extension KernelXML {
    public struct DateBox: Equatable {
        public typealias Value = Date
        
        public let value: Value
        public let format: Format
        
        public init(_ value: Value, format: Format) {
            self.value = value
            self.format = format
        }
        
        public init?(secondsSince1970 string: String) {
            guard let seconds = TimeInterval(string) else {
                return nil
            }
            let value = Date(timeIntervalSince1970: seconds)
            self.init(value, format: .secondsSince1970)
        }
        
        public init?(millisecondsSince1970 string: String) {
            guard let milliseconds = TimeInterval(string) else {
                return nil
            }
            let value = Date(timeIntervalSince1970: milliseconds / 1000.0)
            self.init(value, format: .millisecondsSince1970)
        }
        
        public init?(iso8601 string: String) {
            if #available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *) {
                guard let value = iso8601Formatter.date(from: string) else {
                    return nil
                }
                self.init(value, format: .iso8601)
            } else {
                fatalError("ISO8601DateFormatter is unavailable on this platform.")
            }
        }
        
        public init?(xmlString: String, formatter: DateFormatter) {
            guard let date = formatter.date(from: xmlString) else {
                return nil
            }
            self.init(date, format: .formatter(formatter))
        }
        
        public func xmlString(format: Format) -> String {
            switch format {
            case .secondsSince1970:
                let seconds = value.timeIntervalSince1970
                return seconds.description
            case .millisecondsSince1970:
                let milliseconds = value.timeIntervalSince1970 * 1000.0
                return milliseconds.description
            case .iso8601:
                if #available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *) {
                    return iso8601Formatter.string(from: self.value)
                } else {
                    fatalError("ISO8601DateFormatter is unavailable on this platform.")
                }
            case let .formatter(formatter):
                return formatter.string(from: value)
            }
        }
    }
}

extension KernelXML.DateBox {
    public enum Format: Equatable {
        case secondsSince1970
        case millisecondsSince1970
        case iso8601
        case formatter(DateFormatter)
    }
}

extension KernelXML.DateBox: KernelXML.Boxable {
    public var isNull: Bool { false }
    public var xmlString: String? { xmlString(format: format) }
}

extension KernelXML.DateBox: KernelXML.SimpleBoxable {}

extension KernelXML.DateBox: CustomStringConvertible {
    public var description: String { value.description }
}
