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
    public func includeDeleted(_ withDeleted: Bool = true) -> Self {
        withDeleted ? self.withDeleted() : self
    }
    
    @discardableResult
    public func includeDeletedIfPresent(_ withDeleted: Bool? = nil) -> Self {
        if let withDeleted { self.includeDeleted(withDeleted) } else { self }
    }
}
