//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/07/2023.
//
import Vapor
import KernelSwiftCommon

extension KernelTaskScheduler.ScheduleBuilder {
    public enum Month: Int, CaseIterable {
        case january = 1
        case february = 2
        case march = 3
        case april = 4
        case may = 5
        case june = 6
        case july = 7
        case august = 8
        case september = 9
        case october = 10
        case november = 11
        case december = 12
        
        public var apiResponse: Response {
            switch self {
            case .january: .january
            case .february: .february
            case .march: .march
            case .april: .april
            case .may: .may
            case .june: .june
            case .july: .july
            case .august: .august
            case .september: .september
            case .october: .october
            case .november: .november
            case .december: .december
            }
        }
        
        public enum Response: String, Codable, Equatable, CaseIterable, RawRepresentableAsString, OpenAPIStringEnumSampleable, Sendable {
            case january
            case february
            case march
            case april
            case may
            case june
            case july
            case august
            case september
            case october
            case november
            case december
        }
    }
    
    public enum Day: ExpressibleByIntegerLiteral, Equatable {
        case first
        case last
        case exact(Int)
        
        public init(integerLiteral value: Int) {
            self = .exact(value)
        }
        
        public var apiResponse: Response {
            switch self {
            case .first: .first
            case .last: .last
            case .exact(let val): .exact(val)
            }
        }
        
        public enum Response: Codable, Equatable, CaseIterable, RawRepresentableAsString, OpenAPIStringEnumSampleable, Sendable {
            case first
            case last
            case exact(Int)
            
            public var rawValue: String {
                switch self {
                case .first: "first"
                case .last: "last"
                case .exact(let val): "\(val)"
                }
            }
            
            public static var allCases: [KernelTaskScheduler.ScheduleBuilder.Day.Response] {
                [.first, .last] + (1...31).map { i in Self.exact(i) }
            }
        }
    }
    
    
    
    public enum Weekday: Int, CaseIterable {
        case sunday = 1
        case monday = 2
        case tuesday = 3
        case wednesday = 4
        case thursday = 5
        case friday = 6
        case saturday = 7
        
        public var apiResponse: Response {
            switch self {
            case .sunday: .sunday
            case .monday: .monday
            case .tuesday: .tuesday
            case .wednesday: .wednesday
            case .thursday: .thursday
            case .friday: .friday
            case .saturday: .saturday
            }
        }
        
        public enum Response: String, Codable, Equatable, CaseIterable, RawRepresentableAsString, OpenAPIStringEnumSampleable, Sendable {
            case sunday
            case monday
            case tuesday
            case wednesday
            case thursday
            case friday
            case saturday
        }
    }
    
    public enum DayPeriod: ExpressibleByStringLiteral, CustomStringConvertible {
        case am
        case pm
        
        public var description: String {
            switch self {
            case .am:
                return "am"
            case .pm:
                return "pm"
            }
        }
        
        init(_ string: String) {
            switch string.lowercased() {
            case "am":
                self = .am
            case "pm":
                self = .pm
            default:
                KernelTaskScheduler.logger.warning("Bad value passed to \(String(describing: Self.self)). Defaulting to 'am'")
                self = .am
            }
        }
        
        public init(stringLiteral value: String) {
            self.init(value)
        }
    }
    
    public struct Hour24: ExpressibleByIntegerLiteral, CustomStringConvertible, Sendable {
        let number: Int
        
        public var description: String {
            switch self.number {
            case 0..<10:
                return "0" + self.number.description
            default:
                return self.number.description
            }
        }
        
        init(_ number: Int) {
//            precondition(number >= 0, "24-hour clock cannot preceed 0")
//            precondition(number < 24, "24-hour clock cannot exceed 24 - received: \(number)")
            self.number = min(max(number, 0), 23)
//            self.number = number
        }
        
        public init(integerLiteral value: Int) {
            self.init(value)
        }
    }
    
    public struct Hour12: ExpressibleByIntegerLiteral, CustomStringConvertible, Sendable {
        let number: Int
        
        public var description: String {
            return self.number.description
        }
        
        init(_ number: Int) {
//            precondition(number > 0, "12-hour clock cannot preceed 1")
//            precondition(number <= 12, "12-hour clock cannot exceed 12")
            self.number = min(max(number, 1), 12)
//            self.number = number
        }
        
        public init(integerLiteral value: Int) {
            self.init(value)
        }
    }
    
    public struct Minute: ExpressibleByIntegerLiteral, CustomStringConvertible, Sendable {
        let number: Int
        
        public var description: String {
            switch self.number {
            case 0..<10:
                return "0" + self.number.description
            default:
                return self.number.description
            }
        }
        
        init(_ number: Int) {
            self.number = min(max(number, 0), 59)
        }
        
        public init(integerLiteral value: Int) {
            self.init(value)
        }
    }
    
    public struct Second: ExpressibleByIntegerLiteral, CustomStringConvertible, Sendable {
        let number: Int
        
        public var description: String {
            switch self.number {
            case 0..<10:
                return "0" + self.number.description
            default:
                return self.number.description
            }
        }
        
        init(_ number: Int) {
            self.number = min(max(number, 0), 59)
        }
        
        public init(integerLiteral value: Int) {
            self.init(value)
        }
    }
    
    public struct Millisecond: ExpressibleByIntegerLiteral, CustomStringConvertible, Sendable {
        let number: Int
        
        public var description: String {
            switch self.number {
            case 0..<10:
                return "00" + self.number.description
            case 10..<100:
                return "0" + self.number.description
            default:
                return self.number.description
            }
        }
        
        init(_ number: Int) {
            self.number = min(max(number, 0), 999)
        }
        
        public init(integerLiteral value: Int) {
            self.init(value)
        }
    }
    
    public enum RepeatInterval: Sendable {
        case hours(Hour24)
        case minutes(Minute)
        case seconds(Second)
        case milliseconds(Millisecond)
        
        public func timeInterval() -> Double {
            switch self {
            case .milliseconds(let milliseconds): Double(milliseconds.number) / 1000
            case .seconds(let seconds): Double(seconds.number)
            case .minutes(let minutes): Double(minutes.number) * 60
            case .hours(let hours): Double(hours.number) * 60 * 60
            }
        }
        
        public var apiResponse: Response {
            switch self {
            case .milliseconds(let milliseconds): .milliseconds(milliseconds)
            case .seconds(let seconds): .seconds(seconds)
            case .minutes(let minutes): .minutes(minutes)
            case .hours(let hours): .hours(hours)
            }
        }
        
        public enum Response: Codable, Equatable, CaseIterable, RawRepresentableAsString, OpenAPIStringEnumSampleable, Sendable {
            case hours(Hour24)
            case minutes(Minute)
            case seconds(Second)
            case milliseconds(Millisecond)
            
            public var rawValue: String {
                switch self {
                case .milliseconds(let milliseconds): "\(milliseconds.number) milliseconds"
                case .seconds(let seconds): "\(seconds.number) seconds"
                case .minutes(let minutes): "\(minutes.number) minutes"
                case .hours(let hours): "\(hours.number) hours"
                }
            }
            
            public static var allCases: [KernelTaskScheduler.ScheduleBuilder.RepeatInterval.Response] {
                [
                    .hours(.init(1)), .hours(.init(23)),
                    .minutes(.init(1)), .minutes(.init(59)),
                    .seconds(.init(1)), .seconds(.init(59)),
                    .milliseconds(.init(1)), .milliseconds(.init(999))
                ]
            }
        }
    }
    
    public struct Time: ExpressibleByStringLiteral, CustomStringConvertible {
        var hour: Hour24
        var minute: Minute
        var second: Second
        
        public var description: String {
            return "\(hour):\(minute):\(second)"
        }
        
        public init(stringLiteral value: String) {
            let parts = value.split(separator: ":")
            let dayPeriodSuffixPM = value.hasSuffix("pm") || value.hasSuffix("PM") || value.hasSuffix("Pm")
            let dayPeriodSuffixAM = value.hasSuffix("am") || value.hasSuffix("AM") || value.hasSuffix("Am")
            let extract: (h: Hour24, m: Minute, s: Second) = switch (parts.count, dayPeriodSuffixAM, dayPeriodSuffixPM) {
            case (..<1, _, _): preconditionFailure("Not enough parts to construct time string")
            case (4..., _, _): preconditionFailure("Too many parts to construct time string")
            case (1, true, false): (h: Int(parts[0].prefix(2)) == 12 ? 0 : .init(Int(parts[0].trimmingCharacters(in: .whitespacesAndNewlines + .letters)) ?? 0), m: 0, s: 0)
            case (1, false, true): (h: Int(parts[0].prefix(2)) == 12 ? 12 : .init((Int(parts[0].trimmingCharacters(in: .whitespacesAndNewlines + .letters)) ?? 0) + 12), m: 0, s: 0)
            case (1, false, false): (h: .init(Int(parts[0]) ?? 0), m: 0, s: 0)
            case (2, true, false): (h: Int(parts[0].prefix(2)) == 12 ? 0 : .init(Int(parts[0]) ?? 0), m: .init(Int(parts[1].prefix(2)) ?? 0), s: 0)
            case (2, false, true): (h: Int(parts[0].prefix(2)) == 12 ? 12 : .init((Int(parts[0]) ?? 0) + 12), m: .init(Int(parts[1].prefix(2)) ?? 0), s: 0)
            case (2, false, false): (h: .init(Int(parts[0]) ?? 0), m: .init(Int(parts[1]) ?? 0), s: 0)
            case (3, true, false): (h: Int(parts[0].prefix(2)) == 12 ? 0 : .init(Int(parts[0]) ?? 0), m: .init(Int(parts[1]) ?? 0), s: .init(Int(parts[2].prefix(2)) ?? 0))
            case (3, false, true): (h: Int(parts[0].prefix(2)) == 12 ? 12 : .init((Int(parts[0]) ?? 0) + 12), m: .init(Int(parts[1]) ?? 0), s: .init(Int(parts[2].prefix(2)) ?? 0))
            case (3, false, false): (h: .init(Int(parts[0]) ?? 0), m: .init(Int(parts[1]) ?? 0), s: .init(Int(parts[2]) ?? 0))
            default: preconditionFailure("Unable to construct time string")
            }
            self.init(extract.h, extract.m, extract.s)
        }
        
        public init(_ hour: Hour24, _ minute: Minute, _ second: Second = 0) {
            self.hour = hour
            self.minute = minute
            self.second = second
        }
        
        public init(_ hour: Hour12, _ minute: Minute, _ second: Second = 0, _ period: DayPeriod) {
            self.hour = switch period {
            case .am: if hour.number == 12 && minute.number == 0 { 0 } else { .init(hour.number) }
            case .pm: if hour.number == 12 { 12 } else { .init(hour.number + 12) }
            }
            self.minute = minute
            self.second = second
        }
    }
}

extension KernelTaskScheduler.ScheduleBuilder {
    public func toAPIResponse() -> APIResponse {
        return .init(
            months: months.map { $0.apiResponse },
            days: days.map { $0.apiResponse },
            weekdays: weekdays.map { $0.apiResponse},
            times: times.map { $0.description },
            repeatIntervals: repeatIntervals.map { $0.apiResponse }
        )
    }
    
    public struct APIResponse: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public let months: [Month.Response]
        public let days: [Day.Response]
        public let weekdays: [Weekday.Response]
        public let times: [String]
        public let repeatIntervals: [RepeatInterval.Response]
    }
}
