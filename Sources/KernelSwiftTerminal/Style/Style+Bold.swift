//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 06/11/2023.
//

import Foundation

extension KernelSwiftTerminal.ViewGraph.View {
    public func bold(_ isActive: Bool = true) -> some KernelSwiftTerminal.ViewGraph.View {
        environment(\.bold, isActive)
    }
}

extension KernelSwiftTerminal.Style {
    struct BoldEnvironmentKey: KernelSwiftTerminal.Model.EnvironmentKey {
        static var defaultValue: Bool { false }
    }
}

extension KernelSwiftTerminal.Model.EnvironmentValues {
    public var bold: Bool {
        get { self[KernelSwiftTerminal.Style.BoldEnvironmentKey.self] }
        set { self[KernelSwiftTerminal.Style.BoldEnvironmentKey.self] = newValue }
    }
}
