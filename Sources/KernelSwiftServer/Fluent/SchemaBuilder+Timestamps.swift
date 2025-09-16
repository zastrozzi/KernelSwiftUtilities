//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 09/12/2023.
//

import FluentSQL
import FluentPostgresDriver
import Vapor

extension SchemaBuilder.TimestampFieldMetadata {
    public enum DataType {
        case datetime
        case string
        case double
        
        public var databaseSchemaDataType: DatabaseSchema.DataType {
            switch self {
            case .datetime: .datetime
            case .string: .string
            case .double: .double
            }
        }
    }
}

extension TimestampTrigger {
    public var isRequiredDefault: Bool {
        switch self {
        case .create, .update: true
        case .delete, .none: false
        }
    }
    
    public var defaultFieldName: String {
        switch self {
        case .create: "db_created_at"
        case .update: "db_updated_at"
        case .delete: "db_deleted_at"
        case .none: preconditionFailure("No default field name for TimestampTrigger.none")
        }
    }
}

extension SchemaBuilder {
    public struct TimestampFieldMetadata {
        public let fieldName: String
        public let trigger: TimestampTrigger
        public let dataType: DataType
//        public let isNullable: Bool
        public let constraints: [DatabaseSchema.FieldConstraint]
        
        public init(_ trigger: TimestampTrigger, _ fieldName: String? = nil, _ dataType: DataType = .datetime, required: Bool? = nil, _ constraints: DatabaseSchema.FieldConstraint...) {
            self.fieldName = fieldName ?? trigger.defaultFieldName
            self.trigger = trigger
            self.dataType = dataType
            var composedContraints: [DatabaseSchema.FieldConstraint] = []
            if constraints.contains(where: {
                if case .required = $0 { true } else { false }
            }) || required == true {
                composedContraints.append(.required)
            } else if required == nil && trigger.isRequiredDefault {
                composedContraints.append(.required)
            }
            composedContraints.append(contentsOf: constraints.filter({ if case .required = $0 { false } else { true }}))
            self.constraints = composedContraints
        }
    }
}

extension SchemaBuilder {
    @discardableResult
    public func timestamps(_ triggerMetadata: [TimestampFieldMetadata] = [.init(.create), .init(.update), .init(.delete)]) -> Self {
        for trigger in triggerMetadata {
            self.field(
                .definition(
                    name: .key(.string(trigger.fieldName)),
                    dataType: trigger.dataType.databaseSchemaDataType,
                    constraints: trigger.constraints
                )
            )
        }
        return self
    }
    
    @discardableResult
    public func timestampsWithDefaults(
        _ triggerMetadata: [TimestampFieldMetadata] = [
            .init(.create, required: true, .sql(.default(SQLFunction("now")))),
            .init(.update, required: true, .sql(.default(SQLFunction("now")))),
            .init(.delete, required: false)
        ]
    ) -> Self {
        for trigger in triggerMetadata {
            self.field(
                .definition(
                    name: .key(.string(trigger.fieldName)),
                    dataType: trigger.dataType.databaseSchemaDataType,
                    constraints: trigger.constraints
                )
            )
        }
        return self
    }
}
