//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 26/11/2025.
//

import Foundation
import SwiftUI

extension DynamicLaunchScene {
    public struct ScalingLaunchScreenView: View {
        @State private var scaleDown: Bool = false
        @State private var scaleUp: Bool = false
        @State private var opacity: Double = 1.0
        @Binding private var launchProgress: LaunchProgress
        
        public var configuration: Configuration
        public var launchContent: () -> LaunchContent
        
        public init(
            launchProgress: Binding<LaunchProgress>,
            configuration: Configuration,
            @ViewBuilder launchContent: @escaping () -> LaunchContent
        ) {
            self._launchProgress = launchProgress
            self.configuration = configuration
            self.launchContent = launchContent
        }
        
        public var body: some View {
            Rectangle()
                .fill(configuration.backgroundColor)
                .mask {
                    GeometryReader {
                        let size = $0.size.applying(.init(scaleX: configuration.scaling, y: configuration.scaling))
                        Rectangle()
                            .overlay {
                                launchContent()
                                    .blur(radius: configuration.forceHideContent ? 0 : (scaleUp ? configuration.blurRadius : 0))
                                    .blendMode(.destinationOut)
                                    .animation(.smooth(duration: 0.3, extraBounce: 0)) { content in
                                        content
                                            .scaleEffect(scaleDown ? 0.8 : 1)
                                    }
                                    .visualEffect { [scaleUp] content, proxy in
                                        let scaleX: CGFloat = size.width / proxy.size.width
                                        let scaleY: CGFloat = size.height / proxy.size.height
                                        let maxScale = Swift.max(scaleX, scaleY)
                                        return content
                                            .scaleEffect(scaleUp ? maxScale : 1)
                                    }
                            }
                    }
                }
                .compositingGroup()
                .opacity(configuration.forceHideContent ? 1 : (scaleUp ? 0 : 1))
                .background {
                    Rectangle()
                        .fill(configuration.contentBackgroundColor)
                        .opacity(scaleUp ? 0 : 1)
                }
                .ignoresSafeArea()
                .onChange(of: launchProgress) { oldValue, newValue in
                    if oldValue != newValue {
                        if newValue == .all {
                            dismissView()
                        }
                    }
                }
                .opacity(opacity)
        }
        
        public func dismissView() {
            Task {
                guard !scaleDown else { return }
                try? await Task.sleep(for: .seconds(configuration.initialDelay))
                scaleDown = true
                try? await Task.sleep(for: .seconds(0.1))
                withAnimation(configuration.animation) {
                    scaleUp = true
                }
                withAnimation(.smooth(duration: configuration.dismissDuration)) {
                    opacity = 0
                }
            }
            
        }
    }
}
