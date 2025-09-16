//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 09/05/2023.
//

import Foundation
import Vapor
import KernelSwiftCommon

extension DateFormatter {
    public static let dayFirstNoTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    public static let dayFirstNoTimeNoSlash: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy"
        return formatter
    }()
    
    public static let iso8601NoTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    public static let rfc2822: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        return formatter
    }()
    
    public static let iso8601NoTimeZoneSpaced: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    public static let iso8601NoTimeZoneMissingZ: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter
    }()
//
//    public static var utcTime: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "YYMMDDhhmm"
//    }
    
    nonisolated(unsafe) public static let iso8601NoTimeZone: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()
    
    nonisolated(unsafe) public static let iso8601InternetTimeZone: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withColonSeparatorInTime, .withColonSeparatorInTimeZone]
        return formatter
    }()
    
    nonisolated(unsafe) public static let iso8601FractionalInternetTimeZone: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withColonSeparatorInTime, .withColonSeparatorInTimeZone, .withFractionalSeconds]
        return formatter
    }()
}

extension JSONDecoder.DateDecodingStrategy {
    public static var flexible: Self {
        .custom( { (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            if let dateStr = try? container.decode(String.self) {
                let length = dateStr.count
                var date: Date? = nil
                if length == 10 {
                    if dateStr.contains("/") { date = DateFormatter.dayFirstNoTime.date(from: dateStr) }
                    else { date = DateFormatter.iso8601NoTime.date(from: dateStr) }
                } else if length == 19 {
                    if dateStr.contains("T") {
                        date = DateFormatter.iso8601NoTimeZoneMissingZ.date(from: dateStr)
                    } else {
                        date = DateFormatter.iso8601NoTimeZoneSpaced.date(from: dateStr)
                    }
                } else if length == 20 {
                    date = DateFormatter.iso8601NoTimeZone.date(from: dateStr)
                } else if length == 25 {
                    date = DateFormatter.iso8601InternetTimeZone.date(from: dateStr)
                } else if length == 31 {
                    date = DateFormatter.rfc2822.date(from: dateStr)
                } else {
                    date = DateFormatter.iso8601FractionalInternetTimeZone.date(from: dateStr)
                }
                guard let formattedDate = date else {
                    throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode \(dateStr)")
                }
                return formattedDate
            }
            if let dateInt = try? container.decode(Int.self) {
                if dateInt > 9999999999 {
                    return Date(timeIntervalSince1970: Double(dateInt) / 1000)
                }
                return Date(timeIntervalSince1970: Double(dateInt))
            }
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date")
        })
    }
}

extension URLEncodedFormDecoder.Configuration.DateDecodingStrategy {
    public static var flexible: Self {
        .custom( { (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)
            let length = dateStr.count
            var date: Date? = nil
            if length == 10 {
                date = DateFormatter.iso8601NoTime.date(from: dateStr)
            } else if length == 19 {
                date = DateFormatter.iso8601NoTimeZoneSpaced.date(from: dateStr)
            } else if length == 20 {
                date = DateFormatter.iso8601NoTimeZone.date(from: dateStr)
            } else if length == 25 {
                date = DateFormatter.iso8601InternetTimeZone.date(from: dateStr)
            } else if length == 31 {
                date = DateFormatter.rfc2822.date(from: dateStr)
            } else {
                date = DateFormatter.iso8601FractionalInternetTimeZone.date(from: dateStr)
            }
            guard let formattedDate = date else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode \(dateStr)")
            }
            return formattedDate
        })
    }
}
