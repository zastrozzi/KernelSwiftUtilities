//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/11/2023.
//

import Foundation

extension KernelNetworking.HTTP {
    public struct EmptyResponse: Codable, Equatable, Sendable {
        public init() {}
    }
    
    public struct EmptyPath: Codable, Equatable, Sendable {
        public init() {}
    }
    
    public struct EmptyQuery: Codable, Equatable, Sendable {
        public init() {}
    }
    
    public struct EmptyRequest: Codable, Equatable, Sendable {
        public init() {}
    }
    
    public struct DefaultErrorResponse: Codable, Equatable, Sendable {
        public var reason: String
        public var error: Bool
        
        public init(
            reason: String,
            error: Bool
        ) {
            self.reason = reason
            self.error = error
        }
    }
}
