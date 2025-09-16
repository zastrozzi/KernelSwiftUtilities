//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 31/10/2023.
//

import Foundation

protocol _KernelSwiftTerminalLayoutRootView {
    func loadData(node: KernelSwiftTerminal.ViewGraph.Node)
    func insertControl(at index: Int, node: KernelSwiftTerminal.ViewGraph.Node)
    func removeControl(at index: Int, node: KernelSwiftTerminal.ViewGraph.Node)
}

extension KernelSwiftTerminal.ViewGraph {
    typealias LayoutRootView = _KernelSwiftTerminalLayoutRootView
}
