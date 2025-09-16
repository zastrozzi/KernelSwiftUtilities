//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 18/10/2024.
//

import Foundation
import FluentKit

public enum FieldMask<Value: Codable & Sendable> {
    case fixed(Value)
    case transform(_ transformFunc: (Value) -> Value)
    case generate(_ generateFunc: () -> Value)
}

extension FieldMask where Value == String {
    public static func starred(prefix: Int, fixedLength: Int? = nil) -> Self {
        let maskFunction: (String) -> String = { value in
            let valuePrefix = value.prefix(prefix)
            if let fixedLength {
                return valuePrefix + String(repeating: "*", count: max(0, fixedLength - valuePrefix.count))
            } else {
                return valuePrefix + String(repeating: "*", count: max(0, value.count - valuePrefix.count))
            }
        }
        return .transform(maskFunction)
    }
    
    public static func starredEmail(prefix: Int, fixedLength: Int? = nil, keepDomain: Bool = false) -> Self {
        let maskFunction: (String) -> String = { value in
            let emailParts = value.split(separator: "@")
            guard emailParts.count == 2 else { return value }
            let username = emailParts.first!
            let domain = emailParts.last!
            let usernamePrefix = username.prefix(prefix)
            let maskedDomain = "@" + (keepDomain ? domain : "****.com")
            if let fixedLength {
                return usernamePrefix + String(repeating: "*", count: fixedLength - usernamePrefix.count) + maskedDomain
            } else {
                return usernamePrefix + String(repeating: "*", count: username.count - usernamePrefix.count) + maskedDomain
            }
        }
        return .transform(maskFunction)
    }
}

extension Fields {
    public typealias MaskedField<Value> = MaskedFieldProperty<Self, Value> where Value: Codable & Sendable
}

// MARK: - Type

@propertyWrapper
public final class MaskedFieldProperty<Model, Value>: @unchecked Sendable
where Model: FluentKit.Fields, Value: Codable & Sendable
{
    public let field: FieldProperty<Model, Value>
    public let mask: FieldMask<Value>

    public var projectedValue: MaskedFieldProperty<Model, Value> {
        return self
    }

    public var wrappedValue: Value {
        get {
            guard let value = self.value else {
                fatalError("Cannot access masked field before it is initialized or fetched: \(self.field.key)")
            }
            return value
        }
        set {
            self.value = newValue
        }
    }

    public init(key: FieldKey, mask: FieldMask<Value>) {
        self.field = .init(key: key)
        self.mask = mask
    }
    
    public var maskedValue: Value {
        switch mask {
        case let .fixed(fixedValue): return fixedValue
        case let .transform(transformFunc): return transformFunc(wrappedValue)
        case let .generate(generateFunc): return generateFunc()
        }
    }
}

extension MaskedFieldProperty: CustomStringConvertible {
    public var description: String {
        "@\(Model.self).MaskedField<\(Value.self)>(key: \(self.field.key), mask: \(self.mask))"
    }
}

// MARK: - Property

extension MaskedFieldProperty: AnyProperty { }

extension MaskedFieldProperty: Property {
    public var value: Value? {
        get { self.field.value }
        set { self.field.value = newValue }
    }
}

// MARK: - Queryable

extension MaskedFieldProperty: AnyQueryableProperty {
    public var path: [FieldKey] {
        [self.field.key]
    }
}

extension MaskedFieldProperty: QueryableProperty { }

// MARK: - Query-addressable

extension MaskedFieldProperty: AnyQueryAddressableProperty {
    public var anyQueryableProperty: any AnyQueryableProperty { self }
    public var queryablePath: [FieldKey] { self.path }
}

extension MaskedFieldProperty: QueryAddressableProperty {
    public var queryableProperty: MaskedFieldProperty<Model, Value> { self }
}


// MARK: - Database

extension MaskedFieldProperty: AnyDatabaseProperty {
    public var keys: [FieldKey] {
        [self.field.key]
    }

    public func input(to input: any DatabaseInput) {
        self.field.input(to: input)
    }

    public func output(from output: any DatabaseOutput) throws {
        try self.field.output(from: output)
    }
}

// MARK: - Codable

extension MaskedFieldProperty: AnyCodableProperty {
    public func encode(to encoder: any Encoder) throws {
        try self.field.encode(to: encoder)
    }

    public func decode(from decoder: any Decoder) throws {
        try self.field.decode(from: decoder)
    }
}
