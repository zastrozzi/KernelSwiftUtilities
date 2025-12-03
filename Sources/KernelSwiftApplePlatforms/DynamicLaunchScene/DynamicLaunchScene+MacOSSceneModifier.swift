//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 27/11/2025.
//

import Foundation
import SwiftUI

extension DynamicLaunchScene {
#if os(macOS)
    struct MacOSSceneModifier: ViewModifier {
        @ViewBuilder var launchContent: () -> LaunchContent
        
        @Environment(\.scenePhase) private var scenePhase
        @State private var splashWindow: NSWindow?
        
        func body(content: Content) -> some View {
            content
                .onAppear {
                    // TODO: Add MacOS variant
                }
        }
    }
#endif
}
