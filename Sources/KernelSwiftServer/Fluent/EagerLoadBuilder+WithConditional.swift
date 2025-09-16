//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 4/5/24.
//

import Fluent
import FluentKit

extension EagerLoadBuilder {
    @discardableResult
    public func with<Relation>(_ relationKey: KeyPath<Model, Relation>, if condition: Bool) -> Self
        where Relation: EagerLoadable, Relation.From == Model
    {
        guard condition else { return self }
        return with(relationKey)
    }

    @discardableResult
    public func with<Relation>(
        _ throughKey: KeyPath<Model, Relation>,
        _ nested: (NestedEagerLoadBuilder<Self, Relation>) throws -> (),
        if condition: Bool
    ) rethrows -> Self
        where Relation: EagerLoadable, Relation.From == Model
    {
        guard condition else { return self }
        return try with(throughKey, nested)
    }
    
    @discardableResult
    public func with<Relation>(
        _ relationKey: KeyPath<Model, Relation>,
        withDeleted: Bool,
        if condition: Bool
    ) -> Self
        where Relation: EagerLoadable, Relation.From == Model
    {
        guard condition else { return self }
        return with(relationKey, withDeleted: withDeleted)
    }

    @discardableResult
    public func with<Relation>(
        _ throughKey: KeyPath<Model, Relation>,
        withDeleted: Bool,
        _ nested: (NestedEagerLoadBuilder<Self, Relation>) throws -> (),
        if condition: Bool
    ) rethrows -> Self
        where Relation: EagerLoadable, Relation.From == Model
    {
        guard condition else { return self }
        return try with(throughKey, withDeleted: withDeleted, nested)
    }
}
