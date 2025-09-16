//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 13/03/2025.
//

import Foundation
import SwiftUI
import KernelSwiftCommon

public struct MatchedGeometryDestinationView<Content: View>: View {
    @KernelDI.Injected(\.matchedGeometryManager) var manager
    
    let id: String
    @ViewBuilder var content: Content
    
    public init(id: String, @ViewBuilder content: () -> Content) {
        self.id = id
        self.content = content()
    }
    
    public var body: some View {
        content
            .opacity(opacity)
            .anchorPreference(key: MatchedGeometryAnchorKey.self, value: .bounds) { anchor in
                if let index, manager.geometries[index].isActive { [id + ".destination": anchor] }
                else { [:] }
            }
            .onPreferenceChange(MatchedGeometryAnchorKey.self) { value in
                Task { @MainActor in
                    if let index, manager.geometries[index].isActive, !manager.geometries[index].hideView {
                        manager.geometries[index].destinationAnchor = value[id + ".destination"]
                    }
                }
            }
    }
    
    var index: Int? {
        if let index = manager.geometries.firstIndex(where: { $0.infoID == id }) {
            return index
        }
        return nil
    }
    
    var opacity: CGFloat {
        if let index { manager.geometries[index].isActive ? (manager.geometries[index].hideView ? 1 : 0) : 1 }
        else { 1 }
    }
}

extension View {
    public func matchedGeometryDestination(_ id: String) -> some View {
        MatchedGeometryDestinationView(id: id) {
            self
        }
    }
}
