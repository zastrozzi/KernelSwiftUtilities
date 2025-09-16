//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 31/10/2023.
//

import Foundation

public protocol _KernelSwiftTerminalModifierView {
    func passControl(_ control: KernelSwiftTerminal.Application.Control) -> KernelSwiftTerminal.Application.Control
}

extension KernelSwiftTerminal.ViewGraph {
    public typealias ModifierView = _KernelSwiftTerminalModifierView
}
