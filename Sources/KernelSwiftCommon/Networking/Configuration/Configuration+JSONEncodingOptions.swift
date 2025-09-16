//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 27/03/2025.
//

import Foundation

extension KernelNetworking.Configuration {
    public struct JSONEncodingOptions: OptionSet, Sendable {
        public let rawValue: UInt
        
        public init(rawValue: UInt) { self.rawValue = rawValue }

        public static let prettyPrinted: JSONEncodingOptions = .init(rawValue: 1 << 0)
        public static let sortedKeys: JSONEncodingOptions = .init(rawValue: 1 << 1)
        public static let withoutEscapingSlashes: JSONEncodingOptions = .init(rawValue: 1 << 2)
    }
}

extension JSONEncoder.OutputFormatting {
    init(_ options: KernelNetworking.Configuration.JSONEncodingOptions) {
        self.init()
        if options.contains(.prettyPrinted) { formUnion(.prettyPrinted) }
        if options.contains(.sortedKeys) { formUnion(.sortedKeys) }
        if options.contains(.withoutEscapingSlashes) { formUnion(.withoutEscapingSlashes) }
    }
}
