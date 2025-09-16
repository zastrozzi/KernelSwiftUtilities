//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/07/2023.
//

import Vapor

extension KernelTaskScheduler {
    public class ScheduleBuilder {
        public var calendar: Calendar
        public var months: [Month]
        public var days: [Day]
        public var weekdays: [Weekday]
        public var times: [Time]
        public var repeatIntervals: [RepeatInterval]
        
        required public init() {
            self.calendar = .current
            self.months = []
            self.days = []
            self.weekdays = []
            self.times = []
            self.repeatIntervals = []
        }
        
        public func nextDate(_ current: Date? = nil) -> Date {
            let timeIntervals = repeatIntervals.map { $0.timeInterval() }
            let fullInterval = timeIntervals.reduce(0, +)
            let time = nextTime(after: current ?? .now)
            if weekdays.isEmpty {
                let month = nextMonth(after: time, matching: calendar.dateComponents([.hour, .minute, .second], from: time))
                let day = nextDay(after: month, matching: calendar.dateComponents([.hour, .minute, .second, .month], from: month))
                return day.addingTimeInterval(fullInterval)
            } else {
                let weekday = nextWeekday(after: time, matching: calendar.dateComponents([.hour, .minute, .second], from: time))
                let month = nextMonth(after: weekday, matching: calendar.dateComponents([.hour, .minute, .second, .weekday], from: weekday))
                return month.addingTimeInterval(fullInterval)
            }
            
            
        }
        
        func nextMonth(after current: Date = .now, matching: DateComponents = .init()) -> Date {
            guard !months.isEmpty else { return current }
            guard !months.contains(where: { $0.rawValue == current.monthOfYear }) else { return current }
            return months.compactMap {
                var components = matching
                components.month = $0.rawValue
                return calendar.nextDate(after: current, matching: components, matchingPolicy: .strict)
            }.sorted().first!
        }
        
        func nextWeekday(after current: Date = .now, matching: DateComponents = .init()) -> Date {
            guard !weekdays.isEmpty else { return current }
            guard !weekdays.contains(where: { $0.rawValue == current.dayOfWeek }) else { return current }
            return weekdays.compactMap {
                var components = matching
                components.weekday = $0.rawValue
                return calendar.nextDate(after: current, matching: components, matchingPolicy: .strict)
            }.sorted().first!
        }
        
        func nextDay(after current: Date = .now, matching: DateComponents = .init()) -> Date {
            guard !days.isEmpty else { return current }
            guard !days.contains(where: { $0 == .exact(current.dayOfMonth) }) else { return current }
            guard !(days.contains(where: { $0 == .first }) && (current.dayOfMonth == 1)) else { return current }
            guard !(days.contains(where: { $0 == .last }) && (current.dayOfMonth == current.daysInMonth)) else { return current }
            return days.compactMap {
                var components = matching
                switch $0 {
                case .first: components.day = 1
                case .last: components.day = current.daysInMonth
                case let .exact(exact): components.day = exact
                }
                return calendar.nextDate(after: current, matching: components, matchingPolicy: .strict)
            }.sorted().first!
        }
        
        func nextTime(after current: Date = .now, matching: DateComponents = .init()) -> Date {
            guard !times.isEmpty else { return current }
            return times.compactMap {
                var components = matching
                components.hour = $0.hour.number
                components.minute = $0.minute.number
                components.second = $0.second.number
                return calendar.nextDate(after: current, matching: components, matchingPolicy: .strict)
            }.sorted().first!
        }
    }
}
