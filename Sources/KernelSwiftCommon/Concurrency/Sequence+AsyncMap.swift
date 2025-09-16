//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 11/09/2023.
//

import Foundation

extension Sequence {
    
    public func asyncMap<T>(_ transform: @escaping @Sendable (Element) async throws -> T) async rethrows -> [T] {
        var values = [T]()
        for element in self { try await values.append(transform(element)) }
        return values
    }
}
