//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 21/01/2025.
//

import OpenAPIKit30

extension JSONSchema {
    public func optionalSchemaObject(withNilExample: Bool) -> JSONSchema {
        guard withNilExample else { return optionalSchemaObject() }
        switch self.value {
        case .boolean(let context):
            return .boolean(context.optionalContext().with(example: .init(nil as Any?)))
        case .object(let contextA, let contextB):
            return .object(contextA.optionalContext().with(example: .init(nil as Any?)), contextB)
        case .array(let contextA, let contextB):
            return .array(contextA.optionalContext().with(example: .init(nil as Any?)), contextB)
        case .number(let context, let contextB):
            return .number(context.optionalContext().with(example: .init(nil as Any?)), contextB)
        case .integer(let context, let contextB):
            return .integer(context.optionalContext().with(example: .init(nil as Any?)), contextB)
        case .string(let context, let contextB):
            return .string(context.optionalContext().with(example: .init(nil as Any?)), contextB)
        case .fragment(let context):
            return .fragment(context.optionalContext().with(example: .init(nil as Any?)))
//        case .all(of: let fragments, core: let core):
//            return .all(of: fragments.map { $0.optionalSchemaObject(withNilExample: true) }, core: core.optionalContext().with(example: .init(nil as Any?)))
//        case .one(of: let schemas, core: let core):
//            return .one(of: schemas, core: core.optionalContext().with(example: .init(nil as Any?)))
//        case .any(of: let schemas, core: let core):
//            return .any(of: schemas, core: core.optionalContext().with(example: .init(nil as Any?)))
        case .not(let schema, core: let core):
            return .not(schema, core: core.optionalContext().with(example: .init(nil as Any?)))
        case .reference:
            return self
        default: return optionalSchemaObject()
        }
    }
}
