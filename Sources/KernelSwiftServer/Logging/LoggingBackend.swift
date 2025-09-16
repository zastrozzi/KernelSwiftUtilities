//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 28/01/2025.
//

import Vapor
import KernelSwiftCommon

extension KernelServerPlatform {
    public enum LoggingBackend: String {
        case OS_LOG = "oslog"
        case CONSOLE = "console"
        
        static func fromEnvironment(_ key: String = "LOGGING_BACKEND") -> LoggingBackend {
            Environment.get(key).flatMap(LoggingBackend.init(rawValue:)) ?? .OS_LOG
        }
    }
}

extension KernelServerPlatform {
    public static func bootstrapLogging(envKey: String = "LOGGING_BACKEND", forHost host: String, logLevel: Logger.Level) throws {
//        var env = env
//        let logLevel = try Logger.Level.detect(from: &env)
        switch LoggingBackend.fromEnvironment(envKey) {
        case .CONSOLE:
            print("CONSOLE LOGGING")
            LoggingSystem.bootstrap(
                fragment: timestampDefaultLoggerFragment(),
                console: Terminal(),
                level: logLevel
            )
        case .OS_LOG:
            print("OSLOG LOGGING")
            KernelSwiftCommon.bootstrapLogging(host, logLevel: logLevel)
        }
    }
}
