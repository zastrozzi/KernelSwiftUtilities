//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/08/2023.
//

import Foundation
import SwiftUI

@available(iOS 17.0, macOS 14.0, *)
public struct BinaryInputView: View {
    @Binding var selectedOption: (any BinaryInputRepresentable)?
    let options: [any BinaryInputRepresentable]
    var onChanged: (Bool) -> Void
    
    public init(options: [any BinaryInputRepresentable], selectedOption: Binding<(any BinaryInputRepresentable)?>, onChanged: @escaping (Bool) -> Void = { _ in }) {
        self._selectedOption = selectedOption
        self.options = options
        guard options.count == 2 else { preconditionFailure("Not enough options") }
        self.firstOption = options.first!
        self.lastOption = options.last!
        self.onChanged = onChanged
    }
    
    func handleSelection(_ option: (any BinaryInputRepresentable)?) async throws {
        withAnimation(.bouncy) { selectedOption = option }
        try await Task.sleep(for: .milliseconds(100))
        onChanged(option != nil)
//        if option == nil { onChanged() }
//        else {
//            
//        }
    }
    
    var firstOption: any BinaryInputRepresentable
    var lastOption: any BinaryInputRepresentable
    
    public var body: some View {
//        let hasSelection = selectedOption != nil
        HStack(alignment: .center) {
            if !(selectedOption != nil) || firstOption.equals(selectedOption) {
                BinaryInputOptionView(item: firstOption) {
                    try await handleSelection(firstOption)
                }
            } else { EmptyView() }
            if !(selectedOption != nil) || lastOption.equals(selectedOption) {
                BinaryInputOptionView(item: lastOption) {
                    try await handleSelection(lastOption)
                }
            } else { EmptyView() }
            if (selectedOption != nil) {
                Button(action: { Task { try await handleSelection(nil) } }) {
                    Image(systemName: "arrow.counterclockwise")
                        .imageScale(.large)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.orange)
                }
                .buttonStyle(.plain)
                .transition(.offset(x: 50).combined(with: .opacity))
                .frame(maxHeight: .infinity)
            } else { EmptyView() }
        }.padding(.horizontal).fixedSize(horizontal: false, vertical: true)
    }
}

@available(iOS 17.0, macOS 14.0, *)
public struct BinaryInputOptionView: View {
    var item: any BinaryInputRepresentable
    var onSelected: () async throws -> Void
    
    public init(item: any BinaryInputRepresentable, onSelected: @escaping () async throws -> Void) {
        self.item = item
        self.onSelected = onSelected
    }
    
    public var body: some View {
        Button(action: { Task { try await onSelected() } }) {
            HStack {
                Image(systemName: item.image)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(item.iconColor)
                    .font(KernelSwiftFont(size: 25, weight: .medium).iconFont)
                Text(item.title).foregroundStyle(item.labelColor).fontWeight(.medium)
                Spacer()
            }.padding(8).background(Color.quaternarySystemFill).clipShape(.rect(cornerRadius: 20, style: .continuous))
        }
//        .controlSize(.extraLarge)
//        .buttonStyle(.plain)
        .transition(.move(edge: item.rawValue == true ? .trailing : .leading).combined(with: .offset(x: item.rawValue == true ? 50 : -50)))
    }
}
