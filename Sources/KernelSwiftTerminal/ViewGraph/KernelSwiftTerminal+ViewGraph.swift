//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 31/10/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelDI.Injector {
    public var viewGraph: KernelSwiftTerminal.ViewGraph {
        get { self[KernelSwiftTerminal.ViewGraph.Token.self] }
        set { self[KernelSwiftTerminal.ViewGraph.Token.self] = newValue}
    }
}

extension KernelSwiftTerminal {
    public class ViewGraph: KernelDI.Injectable {
        @KernelDI.Injected(\.renderer) var renderer
        private var updateScheduled = false
        private var invalidatedNodes: [Node] = []
        var nodeBuildStatuses: [UUID: Bool] = [:]
        private var window: Application.Window { get { _window! } set { _window = newValue } }
        private var _window: Application.Window? = nil
        
        var viewAppearedChecks: [Int: Bool] = [:]
        
        required public init() {}
        
        public func initialise(_ window: Application.Window) {
            self.window = window
        }
        
        func invalidateNode(_ node: Node) {
            invalidatedNodes.append(node)
            scheduleUpdate()
        }
        
        private func update() {
            updateScheduled = false
            
            for node in invalidatedNodes {
                node.update(using: node.view)
            }
            invalidatedNodes = []
            
            window.rootControl.layout(size: window.rootLayer.frame.size)
            renderer.update()
        }
        
        func scheduleUpdate() {
            if !updateScheduled {
                DispatchQueue.main.async { self.update() }
                updateScheduled = true
            }
        }
        
        func setNodeBuildStatus(_ id: UUID, _ status: Bool) { nodeBuildStatuses[id] = status }
        func nodeBuildStatus(_ id: UUID) -> Bool { nodeBuildStatuses[id] ?? false }
    }
}
