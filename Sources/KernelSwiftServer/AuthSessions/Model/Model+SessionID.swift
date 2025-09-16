//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 3/4/24.
//

extension KernelAuthSessions.Model {
    public struct SessionID: Sendable, Equatable, Hashable {
        public let string: String
        
        public init(string: String) {
            self.string = string
        }
    }
}

extension KernelAuthSessions.Model.SessionID: Codable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        try self.init(string: container.decode(String.self))
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.string)
    }
}
