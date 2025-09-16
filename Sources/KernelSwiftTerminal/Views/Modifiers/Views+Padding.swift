//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 07/11/2023.
//

import Foundation

extension KernelSwiftTerminal.Views {
    struct Padding<Content: KernelSwiftTerminal.ViewGraph.View>: KernelSwiftTerminal.ViewGraph.View, KernelSwiftTerminal.ViewGraph.PrimitiveView, KernelSwiftTerminal.ViewGraph.ModifierView {
        let content: Content
        let edges: KernelSwiftTerminal.Layout.EdgeSet
        
        init(
            content: Content,
            edges: KernelSwiftTerminal.Layout.EdgeSet
        ) {
            self.content = content
            self.edges = edges
        }
        
        static var size: Int? { Content.size }
        
        func buildNode(_ node: KernelSwiftTerminal.ViewGraph.Node) {
            node.addNode(at: 0, KernelSwiftTerminal.ViewGraph.Node(view: content.view))
        }
        
        func updateNode(_ node: KernelSwiftTerminal.ViewGraph.Node) {
            node.view = self
            node.children[0].update(using: content.view)
        }
        
        func passControl(_ control: KernelSwiftTerminal.Application.Control) -> KernelSwiftTerminal.Application.Control {
            if let paddingControl = control.parent { return paddingControl }
            let paddingControl = Control(edges: edges)
            paddingControl.addSubview(control, at: 0)
            return paddingControl
        }
        
        private class Control: KernelSwiftTerminal.Application.Control {
            let edges: KernelSwiftTerminal.Layout.EdgeSet
            
            init(edges: KernelSwiftTerminal.Layout.EdgeSet) {
                self.edges = edges
                super.init()
            }
            
            override func size(proposedSize: KernelSwiftTerminal.Layout.Size) -> KernelSwiftTerminal.Layout.Size {
                var proposedSize = proposedSize
                proposedSize.width -= (edges.leading + edges.trailing)
                proposedSize.height -= (edges.top + edges.bottom)
                var size = children[0].size(proposedSize: proposedSize)
                size.width += (edges.leading + edges.trailing)
                size.height += (edges.top + edges.bottom)
                return size
            }
            
            override func layout(size: KernelSwiftTerminal.Layout.Size) {
                var contentSize = size
                contentSize.width -= (edges.leading + edges.trailing)
                contentSize.height -= (edges.top + edges.bottom)
                children[0].layout(size: contentSize)
                children[0].layer.frame.position = KernelSwiftTerminal.Layout.Position(column: edges.leading, line: edges.top)
                self.layer.frame.size = size
            }
        }
    }
}

extension KernelSwiftTerminal.ViewGraph.View {
    public func padding(_ all: Int = 1) -> some KernelSwiftTerminal.ViewGraph.View {
        return KernelSwiftTerminal.Views.Padding(content: self, edges: .init(horizontal: all, vertical: all))
    }
    
    public func padding(horizontal: Int) -> some KernelSwiftTerminal.ViewGraph.View {
        return KernelSwiftTerminal.Views.Padding(content: self, edges: .init(horizontal: horizontal))
    }
    
    public func padding(vertical: Int) -> some KernelSwiftTerminal.ViewGraph.View {
        return KernelSwiftTerminal.Views.Padding(content: self, edges: .init(vertical: vertical))
    }
    
    public func padding(horizontal: Int, vertical: Int) -> some KernelSwiftTerminal.ViewGraph.View {
        return KernelSwiftTerminal.Views.Padding(content: self, edges: .init(horizontal: horizontal, vertical: vertical))
    }
    
    public func padding(top: Int) -> some KernelSwiftTerminal.ViewGraph.View {
        return KernelSwiftTerminal.Views.Padding(content: self, edges: .init(top: top))
    }
    
    public func padding(bottom: Int) -> some KernelSwiftTerminal.ViewGraph.View {
        return KernelSwiftTerminal.Views.Padding(content: self, edges: .init(bottom: bottom))
    }
    
    public func padding(leading: Int) -> some KernelSwiftTerminal.ViewGraph.View {
        return KernelSwiftTerminal.Views.Padding(content: self, edges: .init(leading: leading))
    }
    
    public func padding(trailing: Int) -> some KernelSwiftTerminal.ViewGraph.View {
        return KernelSwiftTerminal.Views.Padding(content: self, edges: .init(trailing: trailing))
    }
    
    public func padding(
        top: Int,
        bottom: Int,
        leading: Int,
        trailing: Int
    ) -> some KernelSwiftTerminal.ViewGraph.View {
        return KernelSwiftTerminal.Views.Padding(
            content: self,
            edges: .init(
                top: top,
                bottom: bottom,
                leading: leading,
                trailing: trailing
            )
        )
    }
    
    public func padding(
        top: Int,
        bottom: Int,
        leading: Int
    ) -> some KernelSwiftTerminal.ViewGraph.View {
        return KernelSwiftTerminal.Views.Padding(
            content: self,
            edges: .init(
                top: top,
                bottom: bottom,
                leading: leading
            )
        )
    }
    
    public func padding(
        top: Int,
        bottom: Int,
        trailing: Int
    ) -> some KernelSwiftTerminal.ViewGraph.View {
        return KernelSwiftTerminal.Views.Padding(
            content: self,
            edges: .init(
                top: top,
                bottom: bottom,
                trailing: trailing
            )
        )
    }
    
    public func padding(
        top: Int,
        leading: Int,
        trailing: Int
    ) -> some KernelSwiftTerminal.ViewGraph.View {
        return KernelSwiftTerminal.Views.Padding(
            content: self,
            edges: .init(
                top: top,
                leading: leading,
                trailing: trailing
            )
        )
    }
    
    public func padding(
        top: Int,
        bottom: Int
    ) -> some KernelSwiftTerminal.ViewGraph.View {
        return KernelSwiftTerminal.Views.Padding(
            content: self,
            edges: .init(
                top: top,
                bottom: bottom
            )
        )
    }
    
    public func padding(
        top: Int,
        leading: Int
    ) -> some KernelSwiftTerminal.ViewGraph.View {
        return KernelSwiftTerminal.Views.Padding(
            content: self,
            edges: .init(
                top: top,
                leading: leading
            )
        )
    }
    
    public func padding(
        top: Int,
        trailing: Int
    ) -> some KernelSwiftTerminal.ViewGraph.View {
        return KernelSwiftTerminal.Views.Padding(
            content: self,
            edges: .init(
                top: top,
                trailing: trailing
            )
        )
    }
    
    public func padding(
        bottom: Int,
        leading: Int
    ) -> some KernelSwiftTerminal.ViewGraph.View {
        return KernelSwiftTerminal.Views.Padding(
            content: self,
            edges: .init(
                bottom: bottom,
                leading: leading
            )
        )
    }
    
    public func padding(
        bottom: Int,
        trailing: Int
    ) -> some KernelSwiftTerminal.ViewGraph.View {
        return KernelSwiftTerminal.Views.Padding(
            content: self,
            edges: .init(
                bottom: bottom,
                trailing: trailing
            )
        )
    }
    
    public func padding(
        leading: Int,
        trailing: Int
    ) -> some KernelSwiftTerminal.ViewGraph.View {
        return KernelSwiftTerminal.Views.Padding(
            content: self,
            edges: .init(
                leading: leading,
                trailing: trailing
            )
        )
    }
}
