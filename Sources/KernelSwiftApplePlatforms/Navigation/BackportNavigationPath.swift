//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 31/08/2022.
//

import Foundation
import SwiftUI

#if compiler(>=5.7)
@available(iOS, deprecated: 17.0, message: "Use SwiftUI Navigation API")
public struct BackportNavigationPath {
    var elements: [any Hashable]
    
    public var count: Int { elements.count }
    public var isEmpty: Bool { elements.isEmpty }
    
    public init(_ elements: [any Hashable] = []) {
        self.elements = elements
    }
    
    public init<S: Sequence>(_ elements: S) where S.Element: Hashable {
        self.init(elements.map(AnyHashable.init))
    }
    
    public mutating func append<V: Hashable>(_ value: V) {
        elements.append(value)
    }
    
    public mutating func removeLast(_ k: Int = 1) {
        elements.removeLast(k)
    }
}
#endif
