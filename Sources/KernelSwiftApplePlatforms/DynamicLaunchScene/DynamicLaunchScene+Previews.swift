//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 02/12/2025.
//

import Foundation
import SwiftUI

struct LoadingProgress: ProgressOptionSet {
    enum Stage: UInt, CaseIterable, Hashable, Sendable {
        case stepOne
        case stepTwo
        case stepThree
        case stepFour
        case stepFive
        case stepSix
        
    }
    
    var completed: Set<Stage> = []
    var mostRecentStage: Stage? = nil
    
    static let defaultLabel: String = "Loading..."
    
    static func label(for stage: Stage) -> String {
        switch stage {
        case .stepOne: "Step One"
        case .stepTwo: "Step Two"
        case .stepThree: "Step Three"
        case .stepFour: "Step Four"
        case .stepFive: "Step Five"
        case .stepSix: "Step Six"
        }
    }
}

struct LoadingProgressExampleView: View {
    @State private var progress = LoadingProgress.empty
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Last: \(progress.currentLabel)")
                .font(.headline)
            Text("Latest: \(progress.mostRecentLabel)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            ProgressView(value: progress.currentProgress, total: 1.0)
                .tint(.accentColor)
                .animation(.bouncy, value: progress.currentProgress)
            
            HStack {
                Text("\(Int((progress.currentProgress * 100).rounded()))%")
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
                Spacer()
                Button("Advance") { advance() }
                Button("Reset", role: .destructive) { progress = .empty }
            }
            
            List {
                ForEach(LoadingProgress.orderedStages, id: \.self) { stage in
                    Button {
                        toggle(stage)
                    } label: {
                        HStack {
                            Image(systemName: progress.contains(stage) ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(progress.contains(stage) ? .green : .secondary)
                            Text(LoadingProgress.label(for: stage))
                        }
                    }
                }
            }
            .listStyle(.inset)
            
        }
        .padding()
        .navigationTitle("Loading Progress")
    }
    
    private func toggle(_ stage: LoadingProgress.Stage) {
        if progress.contains(stage) {
            progress.remove(stage)
        } else {
            progress.insert(stage)
        }
    }
    
    private func advance() {
        if let next = LoadingProgress.orderedStages.first(where: { !progress.contains($0) }) {
            progress.insert(next)
        }
    }
}

#Preview("LoadingProgress Example") {
    NavigationStack {
        LoadingProgressExampleView()
    }
}

struct BouncingLaunchView<Content: View, Progress: ProgressOptionSet>: View {
    @State private var isBouncing: Bool = false
    @Binding private var progress: Progress
    private var content: () -> Content
    private var bouncingParameters: BouncingLoopAnimationViewModifier.BounceParameters
    
    init(
        progress: Binding<Progress>,
        bouncingParameters: BouncingLoopAnimationViewModifier.BounceParameters = .init(
            height: -50,
            stiffness: 220,
            damping: 20,
            mass: 1,
            decay: 0.65,
            finalPause: 1.00,
            totalBounces: 2
        ),
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._progress = progress
        self.bouncingParameters = bouncingParameters
        self.content = content
    }
    
    var body: some View {
        ZStack {
            content()
                .bouncingLoopAnimation(
                    parameters: bouncingParameters,
                    isBouncing: $isBouncing
                )
            VStack(spacing: 10) {
                Spacer()
                ProgressView(value: progress.currentProgress, total: 1.0)
                    .tint(.white.opacity(0.5))
                    .animation(.bouncy, value: progress.currentProgress)
                Text("\(progress.mostRecentLabel)")
                    .font(.subheadline)
                    .fontDesign(.serif)
                    .foregroundStyle(.white.secondary)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.blue)
        .onChange(of: progress) { oldValue, newValue in
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

@available(iOS 26.0, macOS 26.0, *)
    #Preview {
        @Previewable @State var progress: LoadingProgress = .empty
        var buttonNamespace: Namespace.ID = Namespace().wrappedValue
        
        BouncingLaunchView(
            progress: $progress
        ) {
            Image(systemName: "figure.walk.diamond")
                .font(.system(size: 60))
                .padding(20)
                .background(
                    .regularMaterial.shadow(.drop(radius: 10)) ,
                    in: .rect(cornerRadius: 20, style: .continuous)
                )
        }
        .overlay(alignment: .top) {
            
            GlassEffectContainer {
                HStack {
                    Button {
                        if let next = LoadingProgress.orderedStages.first(where: { !progress.contains($0) }) {
                            progress.insert(next)
                        }
                    } label: {
                        Label("Advance", systemImage: "arrow.forward")
                            .bold()
                            .labelStyle(.iconOnly)
                            .padding(.vertical, 5)
                            .padding(.leading, 5)
                    }
                    .buttonStyle(.glassProminent)
                    .glassEffectUnion(id: "buttons", namespace: buttonNamespace)
                    Button {
                        progress = .empty
                    } label: {
                        Label("Reset", systemImage: "arrow.counterclockwise")
                            .bold()
                            .labelStyle(.iconOnly)
                            .padding(.vertical, 5)
                            .padding(.trailing, 5)
                    }
                    .buttonStyle(.glassProminent)
                    .glassEffectUnion(id: "buttons", namespace: buttonNamespace)
                    
                }
            }
            .padding(.top)
        }
    }

