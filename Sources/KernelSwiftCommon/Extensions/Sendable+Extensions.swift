//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/09/2023.
//

import Foundation

public struct AnySendable: Sendable {
    public let base: Any & Sendable
    
    @inlinable
    public init<B: Sendable>(base: B) {
        self.base = base
    }
}
