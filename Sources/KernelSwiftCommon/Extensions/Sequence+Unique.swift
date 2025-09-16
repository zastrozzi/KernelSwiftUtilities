//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 09/01/2022.
//

import Foundation

extension Sequence {
    @inlinable
    internal func uniqueCountInternal<Subject: Hashable>(on projection: (Element) throws -> Subject) rethrows -> Int {
        Set<Subject>(try self.map { try projection($0) }).count
    }
    
    @inlinable
    public func uniqueCount() -> Int where Element: Hashable { uniqueCountInternal { $0 } }
    
    @inlinable
    public func uniqueCount<Subject: Hashable>(on projection: (Element) throws -> Subject) rethrows -> Int {
        try uniqueCountInternal(on: projection)
    }
    
    @inlinable
    public func uniqueCount(on projection: (Element) throws -> Bool) rethrows -> Int {
        try uniqueCountInternal(on: projection)
    }
}
