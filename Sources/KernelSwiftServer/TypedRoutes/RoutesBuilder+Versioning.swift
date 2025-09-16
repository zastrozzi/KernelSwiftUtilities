//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 14/06/2023.
//

import Vapor

extension RoutesBuilder {
    public func versioned(_ version: String, _ prefix: String? = nil) -> RoutesBuilder {
        if let prefix {
            return self.grouped(.constant(prefix), .constant(version))
        } else {
            return self.grouped(.constant(version))
        }
    }
}
