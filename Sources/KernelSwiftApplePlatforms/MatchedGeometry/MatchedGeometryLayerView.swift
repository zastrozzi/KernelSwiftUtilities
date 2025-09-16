//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 13/03/2025.
//

import Foundation
import SwiftUI
import KernelSwiftCommon

public struct MatchedGeometryLayerView: View {
    @KernelDI.Injected(\.matchedGeometryManager) var manager
    
    public var body: some View {
        GeometryReader { proxy in
            ForEach(manager.binding(\.geometries)) { $geometry in
                ZStack {
                    if  let sourceAnchor = geometry.sourceAnchor,
                        let destinationAnchor = geometry.destinationAnchor,
                        let layerView = geometry.layerView,
                        !geometry.hideView
                    {
                        let sourceRect = proxy[sourceAnchor]
                        let destinationRect = proxy[destinationAnchor]
                        let animateView = geometry.animateView
                        
                        let size: CGSize = .init(
                            width: animateView ? destinationRect.size.width : sourceRect.size.width,
                            height: animateView ? destinationRect.size.height : sourceRect.size.height
                        )
                        
                        let offset: CGSize = .init(
                            width: animateView ? destinationRect.minX : sourceRect.minX,
                            height: animateView ? destinationRect.minY : sourceRect.minY
                        )
                        
                        layerView
                            .frame(width: size.width, height: size.height)
                            .clipShape(.rect(cornerRadius: animateView ? geometry.dCornerRadius : geometry.sCornerRadius))
                            .offset(offset)
                            .transition(.identity)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            
                        
                    }
                }
                .zIndex(geometry.zIndex)
                .onChange(of: geometry.animateView) { oldValue, newValue in
                    Task {
                        try await Task.sleep(for: .milliseconds(450))
                        if !newValue {
                            geometry.isActive = false
                            geometry.layerView = nil
                            geometry.sourceAnchor = nil
                            geometry.destinationAnchor = nil
                            geometry.sCornerRadius = 0
                            geometry.dCornerRadius = 0
                            geometry.zIndex = 0
                            geometry.completion(false)
                        } else {
                            geometry.hideView = true
                            geometry.completion(true)
                        }
                    }
                }
            }
        }
    }
}

public struct MatchedGeometryLayerViewModifier<Layer: View>: ViewModifier {
    @KernelDI.Injected(\.matchedGeometryManager) var manager
    @Binding var animate: Bool
    @ViewBuilder var layer: Layer
    let id: String
    var sourceCornerRadius: CGFloat
    var destinationCornerRadius: CGFloat
    var zIndex: Double
    var updateSourceContinuously: Bool
    var completion: (Bool) -> ()
    
    public init(
        id: String,
        animate: Binding<Bool>,
        sourceCornerRadius: CGFloat = 0,
        destinationCornerRadius: CGFloat = 0,
        zIndex: Double = 0,
        updateSourceContinuously: Bool = false,
        @ViewBuilder layer: @escaping () -> Layer,
        completion: @escaping (Bool) -> () = { _ in }
    ) {
        self.id = id
        self._animate = animate
        self.sourceCornerRadius = sourceCornerRadius
        self.destinationCornerRadius = destinationCornerRadius
        self.zIndex = zIndex
        self.updateSourceContinuously = updateSourceContinuously
        self.completion = completion
        self.layer = layer()
    }
    
    public func body(content: Content) -> some View {
        content
            .onAppear {
                if !manager.geometries.contains(where: { $0.infoID == id }) {
                    manager.geometries.append(.init(id: id))
                }
            }
            .onChange(of: animate) { oldValue, newValue in
                if let index = manager.geometries.firstIndex(where: { $0.infoID == id }) {
                    manager.geometries[index].isActive = true
                    manager.geometries[index].layerView = AnyView(layer)
                    manager.geometries[index].sCornerRadius = sourceCornerRadius
                    manager.geometries[index].dCornerRadius = destinationCornerRadius
                    manager.geometries[index].zIndex = zIndex
                    manager.geometries[index].updateSourceContinuously = updateSourceContinuously
                    manager.geometries[index].completion = completion
                    
                    if newValue {
                        Task {
                            try await Task.sleep(for: .milliseconds(60))
                            withAnimation(.snappy(duration: 0.35, extraBounce: 0)) {
                                manager.geometries[index].animateView = true
                            }
                        }
                    } else {
                        if let lastSourceAnchor = manager.geometries[index].lastSourceAnchor, updateSourceContinuously {
                            manager.geometries[index].sourceAnchor = lastSourceAnchor
                        }
                        Task {
                            manager.geometries[index].hideView = false
                            withAnimation(.snappy(duration: 0.35, extraBounce: 0)) {
                                manager.geometries[index].animateView = false
                            }
                        }

                    }
                }
            }
    }
}

extension View {
    @ViewBuilder
    public func matchedGeometryLayer<Content: View>(
        id: String,
        animate: Binding<Bool>,
        sourceCornerRadius: CGFloat = 0,
        destinationCornerRadius: CGFloat = 0,
        zIndex: Double = 0,
        updateSourceContinuously: Bool = false,
        @ViewBuilder content: @escaping () -> Content,
        completion: @escaping (Bool) -> () = { _ in }
    ) -> some View {
        modifier(
            MatchedGeometryLayerViewModifier(
                id: id,
                animate: animate,
                sourceCornerRadius: sourceCornerRadius,
                destinationCornerRadius: destinationCornerRadius,
                zIndex: zIndex,
                updateSourceContinuously: updateSourceContinuously,
                layer: content,
                completion: completion
            )
        )
    }
}
