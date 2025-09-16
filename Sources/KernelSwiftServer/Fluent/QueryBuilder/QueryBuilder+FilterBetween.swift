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
    public func filterBetween<FieldValue: Codable & Sendable>(_ fieldKey: String, lower: FieldValue, lowerInclusive: Bool = false, upper: FieldValue, upperInclusive: Bool = false) -> Self {
        return self.group(.and) { filterAnd in
            filterAnd.filter(.string(fieldKey), lowerInclusive ? .greaterThanOrEqual : .greaterThan, lower)
            filterAnd.filter(.string(fieldKey), upperInclusive ? .lessThanOrEqual : .lessThan, upper)
        }
    }
    
    @discardableResult
    public func filterBetween<Field: QueryableProperty>(_ fieldKeyPath: KeyPath<Model, Field>, lower: Field.Value, lowerInclusive: Bool = false, upper: Field.Value, upperInclusive: Bool = false) -> Self where Field.Model == Model {
        return self.group(.and) { filterAnd in
            filterAnd.filter(fieldKeyPath, lowerInclusive ? .greaterThanOrEqual : .greaterThan, lower)
            filterAnd.filter(fieldKeyPath, upperInclusive ? .lessThanOrEqual : .lessThan, upper)
        }
    }
}
