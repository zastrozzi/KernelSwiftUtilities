//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 14/06/2023.
//

import FluentKit

infix operator <~~ // Equivalent to <@ in postgres
infix operator ~~> // Equivalent to @> in postgres
infix operator <&&> // Equivalent to && in postgres

// Does the first array contain the second, that is, does each element appearing in the second array equal some element of the first array?
public func ~~> <Model, Field, Values>(
    lhs: KeyPath<Model, Field>,
    rhs: Values
) -> ModelValueFilter<Model> where
    Model: FluentKit.Schema,
    Field: QueryableProperty,
    Values: Collection,
    Field.Value: Collection,
    Values.Element == Field.Value.Element,
    Values.Element: FluentEnumConvertible
{
    .init(lhs, .custom("@>"), .enumCase("{" + "\(rhs.map { $0.rawValue }.joined(separator: ","))" + "}"))
}

// Is the first array contained by the second?
public func <~~ <Model, Field, Values>(
    lhs: KeyPath<Model, Field>,
    rhs: Values
) -> ModelValueFilter<Model> where
    Model: FluentKit.Schema,
    Field: QueryableProperty,
    Values: Collection,
    Field.Value: Collection,
    Values.Element == Field.Value.Element,
    Values.Element: FluentEnumConvertible
{
    .init(lhs, .custom("<@"), .enumCase("{" + "\(rhs.map { $0.rawValue }.joined(separator: ","))" + "}"))
}

// Do the two arrays have any elements in common?
public func <&&> <Model, Field, Values>(
    lhs: KeyPath<Model, Field>,
    rhs: Values
) -> ModelValueFilter<Model> where
    Model: FluentKit.Schema,
    Field: QueryableProperty,
    Values: Collection,
    Field.Value: Collection,
    Values.Element == Field.Value.Element,
    Values.Element: FluentEnumConvertible
{
    .init(lhs, .custom("&&"), .enumCase("{" + "\(rhs.map { $0.rawValue }.joined(separator: ","))" + "}"))
}
