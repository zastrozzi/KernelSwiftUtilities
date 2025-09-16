//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 07/11/2023.
//

import Foundation

extension KernelSwiftTerminal.ViewGraph.View {
    public func strikethrough(_ isActive: Bool = true) -> some KernelSwiftTerminal.ViewGraph.View {
        environment(\.strikethrough, isActive)
    }
}

extension KernelSwiftTerminal.Style {
    struct StrikethroughEnvironmentKey: KernelSwiftTerminal.Model.EnvironmentKey {
        static var defaultValue: Bool { false }
    }
}

extension KernelSwiftTerminal.Model.EnvironmentValues {
    public var strikethrough: Bool {
        get { self[KernelSwiftTerminal.Style.StrikethroughEnvironmentKey.self] }
        set { self[KernelSwiftTerminal.Style.StrikethroughEnvironmentKey.self] = newValue }
    }
}
