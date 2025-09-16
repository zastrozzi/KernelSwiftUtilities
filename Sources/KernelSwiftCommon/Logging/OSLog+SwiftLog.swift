//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 11/09/2023.
//

import Foundation
import Logging
import struct Logging.Logger

//import Vapor

extension KernelSwiftCommon {
    nonisolated(unsafe) public static var hostAppSubsystem: String = ""
    
//    public static func bootstrapLogging(_ host: String = "") {
//        KernelSwiftCommon.hostAppSubsystem = host
//        #if canImport(OSLog)
//        LoggingSystem.bootstrap(OSLogLogHandler.init)
//        #endif
//    }
    
    public static func bootstrapLogging(_ host: String = "", logLevel: Logging.Logger.Level) {
        KernelSwiftCommon.hostAppSubsystem = host
        #if canImport(OSLog)
        LoggingSystem.bootstrap(OSLogLogHandler.factory(logLevel))
        #endif
    }
    
    
}

#if canImport(OSLog)
import OSLog

public struct OSLogLogHandler: LogHandler {
//    static var hostAppSubsystem = Bundle.main.bundleIdentifier!
    public var logLevel: Logging.Logger.Level = .debug
    public let label: String
    private let osLogger: OSLog
    private let loggingLogger: os.Logger
    private var prettyMetadata: String?
    
    public init(label: String, osLogger: OSLog) {
        self.label = label
        self.osLogger = osLogger
        self.loggingLogger = .init(osLogger)
    }
    
    public init(label: String) {
        self.label = label
        self.osLogger = OSLog(subsystem: KernelSwiftCommon.hostAppSubsystem, category: label)
        self.loggingLogger = .init(osLogger)
    }
    
    public init(label: String, logLevel: Logging.Logger.Level) {
        self.label = label
        self.logLevel = logLevel
        self.osLogger = OSLog(subsystem: KernelSwiftCommon.hostAppSubsystem, category: label)
        self.loggingLogger = .init(osLogger)
    }
    
    public subscript(metadataKey metadataKey: String) -> Logging.Logger.Metadata.Value? {
        get { self.metadata[metadataKey] }
        set { self.metadata[metadataKey] = newValue }
    }
    
    public var metadata: Logging.Logger.Metadata = .init() {
        didSet { self.prettyMetadata = self.prettify(self.metadata) }
    }
    
    public func log(
        level: Logger.Level,
        message: Logger.Message,
        metadata: Logger.Metadata?,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) {
        var combinedMetadata = self.prettyMetadata
        if let metadataOverride = metadata, !metadataOverride.isEmpty {
            combinedMetadata = self.prettify(self.metadata.merging(metadataOverride) { $1 })
        }
        var formedMessage = message.description
        
        if combinedMetadata != nil {
            formedMessage += "\(String.newLine) -- " + combinedMetadata!
        }
        if level == .debug || level == .trace { formedMessage += "\(String.newLine)\(file):\(line) -- \(function)" }
        

//        os_log("%{public}@", log: self.osLogger, type: .from(loggerLevel: level), formedMessage as NSString)
    }
    
    public func log(
        level: Logger.Level,
        message: Logger.Message,
        metadata: Logger.Metadata?,
        source: String,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) {
        var combinedMetadata = self.prettyMetadata
        if let metadataOverride = metadata, !metadataOverride.isEmpty {
            combinedMetadata = self.prettify(self.metadata.merging(metadataOverride) { $1 })
        }
        var formedMessage = message.description
        
        if combinedMetadata != nil {
            formedMessage += "\(String.newLine) -- " + combinedMetadata!
        }
//        if level == .debug || level == .trace { formedMessage += "\(String.newLine)\(file):\(line) -- \(function)" }
        let fileAndLine = "\((file as NSString).lastPathComponent):\(line)"
        if level == .debug || level == .trace {
            loggingLogger.log(level: .from(loggerLevel: level), "\(formedMessage, privacy: .public)\(String.newLine)\(function)\(String.newLine)\(fileAndLine)")
        } else {
            loggingLogger.log(level: .from(loggerLevel: level), "\(formedMessage, privacy: .public)")
        }

//        os_log(
//            "%{public}@%{public}@[%{public}@:%{public}@ -- %{public}@]",
//            log: self.osLogger,
//            type: .from(loggerLevel: level),
//            formedMessage as NSString,
//            "\(String.newLine)",
//            (file as NSString).lastPathComponent,
//            "\(line)",
//            function
//        )
    }
    
    private func prettify(_ metadata: Logger.Metadata) -> String? {
        
        guard !metadata.isEmpty else { return nil }
        return metadata.map { "\($0): \($1)" }.joined(separator: .newLine)
    }
    
    public static var factory: (Logger.Level) -> @Sendable (String) -> LogHandler {
        return { level in
            return { label in
                return OSLogLogHandler(label: label, logLevel: level)
            }
        }
    }
}

extension OSLogType {
    static func from(loggerLevel: Logger.Level) -> Self {
        switch loggerLevel {
        case .trace:
            /// `OSLog` doesn't have `trace`, so use `debug`
            return .debug
        case .debug:
            return .debug
        case .info:
            return .info
        case .notice:
            // https://developer.apple.com/documentation/os/logging/generating_log_messages_from_your_code
            // According to the documentation, `default` is `notice`.
            return .default
        case .warning:
            /// `OSLog` doesn't have `warning`, so use `info`
            return .info
        case .error:
            return .error
        case .critical:
            return .fault
        }
    }
}
#endif
