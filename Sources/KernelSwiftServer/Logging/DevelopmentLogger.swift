//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 24/04/2023.
//

import Foundation
import Vapor

extension Logger {
    nonisolated(unsafe) public static let development = DevelopmentLogger()
}

@dynamicMemberLookup
public struct DevelopmentLogger {
    private var logger: Logger
    
    public init() {
        self.logger = .init(label: "kernel.vapor.logging.development")
    }
    
    public subscript<Value>(dynamicMember member: KeyPath<Logger, Value>) -> Value {
        return logger[keyPath: member]
    }
}

public protocol DevelopmentLoggable {
    func mustChangeFunc(name: String, message: String) -> Void
}

extension DevelopmentLogger: DevelopmentLoggable {
    public func mustChangeFunc(name: String, message: String) {
        self.logger.warning("default \(name) function called, you MUST change it in order to \(message).")
    }
    
    public func shouldChangeFunc(name: String, message: String) {
        self.logger.info("default \(name) function called, you SHOULD change it in order to \(message).")
    }
}
