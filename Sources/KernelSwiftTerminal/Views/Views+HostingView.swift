//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 18/11/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelSwiftTerminal.Views {
    public struct HostingView<Content: ViewGraph.View>: ViewGraph.View {
        @KTObservedObject var rootFocusModel: RootFocusModel = .init()
        
        public let content: Content
        
        public init(content: Content) {
            self.content = content
        }
        
        public var body: some _KernelSwiftTerminalView {
            VStack { content }
        }
        
        class RootFocusModel: ObservableObject {
            @Published var currentFocus: UUID? = nil
            @KernelDI.Injected(\.focusService) var focusService
            
            init() {
                Task { for try await focus in focusService.currentFocusStream.debounce(for: .milliseconds(30)) { self.currentFocus = focus } }
            }
        }
    }
}
