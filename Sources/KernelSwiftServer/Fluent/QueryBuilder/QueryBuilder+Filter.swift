//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 28/01/2025.
//

import Vapor
import Fluent

extension QueryBuilder {
    @discardableResult
    public func filter<Field>(
        _ queryField: QueryField<Model, Field>,
        _ method: DatabaseQuery.Filter.Method
    ) -> Self {
        switch queryField {
        case let .field(keyPath, value): self.filter(keyPath, method, value)
//        case let .id(value): self.filter(\._$id, method, value)
        }
    }
    
    @discardableResult
    public func filter<TrueField, FalseField>(
        _ queryField: ConditionalQueryField<Model, TrueField, FalseField>,
        _ method: DatabaseQuery.Filter.Method
    ) -> Self {
        switch queryField.condition {
        case true : self.filter(queryField.trueQueryField(), method)
        case false : self.filter(queryField.falseQueryField(), method)
        }
    }
    
    @discardableResult
    public func filter<To: FluentKit.Model, Through: FluentKit.Model>(
        siblings: KeyPath<Model, SiblingsProperty<Model, To, Through>>,
        _ filter: ModelValueFilter<To>
    ) -> Self {
        
        self.join(siblings: siblings).filter(To.self, filter)
    }
    
    @discardableResult
    public func filter<Field: QueryableProperty, To: FluentKit.Model, Through: FluentKit.Model>(siblings: KeyPath<Model, SiblingsProperty<Model, To, Through>>, _ fieldKeyPath: KeyPath<To, Field>, _ method: DatabaseQuery.Filter.Method, _ value: Field.Value) -> Self where Field.Model == To {
        
        return self.join(siblings: siblings).filter(To.self, fieldKeyPath, method, value)
    }
    
    @discardableResult
    public func filter<
        Field: QueryableProperty,
        To: FluentKit.Model,
        Through: FluentKit.Model,
        Values: Collection<Field.Value>
    >(
        siblings: KeyPath<Model, SiblingsProperty<Model, To, Through>>,
        _ fieldKeyPath: KeyPath<To, Field>,
        subset: Values,
        inverse: Bool = false
    ) -> Self
    where Field.Model == To, Values.Element == Field.Value {
        self
            .join(siblings: siblings)
            .filter(
                .extendedPath(
                    To.path(for: fieldKeyPath),
                    schema: To.schemaOrAlias,
                    space: nil
                ),
                .subset(inverse: inverse),
                .array(subset.map { .bind($0) })
            )
    }
    
    @discardableResult
    public func filter(_ filter: ModelValueFilter<Model>, if condition: Bool) -> Self {
        condition ? self.filter(Model.self, filter) : self
    }

    @discardableResult
    public func filter<Joined>(
        _ schema: Joined.Type,
        _ filter: ModelValueFilter<Joined>,
        if condition: Bool
    ) -> Self
        where Joined: Schema
    {
        condition ? self.filter(schema, filter) : self
    }
}
