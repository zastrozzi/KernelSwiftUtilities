//
//  File.swift
//
//
//  Created by Jonathan Forbes on 05/07/2023.
//

import Fluent
import PostgresNIO
import FluentPostgresDriver
import PostgresKit
import KernelSwiftCommon

extension Fields {
    public typealias OptionalKernelEnumArray<EnumValue> = OptionalKernelEnumArrayProperty<Self, EnumValue> where EnumValue: FluentEnumConvertible
}

@propertyWrapper
public final class OptionalKernelEnumArrayProperty<Model, EnumValue> where Model: FluentKit.Fields, EnumValue: FluentEnumConvertible {
    public let field: OptionalFieldProperty<Model, Array<EnumValue>>
    
    
    public var projectedValue: OptionalKernelEnumArrayProperty<Model, EnumValue> {
        return self
    }
    
    public var wrappedValue: Array<EnumValue>? {
        get {
            self.value ?? nil
        }
        set {
            self.value = .some(newValue)
        }
    }
    
    public init(key: FieldKey) {
        self.field = .init(key: key)
    }
}

extension OptionalKernelEnumArrayProperty: AnyProperty {}

extension OptionalKernelEnumArrayProperty: Property {
    public var value: Array<EnumValue>?? {
        get {
            self.field.value.map { raw in
                return raw
            }
        }
        set {
            self.field.value = newValue??.sorted(\.rawValue)
        }
    }
}

extension OptionalKernelEnumArrayProperty: AnyQueryableProperty {
    public var path: [FieldKey] {
        self.field.path
    }
}

extension OptionalKernelEnumArrayProperty: QueryableProperty {
    public static func queryValue(_ value: Value) -> DatabaseQuery.Value {
        if let value {
            return .enumCase("{" + "\(value.map { $0.rawValue }.joined(separator: ","))" + "}")
        } else {
            return .null
        }
    }
}

extension OptionalKernelEnumArrayProperty: AnyQueryAddressableProperty {
    public var anyQueryableProperty: AnyQueryableProperty { self }
    public var queryablePath: [FieldKey] { self.path }
}

extension OptionalKernelEnumArrayProperty: QueryAddressableProperty {
    public var queryableProperty: OptionalKernelEnumArrayProperty<Model, EnumValue> { self }
}

extension OptionalKernelEnumArrayProperty: AnyDatabaseProperty {
    public var keys: [FieldKey] {
        self.field.keys
    }
    
    public func input(to input: DatabaseInput) {
        let value: DatabaseQuery.Value
        if let fieldValue = self.field.value, let fieldValue {
            value = .array(fieldValue.map { .enumCase($0.rawValue) })
        }
        else { value = .default }
        switch value {
        case .bind(let bind as String):
            input.set(.enumCase(bind), at: self.field.key)
        case .array(let items):
            var transformedCases: [String] = []
            for i in items {
                if case let .enumCase(caseString) = i {
                    transformedCases.append(caseString)
                }
                else if case let .bind(str as String) = i {
                    transformedCases.append(str)
                }
            }
            input.set(.enumCase("{" + transformedCases.joined(separator: ",") + "}"), at: self.field.key)
        case .default:
            input.set(.default, at: self.field.key)
        default:
            fatalError("Unexpected input value type for '\(Model.self)'.'\(self.field.key)': \(value)")
        }
    }
    
    public func output(from output: DatabaseOutput) throws {
        if let stringOutOrig = try? output.decode(self.field.key, as: String.self),
            stringOutOrig.hasPrefix("{"),
            stringOutOrig.hasSuffix("}")
        {
            var stringOut = stringOutOrig
            stringOut.removeFirst(1)
            stringOut.removeLast(1)
            self.field.value = stringOut.split(separator: ",")
                .compactMap { Value.Wrapped.Element.init(rawValue: String($0)) } as? Value ?? [] as! Value
        } else {
            try self.field.output(from: output)
        }
        
    }
}
