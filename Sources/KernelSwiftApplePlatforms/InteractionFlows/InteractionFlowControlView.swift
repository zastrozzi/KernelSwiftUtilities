//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 27/08/2023.
//

import Foundation
import SwiftUI
import KernelSwiftCommon

@available(iOS 17.0, macOS 14.0, *)
public struct InteractionFlowControlView: View {
//    @Injected(\.interactionFlowService) var interactionFlowService
//    @Injected(\.inputService) var inputService
    @KernelDI.Injected(\.interactionFlowService.latestSkippedElement) var latestSkipped
    @KernelDI.Injected(\.interactionFlowService.currentFlowElementIsSkippable) var isSkippable
    @KernelDI.Injected(\.interactionFlowService.currentFlowElement) var currentElement
    @KernelDI.Injected(\.inputService.currentInputCanSubmit) var isProgressable
    
//    var onInteraction: () -> Void
    
    public init() {
//        self.onInteraction = onInteraction
    }
    
    public var body: some View {
        VStack {
//            HStack {
//                
//            }
            HStack {
                if hasSkipped {
                    Button(action: { revertLatestSkip() }) {
                        HStack {
                            Image(systemName: "gobackward")
                            Text("\(skippedTitle)").multilineTextAlignment(.leading)
                        }.padding(.init(vertical: 7, horizontal: 15)).foregroundStyle(Color.red)
                        
                        
                        
                        
                    }
                    .background(Material.thin, in: .rect(cornerRadius: 5, style: .continuous))
                    
                    .fontWeight(.bold).controlSize(.small)
                    //                    .padding(10)
                    //                    .transition(.move(edge: .bottom).combined(with: .offset(y: 100)))
                }
                Spacer()
                if isSkippable {
                    Button(action: { skipCurrentElement() }) {
                        HStack {
                            Text("Skip").fontWeight(.medium)
                            Image(systemName: "forward").imageScale(.small)
                        }.padding(.init(vertical: 7, horizontal: 15)).foregroundStyle(Color.white)
                        
                    }
                    .background(Color.orange.gradient, in: .rect(cornerRadius: 20, style: .continuous))
                    
                    //                .controlSize(.extraLarge)
                    //                .buttonStyle(.plain)
                    //                .padding(10)
                    
                }
                if isProgressable {
                    Button(action: { progressElement() }) {
                        HStack {
                            Text("Next").fontWeight(.medium)
                            Image(systemName: "arrow.forward").imageScale(.small)
                        }.padding(.init(vertical: 7, horizontal: 15)).foregroundStyle(Color.white)
                            .background(Color.accentColor.gradient, in: .rect(cornerRadius: 20, style: .continuous))
                        //                        .disabled(!isProgressable)
                        //                .controlSize(.extraLarge)
                        //                .buttonStyle(.plain)
                        //                .padding(10)
//                            .transition(.move(edge: .bottom).combined(with: .offset(y: 100)))
                    }
                }
            }
            
        }.padding([.bottom, .horizontal], 10)
    }
    
    func skipCurrentElement() {
        withAnimation(.bouncy) {
            KernelDI.inject(\.interactionFlowService).skipCurrentElement()
            KernelDI.inject(\.inputService).removeCurrencyKeyboard()
        }
//        onInteraction()
    }
    
    func progressElement() {
        withAnimation(.bouncy) {
            currentElement?.defocusInput()
            if let next = currentElement?.getNextIdentifier(skipping: false) {
                KernelDI.inject(\.interactionFlowService).progressFlow(next)
            }
        }
        KernelDI.inject(\.inputService).resetCanSubmit(delayed: false)
//        onInteraction()
    }
    
    func revertLatestSkip() {
        withAnimation(.bouncy) {
            if let skippedId {
                KernelDI.inject(\.interactionFlowService).regressFlow(to: skippedId)
            }
        }
    }
    
    var skippedTitle: String {
        skippedId?.inputTitle ?? "Skipped"
    }
    
    var skippedId: (any InteractionFlowElementIdentifiable)? {
        latestSkipped?.id
    }
//    
//    var latestSkipped: InteractionFlowElement? {
//        interactionFlowService.latestSkippedElement
//    }
    
    var hasSkipped: Bool {
//        true
        latestSkipped != nil
    }
//    
//    var isSkippable: Bool {
////        true
//        interactionFlowService.currentFlowElementIsSkippable
//    }
//    
//    var currentElement: InteractionFlowElement? {
//        interactionFlowService.currentFlowElement
//    }
//    
//    var isProgressable: Bool {
//        inputService.currentInputCanSubmit
//    }
}

//@available(iOS 17.0, macOS 14.0, *)
//#Preview {
//    ScrollView {
//        ForEach(0...5, id: \.self) { _ in
//            RoundedRectangle(cornerRadius: 20, style: .continuous)
//                .fill(.quaternary).frame(height: 200).padding(.horizontal)
//        }
//    }.overlay(alignment: .bottomTrailing) {
//        InteractionFlowControlView()
//    }
//    
//}
