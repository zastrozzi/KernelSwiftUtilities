//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 27/11/2025.
//

import Foundation
import SwiftUI

extension DynamicLaunchScene {
#if os(iOS)
    public struct IOSSceneModifier: ViewModifier {
        var configuration: Configuration
        var launchContent: () -> LaunchContent
        
        @Environment(\.scenePhase) private var scenePhase
        @State private var launchWindow: UIWindow?
        
        public init(
            configuration: Configuration,
            @ViewBuilder launchContent: @escaping () -> LaunchContent
        ) {
            self.configuration = configuration
            self.launchContent = launchContent
        }
        
        public func body(content: Content) -> some View {
            content
                .onAppear {
                    let scenes = UIApplication.shared.connectedScenes
                    
                    for scene in scenes {
                        guard
                            let windowScene = scene as? UIWindowScene,
                            checkStates(windowScene.activationState),
                            !windowScene.windows.contains(where: { $0.tag == configuration.launchWindowTag })
                        else {
                            print("Launch window already exists for this scene or the scene's state is invalid")
                            continue
                        }
                        
                        let window: UIWindow = .init(windowScene: windowScene)
                        window.tag = configuration.launchWindowTag
                        window.backgroundColor = .clear
                        window.isHidden = false
                        window.isUserInteractionEnabled = true
                        
                        guard configuration.launchScreenType == .scaling else {
                            print("Custom launch screen is not supported on iOS yet")
                            continue
                        }
                        
                        let rootViewController = UIHostingController(
                            rootView: ScalingLaunchScreenView(
                                configuration: configuration,
                                launchContent: launchContent
                            ) {
                                window.isHidden = true
                                window.isUserInteractionEnabled = false
                            }
                        )
                        
                        rootViewController.view.backgroundColor = .clear
                        window.rootViewController = rootViewController
                        self.launchWindow = window
                        print("Launch window added to the scene")
                    }
                }
        }
        
        private func checkStates(_ state: UIWindowScene.ActivationState) -> Bool {
            switch scenePhase {
            case .active: state == .foregroundActive
            case .inactive: state == .foregroundInactive
            case .background: state == .background
            @unknown default: state.hashValue == scenePhase.hashValue
            }
        }
    }
#endif
    
}
