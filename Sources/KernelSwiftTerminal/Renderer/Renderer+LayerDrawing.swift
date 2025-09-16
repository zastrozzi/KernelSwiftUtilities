//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 31/10/2023.
//

import Foundation



public protocol _KernelSwiftTerminalLayerDrawingNonClass {
    func cell(at position: KernelSwiftTerminal.Layout.Position) -> KernelSwiftTerminal.Layout.Cell?
    var hasFocus: Bool { get }
    var isFocusable: Bool { get }
    var isSelectable: Bool { get }
}

public protocol _KernelSwiftTerminalLayerDrawing: AnyObject, _KernelSwiftTerminalLayerDrawingNonClass {}

extension KernelSwiftTerminal.Renderer {
    public typealias LayerDrawing = _KernelSwiftTerminalLayerDrawing
    public typealias LayerDrawingNC = _KernelSwiftTerminalLayerDrawingNonClass
}

extension KernelSwiftTerminal.Renderer.LayerDrawingNC {
    public var isFocusable: Bool { false }
    public var isSelectable: Bool { false }
}
