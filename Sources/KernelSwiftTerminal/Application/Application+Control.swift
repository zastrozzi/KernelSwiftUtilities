//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 31/10/2023.
//

import Foundation
import KernelSwiftCommon

public protocol SelectableControl: KernelSwiftTerminal.Renderer.LayerDrawing {
    var keyboardInputParser: KernelSwiftTerminal.Application.KeyboardInputKeyParser { get }
    func handleSelection() -> Void
}

public protocol TextReceivableControl: KernelSwiftTerminal.Renderer.LayerDrawing {
    var text: String { get set }
    var keyboardInputParser: KernelSwiftTerminal.Application.KeyboardInputKeyParser { get }
    var layer: KernelSwiftTerminal.Renderer.Layer { get }
}

extension SelectableControl {
    public func setupSelectionHandler() {
        Task {
            for try await _ in keyboardInputParser.returnKeySequence.filter({ _ in self.hasFocus }) {
                self.handleSelection()
            }
        }
    }
}

extension TextReceivableControl {
    public func setupTextReceivingHandler() {
        Task {
            for try await char in keyboardInputParser.nonEscapedCharacterSequence.filter({ _ in self.hasFocus }) {
                if char.first?.asciiValue == .ascii.delete {
                    if !self.text.isEmptyOrBlank { self.text.removeLast() }
                }
                else { self.text += char }
                layer.invalidate()
            }
        }
    }
}

extension KernelSwiftTerminal.Application {
    public class Control: KernelSwiftTerminal.Renderer.LayerDrawing {
        private(set) var children: [Control] = []
        private(set) var parent: Control?
        
        private var idx: Int = 0
        var id: UUID
        
        public var hasFocus: Bool { isFocusable ? focusService.isCurrentFocus(id) : false }
        public var isFocusable: Bool { false }
        public var isSelectable: Bool { false }
        
        var window: Window?
        private(set) lazy var layer: KernelSwiftTerminal.Renderer.Layer = makeLayer()
        
        @KernelDI.Injected(\.focusService) var focusService
        @KernelDI.Injected(\.keyboardInputParser) var keyboardInputParser
        
        public init(id: UUID = .init()) {
            self.id = id
        }
        
        var root: Control { parent?.root ?? self }
        
        func addSubview(_ view: Control, at index: Int) {
            self.children.insert(view, at: index)
            layer.addLayer(view.layer, at: index)
            view.parent = self
            view.window = window
            for i in index ..< children.count { children[i].idx = i }
            focusService.add(view.id, to: id, at: index, focusable: view.isFocusable)
        }
        
        func removeSubview(at index: Int) {
            children[index].window = nil
            children[index].parent = nil
            self.children.remove(at: index)
            layer.removeLayer(at: index)
            for i in index ..< children.count { children[i].idx = i }
            focusService.remove(from: id, at: index)
        }
        
        func isDescendant(of control: Control) -> Bool {
            guard let parent else { return false }
            return control === parent || parent.isDescendant(of: control)
        }
        
        func makeLayer() -> KernelSwiftTerminal.Renderer.Layer {
            let layer = KernelSwiftTerminal.Renderer.Layer()
            layer.content = self
            return layer
        }
        
        // MARK: - Layout
        
        func size(proposedSize: KernelSwiftTerminal.Layout.Size) -> KernelSwiftTerminal.Layout.Size {
            proposedSize
        }
        
        func layout(size: KernelSwiftTerminal.Layout.Size) {
            layer.frame.size = size
        }
        
        func horizontalFlexibility(height: Int) -> Int {
            let minSize = size(proposedSize: .init(width: 0, height: height))
            let maxSize = size(proposedSize: .init(width: .max, height: height))
            return maxSize.width - minSize.width
        }
        
        func verticalFlexibility(width: Int) -> Int {
            let minSize = size(proposedSize: .init(width: width, height: 0))
            let maxSize = size(proposedSize: .init(width: width, height: .max))
            return maxSize.height - minSize.height
        }
        
        // MARK: - Drawing
        
        public func cell(at position: KernelSwiftTerminal.Layout.Position) -> KernelSwiftTerminal.Layout.Cell? { nil }
                
        // MARK: - Selection
        
        
        
        func focusGained() {
            scroll(to: .zero)
        }
        
        func focusLost() {
            
        }
        // MARK: - Scrolling
        
        func scroll(to position: KernelSwiftTerminal.Layout.Position) {
            parent?.scroll(to: position + layer.frame.position)
        }
        
    }
}
