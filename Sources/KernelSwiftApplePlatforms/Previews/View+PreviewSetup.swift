//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 15/01/2025.
//

import SwiftUI

struct PreviewSetupViewModifier: ViewModifier {
    let setupPreviewTask: () async -> Void
    
    func body(content: Content) -> some View {
        content
            .task {
                await setupPreviewTask()
                print("Preview Setup Complete")
            }
    }
}

extension View {
    public func previewSetup(_ task: @escaping () async -> Void) -> some View {
        modifier(PreviewSetupViewModifier(setupPreviewTask: task))
    }
}
