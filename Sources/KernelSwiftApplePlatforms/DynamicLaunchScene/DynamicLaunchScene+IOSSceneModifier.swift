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
        @State var launchProgress: LaunchProgress = .empty
        var configuration: Configuration
        var launchContent: () -> LaunchContent
        let loadingSequence: (_ progress: Binding<LaunchProgress>) async throws -> Void
        
        @Environment(\.scenePhase) private var scenePhase
        @State private var launchWindow: UIWindow?
        
        public init(
            configuration: Configuration,
            @ViewBuilder launchContent: @escaping () -> LaunchContent,
            loadingSequence: @escaping (_ progress: Binding<LaunchProgress>) async throws -> Void
        ) {
            self.configuration = configuration
            self.launchContent = launchContent
            self.loadingSequence = loadingSequence
        }
        
        public func body(content: Content) -> some View {
            content
                .task {
                    print("Adding Launch window to scene")
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
                        
                        switch configuration.launchScreenType {
                        case .scaling:
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
                        case .progressBouncing:
                            let rootViewController = UIHostingController(
                                rootView: ProgressBouncingLaunchScreenView(
                                    launchProgress: $launchProgress,
                                    configuration: configuration,
                                    launchContent: launchContent
                                )
                            )
                            rootViewController.view.backgroundColor = .clear
                            window.rootViewController = rootViewController
                        default:
                            print("Custom launch screen is not supported on iOS yet")
                            continue
                        }
                        
                        
                        
                        self.launchWindow = window
                        print("Launch window added to the scene")
                        do {
                            print("Loading sequence started")
                            try await loadingSequence($launchProgress)
                            if launchProgress != .all {
                                print("Loading sequence finished before completion")
                            } else {
                                print("Loading sequence completed")
                                try await Task.sleep(for: .seconds(configuration.dismissDuration))
                                window.isHidden = true
                                window.isUserInteractionEnabled = false
                            }
                        } catch {
                            print("An error occurred in loading sequence: \(error)")
                        }
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
