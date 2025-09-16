//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 01/11/2023.
//

import Foundation

extension KernelSwiftTerminal.Layout {
    public enum Axis {
        case horizontal
        case vertical
    }
}

extension KernelSwiftTerminal.Layout {
    struct AxisEnvironmentKey: KernelSwiftTerminal.Model.EnvironmentKey {
        static var defaultValue: Axis { .vertical }
    }
}

extension KernelSwiftTerminal.Model.EnvironmentValues {
    var axis: KernelSwiftTerminal.Layout.Axis {
        get { self[KernelSwiftTerminal.Layout.AxisEnvironmentKey.self] }
        set { self[KernelSwiftTerminal.Layout.AxisEnvironmentKey.self] = newValue }
    }
}
