//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 10/11/2023.
//

import Foundation

public protocol _KernelSwiftTerminalControllable: KernelSwiftTerminal.Renderer.LayerDrawingNC {
    var window: KernelSwiftTerminal.Application.Window { get set }
    var layer: KernelSwiftTerminal.Renderer.Layer { get set }
    func size(proposedSize: KernelSwiftTerminal.Layout.Size) -> KernelSwiftTerminal.Layout.Size
    func layout(size: KernelSwiftTerminal.Layout.Size)
    func horizontalFlexibility(height: Int) -> Int
    func verticalFlexibility(width: Int) -> Int
}
