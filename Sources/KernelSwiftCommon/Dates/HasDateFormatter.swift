//
//  File.swift
//
//
//  Created by Jonathan Forbes on 29/03/2022.
//

import Foundation

public protocol HasDateFormatter {
    static var dateFormatter: DateFormatter { get }
}

extension Date {
    public var iso8601: String {
        return Self.ISO8601FormatStyle().format(self)
    }
}
