//
//  File.swift
//  
//
//  Created by Jimmy Hough Jr on 10/24/23.
//

import Foundation
import KernelSwiftCommon

extension DateFormatter {
    public static var dayFirstNoTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    public static var noTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    //
    //    public static var utcTime: DateFormatter = {
    //        let formatter = DateFormatter()
    //        formatter.dateFormat = "YYMMDDhhmm"
    //    }
    
    public static var iso8601NoTimeZone: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()
    
    public static var iso8601InternetTimeZone: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withColonSeparatorInTime, .withColonSeparatorInTimeZone]
        return formatter
    }()
    
    public static var iso8601FractionalInternetTimeZone: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withColonSeparatorInTime, .withColonSeparatorInTimeZone, .withFractionalSeconds]
        return formatter
    }()
}

