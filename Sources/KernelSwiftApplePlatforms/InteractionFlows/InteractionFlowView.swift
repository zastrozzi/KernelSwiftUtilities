//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 22/08/2023.
//

import Foundation
import SwiftUI
import KernelSwiftCommon

@available(iOS 17.0, macOS 14.0, *)
public struct InteractionFlowView: View {
    public static var shared: Self = .init()
//    @Injected(\.interactionFlowService.allFlowElements) var allFlowElements: [InteractionFlowElement]
    @InjectedBinding(\.interactionFlowService.activeFlowElements) var activeElements
    @InjectedBinding(\.interactionFlowService.flowIsLoaded) var flowIsLoaded
    
    public init() {
        print("Inter flow view ")
    }
    
    public var body: some View {
        if $flowIsLoaded.wrappedValue {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(activeElements) { element in
                        InteractionFlowElementView(element: element)
                    }
                }
                .padding(.bottom, 100)
                .scrollBounceBehavior(.always)
            }
            .overlay(alignment: .bottomTrailing) {
                InteractionFlowControlView()
            }
        }
    }
}
