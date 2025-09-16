//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 10/11/2023.
//

import Foundation
import KernelSwiftCommon
import AsyncAlgorithms
import Logging

extension KernelDI.Injector {
    public var logger: KernelSwiftTerminal.LoggingService {
        get { self[KernelSwiftTerminal.LoggingService.Token.self] }
        set { self[KernelSwiftTerminal.LoggingService.Token.self] = newValue}
    }
}

extension KernelSwiftTerminal {
    public final class LoggingService: KernelDI.Injectable {
        private var _logChannels: AsyncChannel<LogMessage> = .init()
        private lazy var logChannels: some TypedAsyncSequence<LogMessage> = _logChannels.broadcast()
        
        public init() {}
        
        public func logs(_ identifier: LogIdentifier = .all, level: LogLevel = .debug) -> some TypedAsyncSequence<LogMessage> {
            logChannels.filter { (identifier != .all ? $0.channels.contains(identifier) : true) && $0.level >= level }
        }
        
        public func log(_ identifiers: LogIdentifier..., level: LogLevel = .debug, _ message: String) {
            log(identifiers, level: level, message)
        }
        
        private func log(_ identifiers: [LogIdentifier], level: LogLevel = .debug, _ message: String) {
            let ident: Set<LogIdentifier> = identifiers.isEmpty ? [.all] : .init(identifiers)
            Task { await _logChannels.send(.init(channels: ident, level: level, message: message)) }
        }
        
        public struct LogMessage: Sendable {
            public let id: UUID
            public let timestamp: Date
            public let channels: Set<LogIdentifier>
            public let level: LogLevel
            public let message: String
            
            public init(
                channels: Set<LogIdentifier> = [.all],
                level: LogLevel = .debug,
                message: String
            ) {
                self.id = .init()
                self.timestamp = .now
                self.channels = channels
                self.level = level
                self.message = message
            }
        }
        
        public enum LogIdentifier: Codable, Hashable, Sendable {
            case all
            case id(String)
            
            public var label: String {
                switch self {
                case .all: "ALL"
                case let .id(str): str
                }
            }
        }
        
        public enum LogLevel: String, Codable, CaseIterable, Sendable, Comparable {
            case trace
            case debug
            case info
            case notice
            case warning
            case error
            case critical
            
            internal var intValue: Int {
                switch self {
                case .trace: 0
                case .debug: 1
                case .info: 2
                case .notice: 3
                case .warning: 4
                case .error: 5
                case .critical: 6
                }
            }
            
            public static func < (lhs: Self, rhs: Self) -> Bool {
                return lhs.intValue < rhs.intValue
            }
        }
    }
}
