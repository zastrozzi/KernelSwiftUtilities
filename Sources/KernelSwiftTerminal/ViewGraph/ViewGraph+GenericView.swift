//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 31/10/2023.
//

import Foundation

protocol _KernelSwiftTerminalGenericView {
    func buildNode(_ node: KernelSwiftTerminal.ViewGraph.Node)
    func updateNode(_ node: KernelSwiftTerminal.ViewGraph.Node)
    static var size: Int? { get }
}

extension KernelSwiftTerminal.ViewGraph {
    typealias GenericView = _KernelSwiftTerminalGenericView
}

extension KernelSwiftTerminal {
    typealias GenericView = ViewGraph.GenericView
}
