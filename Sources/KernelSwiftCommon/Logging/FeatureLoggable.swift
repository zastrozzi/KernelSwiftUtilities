//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 11/09/2023.
//

import Foundation
import Logging

public final class FeatureLoggers: Sendable {
//    public static let shared = FeatureLoggers()
    
    nonisolated(unsafe)
    private static var loggers: [String: Logger] = [:]
    
    public static func getLogger(forName name: String) -> Logger? {
        loggers[name]
    }
    
    public static func setLogger(_ logger: Logger, forName name: String) {
        loggers[name] = logger
    }
    
    public static func logger<Feature: FeatureLoggable>(_ feature: Feature.Type = Feature.self) -> Logger {
        if let logger = getLogger(forName: Feature.loggerName) { return logger }
        let newLogger = Logger(label: Feature.loggerName)
        setLogger(newLogger, forName: Feature.loggerName)
        newLogger.info("Static Logger initialised for \(Feature.loggerName)")
        return newLogger
    }
}

public protocol FeatureLoggable {
    static var logger: Logger { get }
}

extension FeatureLoggable {
    public static func makeLogger() -> Logger {
//        let newLogger = Logger(label: typeName(Self.self))
//        newLogger.info("Logger initialised for \(typeName(Self.self))")
//        return newLogger
        fallbackLogger
    }
    
//    public static var logger: Logger {
//        if let logger = FeatureLoggers.getLogger(forName: loggerName) {
//            return logger
//        } else {
//            let newLogger = makeLogger()
//            FeatureLoggers.setLogger(newLogger, forName: loggerName)
//            return newLogger
//        }
//    }
    
    public static var logger: Logger { FeatureLoggers.logger(Self.self) }
    public static var fallbackLogger: Logger { FeatureLoggers.logger(Self.self) }
    public static var loggerName: String { typeName(Self.self) }
}

