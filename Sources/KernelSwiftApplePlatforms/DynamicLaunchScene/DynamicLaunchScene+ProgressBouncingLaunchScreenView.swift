//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 02/12/2025.
//

import Foundation
import SwiftUI

extension DynamicLaunchScene {
    public struct ProgressBouncingLaunchScreenView: View {
        @State private var isBouncing: Bool = false
        @Binding private var launchProgress: LaunchProgress
        public var configuration: Configuration
        private var launchContent: () -> LaunchContent
        private var bouncingParameters: BouncingLoopAnimationViewModifier.BounceParameters
        public var isCompleted: () -> ()
        
        public init(
            launchProgress: Binding<LaunchProgress>,
            configuration: Configuration,
            bouncingParameters: BouncingLoopAnimationViewModifier.BounceParameters = .init(
                height: -50,
                stiffness: 220,
                damping: 20,
                mass: 1,
                decay: 0.65,
                finalPause: 1.00,
                totalBounces: 2
            ),
            @ViewBuilder launchContent: @escaping () -> LaunchContent,
            isCompleted: @escaping () -> ()
        ) {
            self._launchProgress = launchProgress
            self.configuration = configuration
            self.bouncingParameters = bouncingParameters
            self.launchContent = launchContent
            self.isCompleted = isCompleted
        }
        
        public var body: some View {
            ZStack {
                launchContent()
                    .bouncingLoopAnimation(
                        parameters: bouncingParameters,
                        isBouncing: $isBouncing
                    )
                VStack(spacing: 10) {
                    Spacer()
                    ProgressView(value: launchProgress.currentProgress, total: 1.0)
                        .tint(.white.opacity(0.5))
                        .animation(.bouncy, value: launchProgress.currentProgress)
                    Text("\(launchProgress.mostRecentLabel)")
                        .font(.subheadline)
                        .fontDesign(.serif)
                        .foregroundStyle(.white.secondary)
                }
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(configuration.backgroundColor)
            .onChange(of: launchProgress) { oldValue, newValue in
                if oldValue != newValue {
                    if newValue == .all || newValue == .empty {
                        isBouncing = false
                    } else {
                        isBouncing = true
                    }
                }
            }
        }
    }
}
