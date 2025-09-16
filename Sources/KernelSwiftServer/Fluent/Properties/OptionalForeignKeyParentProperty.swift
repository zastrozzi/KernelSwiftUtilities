//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 07/09/2024.
//

import Fluent
import FluentKit

extension Model {
    public typealias OptionalForeignKeyParent<To, ForeignKey> = OptionalForeignKeyParentProperty<Self, To, ForeignKey>
    where To: Model, ForeignKey: Codable & Sendable
}


// MARK: Type

@propertyWrapper
public final class OptionalForeignKeyParentProperty<From, To, ForeignKey>: @unchecked Sendable
where From: Model, To: Model, ForeignKey: Codable & Sendable
{
    @OptionalFieldProperty<From, ForeignKey>
    public var foreignKey: ForeignKey?
    public let parentPath: KeyPath<To, FieldProperty<To, ForeignKey>>
    public let key: FieldKey

    public var wrappedValue: To? {
        get {
            self.value ?? nil
        }
        set {
            fatalError("OptionalForeignKeyParent relation \(self.name) is get-only.")
        }
    }
    
    public convenience init(key: FieldKey, for parent: KeyPath<To, FieldProperty<To, ForeignKey>>) {
        self.init(key: key, parentPath: parent)
    }

    public var projectedValue: OptionalForeignKeyParentProperty<From, To, ForeignKey> {
        self
    }

    public var value: To??

    private init(key: FieldKey, parentPath: KeyPath<To, FieldProperty<To, ForeignKey>>) {
//        guard !(To.IDValue.self is any Fields.Type) else {
//            fatalError("Can not use @Parent to target a model with composite ID; use @CompositeParent instead.")
//        }
        
        self._foreignKey = .init(key: key)
        self.parentPath = parentPath
        self.key = key
    }

    public func query(on database: any Database) -> QueryBuilder<To> {
        let builder = To.query(on: database)
        if let fk = self.foreignKey {
            builder.filter(parentPath == fk)
        } else {
            builder.filter(parentPath == .null)
        }
        return builder
    }
}

extension OptionalForeignKeyParentProperty: CustomStringConvertible {
    public var description: String {
        self.name
    }
}

// MARK: Relation

extension OptionalForeignKeyParentProperty: Relation {
    public var name: String {
        "OptionalForeignKeyParent<\(From.self), \(To.self)>(key: \(self.$foreignKey.key))"
    }

    public func load(on database: any Database) -> EventLoopFuture<Void> {
        self.query(on: database).first().map {
            self.value = $0
        }
    }
}

// MARK: Property

extension OptionalForeignKeyParentProperty: AnyProperty { }

extension OptionalForeignKeyParentProperty: Property {
    public typealias Model = From
    public typealias Value = To?
}

// MARK: Query-addressable

extension OptionalForeignKeyParentProperty: AnyQueryAddressableProperty {
    public var anyQueryableProperty: any AnyQueryableProperty { self.$foreignKey.anyQueryableProperty }
    public var queryablePath: [FieldKey] { self.$foreignKey.queryablePath }
}


extension OptionalForeignKeyParentProperty: QueryAddressableProperty {
    public var queryableProperty: OptionalFieldProperty<From, ForeignKey> { self.$foreignKey.queryableProperty }
}

// MARK: Database

extension OptionalForeignKeyParentProperty: AnyDatabaseProperty {
    public var keys: [FieldKey] {
        self.$foreignKey.keys
    }
    
    public func input(to input: any DatabaseInput) {
        self.$foreignKey.input(to: input)
    }

    public func output(from output: any DatabaseOutput) throws {
        try self.$foreignKey.output(from: output)
    }
}

// MARK: Codable

extension OptionalForeignKeyParentProperty: AnyCodableProperty {
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        if case .some(.some(let parent)) = self.value { // require truly non-nil so we don't mis-encode when value has been manually cleared
            try container.encode(parent)
        } else {
            try container.encode([
                self.$foreignKey.key.description: self.foreignKey
            ])
        }
    }

    public func decode(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: SomeCompatCodingKey.self)
        try self.$foreignKey.decode(from: container.superDecoder(forKey: .init(stringValue: self.$foreignKey.key.description)))
    }
}
