//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 23/10/2025.
//

import Foundation
import SwiftUI

extension View {
    @ViewBuilder
    public func configurableListRow<Background: View>(
        top: CGFloat = 0,
        leading: CGFloat = 0,
        bottom: CGFloat = 0,
        trailing: CGFloat = 0,
        separator: Visibility = .hidden,
        background: Background = Color.clear
    ) -> some View {
        self
            .listRowInsets(.init(top: top, leading: leading, bottom: bottom, trailing: trailing))
            .listRowSeparator(separator)
            .listRowBackground(background)
    }
}
