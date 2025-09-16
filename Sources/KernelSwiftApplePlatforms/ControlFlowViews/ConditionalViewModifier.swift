//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 05/03/2025.
//

import Foundation
import SwiftUI

extension View {
    @ViewBuilder public func `if`<Content: View>(_ condition: Bool, @ViewBuilder transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

extension View {
    @ViewBuilder public func `ifInline`<Content: View>(_ condition: @autoclosure () -> Bool, @ViewBuilder transform: (Self) -> Content) -> some View {
        if condition() {
            transform(self)
        } else {
            self
        }
    }
}
