//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 13/03/2025.
//

import Foundation
import SwiftUI

#if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst)
public struct MatchedGeometryWrapperView<Content: View>: View {
    @ViewBuilder var content: Content
    @Environment(\.scenePhase) private var scenePhase
    @State private var overlayWindow: UIWindow?
    var isPreview: Bool = false
    
    public init(isPreview: Bool = false, @ViewBuilder content: () -> Content) {
        self.isPreview = isPreview
        self.content = content()
    }
    
    public var body: some View {
        content
            .onAppear(perform: {
                if isPreview { addOverlayWindow() }
            })
            .onChange(of: scenePhase) { oldValue, newValue in
                if newValue == .active { addOverlayWindow() }
            }
    }
    
    func addOverlayWindow() {
        for scene in UIApplication.shared.connectedScenes {
            if let windowScene = scene as? UIWindowScene, scene.activationState == .foregroundActive, overlayWindow == nil {
                let window = MatchedGeometryPassthroughWindow(windowScene: windowScene)
                window.backgroundColor = .clear
                window.isUserInteractionEnabled = false
                window.isHidden = false
                let rootController = UIHostingController(rootView: MatchedGeometryLayerView())
                rootController.view.frame = windowScene.screen.bounds
                rootController.view.backgroundColor = .clear
                
                window.rootViewController = rootController
                
                overlayWindow = window
            }
        }
        
        if overlayWindow == nil {
            print("NO WINDOW SCENE FOUND")
        }
    }
}

extension View {
    public func matchedGeometryWrapper(isPreview: Bool = false) -> some View {
        MatchedGeometryWrapperView(isPreview: isPreview) { self }
    }
}
#else
extension View {
    public func matchedGeometryWrapper(isPreview: Bool = false) -> some View {
        self
    }
}
#endif
