//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 03/02/2025.
//

import FluentKit

public enum RelationPointerKey<From, To, FromProp>: Sendable
where From: Model, To: Model, FromProp: QueryableProperty, FromProp.Model == From, FromProp.Value: Hashable
{
    case required(KeyPath<To, To.Pointer<From, FromProp>>)
    case optional(KeyPath<To, To.OptionalPointer<From, FromProp>>)
}

extension Model {
    public typealias References<To, FromProp> = ReferencesProperty<Self, To, FromProp>
    where To: Model, FromProp: QueryableProperty, FromProp.Model == Self, FromProp.Value: Hashable
}

// MARK: Type

/// A Fluent property wrapper which represents the _referenced_ side of a one-to-many relation between two models.
///
/// This property wrapper does not represent any column in a database table; it creates a "virtual" property suitable
/// for accessing the models on the far side of the relation.
///
/// This property wrapper differs from Fluent's built in `ChildrenProperty` and `CompositeChildrenProperty` wrappers in
/// that it is used for relations provided by ``PointerProperty`` and ``OptionalPointerProperty`` properties on the other
/// side of the relation, rather than by `ParentProperty` or `OptionalParentProperty`. It can _not_ be used to refer
/// to `ParentProperty` relations.
@propertyWrapper
public final class ReferencesProperty<From, To, FromProp>: @unchecked Sendable
where From: Model, To: Model, FromProp: QueryableProperty, FromProp.Model == From, FromProp.Value: Hashable, FromProp: Sendable
{
    public let parentKey: RelationPointerKey<From, To, FromProp>
    let fromKeypath: KeyPath<From, FromProp>
    var idValue: FromProp.Value?
    
    public var value: [To]?
    
    public convenience init(for parent: KeyPath<To, To.Pointer<From, FromProp>>) {
        self.init(for: .required(parent), referencedBy: To()[keyPath: parent].toKeypath)
    }
    
    public convenience init(for optionalParent: KeyPath<To, To.OptionalPointer<From, FromProp>>) {
        self.init(for: .optional(optionalParent), referencedBy: To()[keyPath: optionalParent].toKeypath)
    }
    
    private init(for parentKey: RelationPointerKey<From, To, FromProp>, referencedBy relatedKeypath: KeyPath<From, FromProp>) {
        self.parentKey = parentKey
        self.fromKeypath = relatedKeypath
    }
    
    public var wrappedValue: [To] {
        get {
            guard let value = self.value else {
                fatalError("References relation not eager loaded, use $ prefix to access: \(self.name)")
            }
            return value
        }
        set { fatalError("References relation \(self.name) is get-only.") }
    }
    
    public var projectedValue: ReferencesProperty<From, To, FromProp> {
        self
    }
    
    public var fromValue: FromProp.Value? {
        get { self.idValue }
        set { self.idValue = newValue }
    }
    
    public func query(on database: any Database) -> QueryBuilder<To> {
        guard let id = self.idValue else {
            fatalError("Cannot query references relation \(self.name) from unsaved model.")
        }
        let builder = To.query(on: database)
        switch self.parentKey {
        case .optional(let optional):
            builder.filter(optional.appending(path: \.$ref) == id)
        case .required(let required):
            builder.filter(required.appending(path: \.$ref) == id)
        }
        return builder
    }
    
    public func create(_ to: [To], on database: any Database) -> EventLoopFuture<Void> {
        guard let id = self.idValue else {
            fatalError("Cannot save child in relation \(self.name) to unsaved model.")
        }
        to.forEach {
            switch self.parentKey {
            case .required(let keyPath):
                $0[keyPath: keyPath].ref = id
            case .optional(let keyPath):
                $0[keyPath: keyPath].ref = id
            }
        }
        return to.create(on: database)
    }
    
    public func create(_ to: To, on database: any Database) -> EventLoopFuture<Void> {
        guard let id = self.idValue else {
            fatalError("Cannot save child in relation \(self.name) to unsaved model.")
        }
        switch self.parentKey {
        case .required(let keyPath):
            to[keyPath: keyPath].ref = id
        case .optional(let keyPath):
            to[keyPath: keyPath].ref = id
        }
        return to.create(on: database)
    }
}

extension ReferencesProperty: CustomStringConvertible {
    public var description: String {
        self.name
    }
}

// MARK: Property

extension ReferencesProperty: AnyProperty {}

extension ReferencesProperty: Property {
    public typealias Model = From
    public typealias Value = [To]
}

// MARK: Database

extension ReferencesProperty: AnyDatabaseProperty {
    public var keys: [FieldKey] {
        []
    }
    
    public func input(to input: any DatabaseInput) {
        // references never has input
    }
    
    public func output(from output: any DatabaseOutput) throws {
        let key: FieldKey
        switch self.parentKey {
        case .required(let required): key = To()[keyPath: required].$ref.key
        case .optional(let optional): key = To()[keyPath: optional].$ref.key
        }
        if output.contains(key) {
            self.idValue = try output.decode(key, as: FromProp.Value.self)
        }
    }
}

// MARK: Codable

extension ReferencesProperty: AnyCodableProperty {
    public func encode(to encoder: any Encoder) throws {
        if let rows = self.value {
            var container = encoder.singleValueContainer()
            try container.encode(rows)
        }
    }
    
    public func decode(from decoder: any Decoder) throws {
        // don't decode
    }
    
    public var skipPropertyEncoding: Bool {
        self.value == nil // Avoids leaving an empty JSON object lying around in some cases.
    }
}

// MARK: Relation

extension ReferencesProperty: Relation {
    public var name: String {
        "References<\(From.self), \(To.self)>(for: \(self.parentKey))"
    }
    
    public func load(on database: any Database) -> EventLoopFuture<Void> {
        self.query(on: database).all().map {
            self.value = $0
        }
    }
}

// MARK: Eager Loadable

extension ReferencesProperty: EagerLoadable {
    public static func eagerLoad<Builder>(
        _ relationKey: KeyPath<From, ReferencesProperty<From, To, FromProp>>,
        to builder: Builder
    )
    where Builder : EagerLoadBuilder, From == Builder.Model
    {
        self.eagerLoad(relationKey, withDeleted: false, to: builder)
    }
    
    public static func eagerLoad<Builder>(
        _ relationKey: KeyPath<From, From.References<To, FromProp>>,
        withDeleted: Bool,
        to builder: Builder
    )
    where Builder: EagerLoadBuilder, Builder.Model == From
    {
        let loader = ReferencesEagerLoader(relationKey: relationKey, withDeleted: withDeleted)
        builder.add(loader: loader)
    }
    
    
    public static func eagerLoad<Loader, Builder>(
        _ loader: Loader,
        through: KeyPath<From, From.References<To, FromProp>>,
        to builder: Builder
    ) where
    Loader: EagerLoader,
    Loader.Model == To,
    Builder: EagerLoadBuilder,
    Builder.Model == From
    {
        let loader = ThroughReferencesEagerLoader(relationKey: through, loader: loader)
        builder.add(loader: loader)
    }
}

private struct ReferencesEagerLoader<From, To, FromProp>: EagerLoader
where From: Model, To: Model, FromProp: QueryableProperty, FromProp.Model == From, FromProp.Value: Hashable, FromProp: Sendable
{
    // Needed because the extension that normally adds this inside FluentKit is not public.
    func anyRun(models: [any AnyModel], on database: any Database) -> EventLoopFuture<Void> {
        self.run(models: models.map { $0 as! Model }, on: database)
    }
    
    let relationKey: KeyPath<From, From.References<To, FromProp>>
    let withDeleted: Bool
    
    func run(models: [From], on database: any Database) -> EventLoopFuture<Void> {
        let ids = models.map { $0[keyPath: $0[keyPath: self.relationKey].fromKeypath].value! }
        
        let builder = To.query(on: database)
        let parentKey = From()[keyPath: self.relationKey].parentKey
        switch parentKey {
        case .optional(let optional):
            builder.filter(optional.appending(path: \.$ref) ~~ Set(ids))
        case .required(let required):
            builder.filter(required.appending(path: \.$ref) ~~ Set(ids))
        }
        if (self.withDeleted) {
            builder.withDeleted()
        }
        return builder.all().map {
            for model in models {
                let id = model[keyPath: self.relationKey].idValue!
                model[keyPath: self.relationKey].value = $0.filter { child in
                    switch parentKey {
                    case .optional(let optional):
                        return child[keyPath: optional].ref == id
                    case .required(let required):
                        return child[keyPath: required].ref == id
                    }
                }
            }
        }
    }
}

private struct ThroughReferencesEagerLoader<From, Through, FromProp, Loader>: EagerLoader
where From: Model, Loader: EagerLoader, Loader.Model == Through, FromProp: QueryableProperty, FromProp.Model == From, FromProp.Value: Hashable, FromProp: Sendable
{
    // Needed because the extension that normally adds this inside FluentKit is not public.
    func anyRun(models: [any AnyModel], on database: any Database) -> EventLoopFuture<Void> {
        self.run(models: models.map { $0 as! Model }, on: database)
    }
    
    let relationKey: KeyPath<From, From.References<Through, FromProp>>
    let loader: Loader
    
    func run(models: [From], on database: any Database) -> EventLoopFuture<Void> {
        let throughs = models.flatMap {
            $0[keyPath: self.relationKey].value!
        }
        return self.loader.run(models: throughs, on: database)
    }
}

extension ReferencesProperty: AliasableProperty {}

