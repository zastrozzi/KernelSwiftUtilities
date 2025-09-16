//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 28/01/2025.
//

import Foundation
import Vapor
import Fluent

extension QueryBuilder {
    @discardableResult
    public func addFilters(_ otherBuilders: [QueryBuilder<Model>]) -> Self {
        for otherBuilder in otherBuilders {
            if !otherBuilder.query.filters.isEmpty {
                self.query.filters.append(.group(otherBuilder.query.filters, .and))
            }
        }
        return self
    }
    
    @discardableResult
    public func addFilters(_ otherBuilders: QueryBuilder<Model>...) -> Self {
        return self.addFilters(otherBuilders)
    }
}


