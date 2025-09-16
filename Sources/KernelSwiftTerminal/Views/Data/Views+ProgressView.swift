//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 19/11/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelSwiftTerminal.Views {
    public struct ProgressView: KernelSwiftTerminal.ViewGraph.View, KernelSwiftTerminal.ViewGraph.PrimitiveView {
        @KTBinding public var progress: Double
        
        public init(progress: KTBinding<Double>) {
            self._progress = progress
        }
        
        static var size: Int? { 1 }
        
        func buildNode(_ node: KernelSwiftTerminal.ViewGraph.Node) {
            node.control = Control(progress: progress)
        }
        
        func updateNode(_ node: KernelSwiftTerminal.ViewGraph.Node) {
            node.view = self
            (node.control as! Control).progress = progress
        }
        
        private class Control: KernelSwiftTerminal.Application.Control {
            var progress: Double
            var actualWidth: Int = 0
            var progressWidth: Int = 0
            
            init(progress: Double) {
                self.progress = progress
                super.init()
            }
            
            override func size(proposedSize: KernelSwiftTerminal.Layout.Size) -> KernelSwiftTerminal.Layout.Size {
                actualWidth = proposedSize.width
                progressWidth = (max(actualWidth - 2, 0) * Int(progress * 100)) / 100
                return .init(width: actualWidth, height: 1)
            }
            
            override func cell(at position: KernelSwiftTerminal.Layout.Position) -> KernelSwiftTerminal.Layout.Cell? {
                guard position.line == .zero else { return nil }
                return switch position.column {
                case .zero: .init(char: "[")
                case actualWidth - 1: .init(char: "]")
                case ...progressWidth: .init(char: "X")
                default: .init(char: " ")
                }
            }
        }
    }
}
