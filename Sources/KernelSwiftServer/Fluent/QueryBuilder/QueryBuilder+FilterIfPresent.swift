//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 28/01/2025.
//

import Foundation
import Vapor
import Fluent
import SQLKit

extension QueryBuilder {
    @discardableResult
    public func filterIfPresent<Field: QueryableProperty>(_ fieldKeyPath: KeyPath<Model, Field>, _ method: DatabaseQuery.Filter.Method, _ value: Field.Value? = nil) -> Self where Field.Model == Model {
        guard let value else { return self }
        return self.filter(fieldKeyPath, method, value)
    }
    
    @discardableResult
    public func filterIfPresent<Field: QueryableProperty, Value>(_ fieldKeyPath: KeyPath<Model, Field>, _ method: DatabaseQuery.Filter.Method, _ value: Value? = nil) -> Self where Field.Model == Model, Field.Value == Optional<Value> {
        guard let value else { return self }
        return self.filter(fieldKeyPath, method, value)
    }
    
    @discardableResult
    public func filterOptionalIfPresent<Field: QueryableProperty>(_ fieldKeyPath: KeyPath<Model, Field>, _ method: DatabaseQuery.Filter.Method, _ value: Field.Value?? = nil) -> Self where Field.Model == Model {
        guard let value else { return self }
        guard let value else { return self }
        return self.filter(fieldKeyPath, method, value)
    }
    
    @discardableResult
    public func filterIfPresent<Field: QueryableProperty>(_ fieldKeyPath: KeyPath<Model, Field>, _ method: DatabaseQuery.Filter.Method, _ value: [Field.Value]? = nil) -> Self where Field.Model == Model, Field.Value: FluentEnumConvertible {
        guard let value else  { return self }
        return self.filter(.extendedPath(
            Model.path(for: fieldKeyPath),
            schema: Model.schemaOrAlias,
            space: Model._spaceIfNotAliased
        ), method, .array(value.map { .enumCase($0.rawValue) }))
    }
    
    @discardableResult
    public func filterIfPresent<Field: QueryableProperty>(_ fieldKeyPath: KeyPath<Model, Field>, _ method: DatabaseQuery.Filter.Method, _ value: [Field.Value]? = nil) -> Self where Field.Model == Model, Field.Value == Model.IDValue {
        guard let value else  { return self }
        return self.filter(.extendedPath(
            Model.path(for: fieldKeyPath),
            schema: Model.schemaOrAlias,
            space: Model._spaceIfNotAliased
        ), method, .array(value.map { .bind($0) }))
    }
    
    @discardableResult
    public func filterIfPresent<Field: QueryableProperty>(_ fieldKeyPath: KeyPath<Model, Field>, enumFilters: FluentEnumFilterQueryParamObject<Field.Value>? = nil) -> Self where Field.Value: FluentStringEnum {
        guard let enumFilters else { return self }
        var newSelf = self
        if let equal = enumFilters.equalTo {
            newSelf = self.filter(.extendedPath(
                Model.path(for: fieldKeyPath),
                schema: Model.schemaOrAlias,
                space: Model._spaceIfNotAliased
            ), .equal, .enumCase(equal.rawValue))
        }
        if let inValues = enumFilters.inValues {
            newSelf = self.filter(.extendedPath(
                Model.path(for: fieldKeyPath),
                schema: Model.schemaOrAlias,
                space: Model._spaceIfNotAliased
            ), .subset(inverse: false), .array(inValues.map { .enumCase($0.rawValue) }))
        }
        if let notInValues = enumFilters.notInValues {
            newSelf = self.filter(.extendedPath(
                Model.path(for: fieldKeyPath),
                schema: Model.schemaOrAlias,
                space: Model._spaceIfNotAliased
            ), .subset(inverse: true), .array(notInValues.map { .enumCase($0.rawValue) }))
        }
        return newSelf
    }
    
    @discardableResult
    public func filterIfPresent<Field: QueryableProperty, Enum: FluentStringEnum>(_ fieldKeyPath: KeyPath<Model, Field>, enumFilters: FluentEnumFilterQueryParamObject<Enum>? = nil) -> Self where Field.Value == Optional<Enum> {
        guard let enumFilters else { return self }
        var newSelf = self
        if let equal = enumFilters.equalTo {
            newSelf = self.filter(.extendedPath(
                Model.path(for: fieldKeyPath),
                schema: Model.schemaOrAlias,
                space: Model._spaceIfNotAliased
            ), .equal, .enumCase(equal.rawValue))
        }
        if let inValues = enumFilters.inValues {
            newSelf = self.filter(.extendedPath(
                Model.path(for: fieldKeyPath),
                schema: Model.schemaOrAlias,
                space: Model._spaceIfNotAliased
            ), .subset(inverse: false), .array(inValues.map { .enumCase($0.rawValue) }))
        }
        if let notInValues = enumFilters.notInValues {
            newSelf = self.filter(.extendedPath(
                Model.path(for: fieldKeyPath),
                schema: Model.schemaOrAlias,
                space: Model._spaceIfNotAliased
            ), .subset(inverse: true), .array(notInValues.map { .enumCase($0.rawValue) }))
        }
        return newSelf
    }
    
    @discardableResult
    public func filterIfPresent<Field: QueryAddressableProperty & QueryableProperty, Enum: FluentStringEnum>(_ fieldKeyPath: KeyPath<Model, Field>, enumFilters: FluentEnumArrayFilterQueryParamObject<Enum>? = nil) -> Self where Field.Value == Array<Enum> {
        guard let enumFilters else { return self }
        var newSelf = self
        
        if let equalValues = enumFilters.equalValues {
            newSelf = self.filter(fieldKeyPath <~~ equalValues).filter(fieldKeyPath ~~> equalValues)
        }
        if let inValues = enumFilters.inValues { newSelf = self.filter(fieldKeyPath <~~ inValues) }
        if let anyValues = enumFilters.anyValues { newSelf = self.filter(fieldKeyPath <&&> anyValues) }
        if let allValues = enumFilters.allValues { newSelf = self.filter(fieldKeyPath ~~> allValues) }
        if let notInValues = enumFilters.notInValues { newSelf = self.filter(fieldKeyPath, notIn: notInValues) }
        return newSelf
    }
    
    @discardableResult
    public func filterIfPresent<Field: QueryableProperty>(_ fieldKeyPath: KeyPath<Model, Field>, dateFilters: DateFilterQueryParamObject? = nil) -> Self where Field.Model == Model, Field.Value.Type == Date.Type {
        guard let dateFilters else { return self }
        var newSelf = self
        if let equal = dateFilters.equalTo {
            newSelf = self.filter(fieldKeyPath, .equal, equal)
        }
        if let lessThan = dateFilters.lessThan {
            newSelf = self.filter(fieldKeyPath, .lessThan, lessThan)
        }
        if let greaterThan = dateFilters.greaterThan {
            newSelf = self.filter(fieldKeyPath, .greaterThan, greaterThan)
        }
        return newSelf
    }
    
    
    @discardableResult
    public func filterIfPresent<Field: QueryableProperty>(_ fieldKeyPath: KeyPath<Model, Field>, dateFilters: DateFilterQueryParamObject? = nil) -> Self where Field.Model == Model, Field.Value.Type == Optional<Date>.Type {
        guard let dateFilters else { return self }
        var newSelf = self
        if let equal = dateFilters.equalTo {
            newSelf = self.filter(fieldKeyPath, .equal, equal)
        }
        if let lessThan = dateFilters.lessThan {
            newSelf = self.filter(fieldKeyPath, .lessThan, lessThan)
        }
        if let greaterThan = dateFilters.greaterThan {
            newSelf = self.filter(fieldKeyPath, .greaterThan, greaterThan)
        }
        return newSelf
    }
    
    @discardableResult
    public func filterIfPresent<Field: QueryableProperty>(_ fieldKeyPath: KeyPath<Model, Field>, stringFilters: StringFilterQueryParamObject? = nil) -> Self where Field.Model == Model, Field.Value.Type == String.Type {
        guard let stringFilters else { return self }
        var newSelf = self
        if let equal = stringFilters.equalTo {
            newSelf = self.filter(fieldKeyPath, .equal, equal)
        }
        if let like = stringFilters.contains {
            newSelf = self.filter(fieldKeyPath, .custom("ilike"), "%\(like)%")
        }
        return newSelf
    }
    
    @discardableResult
    public func filterIfPresent<Field: QueryableProperty>(_ fieldKeyPath: KeyPath<Model, Field>, stringFilters: StringFilterQueryParamObject? = nil) -> Self where Field.Model == Model, Field.Value.Type == Optional<String>.Type {
        guard let stringFilters else { return self }
        var newSelf = self
        if let equal = stringFilters.equalTo {
            newSelf = self.filter(fieldKeyPath, .equal, equal)
        }
        if let like = stringFilters.contains {
            newSelf = self.filter(fieldKeyPath, .custom("ilike"), "%\(like)%")
        }
        return newSelf
    }
    
    @discardableResult
    public func filterIfPresent<Field: QueryableProperty, NumericType: Numeric & Codable>(_ fieldKeyPath: KeyPath<Model, Field>, numericFilters: NumericFilterQueryParamObject<NumericType>? = nil) -> Self where Field.Model == Model, Field.Value.Type == NumericType.Type {
        guard let numericFilters else { return self }
        var newSelf = self
        if let equal = numericFilters.equalTo {
            newSelf = self.filter(fieldKeyPath, .equal, equal)
        }
        if let lessThan = numericFilters.lessThan {
            newSelf = self.filter(fieldKeyPath, .lessThan, lessThan)
        }
        if let greaterThan = numericFilters.greaterThan {
            newSelf = self.filter(fieldKeyPath, .greaterThan, greaterThan)
        }
        if let lessThanOrEqualTo = numericFilters.lessThanOrEqualTo {
            newSelf = self.filter(fieldKeyPath, .lessThanOrEqual, lessThanOrEqualTo)
        }
        if let greaterThanOrEqualTo = numericFilters.greaterThanOrEqualTo {
            newSelf = self.filter(fieldKeyPath, .greaterThanOrEqual, greaterThanOrEqualTo)
        }
        return newSelf
    }
    
    @discardableResult
    public func filterIfPresent<Field: QueryableProperty, NumericType: Numeric & Codable>(_ fieldKeyPath: KeyPath<Model, Field>, numericFilters: NumericFilterQueryParamObject<NumericType>? = nil) -> Self where Field.Value == Optional<NumericType> {
        guard let numericFilters else { return self }
        var newSelf = self
        if let equal = numericFilters.equalTo {
            newSelf = self.filter(.extendedPath(
                Model.path(for: fieldKeyPath),
                schema: Model.schemaOrAlias,
                space: Model._spaceIfNotAliased
            ), .equal, .bind(equal))
        }
        if let lessThan = numericFilters.lessThan {
            newSelf = self.filter(.extendedPath(
                Model.path(for: fieldKeyPath),
                schema: Model.schemaOrAlias,
                space: Model._spaceIfNotAliased
            ), .lessThan, .bind(lessThan))
        }
        if let greaterThan = numericFilters.greaterThan {
            newSelf = self.filter(.extendedPath(
                Model.path(for: fieldKeyPath),
                schema: Model.schemaOrAlias,
                space: Model._spaceIfNotAliased
            ), .greaterThan, .bind(greaterThan))
        }
        if let lessThanOrEqualTo = numericFilters.lessThanOrEqualTo {
            newSelf = self.filter(.extendedPath(
                Model.path(for: fieldKeyPath),
                schema: Model.schemaOrAlias,
                space: Model._spaceIfNotAliased
            ), .lessThanOrEqual, .bind(lessThanOrEqualTo))
        }
        if let greaterThanOrEqualTo = numericFilters.greaterThanOrEqualTo {
            newSelf = self.filter(.extendedPath(
                Model.path(for: fieldKeyPath),
                schema: Model.schemaOrAlias,
                space: Model._spaceIfNotAliased
            ), .greaterThanOrEqual, .bind(greaterThanOrEqualTo))
        }
        return newSelf
    }
    
    @discardableResult
    public func filterIfPresent<Field: QueryableProperty, To: FluentKit.Model, Through: FluentKit.Model>(siblings: KeyPath<Model, SiblingsProperty<Model, To, Through>>, _ fieldKeyPath: KeyPath<To, Field>, _ method: DatabaseQuery.Filter.Method, _ value: Field.Value? = nil) -> Self where Field.Model == To {
        guard let value else  { return self }
        return self.join(siblings: siblings).filter(To.self, fieldKeyPath, method, value)
    }
    
    @discardableResult
    public func filterIfPresent<Joined, Field>(
        _ joined: Joined.Type,
        _ field: KeyPath<Joined, Field>,
        _ method: DatabaseQuery.Filter.Method,
        _ value: Field.Value? = nil
    ) -> Self
        where Joined: Schema, Field: QueryableProperty, Field.Model == Joined
    {
        guard let value else { return self }
        return self.filter(joined, field, method, value)
    }
    
    @discardableResult
    public func filterIfPresent<Joined, Field, Value>(
        _ joined: Joined.Type,
        _ field: KeyPath<Joined, Field>,
        _ method: DatabaseQuery.Filter.Method,
        _ value: Value? = nil
    ) -> Self
        where Joined: Schema, Field: QueryableProperty, Field.Model == Joined, Field.Value == Optional<Value>
    {
        guard let value else { return self }
        return self.filter(joined, field, method, value)
    }
    
    @discardableResult
    public func filterIfPresent<Field>(
        _ queryField: QueryField<Model, Field>? = nil,
        _ method: DatabaseQuery.Filter.Method
    ) -> Self {
        guard let queryField else { return self }
        switch queryField {
        case let .field(keyPath, value): return self.filter(keyPath, method, value)
//        case let .id(value): self.filter(\._$id, method, value)
        }
    }
}

extension QueryBuilder {
    public func filter<Field: QueryAddressableProperty, Enum: FluentStringEnum>(
        _ fieldKeyPath: KeyPath<Model, Field>,
        notIn values: [Enum]
    ) -> Self where Field.Value == Array<Enum> {
        self.filter(.sql(
            SQLUnaryExpression(
                .not,
                SQLGroupExpression(
                    SQLBinaryExpression(
                        left: SQLColumn(
                            SQLIdentifier(Model.path(for: fieldKeyPath.appending(path: \.queryableProperty))[0].description),
                            table: SQLQualifiedTable(Model.schemaOrAlias, space: Model._spaceIfNotAliased)
                        ),
                        op: SQLRaw("&&"),
                        right: SQLRaw("'{" + values.map { $0.rawValue }.joined(separator: ",") + "}'")
                    )
                )
            )
        ))
    }
}
