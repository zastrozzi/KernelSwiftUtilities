//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 23/01/2025.
//

import Fluent
import Vapor

public enum QueryField<FluentModel: Model, Field: QueryableProperty> where Field.Model == FluentModel {
    case field(
        _ fieldKeyPath: KeyPath<FluentModel, Field>,
        _ value: Field.Value
    )
    
    public static func id(_ id: FluentModel.IDValue) -> QueryField<FluentModel, FluentModel.ID<FluentModel.IDValue>> {
        .field(\._$id, id)
    }
    
    public var fieldKeyPath: KeyPath<FluentModel, Field> {
        switch self {
        case let .field(path, _):
            return path
        }
    }
    
    public var value: Field.Value {
        switch self {
        case let .field(_, value):
            return value
        }
    }
    
    public var fieldType: Field.Type {
        Field.self
    }
    
    public func forModel<OtherModel: Model, OtherField: QueryableProperty, MatchingField: QueryableProperty>(
        matching matchingFieldKeyPath: KeyPath<FluentModel, MatchingField>,
        _ otherModelType: OtherModel.Type = OtherModel.self,
        _ otherKeyPath: KeyPath<OtherModel, OtherField>,
        _ otherFieldType: OtherField.Type = OtherField.self
    ) -> QueryField<OtherModel, OtherField>? where OtherField.Model == OtherModel, MatchingField.Model == FluentModel {
        guard fieldKeyPath == matchingFieldKeyPath else { return nil }
        return .field(otherKeyPath, value as! OtherField.Value)
    }
    
    public func forModel<OtherModel: Model, OtherField: QueryableProperty>(
        _ otherModelType: OtherModel.Type = OtherModel.self,
        _ otherKeyPath: KeyPath<OtherModel, OtherField>,
        _ otherFieldType: OtherField.Type = OtherField.self
    ) -> QueryField<OtherModel, OtherField> where OtherField.Model == OtherModel {
        .field(otherKeyPath, value as! OtherField.Value)
    }
}

public enum ConditionalQueryField<FluentModel: Model, TrueField: QueryableProperty, FalseField: QueryableProperty>: Sendable where TrueField.Model == FluentModel, FalseField.Model == FluentModel {
    case field(
        _ condition: Bool,
        _ trueFieldKeyPath: KeyPath<FluentModel, TrueField>,
        _ falseFieldKeyPath: KeyPath<FluentModel, FalseField>,
        _ trueValue: TrueField.Value,
        _ falseValue: FalseField.Value
    )
    
    public var trueFieldKeyPath: KeyPath<FluentModel, TrueField> {
        switch self {
        case let .field(_, path, _, _, _):
            return path
        }
    }
    
    public var falseFieldKeyPath: KeyPath<FluentModel, FalseField> {
        switch self {
        case let .field(_, _, path, _, _):
            return path
        }
    }
    
    public var trueValue: TrueField.Value {
        switch self {
        case let .field(_, _, _, value, _):
            return value
        }
    }
    
    public var falseValue: FalseField.Value {
        switch self {
        case let .field(_, _, _, _, value):
            return value
        }
    }
    
    public var conditionalTrueValue: TrueField.Value? {
        switch self {
        case let .field(condition, _, _, value, _):
            return condition ? value : nil
        }
    }
    
    public var conditionalFalseValue: FalseField.Value? {
        switch self {
        case let .field(condition, _, _, _, value):
            return condition ? nil : value
        }
    }
    
    public var trueFieldType: TrueField.Type { TrueField.self }
    public var falseFieldType: FalseField.Type { FalseField.self }
    
    public var condition: Bool {
        switch self {
        case let .field(conditionValue, _, _, _, _): conditionValue
        }
    }
    
    public func trueQueryField() -> QueryField<FluentModel, TrueField> {
        .field(trueFieldKeyPath, trueValue)
    }
    
    public func falseQueryField() -> QueryField<FluentModel, FalseField> {
        .field(falseFieldKeyPath, falseValue)
    }
    
    public func forModel<
        OtherModel: Model,
        OtherTrueField: QueryableProperty,
        OtherFalseField: QueryableProperty,
        MatchingTrueField: QueryableProperty,
        MatchingFalseField: QueryableProperty
    >(
        matchingTrue matchingTrueFieldKeyPath: KeyPath<FluentModel, MatchingTrueField>,
        matchingFalse matchingFalseFieldKeyPath: KeyPath<FluentModel, MatchingFalseField>,
        _ otherModelType: OtherModel.Type = OtherModel.self,
        _ otherTrueKeyPath: KeyPath<OtherModel, OtherTrueField>,
        _ otherFalseKeyPath: KeyPath<OtherModel, OtherFalseField>,
        _ otherTrueFieldType: OtherTrueField.Type = OtherTrueField.self,
        _ otherFalseFieldType: OtherFalseField.Type = OtherFalseField.self
    ) throws -> ConditionalQueryField<
        OtherModel,
        OtherTrueField,
        OtherFalseField
    >
    where
        OtherTrueField.Model == OtherModel,
        OtherFalseField.Model == OtherModel,
        MatchingTrueField.Model == FluentModel,
        MatchingFalseField.Model == FluentModel
    {
        guard trueFieldKeyPath == matchingTrueFieldKeyPath else {
            throw ConditionalQueryFieldError.mismatchedKeyPath(trueFieldKeyPath.stringValue, matchingTrueFieldKeyPath.stringValue)
        }
        guard falseFieldKeyPath == matchingFalseFieldKeyPath else {
            throw ConditionalQueryFieldError.mismatchedKeyPath(falseFieldKeyPath.stringValue, matchingFalseFieldKeyPath.stringValue)
        }
        return .field(
            condition,
            otherTrueKeyPath,
            otherFalseKeyPath,
            trueValue as! OtherTrueField.Value,
            falseValue as! OtherFalseField.Value
        )
    }
    
    public enum ConditionalQueryFieldError: Error, CustomStringConvertible {
        case mismatchedKeyPath(_ lhs: String, _ rhs: String)
        
        public var reason: String {
            switch self {
            case let .mismatchedKeyPath(lhs, rhs): "Mismatched Key Paths: \(lhs) != \(rhs)"
            
            }
        }
        
        public var description: String { return "ConditionalQueryField Error: \(self.reason)" }
        public var errorDescription: String? { description }
    }
    
    
}


public typealias ConditionalIDQuery<FluentModel: Model, TrueValue: Equatable & Codable> = ConditionalQueryField<
    FluentModel,
    FieldProperty<FluentModel, TrueValue>,
    IDProperty<FluentModel, UUID>
>

public typealias ConditionalQuery<FluentModel: Model, TrueValue: Equatable & Codable, FalseValue: Equatable & Codable> = ConditionalQueryField<
    FluentModel,
    FieldProperty<FluentModel, TrueValue>,
    FieldProperty<FluentModel, FalseValue>
>

public enum QueryFieldPropertyType {
    case id
    case field
    case foreignKey
}
