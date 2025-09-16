//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 06/12/2023.
//

import Fluent
import FluentKit

extension Fields {
    public typealias OptionalGroupParent<To> = OptionalGroupParentProperty<Self, To>
    where To: Model
}

@propertyWrapper
public final class OptionalGroupParentProperty<From, To>: @unchecked Sendable
where From: Fields, To: Model
{
    @OptionalFieldProperty<From, To.IDValue>
    public var id: To.IDValue?
    
    public var wrappedValue: To? {
        get {
            self.value ?? nil
        }
        set {
            fatalError("OptionalGroupParent relation \(self.name) is get-only.")
        }
    }
    
    public var projectedValue: OptionalGroupParentProperty<From, To> {
        return self
    }
    
    public var value: To??
    
    public init(key: FieldKey) {
        guard !(To.IDValue.self is Fields.Type) else {
            fatalError("Can not use @OptionalGroupParent to target a model with composite ID.")
        }
        
        self._id = .init(key: key)
    }
    
    public func query(on database: Database) -> QueryBuilder<To> {
        let builder = To.query(on: database)
        if let id = self.id {
            builder.filter(\._$id == id)
        } else {
            builder.filter(\._$id == .null)
        }
        return builder
    }
}

extension OptionalGroupParentProperty: CustomStringConvertible {
    public var description: String {
        self.name
    }
}

extension OptionalGroupParentProperty: Relation {
    public var name: String {
        "OptionalGroupParent<\(From.self), \(To.self)>(key: \(self.$id.key))"
    }
    
    public func load(on database: Database) -> EventLoopFuture<Void> {
        self.query(on: database).first().map {
            self.value = $0
        }
    }
}

extension OptionalGroupParentProperty: AnyProperty { }

extension OptionalGroupParentProperty: Property {
    public typealias Model = From
    public typealias Value = To?
}

extension OptionalGroupParentProperty: AnyQueryAddressableProperty {
    public var anyQueryableProperty: AnyQueryableProperty { self.$id.anyQueryableProperty }
    public var queryablePath: [FieldKey] { self.$id.queryablePath }
}

extension OptionalGroupParentProperty: QueryAddressableProperty {
    public var queryableProperty: OptionalFieldProperty<From, To.IDValue> { self.$id.queryableProperty }
}


extension OptionalGroupParentProperty: AnyDatabaseProperty {
    public var keys: [FieldKey] {
        self.$id.keys
    }
    
    public func input(to input: DatabaseInput) {
        self.$id.input(to: input)
    }
    
    public func output(from output: DatabaseOutput) throws {
        try self.$id.output(from: output)
    }
}

extension OptionalGroupParentProperty: AnyCodableProperty {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if case .some(.some(let parent)) = self.value {
            try container.encode(parent)
        } else {
            try container.encode([
                "id": self.id
            ])
        }
    }
    
    public func decode(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SomeCompatCodingKey.self)
        try self.$id.decode(from: container.superDecoder(forKey: .init(stringValue: "id")))
    }
}

public struct SomeCompatCodingKey: CodingKey, Hashable {
    public let stringValue: String
    public let intValue: Int?
  
    public init(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = Int(stringValue)
    }

    public init(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }
    
    public var description: String {
        "SomeCompatCodingKey(\"\(self.stringValue)\"\(self.intValue.map { ", int: \($0)" } ?? ""))"
    }
}
