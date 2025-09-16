//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 10/05/2023.
//

import Foundation
import Vapor

extension Routes {
    public func matching(exactly: Bool = false, _ components: [PathComponent]) -> [Route] {
        let comparator: (PathComponent, PathComponent) -> Bool = { leftEl, rightEl in
            let leftEl = leftEl as any Equatable, rightEl = rightEl as any Equatable
            return leftEl.isEqual(rightEl)
        }
        return all.filter { exactly ? $0.path.elementsEqual(components, by: comparator) : $0.path.starts(with: components, by: comparator) }
    }
    
    public func matching(exactly: Bool = false, _ components: [TypedPathComponent]) -> [Route] {
        return matching(exactly: exactly, components.map { $0.vaporPathComponent })
    }
    
    public func matching(exactly: Bool = false, _ components: PathComponent...) -> [Route] {
        return matching(exactly: exactly, components)
    }
    
    public func matching(exactly: Bool = false, _ components: TypedPathComponent...) -> [Route] {
        return matching(exactly: exactly, components)
    }
}
