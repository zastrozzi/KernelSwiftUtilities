//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 11/09/2023.
//

import Foundation

extension Sequence {
    public func asyncForEach(_ operation: (Element) async throws -> Void) async rethrows {
        for element in self { try await operation(element) }
    }
}
