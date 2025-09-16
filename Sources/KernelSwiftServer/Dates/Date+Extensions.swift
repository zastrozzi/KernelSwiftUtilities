//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 12/05/2023.
//

//import Foundation
//
//extension Date {
//    public var startOfMonth: Date {
//
//        let calendar = Calendar.current
//        let components = calendar.dateComponents([.year, .month], from: self)
//
//        return calendar.date(from: components)!
//    }
//    
//    public var startOfDay: Date {
//        let calendar = Calendar.current
//        var components = calendar.dateComponents([.year, .month, .day], from: self)
//        components.timeZone = .current
//        return calendar.date(from: components)!
//    }
//    
//    public func startOfDay(timeZone: TimeZone = .current) -> Date {
//        let calendar = Calendar.current
//        var components = calendar.dateComponents([.year, .month, .day], from: self)
//        components.timeZone = timeZone
//        return calendar.date(from: components)!
//    }
//    
//    public var endOfDay: Date {
//        let calendar = Calendar.current
//        let startOfDay = self.startOfDay
//        let nextDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
//        return calendar.date(byAdding: .second, value: -1, to: nextDay)!
//    }
//    
//    public func endOfDay(timeZone: TimeZone = .current) -> Date {
//        let calendar = Calendar.current
//        let startOfDay = self.startOfDay(timeZone: timeZone)
//        let nextDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
//        return calendar.date(byAdding: .second, value: -1, to: nextDay)!
//    }
//    
//    public var endOfMonth: Date {
//        var components = DateComponents()
//        components.month = 1
//        components.second = -1
//        return Calendar.current.date(byAdding: components, to: startOfMonth)!
//    }
//    
//    public var dayOfWeek: Int {
//        let calendar = Calendar.current
//        return calendar.component(.weekday, from: self)
//    }
//    
//    public var dayOfMonth: Int {
//        let calendar = Calendar.current
//        return calendar.component(.day, from: self)
//    }
//    
//    public var monthOfYear: Int {
//        let calendar = Calendar.current
//        return calendar.component(.month, from: self)
//    }
//    
//    public var daysInMonth: Int {
//        let calendar = Calendar.current
//
//        let dateComponents = DateComponents(year: calendar.component(.year, from: self), month: calendar.component(.month, from: self))
//        let date = calendar.date(from: dateComponents)!
//
//        let range = calendar.range(of: .day, in: .month, for: date)!
//        let numDays = range.count
//
//        return numDays
//    }
//}
