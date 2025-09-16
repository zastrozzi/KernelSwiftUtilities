//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 31/10/2023.
//

import Foundation
import AsyncAlgorithms
import KernelSwiftCommon

extension KernelSwiftTerminal.Application {
    public struct Window: KernelSwiftTerminal.Renderer.LayerDrawingNC {
        
        private(set) lazy var rootLayer: KernelSwiftTerminal.Renderer.Layer = makeLayer()
        
        @KernelDI.Injected(\.keyboardInputParser) var keyboardInputParser
        @KernelDI.Injected(\.focusService) var focusService
        
        public var hasFocus: Bool { focusService.isCurrentFocus(id) }
        public var isFocusable: Bool { false }
        public var isSelectable: Bool { false }
        
        public var id: UUID
        
        private(set) var controls: [UUID: Control] = [:]
        private(set) var rootControlId: UUID? = nil
        
        var rootControl: Control {
            get { controls[rootControlId!]! }
        }
        
        public init(id: UUID = .init()) {
            self.id = id
            focusService.start()
        }
        
        mutating func addRootControl(_ control: Control) {
            self.rootControlId = control.id
            focusService.addRoot(control.id)
            addControl(control)
        }
       
        mutating func addControl(_ control: Control) {
            control.window = self
            self.controls[control.id] = control
            rootLayer.addLayer(control.layer, at: 0)
        }
        
        private func makeLayer() -> KernelSwiftTerminal.Renderer.Layer {
            let layer = KernelSwiftTerminal.Renderer.Layer()
            layer.content = self
            return layer
        }
        
        public func cell(at position: KernelSwiftTerminal.Layout.Position) -> KernelSwiftTerminal.Layout.Cell? {
            .init(char: " ")
        }
    }
}
