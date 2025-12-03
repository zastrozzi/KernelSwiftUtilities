//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 01/12/2025.
//

import Foundation
import SwiftUI

public protocol ProgressOptionSet: ExpressibleByArrayLiteral, Hashable, Sendable where ArrayLiteralElement == Stage {
    associatedtype Stage: CaseIterable & RawRepresentable & Hashable & Sendable where Stage.RawValue == UInt
    /// Storage for completed stages
    var completed: Set<Stage> { get set }
    /// The most recently completed stage (if known).
    var mostRecentStage: Stage? { get set }
    /// Display label for a single stage.
    static func label(for stage: Stage) -> String
    /// Default initializer
    init()
    /// Default label
    static var defaultLabel: String { get }
}

// MARK: OptionSet API
extension ProgressOptionSet {
    public var isEmpty: Bool { completed.isEmpty }
    public var count: Int { completed.count }
    public func contains(_ stage: Stage) -> Bool { completed.contains(stage) }
    public mutating func insert(_ stage: Stage) {
        completed.insert(stage)
        self.mostRecentStage = stage
    }
    public mutating func remove(_ stage: Stage) {
        completed.remove(stage)
        if mostRecentStage == stage {
            mostRecentStage = latestStage
        }
    }
    
    public func union(_ other: Self) -> Self { var copy = self; copy.formUnion(other); return copy }
    public mutating func formUnion(_ other: Self) {
        completed.formUnion(other.completed)
        if let m = other.mostRecentStage {
            self.mostRecentStage = m
        }
    }
    public func intersection(_ other: Self) -> Self {
        var copy = self
        copy.formIntersection(other)
        return copy
    }
    public mutating func formIntersection(_ other: Self) {
        completed.formIntersection(other.completed)
        if let m = mostRecentStage, !completed.contains(m) {
            mostRecentStage = latestStage
        }
    }
    public func subtracting(_ other: Self) -> Self {
        var copy = self
        copy.subtract(other)
        return copy
    }
    public mutating func subtract(_ other: Self) {
        let removing = other.completed
        completed.subtract(removing)
        if let m = mostRecentStage, removing.contains(m) {
            mostRecentStage = latestStage
        }
    }
    public func isSuperset(of other: Self) -> Bool { completed.isSuperset(of: other.completed) }
    public func isSubset(of other: Self) -> Bool { completed.isSubset(of: other.completed) }
    
    public static func | (lhs: Self, rhs: Self) -> Self { lhs.union(rhs) }
    public static func |= (lhs: inout Self, rhs: Self) { lhs.formUnion(rhs) }
    public static func & (lhs: Self, rhs: Self) -> Self { lhs.intersection(rhs) }
    public static func &= (lhs: inout Self, rhs: Self) { lhs.formIntersection(rhs) }
    public static func - (lhs: Self, rhs: Self) -> Self { lhs.subtracting(rhs) }
    public static func -= (lhs: inout Self, rhs: Self) { lhs.subtract(rhs) }
    
    /// Union of all stages.
    public static var all: Self { Self(orderedStages) }
    /// An empty set of stages.
    public static var empty: Self { Self() }
}

extension ProgressOptionSet {
    /// Ordered list of single stages from earliest to latest.
    public static var orderedStages: [Stage] {
        Array(Stage.allCases).sorted { $0.rawValue < $1.rawValue }
    }
    
    /// Initialise from a sequence of stages.
    public init<S: Sequence>(_ stages: S) where S.Element == Stage {
        self.init()
        let array = Array(stages)
        self.completed = Set(array)
        self.mostRecentStage = array.last
    }
    
    public init(arrayLiteral elements: Stage...) {
        self.init(elements)
    }
    
    /// Initialise from a single stage.
    public init(_ stage: Stage) {
        self.init()
        self.completed = [stage]
        self.mostRecentStage = stage
    }
    
    /// The latest stage contained in this set based on `orderedStages`.
    public var latestStage: Stage? {
        for stage in Self.orderedStages.reversed() where completed.contains(stage) { return stage }
        return nil
    }
    
    /// A display label representing the latest stage in this set.
    public var currentLabel: String {
        guard let s = latestStage else { return Self.defaultLabel }
        return Self.label(for: s)
    }
    
    public var mostRecentLabel: String {
        guard let s = mostRecentStage else { return Self.defaultLabel }
        return Self.label(for: s)
    }
    
    /// The fraction of stages contained in this set.
    public var currentProgress: Double {
        let uniqueStages = Set(Self.orderedStages)
        let total = uniqueStages.count
        guard total > 0 else { return 0.0 }
        let completedCount = completed.intersection(uniqueStages).count
        return Double(completedCount) / Double(total)
    }
}
//
//struct LoadingProgress: @MainActor ProgressOptionSet {
//    enum Stage: UInt, CaseIterable, Hashable, Sendable {
//        case loadingPoems
//        case loadedPoems
//        case loadingAuthors
//        case loadedAuthors
//        case loadingCollections
//        case loadedCollections
//    }
//    
//    // Storage for completed stages
//    var completed: Set<Stage> = []
//    // Most recently completed stage
//    var mostRecentStage: Stage? = nil
//    
//    static func label(for stage: Stage) -> String {
//        switch stage {
//        case .loadingPoems: return "Loading Poems"
//        case .loadedPoems: return "Loaded Poems"
//        case .loadingAuthors: return "Loading Authors"
//        case .loadedAuthors: return "Loaded Authors"
//        case .loadingCollections: return "Loading Collections"
//        case .loadedCollections: return "Loaded Collections"
//        }
//    }
//}
//
//struct LoadingProgressExampleView: View {
//    @State private var progress = LoadingProgress.empty
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            Text("Last: \(progress.currentLabel.isEmpty ? "" : progress.currentLabel)")
//                .font(.headline)
//            Text("Latest: \(progress.mostRecentLabel.isEmpty ? "" : progress.mostRecentLabel)")
//                .font(.subheadline)
//                .foregroundStyle(.secondary)
//            
//            ProgressView(value: progress.currentProgress, total: 1.0)
//                .tint(.accentColor)
//                .animation(.bouncy, value: progress.currentProgress)
//            
//            HStack {
//                Text("\(Int((progress.currentProgress * 100).rounded()))%")
//                    .monospacedDigit()
//                    .foregroundStyle(.secondary)
//                Spacer()
//                Button("Advance") { advance() }
//                Button("Reset", role: .destructive) { progress = .empty }
//            }
//            
//            List {
//                ForEach(LoadingProgress.orderedStages, id: \.self) { stage in
//                    Button {
//                        toggle(stage)
//                    } label: {
//                        HStack {
//                            Image(systemName: progress.contains(stage) ? "checkmark.circle.fill" : "circle")
//                                .foregroundStyle(progress.contains(stage) ? .green : .secondary)
//                            Text(LoadingProgress.label(for: stage))
//                        }
//                    }
//                }
//            }
//            .listStyle(.inset)
//            
//        }
//        .padding()
//        .navigationTitle("Loading Progress")
//    }
//    
//    private func toggle(_ stage: LoadingProgress.Stage) {
//        if progress.contains(stage) {
//            progress.remove(stage)
//        } else {
//            progress.insert(stage)
//        }
//    }
//    
//    private func advance() {
//        if let next = LoadingProgress.orderedStages.first(where: { !progress.contains($0) }) {
//            progress.insert(next)
//        }
//    }
//}
//
//#Preview("LoadingProgress Example") {
//    NavigationStack {
//        LoadingProgressExampleView()
//    }
//}
