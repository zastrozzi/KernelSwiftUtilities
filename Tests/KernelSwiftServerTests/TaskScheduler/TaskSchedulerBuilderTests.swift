//
//  File.swift
//
//
//  Created by Jonathan Forbes on 26/06/2023.
//

import Testing
import Foundation
import KernelSwiftServer

@Suite
struct KernelTaskSchedulerBuilderTests {
    @Test
    func testTimesRelativeDaysBuilder() throws {
        let x = KernelTaskScheduler.ScheduleBuilder().in(.april, .may).on(.monday, .tuesday).each(.hours(18))
        print(x.months, x.days, x.weekdays, x.times, "BUILDER")
        print(Date.now)
        let first = x.nextDate()
        let second = x.nextDate(first)
        let third = x.nextDate(second)
        let four = x.nextDate(third)
        let five = x.nextDate(four)
        let six = x.nextDate(five)
        let seven = x.nextDate(six)
        let eight = x.nextDate(seven)
        let nine = x.nextDate(eight)
        let ten = x.nextDate(nine)
        let elev = x.nextDate(ten)
        let twel = x.nextDate(elev)
        let thir = x.nextDate(twel)
        
        print("first", first)
        print("second", second)
        print("third", third)
        print("four", four)
        print("five", five)
        print("six", six)
        print("seven", seven)
        print("eight", eight)
        print("nine", nine)
        print("ten", ten)
        print("elev", elev)
        print("twel", twel)
        print("thir", thir)
        
        x.on(.last).at("10am")
        print(x.months, x.days, x.weekdays, x.times, "BUILDER")
        
        let _first = x.nextDate()
        let _second = x.nextDate(_first)
        let _third = x.nextDate(_second)
        let _four = x.nextDate(_third)
        let _five = x.nextDate(_four)
        let _six = x.nextDate(_five)
        let _seven = x.nextDate(_six)
        let _eight = x.nextDate(_seven)
        let _nine = x.nextDate(_eight)
        let _ten = x.nextDate(_nine)
        let _elev = x.nextDate(_ten)
        let _twel = x.nextDate(_elev)
        let _thir = x.nextDate(_twel)
        
        print("first", _first)
        print("second", _second)
        print("third", _third)
        print("four", _four)
        print("five", _five)
        print("six", _six)
        print("seven", _seven)
        print("eight", _eight)
        print("nine", _nine)
        print("ten", _ten)
        print("elev", _elev)
        print("twel", _twel)
        print("thir", _thir)
    }
}

