//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 21/02/2022.
//

import Foundation

//public extension Int {
//    func convertSecondsToHoursMinutesSeconds() -> String? {
//        let formatter = DateComponentsFormatter()
//        formatter.allowedUnits = [.hour, .minute, .second]
//        formatter.unitsStyle = .positional
//        return formatter.string(from: TimeInterval(self))
//    }
//}

extension Int {
    public func updateBytes(_ b: inout [UInt8], offset o: Int) {
        for i in .zero..<8 { b[o + i] = .init((self >> (i * 8)) & 0xff) }
    }
}
