//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 31/10/2023.
//

import Foundation

extension KernelSwiftTerminal.Views {
    public struct EmptyView: ViewGraph.View, ViewGraph.PrimitiveView {
        public init() {}
        
        static var size: Int? { 0 }
        
        func buildNode(_ node: ViewGraph.Node) {}
        
        func updateNode(_ node: ViewGraph.Node) {}
    }
}
