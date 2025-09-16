//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 07/11/2023.
//

import Foundation

extension KernelSwiftTerminal.ViewGraph.View {
    public func italic(_ isActive: Bool = true) -> some KernelSwiftTerminal.ViewGraph.View {
        environment(\.italic, isActive)
    }
}

extension KernelSwiftTerminal.Style {
    struct ItalicEnvironmentKey: KernelSwiftTerminal.Model.EnvironmentKey {
        static var defaultValue: Bool { false }
    }
}

extension KernelSwiftTerminal.Model.EnvironmentValues {
    public var italic: Bool {
        get { self[KernelSwiftTerminal.Style.ItalicEnvironmentKey.self] }
        set { self[KernelSwiftTerminal.Style.ItalicEnvironmentKey.self] = newValue }
    }
}
