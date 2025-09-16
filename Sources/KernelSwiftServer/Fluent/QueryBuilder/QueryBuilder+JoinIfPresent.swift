//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 28/01/2025.
//

import Foundation
import Vapor
import Fluent

extension QueryBuilder {
    @discardableResult
    public func joinIfPresent<To>(
        parent: KeyPath<Model, ParentProperty<Model, To>>,
        method: DatabaseQuery.Join.Method = .inner,
        property: Optional<Any>
    ) -> Self {
        (property != nil) ? self.join(parent: parent, method: method) : self
    }
    
    @discardableResult
    public func joinIfPresent<To>(
        parent: KeyPath<Model, OptionalParentProperty<Model, To>>,
        method: DatabaseQuery.Join.Method = .inner,
        property: Optional<Any>
    ) -> Self {
        (property != nil) ? self.join(parent: parent, method: method) : self
    }
    
    @discardableResult
    public func joinIfPresent<From, To, Through>(
        from model: From.Type,
        siblings: KeyPath<From, SiblingsProperty<From, To, Through>>,
        property: Optional<Any>
    ) -> Self
        where From: FluentKit.Model, To: FluentKit.Model, Through: FluentKit.Model
    {
        (property != nil) ? self.join(from: model, siblings: siblings) : self
    }
    
    @discardableResult
    public func joinIfPresent<From, To>(
        from model: From.Type,
        parent: KeyPath<From, ParentProperty<From, To>>,
        property: Optional<Any>
    ) -> Self
        where From: FluentKit.Model, To: FluentKit.Model
    {
        (property != nil) ? self.join(from: model, parent: parent) : self
    }
    
    @discardableResult
    public func joinIfPresent<From, To>(
        from model: From.Type,
        parent: KeyPath<From, OptionalParentProperty<From, To>>,
        property: Optional<Any>
    ) -> Self
        where From: FluentKit.Model, To: FluentKit.Model
    {
        (property != nil) ? self.join(from: model, parent: parent) : self
    }
    
    @discardableResult
    public func joinIfPresent<To, Through>(
        siblings: KeyPath<Model, SiblingsProperty<Model, To, Through>>,
        property: Optional<Any>
    ) -> Self
        where To: FluentKit.Model, Through: FluentKit.Model
    {
        if (property != nil) {
            return self.join(siblings: siblings)
        } else {
            return self
        }
    }
    
    @discardableResult
    public func joinIfPresent<Foreign>(
        _ foreign: Foreign.Type,
        on filter: ComplexJoinFilter,
        method: DatabaseQuery.Join.Method = .inner,
        property: Optional<Any>
    ) -> Self where Foreign: Schema {
        (property != nil) ? self.join(Foreign.self, on: filter, method: method) : self
    }
}
