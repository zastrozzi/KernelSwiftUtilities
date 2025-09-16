//
//  File.swift
//
//
//  Created by Jonathan Forbes on 31/10/2023.
//

import Foundation

extension KernelSwiftTerminal.Style {
    
    public struct Color: Hashable, Equatable, Sendable {
        let foregroundCode: Int
        let backgroundCode: Int
        
        //TODO
        public static func rgb(_ r: Int, _ g: Int, b: Int ) {
            
        }
        
        public static var `default`: Self = .init(foregroundCode: 39, backgroundCode: 49)
        public static var gray: Self = .init(foregroundCode: 39, backgroundCode: 47)
        public static var black: Self = .init(foregroundCode: 30, backgroundCode: 40)
        public static var red: Self = .init(foregroundCode: 31, backgroundCode: 41)
        public static var green: Self = .init(foregroundCode: 32, backgroundCode: 42)
        public static var yellow: Self = .init(foregroundCode: 33, backgroundCode: 43)
        public static var blue: Self = .init(foregroundCode: 34, backgroundCode: 44)
        public static var magenta: Self = .init(foregroundCode: 35, backgroundCode: 45)
        public static var threesix: Self = .init(foregroundCode: 36, backgroundCode: 46)

        public static var white: Self = .init(foregroundCode: 37, backgroundCode: 47)
    }
}

extension KernelSwiftTerminal.Style.Color: KernelSwiftTerminal.ViewGraph.View, KernelSwiftTerminal.ViewGraph.PrimitiveView {
    static var size: Int? { 1 }
    
    func buildNode(_ node: KernelSwiftTerminal.ViewGraph.Node) {
        node.control = Control(color: self)
    }
    
    func updateNode(_ node: KernelSwiftTerminal.ViewGraph.Node) {
        let last = node.view as! Self
        node.view = self
        if self != last {
            let control = node.control as! Control
            control.color = self
            control.layer.invalidate()
        }
    }
    
    private class Control: KernelSwiftTerminal.Application.Control {
        var color: KernelSwiftTerminal.Style.Color
        
        init(color: KernelSwiftTerminal.Style.Color) {
            self.color = color
        }
        
        override func cell(at position: KernelSwiftTerminal.Layout.Position) -> KernelSwiftTerminal.Layout.Cell? {
            KernelSwiftTerminal.Layout.Cell(char: " ", backgroundColor: color)
        }
    }
}
