//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 26/11/2025.
//

import Foundation
import SwiftUI

public struct DynamicLaunchScene<LaunchProgress: ProgressOptionSet, RootContent: View, LaunchContent: View>: Scene {
    var configuration: Configuration
    let launchContent: () -> LaunchContent
    let rootContent: () -> RootContent
    let loadingSequence: (_ progress: LaunchProgress) async throws -> Void
    
    public init(
        configuration: Configuration,
        @ViewBuilder launchContent: @escaping () -> LaunchContent,
        @ViewBuilder rootContent: @escaping () -> RootContent,
        loadingSequence: @escaping (_ progress: LaunchProgress) async throws -> Void
    ) {
        self.configuration = configuration
        self.launchContent = launchContent
        self.rootContent = rootContent
        self.loadingSequence = loadingSequence
    }
    
    public var body: some Scene {
        WindowGroup {
            rootContent()
            #if os(macOS)
                .modifier(
                    MacOSSceneModifier(
                        launchContent: launchContent
                    )
                )
            #endif
            #if os(iOS)
                .modifier(
                    IOSSceneModifier(
                        configuration: configuration,
                        launchContent: launchContent,
                        loadingSequence: loadingSequence
                    )
                )
            #endif
        }
    }
}



