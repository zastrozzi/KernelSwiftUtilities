//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 26/03/2025.
//

import Foundation

extension KernelValidation {
    public enum ValidationKey: CodingKey, Hashable {
        case key(String)
        case index(Int)
        
        /// See `CodingKey`.
        public var stringValue: String {
            switch self {
            case .index(let index): return index.description
            case .key(let key): return key
            }
        }
        
        /// See `CodingKey`.
        public var intValue: Int? {
            switch self {
            case .index(let index): return index
            case .key(let key): return Int(key)
            }
        }
        
        /// See `CodingKey`.
        public init?(stringValue: String) {
            self = .key(stringValue)
        }
        
        /// See `CodingKey`.
        public init?(intValue: Int) {
            self = .index(intValue)
        }
        
        public init(_ codingKey: CodingKey) {
            if let intValue = codingKey.intValue {
                self = .index(intValue)
            } else {
                self = .key(codingKey.stringValue)
            }
        }
        
        public init(_ codingKeyRepresentable: CodingKeyRepresentable) {
            self.init(codingKeyRepresentable.codingKey)
        }
    }
}

extension KernelValidation.ValidationKey: CustomStringConvertible {
    public var description: String {
        switch self {
        case .index(let index):
            return index.description
        case .key(let key):
            return key.description
        }
    }
}

extension KernelValidation.ValidationKey: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .index(let index):
            return index.description
        case .key(let key):
            return key.debugDescription
        }
    }
}

extension KernelValidation.ValidationKey: ExpressibleByStringLiteral {
    public init(stringLiteral: String) {
        self = .key(stringLiteral)
    }
}

extension KernelValidation.ValidationKey: ExpressibleByIntegerLiteral {
    public init(integerLiteral: Int) {
        self = .index(integerLiteral)
    }
}
