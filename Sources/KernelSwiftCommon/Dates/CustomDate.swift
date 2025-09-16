//
//  File.swift
//
//
//  Created by Jonathan Forbes on 29/03/2022.
//

import Foundation

public struct CustomDate<E: HasDateFormatter>: Codable {
    public let value: Date
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let text = try container.decode(String.self)
        guard let date = E.dateFormatter.date(from: text) else {
            throw CustomDateError.general
        }
        self.value = date
    }
    
    public init(from dateToFormat: Date) throws {
        let dateString = E.dateFormatter.string(from: dateToFormat)
        guard let date = E.dateFormatter.date(from: dateString) else {
            throw CustomDateError.general
        }
        self.value = date
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let date = E.dateFormatter.string(from: value)
        try container.encode(date)
    }
    
    public enum CustomDateError: Error {
        case general
    }
    
    static var defaultFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }
}

public struct iso86021DateOnly: HasDateFormatter {
    public static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
}
