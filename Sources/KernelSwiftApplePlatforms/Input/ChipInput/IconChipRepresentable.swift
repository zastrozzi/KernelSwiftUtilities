//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/08/2023.
//

import Foundation
import SwiftUI

public protocol IconChipRepresentable: Identifiable, Equatable, CaseIterable, Hashable {
    var image: String { get }
    var title: String { get }
    var color: Color { get }
    var identifier: String { get }
}

extension IconChipRepresentable {
    public static func == (lhs: Self, rhs: any IconChipRepresentable) -> Bool {
        lhs.id == (rhs as! Self).id
    }
    
    public static func == (lhs: any IconChipRepresentable, rhs: Self) -> Bool {
        rhs.id == (lhs as! Self).id
    }
    
    public var identifier: String { self.id as! String }
}

extension Binding {
    public func erased<Underlying: IconChipRepresentable & Sendable>() -> Binding<(any IconChipRepresentable)?> where Value == Underlying? {
        .init {
            wrappedValue
        } set: {
            wrappedValue = $0 as? Underlying
        }
    }
}
