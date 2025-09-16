//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 06/11/2023.
//

import Foundation

extension KernelSwiftTerminal.Views {
    public struct Spacer: KernelSwiftTerminal.ViewGraph.View, KernelSwiftTerminal.ViewGraph.PrimitiveView {
        @KernelSwiftTerminal.Model.Environment(\.axis) var axis
        
        public init() {}
        
        static var size: Int? { 1 }
        
        func buildNode(_ node: KernelSwiftTerminal.ViewGraph.Node) {
            setupEnvironmentProperties(node: node)
            node.control = Control(orientation: axis)
        }
        
        func updateNode(_ node: KernelSwiftTerminal.ViewGraph.Node) {
            setupEnvironmentProperties(node: node)
            node.view = self
            let control = node.control as! Control
            control.orientation = axis
        }
        
        private class Control: KernelSwiftTerminal.Application.Control {
            var orientation: KernelSwiftTerminal.Layout.Axis
            
            init(orientation: KernelSwiftTerminal.Layout.Axis) {
                self.orientation = orientation
            }
            
            override func size(proposedSize: KernelSwiftTerminal.Layout.Size) -> KernelSwiftTerminal.Layout.Size {
                switch orientation {
                case .horizontal: .init(width: proposedSize.width, height: 0)
                case .vertical: .init(width: 0, height: proposedSize.height)
                }
            }
        }
    }

}
