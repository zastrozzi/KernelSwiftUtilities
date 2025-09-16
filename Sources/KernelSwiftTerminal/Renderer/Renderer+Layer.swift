//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 31/10/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelSwiftTerminal.Renderer {
    public class Layer {
        private(set) var children: [Layer] = []
        private(set) var parent: Layer?
        
        var content: LayerDrawingNC?
        
        public var invalidated: KernelSwiftTerminal.Layout.Rect?
        
        @KernelDI.Injected(\.renderer) var renderer
        @KernelDI.Injected(\.viewGraph) var viewGraph
        
        public var frame: KernelSwiftTerminal.Layout.Rect = .zero {
            didSet {
                if oldValue != frame {
                    parent?.invalidate(rect: oldValue)
                    parent?.invalidate(rect: frame)
                }
            }
        }
        
        public func addLayer(_ layer: Layer, at index: Int) {
            children.insert(layer, at: index)
            layer.parent = self
        }
        
        public func removeLayer(at index: Int) {
            children[index].parent = nil
            self.children.remove(at: index)
        }
        
        public func invalidate() {
            invalidate(rect: .init(position: .zero, size: frame.size))
        }
        
        /// This recursively invalidates the same rect in the parent, in the
        /// parent's coordinate system.
        /// If the parent is the root layer, it sets the `invalidated` rect instead.
        public func invalidate(rect: KernelSwiftTerminal.Layout.Rect) {
            if let parent {
                parent.invalidate(rect: .init(position: rect.position + frame.position, size: rect.size))
                return
            }
            viewGraph.scheduleUpdate()
            guard let invalidated else {
                invalidated = rect
                return
            }
            self.invalidated = rect.union(invalidated)
        }
        
        public func cell(at position: KernelSwiftTerminal.Layout.Position) -> KernelSwiftTerminal.Layout.Cell? {
            var char: KernelSwiftTerminal.Layout.Cell? = nil
            
            // Draw children
            for child in children.reversed() {
                guard child.frame.contains(position) else { continue }
                let position = position - child.frame.position
                if let cell = child.cell(at: position) {
                    if char == nil {
                        char = cell
                    }
                    if let color = cell.backgroundColor {
                        char?.backgroundColor = color
                        break
                    }
                }
            }
            
            // Draw layer content as background
            if let cell = content?.cell(at: position) {
                if char == nil {
                    char = cell
                }
                if char?.backgroundColor == nil, let backgroundColor = cell.backgroundColor {
                    char?.backgroundColor = backgroundColor
                }
                
                if content?.hasFocus ?? false { char?.attributes.inverted = true }
            }
            
            return char
        }
        
    }
}
