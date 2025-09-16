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
    public func search(_ fieldKey: String, searchTerm: String) -> Self {
        return self.filter(.string(fieldKey), .custom("ilike"), "%\(searchTerm)%")
    }
    
    @discardableResult
    public func search<Field: QueryableProperty>(_ fieldKeyPath: KeyPath<Model, Field>, searchTerm: String) -> Self where Field.Model == Model, Field.Value == String {
        return self.filter(.extendedPath(Model.path(for: fieldKeyPath), schema: Model.schemaOrAlias, space: Model.space), .custom("ilike"), Field.queryValue("%\(searchTerm)%"))
    }
    
    @discardableResult
    public func search(_ fieldKeys: [String], searchTerm: String) -> Self {
        guard !fieldKeys.isEmpty else { return self }
        return self.group(.or) { searchOr in
            fieldKeys.forEach { fieldKey in
                searchOr.search(fieldKey, searchTerm: searchTerm)
            }
        }
    }
    
    @discardableResult
    public func search<Field: QueryableProperty>(_ fieldKeys: [KeyPath<Model, Field>], searchTerm: String) -> Self where Field.Model == Model, Field.Value == String {
        guard !fieldKeys.isEmpty else { return self }
        return self.group(.or) { searchOr in
            fieldKeys.forEach { fieldKey in
                searchOr.search(fieldKey, searchTerm: searchTerm)
            }
        }
    }
}
