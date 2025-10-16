//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 17/10/2025.
//

import Foundation
import SwiftUI

public protocol NavigationTabSelection: RawRepresentable, Identifiable, Codable, Equatable, Hashable, CaseIterable, Sendable where RawValue == String {
    var title: String { get }
    var systemImage: String { get }
}

extension NavigationTabSelection {
    public var id: String { rawValue }
}

@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
extension Tab {
    nonisolated public init(tabSelection: Value, @ViewBuilder content: () -> Content) where Content: View, Label == DefaultTabLabel, Value: NavigationTabSelection {
        self.init(tabSelection.title, systemImage: tabSelection.systemImage, value: tabSelection, content: content)
    }
}
