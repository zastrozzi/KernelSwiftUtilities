//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/07/2023.
//
import KernelSwiftCommon

extension KernelTaskScheduler.ScheduleBuilder {
    
    public static func `in`(_ months: Month...) -> Self { Self.init().in(months) }
    public static func on(_ days: Day...) -> Self { Self.init().on(days) }
    public static func on(_ weekdays: Weekday...) -> Self { Self.init().on(weekdays) }
    public static func each(_ intervals: RepeatInterval...) -> Self { Self.init().each(intervals) }
    public static func at(_ times: Time...) -> Self { Self.init().at(times) }
    //
    @discardableResult
    public func `in`(_ months: Month...) -> Self { self.in(months) }
    
    @discardableResult
    public func `in`(_ months: [Month]) -> Self {
        self.months = months
        return self
    }
    
    @discardableResult
    public func on(_ days: Day...) -> Self { self.on(days) }
    
    @discardableResult
    public func on(_ days: [Day]) -> Self {
        self.weekdays = []
        self.days = days
        return self
    }
    
    @discardableResult
    public func on(_ weekdays: Weekday...) -> Self { self.on(weekdays) }
    
    @discardableResult
    public func on(_ weekdays: [Weekday]) -> Self {
        self.days = []
        self.weekdays = weekdays
        return self
    }
    
    @discardableResult
    public func each(_ intervals: RepeatInterval...) -> Self { each(intervals) }
    
    //    @discardableResult
    public func each(_ intervals: [RepeatInterval]) -> Self {
        guard times.isEmpty else {
            KernelTaskScheduler.logger.debug("CANNOT ADD INTERVALS")
            return self
        }
        self.repeatIntervals.append(contentsOf: intervals)
        return self
    }
    
    @discardableResult
    public func at(_ times: Time...) -> Self { self.at(times) }
    
    @discardableResult
    public func at(_ times: [Time]) -> Self {
        guard repeatIntervals.isEmpty else {
            KernelTaskScheduler.logger.debug("CANNOT ADD TIMES")
            return self
        }
        self.times = times
        return self
    }
    
    
}

