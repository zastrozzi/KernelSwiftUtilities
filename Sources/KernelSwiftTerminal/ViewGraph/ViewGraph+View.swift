//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 31/10/2023.
//

import Foundation

public protocol _KernelSwiftTerminalView {
    associatedtype Body: KernelSwiftTerminal.View
    @KernelSwiftTerminal.ViewGraph.ViewBuilder var body: Body { get }
}

extension Never: KernelSwiftTerminal.View {
    public var body: Never {
        fatalError()
    }
    
    public typealias Body = Never
}

extension KernelSwiftTerminal {
    public typealias View = ViewGraph.View
}

extension KernelSwiftTerminal.ViewGraph {
    public typealias View = _KernelSwiftTerminalView
}
