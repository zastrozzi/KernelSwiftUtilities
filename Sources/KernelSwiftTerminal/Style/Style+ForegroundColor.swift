//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 06/11/2023.
//

import Foundation

extension KernelSwiftTerminal.ViewGraph.View {
    public func foregroundColor(_ color: KernelSwiftTerminal.Style.Color) -> some KernelSwiftTerminal.ViewGraph.View {
        environment(\.foregroundColor, color)
    }
}

extension KernelSwiftTerminal.Style {
    struct ForegroundColorEnvironmentKey: KernelSwiftTerminal.Model.EnvironmentKey {
        static var defaultValue: Color { .default }
    }
}

extension KernelSwiftTerminal.Model.EnvironmentValues {
    public var foregroundColor: KernelSwiftTerminal.Style.Color {
        get { self[KernelSwiftTerminal.Style.ForegroundColorEnvironmentKey.self] }
        set { self[KernelSwiftTerminal.Style.ForegroundColorEnvironmentKey.self] = newValue }
    }
}
