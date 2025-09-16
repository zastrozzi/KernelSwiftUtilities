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
    public func join<Foreign>(
        _ foreign: Foreign.Type,
        on filter: ComplexJoinFilter,
        method: DatabaseQuery.Join.Method = .inner,
        if condition: Bool
    ) -> Self where Foreign: Schema {
        condition ? self.join(Foreign.self, on: filter, method: method) : self
    }
}
