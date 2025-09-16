//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 07/09/2024.
//

import Fluent
import FluentKit

extension Model {
    public typealias ForeignKeyParent<To, ForeignKey> = ForeignKeyParentProperty<Self, To, ForeignKey>
    where To: Model, ForeignKey: Codable
}

// MARK: Type

@propertyWrapper
public final class ForeignKeyParentProperty<From, To, ForeignKey>: @unchecked Sendable
where From: Model, To: Model, ForeignKey: Codable & Sendable {
    @FieldProperty<From, ForeignKey>
    public var foreignKey: ForeignKey
    public let parentPath: KeyPath<To, FieldProperty<To, ForeignKey>>
    public let key: FieldKey
    
    public convenience init(key: FieldKey, for parent: KeyPath<To, FieldProperty<To, ForeignKey>>) {
        self.init(key: key, parentPath: parent)
    }
    
    
    public var wrappedValue: To {
        get {
            guard let value = self.value else {
                fatalError("Parent relation not eager loaded, use $ prefix to access: \(self.name)")
            }
            return value
        }
        set { fatalError("use $ prefix to access \(self.name)") }
    }

    public var projectedValue: ForeignKeyParentProperty<From, To, ForeignKey> {
        self
    }

    public var value: To?
    
    private init(key: FieldKey, parentPath: KeyPath<To, FieldProperty<To, ForeignKey>>) {
//        guard !(To.IDValue.self is any Fields.Type) else {
//            fatalError("Can not use @Parent to target a model with composite ID; use @CompositeParent instead.")
//        }
        
        self._foreignKey = .init(key: key)
        self.parentPath = parentPath
        self.key = key
    }

    public func query(on database: any Database) -> QueryBuilder<To> {
        To.query(on: database)
            .filter(parentPath == self.foreignKey)
    }
}

extension ForeignKeyParentProperty: CustomStringConvertible {
    public var description: String {
        self.name
    }
}

// MARK: Relation

extension ForeignKeyParentProperty: Relation {
    public var name: String {
        "ForeignKeyParent<\(From.self), \(To.self)>(key: \(self.$foreignKey.key))"
    }

    public func load(on database: any Database) -> EventLoopFuture<Void> {
        self.query(on: database).first().map {
            self.value = $0
        }
    }
}

// MARK: Property

extension ForeignKeyParentProperty: AnyProperty { }

extension ForeignKeyParentProperty: Property {
    public typealias Model = From
    public typealias Value = To
}

// MARK: Query-addressable

extension ForeignKeyParentProperty: AnyQueryAddressableProperty {
    public var anyQueryableProperty: any AnyQueryableProperty { self.$foreignKey.anyQueryableProperty }
    public var queryablePath: [FieldKey] { self.$foreignKey.queryablePath }
}

extension ForeignKeyParentProperty: QueryAddressableProperty {
    public var queryableProperty: FieldProperty<From, ForeignKey> { self.$foreignKey.queryableProperty }
}

// MARK: Database

extension ForeignKeyParentProperty: AnyDatabaseProperty {
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

extension ForeignKeyParentProperty: AnyCodableProperty {
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        if let parent = self.value {
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
