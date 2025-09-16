//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/04/2022.
//

import Foundation
import Vapor

public enum TypedPathComponent: ExpressibleByStringLiteral, CustomStringConvertible {
    case constant(String)
    case parameter(name: String, Meta)
    case anything
    case catchall
    
    public struct Meta: Sendable {
        public let type: Any.Type
        public let description: String?
        
        public init(type: Any.Type = String.self, description: String? = nil) {
            self.type = type
            self.description = description
        }
    }
    
    public init(stringLiteral value: StringLiteralType) {
        switch PathComponent(stringLiteral: value) {
        case .constant(let value):
            self = .constant(value)
        case .parameter(let name):
            self = .parameter(name: name, .init(type: String.self, description: nil))
        case .anything:
            self = .anything
        case .catchall:
            self = .catchall
        }
    }
    
    public var parameterType: Any.Type? {
        guard case .parameter(_, let meta) = self else { return nil }
        return meta.type
    }
    
    public var description: String {
        switch self {
        case .anything:
            return PathComponent.anything.description
        case .catchall:
            return PathComponent.catchall.description
        case .parameter(name: let value, _):
            return PathComponent.parameter(value).description
        case .constant(let value):
            return PathComponent.constant(value).description
        }
    }
    
    public var vaporPathComponent: PathComponent {
        switch self {
        case .anything: return .anything
        case .catchall: return .catchall
        case .parameter(name: let name, _): return .parameter(name)
        case .constant(let value): return .constant(value)
        }
    }
}

extension TypedPathComponent {
    public static func parameter(_ name: String) -> Self {
        return .parameter(name: name, .init(type: String.self, description: nil))
    }
    
    public static func parameter(_ name: String, type: Any.Type) -> Self {
        return .parameter(name: name, .init(type: type, description: nil))
    }
    
    public func description(_ description: String) -> Self {
        guard case let .parameter(name, meta) = self else {
            return self
        }
        return .parameter(name: name, .init(type: meta.type, description: description))
    }
    
    public func parameterType(_ type: Any.Type) -> Self {
        guard case let .parameter(name, meta) = self else {
            return self
        }
        return .parameter(name: name, .init(type: type, description: meta.description))
    }
    
}

extension Array where Element == PathComponent {
    public func getConstantValueWithPrefix(_ prefix: String, trimmingPrefix: Bool = true) -> String? {
        compactMap({
            if case let .constant(value) = $0, value.hasPrefix(prefix) {
                trimmingPrefix ? String(value.dropFirst(prefix.count)) : value
            } else { nil }
        }).first
    }
}

extension PathComponent {
    var typedPathComponent: TypedPathComponent {
        switch self {
        case .anything:
            return .anything
        case .catchall:
            return .catchall
        case .constant(let value):
            return .constant(value)
        case .parameter(let name):
            return .parameter(name)
        }
    }
}

extension String {
    public func description(_ string: String) -> TypedPathComponent {
        let component = TypedPathComponent(stringLiteral: self)
        guard case let .parameter(name, _) = component else { return component }
        return .parameter(name: name, .init(type: String.self, description: string))
    }
    
    public func parameterType(_ type: Any.Type) -> TypedPathComponent {
        let component = TypedPathComponent(stringLiteral: self)
        guard case let .parameter(name, meta) = component else { return component }
        return .parameter(name: name, .init(type: type, description: meta.description))
    }
}

extension Array where Element == TypedPathComponent {
    public var string: String {
        self.map(\.description).joined(separator: "/")
    }
}
