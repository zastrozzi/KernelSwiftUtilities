//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 31/10/2023.
//

import Foundation

@available(macOS 12, *)
extension AttributeDynamicLookup {
    public subscript<T: AttributedStringKey>(dynamicMember keyPath: KeyPath<KernelSwiftTerminal.Style.AttributeScopes, T>) -> T {
        self[T.self]
    }
}
