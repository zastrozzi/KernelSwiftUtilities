//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 07/11/2023.
//

import Foundation

extension KernelSwiftTerminal.ViewGraph.View {
    public func underline(_ isActive: Bool = true) -> some KernelSwiftTerminal.ViewGraph.View {
        environment(\.underline, isActive)
    }
}

extension KernelSwiftTerminal.Style {
    struct UnderlineEnvironmentKey: KernelSwiftTerminal.Model.EnvironmentKey {
        static var defaultValue: Bool { false }
    }
}

extension KernelSwiftTerminal.Model.EnvironmentValues {
    public var underline: Bool {
        get { self[KernelSwiftTerminal.Style.UnderlineEnvironmentKey.self] }
        set { self[KernelSwiftTerminal.Style.UnderlineEnvironmentKey.self] = newValue }
    }
}
