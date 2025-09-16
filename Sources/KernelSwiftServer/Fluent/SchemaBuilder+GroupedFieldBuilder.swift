//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/12/2023.
//

import FluentKit

extension SchemaBuilder {
    public class GroupedFieldBuilder {
        var definitions: [DatabaseSchema.FieldDefinition] = []
        var deleteFields: [DatabaseSchema.FieldName] = []
        
        public init(definitions: [DatabaseSchema.FieldDefinition] = [], deleteFields: [DatabaseSchema.FieldName] = []) {
            self.definitions = definitions
            self.deleteFields = deleteFields
        }
        
        public static func field(
            _ key: FieldKey,
            _ dataType: DatabaseSchema.DataType,
            _ constraints: DatabaseSchema.FieldConstraint...
        ) -> GroupedFieldBuilder { .init(definitions: [.definition(name: .key(key), dataType: dataType, constraints: constraints)]) }
        
        public static func deleteField(_ key: FieldKey) -> GroupedFieldBuilder {
            .init(deleteFields: [.key(key)])
        }
        
        public static func group(_ key: FieldKey, _ updateBuilder: (GroupedFieldBuilder) -> Void) -> GroupedFieldBuilder {
            let builder: GroupedFieldBuilder = .init()
            let returnBuilder: GroupedFieldBuilder = .init()
            updateBuilder(builder)
            for groupedField in builder.definitions {
                if
                    case let .definition(name, dataType, constraints) = groupedField,
                    case let .key(nameAsKey) = name
                {
                    returnBuilder.definitions.append(.definition(name: .key(.groupPrefix(key, nameAsKey)), dataType: dataType, constraints: constraints))
                }
            }
            for groupedDeleteField in builder.deleteFields {
                if
                    case let .key(nameAsKey) = groupedDeleteField
                {
                    returnBuilder.deleteFields.append(.key(.groupPrefix(key, nameAsKey)))
                }
            }
            return returnBuilder
        }
        
        public static func group(_ key: FieldKey, _ makeBuilder: () -> GroupedFieldBuilder) -> GroupedFieldBuilder {
            let builder: GroupedFieldBuilder = makeBuilder()
            let returnBuilder: GroupedFieldBuilder = .init()
            for groupedField in builder.definitions {
                if
                    case let .definition(name, dataType, constraints) = groupedField,
                    case let .key(nameAsKey) = name
                {
                    returnBuilder.definitions.append(.definition(name: .key(.groupPrefix(key, nameAsKey)), dataType: dataType, constraints: constraints))
                }
            }
            for groupedDeleteField in builder.deleteFields {
                if
                    case let .key(nameAsKey) = groupedDeleteField
                {
                    returnBuilder.deleteFields.append(.key(.groupPrefix(key, nameAsKey)))
                }
            }
            return returnBuilder
        }
        
        public static func group(_ key: FieldKey, _ definitions: [DatabaseSchema.FieldDefinition]) -> GroupedFieldBuilder {
            let returnBuilder: GroupedFieldBuilder = .init()
            for groupedField in definitions {
                if
                    case let .definition(name, dataType, constraints) = groupedField,
                    case let .key(nameAsKey) = name
                {
                    returnBuilder.definitions.append(.definition(name: .key(.groupPrefix(key, nameAsKey)), dataType: dataType, constraints: constraints))
                }
            }
            return returnBuilder
        }
        
        public static func optionalGroup(_ key: FieldKey, _ updateBuilder: (GroupedFieldBuilder) -> Void) -> GroupedFieldBuilder {
            let builder: GroupedFieldBuilder = .init()
            let returnBuilder: GroupedFieldBuilder = .init()
            updateBuilder(builder)
            for groupedField in builder.definitions {
                if
                    case let .definition(name, dataType, constraints) = groupedField,
                    case let .key(nameAsKey) = name
                {
                    var optionalConstraints: [DatabaseSchema.FieldConstraint] = []
                    constraints.forEach { constraint in
                        switch constraint {
                        case .required: break
                        default: optionalConstraints.append(constraint)
                        }
                    }
                    returnBuilder.definitions.append(.definition(name: .key(.groupPrefix(key, nameAsKey)), dataType: dataType, constraints: optionalConstraints))
                }
            }
            for groupedDeleteField in builder.deleteFields {
                if
                    case let .key(nameAsKey) = groupedDeleteField
                {
                    returnBuilder.deleteFields.append(.key(.groupPrefix(key, nameAsKey)))
                }
            }
            return returnBuilder
        }
        
        public static func optionalGroup(_ key: FieldKey, _ makeBuilder: () -> GroupedFieldBuilder) -> GroupedFieldBuilder {
            let builder: GroupedFieldBuilder = makeBuilder()
            let returnBuilder: GroupedFieldBuilder = .init()
            for groupedField in builder.definitions {
                if
                    case let .definition(name, dataType, constraints) = groupedField,
                    case let .key(nameAsKey) = name
                {
                    var optionalConstraints: [DatabaseSchema.FieldConstraint] = []
                    constraints.forEach { constraint in
                        switch constraint {
                        case .required: break
                        default: optionalConstraints.append(constraint)
                        }
                    }
                    returnBuilder.definitions.append(.definition(name: .key(.groupPrefix(key, nameAsKey)), dataType: dataType, constraints: optionalConstraints))
                }
            }
            for groupedDeleteField in builder.deleteFields {
                if
                    case let .key(nameAsKey) = groupedDeleteField
                {
                    returnBuilder.deleteFields.append(.key(.groupPrefix(key, nameAsKey)))
                }
            }
            return returnBuilder
        }
        
        public static func optionalGroup(_ key: FieldKey, _ definitions: [DatabaseSchema.FieldDefinition]) -> GroupedFieldBuilder {
            let returnBuilder: GroupedFieldBuilder = .init()
            for groupedField in definitions {
                if
                    case let .definition(name, dataType, constraints) = groupedField,
                    case let .key(nameAsKey) = name
                {
                    var optionalConstraints: [DatabaseSchema.FieldConstraint] = []
                    constraints.forEach { constraint in
                        switch constraint {
                        case .required: break
                        default: optionalConstraints.append(constraint)
                        }
                    }
                    returnBuilder.definitions.append(.definition(name: .key(.groupPrefix(key, nameAsKey)), dataType: dataType, constraints: optionalConstraints))
                }
            }
            return returnBuilder
        }

        
        @discardableResult
        public func field(
            _ key: FieldKey,
            _ dataType: DatabaseSchema.DataType,
            _ constraints: DatabaseSchema.FieldConstraint...
        ) -> GroupedFieldBuilder {
            definitions.append(.definition(name: .key(key), dataType: dataType, constraints: constraints))
            return self
        }
        
        @discardableResult
        public func deleteField(_ key: FieldKey) -> GroupedFieldBuilder {
            deleteFields.append(.key(key))
            return self
        }
        
        @discardableResult
        public func group(_ key: FieldKey, _ updateBuilder: (GroupedFieldBuilder) -> Void) -> GroupedFieldBuilder {
            let builder: GroupedFieldBuilder = .init()
            updateBuilder(builder)
            for groupedField in builder.definitions {
                if
                    case let .definition(name, dataType, constraints) = groupedField,
                    case let .key(nameAsKey) = name
                {
                    definitions.append(.definition(name: .key(.groupPrefix(key, nameAsKey)), dataType: dataType, constraints: constraints))
                }
            }
            for groupedDeleteField in builder.deleteFields {
                if
                    case let .key(nameAsKey) = groupedDeleteField
                {
                    deleteFields.append(.key(.groupPrefix(key, nameAsKey)))
                }
            }
            return self
        }
        
        @discardableResult
        public func group(_ key: FieldKey, _ makeBuilder: () -> GroupedFieldBuilder) -> GroupedFieldBuilder {
            let builder: GroupedFieldBuilder = makeBuilder()
            for groupedField in builder.definitions {
                if
                    case let .definition(name, dataType, constraints) = groupedField,
                    case let .key(nameAsKey) = name
                {
                    definitions.append(.definition(name: .key(.groupPrefix(key, nameAsKey)), dataType: dataType, constraints: constraints))
                }
            }
            for groupedDeleteField in builder.deleteFields {
                if
                    case let .key(nameAsKey) = groupedDeleteField
                {
                    deleteFields.append(.key(.groupPrefix(key, nameAsKey)))
                }
            }
            return self
        }
        
        @discardableResult
        public func group(_ key: FieldKey, _ definitions: [DatabaseSchema.FieldDefinition]) -> GroupedFieldBuilder {
            for groupedField in definitions {
                if
                    case let .definition(name, dataType, constraints) = groupedField,
                    case let .key(nameAsKey) = name
                {
                    self.definitions.append(.definition(name: .key(.groupPrefix(key, nameAsKey)), dataType: dataType, constraints: constraints))
                }
            }
            return self
        }
        
        @discardableResult
        public func optionalGroup(_ key: FieldKey, _ updateBuilder: (GroupedFieldBuilder) -> Void) -> GroupedFieldBuilder {
            let builder: GroupedFieldBuilder = .init()
            updateBuilder(builder)
            for groupedField in builder.definitions {
                if
                    case let .definition(name, dataType, constraints) = groupedField,
                    case let .key(nameAsKey) = name
                {
                    var optionalConstraints: [DatabaseSchema.FieldConstraint] = []
                    constraints.forEach { constraint in
                        switch constraint {
                        case .required: break
                        default: optionalConstraints.append(constraint)
                        }
                    }
                    definitions.append(.definition(name: .key(.groupPrefix(key, nameAsKey)), dataType: dataType, constraints: optionalConstraints))
                }
            }
            for groupedDeleteField in builder.deleteFields {
                if
                    case let .key(nameAsKey) = groupedDeleteField
                {
                    deleteFields.append(.key(.groupPrefix(key, nameAsKey)))
                }
            }
            return self
        }
        
        @discardableResult
        public func optionalGroup(_ key: FieldKey, _ makeBuilder: () -> GroupedFieldBuilder) -> GroupedFieldBuilder {
            let builder: GroupedFieldBuilder = makeBuilder()
            for groupedField in builder.definitions {
                if
                    case let .definition(name, dataType, constraints) = groupedField,
                    case let .key(nameAsKey) = name
                {
                    var optionalConstraints: [DatabaseSchema.FieldConstraint] = []
                    constraints.forEach { constraint in
                        switch constraint {
                        case .required: break
                        default: optionalConstraints.append(constraint)
                        }
                    }
                    definitions.append(.definition(name: .key(.groupPrefix(key, nameAsKey)), dataType: dataType, constraints: optionalConstraints))
                }
            }
            for groupedDeleteField in builder.deleteFields {
                if
                    case let .key(nameAsKey) = groupedDeleteField
                {
                    deleteFields.append(.key(.groupPrefix(key, nameAsKey)))
                }
            }
            return self
        }
        
        @discardableResult
        public func optionalGroup(_ key: FieldKey, _ definitions: [DatabaseSchema.FieldDefinition]) -> GroupedFieldBuilder {
            for groupedField in definitions {
                if
                    case let .definition(name, dataType, constraints) = groupedField,
                    case let .key(nameAsKey) = name
                {
                    var optionalConstraints: [DatabaseSchema.FieldConstraint] = []
                    constraints.forEach { constraint in
                        switch constraint {
                        case .required: break
                        default: optionalConstraints.append(constraint)
                        }
                    }
                    self.definitions.append(.definition(name: .key(.groupPrefix(key, nameAsKey)), dataType: dataType, constraints: optionalConstraints))
                }
            }
            return self
        }
        
        public func create() -> [DatabaseSchema.FieldDefinition] { definitions }
    }
}

extension SchemaBuilder {
    @discardableResult
    public func group(_ key: FieldKey, updateBuilder: (GroupedFieldBuilder) -> Void) -> Self {
        let builder: GroupedFieldBuilder = .init()
        updateBuilder(builder)
        for groupedField in builder.definitions {
            if
                case let .definition(name, dataType, constraints) = groupedField,
                case let .key(nameAsKey) = name
            {
                self.field(.definition(name: .key(.groupPrefix(key, nameAsKey)), dataType: dataType, constraints: constraints))
            }
        }
        for groupedDeleteField in builder.deleteFields {
            if
                case let .key(nameAsKey) = groupedDeleteField
            {
                self.deleteField(.key(.groupPrefix(key, nameAsKey)))
            }
        }
        return self
    }
    
    @discardableResult
    public func group(_ key: FieldKey, makeBuilder: () -> GroupedFieldBuilder) -> Self {
        let builder: GroupedFieldBuilder = makeBuilder()
        for groupedField in builder.definitions {
            if
                case let .definition(name, dataType, constraints) = groupedField,
                case let .key(nameAsKey) = name
            {
                self.field(.definition(name: .key(.groupPrefix(key, nameAsKey)), dataType: dataType, constraints: constraints))
            }
        }
        for groupedDeleteField in builder.deleteFields {
            if
                case let .key(nameAsKey) = groupedDeleteField
            {
                self.deleteField(.key(.groupPrefix(key, nameAsKey)))
            }
        }
        return self
    }
    
    @discardableResult
    public func group(_ key: FieldKey, _ definitions: [DatabaseSchema.FieldDefinition]) -> Self {
        for groupedField in definitions {
            if
                case let .definition(name, dataType, constraints) = groupedField,
                case let .key(nameAsKey) = name
            {
                self.field(.definition(name: .key(.groupPrefix(key, nameAsKey)), dataType: dataType, constraints: constraints))
            }
        }
        return self
    }
}

extension SchemaBuilder {
    @discardableResult
    public func optionalGroup(_ key: FieldKey, updateBuilder: (GroupedFieldBuilder) -> Void) -> Self {
        let builder: GroupedFieldBuilder = .init()
        updateBuilder(builder)
        for groupedField in builder.definitions {
            if
                case let .definition(name, dataType, constraints) = groupedField,
                case let .key(nameAsKey) = name
            {
                var optionalConstraints: [DatabaseSchema.FieldConstraint] = []
                constraints.forEach { constraint in
                    switch constraint {
                    case .required: break
                    default: optionalConstraints.append(constraint)
                    }
                }
                self.field(.definition(name: .key(.groupPrefix(key, nameAsKey)), dataType: dataType, constraints: optionalConstraints))
            }
        }
        for groupedDeleteField in builder.deleteFields {
            if
                case let .key(nameAsKey) = groupedDeleteField
            {
                self.deleteField(.key(.groupPrefix(key, nameAsKey)))
            }
        }
        return self
    }
    
    @discardableResult
    public func optionalGroup(_ key: FieldKey, makeBuilder: () -> GroupedFieldBuilder) -> Self {
        let builder: GroupedFieldBuilder = makeBuilder()
        for groupedField in builder.definitions {
            if
                case let .definition(name, dataType, constraints) = groupedField,
                case let .key(nameAsKey) = name
            {
                var optionalConstraints: [DatabaseSchema.FieldConstraint] = []
                constraints.forEach { constraint in
                    switch constraint {
                    case .required: break
                    default: optionalConstraints.append(constraint)
                    }
                }
                self.field(.definition(name: .key(.groupPrefix(key, nameAsKey)), dataType: dataType, constraints: optionalConstraints))
            }
        }
        for groupedDeleteField in builder.deleteFields {
            if
                case let .key(nameAsKey) = groupedDeleteField
            {
                self.deleteField(.key(.groupPrefix(key, nameAsKey)))
            }
        }
        return self
    }
    
    @discardableResult
    public func optionalGroup(_ key: FieldKey, _ definitions: [DatabaseSchema.FieldDefinition]) -> Self {
        for groupedField in definitions {
            if
                case let .definition(name, dataType, constraints) = groupedField,
                case let .key(nameAsKey) = name
            {
                var optionalConstraints: [DatabaseSchema.FieldConstraint] = []
                constraints.forEach { constraint in
                    switch constraint {
                    case .required: break
                    default: optionalConstraints.append(constraint)
                    }
                }
                self.field(.definition(name: .key(.groupPrefix(key, nameAsKey)), dataType: dataType, constraints: optionalConstraints))
            }
        }
        return self
    }
}

extension FieldKey {
    public static func groupPrefix(_ groupKey: FieldKey, _ fieldKey: FieldKey) -> Self {
        .prefix(.prefix(groupKey, "_"), fieldKey)
    }
}
