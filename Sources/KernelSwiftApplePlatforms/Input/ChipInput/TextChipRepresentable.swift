//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 06/03/2025.
//

import Foundation
import SwiftUI

public protocol TextChipRepresentable: Identifiable, Equatable, CaseIterable, Hashable {
    var title: String { get }
    var color: Color { get }
    var identifier: String { get }
}

extension TextChipRepresentable {
    public static func == (lhs: Self, rhs: any TextChipRepresentable) -> Bool {
        lhs.id == (rhs as! Self).id
    }
    
    public static func == (lhs: any TextChipRepresentable, rhs: Self) -> Bool {
        rhs.id == (lhs as! Self).id
    }
    
    public var identifier: String { self.id as! String }
}

extension Binding {
    public func erased<Underlying: TextChipRepresentable & Sendable>() -> Binding<(any TextChipRepresentable)?> where Value == Underlying? {
        .init {
            wrappedValue
        } set: {
            wrappedValue = $0 as? Underlying
        }
    }
}
