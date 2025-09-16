//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 13/03/2025.
//

import Foundation
import SwiftUI
import KernelSwiftCommon

public struct MatchedGeometrySourceView<Content: View>: View {
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
            .anchorPreference(key: MatchedGeometryContinuousAnchorKey.self, value: .bounds) { anchor in
                if let index, manager.geometries[index].isActive { [id: anchor] }
                else { [:] }
            }
            .anchorPreference(key: MatchedGeometryAnchorKey.self, value: .bounds) { anchor in
                if let index, manager.geometries[index].isActive { [id: anchor] }
                else { [:] }
            }
            .onPreferenceChange(MatchedGeometryAnchorKey.self) { value in
                Task { @MainActor in
                    if let index, manager.geometries[index].isActive, manager.geometries[index].sourceAnchor == nil {
                        manager.geometries[index].sourceAnchor = value[id]
                    }
                }
            }
            .onPreferenceChange(MatchedGeometryContinuousAnchorKey.self) { value in
                Task { @MainActor in
                    if let index, manager.geometries[index].isActive, manager.geometries[index].updateSourceContinuously {
                        manager.geometries[index].lastSourceAnchor = value[id]
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
        if let index { manager.geometries[index].destinationAnchor == nil ? 1 : 0 }
        else { 1 }
    }
}

extension View {
    public func matchedGeometrySource(_ id: String) -> some View {
        MatchedGeometrySourceView(id: id) { self }
    }
}
