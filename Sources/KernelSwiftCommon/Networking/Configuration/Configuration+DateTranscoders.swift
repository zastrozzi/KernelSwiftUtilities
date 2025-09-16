//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 27/03/2025.
//

import Foundation

@_documentation(visibility: private)
public protocol _KernelNetworking_Configuration_DateTranscoder: Sendable {
    func encode(_: Date) throws -> String
    func decode(_: String) throws -> Date
}

extension KernelNetworking.Configuration {
    public typealias DateTranscoder = _KernelNetworking_Configuration_DateTranscoder
}

extension KernelNetworking.Configuration {
    public struct ISO8601DateTranscoder: DateTranscoder, @unchecked Sendable {
        private let lock: NSLock
        private let locked_formatter: ISO8601DateFormatter
        
        public init(options: ISO8601DateFormatter.Options? = nil) {
            let formatter = ISO8601DateFormatter()
            if let options { formatter.formatOptions = options }
            lock = NSLock()
            lock.name = "kernel.networking.configuration.ISO8601DateTranscoder"
            locked_formatter = formatter
        }
        
        public func encode(_ date: Date) throws -> String {
            lock.lock()
            defer { lock.unlock() }
            return locked_formatter.string(from: date)
        }
        
        public func decode(_ dateString: String) throws -> Date {
            lock.lock()
            defer { lock.unlock() }
            guard let date = locked_formatter.date(from: dateString) else {
                throw DecodingError.dataCorrupted(
                    .init(codingPath: [], debugDescription: "Expected date string to be ISO8601-formatted.")
                )
            }
            return date
        }
    }
}

extension KernelNetworking.Configuration.DateTranscoder where Self == KernelNetworking.Configuration.ISO8601DateTranscoder {
    public static var iso8601: Self { KernelNetworking.Configuration.ISO8601DateTranscoder() }

    public static var iso8601WithFractionalSeconds: Self {
        .init(options: [.withInternetDateTime, .withFractionalSeconds])
    }
}

extension JSONEncoder.DateEncodingStrategy {
    static func from(dateTranscoder: any KernelNetworking.Configuration.DateTranscoder) -> Self {
        .custom { date, encoder in
            let dateAsString = try dateTranscoder.encode(date)
            var container = encoder.singleValueContainer()
            try container.encode(dateAsString)
        }
    }
}

extension JSONDecoder.DateDecodingStrategy {
    static func from(dateTranscoder: any KernelNetworking.Configuration.DateTranscoder) -> Self {
        .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            return try dateTranscoder.decode(dateString)
        }
    }
}
