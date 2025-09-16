//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 3/4/24.
//

extension KernelAuthSessions.Model {
    public struct SessionData: Sendable {
        public var snapshot: [String: String] { self.storage }
        private var storage: [String: String]
        
        public init() {
            self.storage = [:]
        }
        
        public init(initialData data: [String: String]) {
            self.storage = data
        }
        
        public subscript(_ key: String) -> String? {
            get { self.storage[key] }
            set { self.storage[key] = newValue }
        }
    }
}

extension KernelAuthSessions.Model.SessionData: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.storage == rhs.storage
    }
}

extension KernelAuthSessions.Model.SessionData: Codable {
    public init(from decoder: any Decoder) throws {
        self.storage = try .init(from: decoder)
    }
    
    public func encode(to encoder: any Encoder) throws {
        try self.storage.encode(to: encoder)
    }
}

extension KernelAuthSessions.Model.SessionData: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, String)...) {
        let dict: [String: String] = elements.reduce(into: [:]) { $0[$1.0] = $1.1 }
        self.init(initialData: dict)
    }
}
