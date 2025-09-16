//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 15/05/2023.
//

import Foundation

extension Date {
    public static let ticksAt1970: Int64 = 621_355_968_000_000_000
    public static let ticksPerSecond: Double = 10_000_000
    
    public static let ticksMinValue: Int64 = 0
    public static let ticksMaxValue: Int64 = 3_155_378_975_999_999_999
    
    public init(ticks: Int64) {
        if ticks == Date.ticksMinValue { self = Date.distantPast }
        else if ticks == Date.ticksMaxValue { self = Date.distantFuture }
        else {
            let dateSeconds = Double(ticks - Date.ticksAt1970) / Date.ticksPerSecond
            self.init(timeIntervalSince1970: dateSeconds)
        }
    }
    
    public func ticks() -> Int64 {
        if self == Date.distantPast { return Date.ticksMinValue }
        if self == Date.distantFuture { return Date.ticksMaxValue }
        let ticksSince1970 = Int64(round(self.timeIntervalSince1970 * Date.ticksPerSecond))
        return Date.ticksAt1970 &+ ticksSince1970
    }
}

extension Date {
    public static let millisecondsAt1970: Int64 = 62_135_596_800_000
    public static let millisecondsPerSecond: Double = 1_000
    
    public static let millisecondsMinValue: Int64 = 0
    public static let millisecondsMaxValue: Int64 = 3_155_378_975_999_999
    
    public init(milliseconds: Int64) {
        if milliseconds == Date.millisecondsMinValue { self = Date.distantPast }
        else if milliseconds == Date.millisecondsMaxValue { self = Date.distantFuture }
        else {
            let dateSeconds = Double(milliseconds - Date.millisecondsAt1970) / Date.millisecondsPerSecond
            self.init(timeIntervalSince1970: dateSeconds)
        }
    }
    
    public func millisecondsSince1970() -> Int64 {
        if self == Date.distantPast { return Date.millisecondsMinValue }
        if self == Date.distantFuture { return Date.millisecondsMaxValue }
        let millisecondsSince1970 = Int64(round(self.timeIntervalSince1970 * Date.millisecondsPerSecond))
        return millisecondsSince1970
    }
}
