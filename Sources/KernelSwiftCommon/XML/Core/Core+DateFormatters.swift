//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 18/06/2025.
//

import Foundation

extension KernelXML {
    @available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
    public static var iso8601Formatter: ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = .withInternetDateTime
        return formatter
    }
}
