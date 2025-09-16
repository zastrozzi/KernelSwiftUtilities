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
    public func paginatedSort(orderBy: String, order: KPPaginationOrder, limit: Int, offset: Int) -> Self {
        limit == 0
        ? self.sort(.string(orderBy), order.asSortDirection)
        : self
            .sort(.string(orderBy), order.asSortDirection)
            .limit(limit)
            .offset(offset)
    }
    
    @discardableResult
    public func paginatedSort<Field: QueryableProperty>(orderBy: KeyPath<Model, Field>, order: KPPaginationOrder, limit: Int, offset: Int) -> Self where Field.Model == Model {
        return self
            .sort(orderBy, order.asSortDirection)
            .limit(limit)
            .offset(offset)
    }
    
    @discardableResult
    public func paginatedSort(_ pagination: DefaultPaginatedQueryParams? = nil) -> Self {
        if let pagination {
            return self.paginatedSort(orderBy: pagination.orderBy, order: pagination.order, limit: pagination.limit, offset: pagination.offset)
        } else { return self }
    }
}
