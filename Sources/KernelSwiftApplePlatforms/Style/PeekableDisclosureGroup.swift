//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 24/10/2025.
//

import Foundation
import SwiftUI

public struct PeekableDisclosureGroupStyle: DisclosureGroupStyle {
    private let systemImage: String
    private let lineLimit: Int
    private let animation: Animation?
    private let expandable: Bool
    
    public init(
        systemImage: String,
        lineLimit: Int,
        animation: Animation?,
        expandable: Bool
    ) {
        self.systemImage = systemImage
        self.lineLimit = lineLimit
        self.animation = animation
        self.expandable = expandable
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        PeekableDisclosureGroupView(
            configuration: configuration,
            systemImage: systemImage,
            lineLimit: lineLimit,
            animation: animation,
            expandable: expandable
        )
    }
    
    private struct PeekableDisclosureGroupView: View {
        let configuration: Configuration
        let systemImage: String
        let lineLimit: Int
        let animation: Animation?
        let expandable: Bool
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                // Header
                Button {
                    if expandable {
                        withAnimation(animation) {
                            configuration.isExpanded.toggle()
                        }
                    }
                } label: {
                    HStack(alignment: .firstTextBaseline) {
                        configuration.label
                        Spacer(minLength: 8)
                        if expandable {
                            Image(systemName: systemImage)
                                .rotationEffect(.degrees(configuration.isExpanded ? 180 : 0))
                                .accessibilityHidden(true)
                        }
                    }
                }
                .buttonStyle(.plain)
                
                configuration.content
                    .lineLimit(configuration.isExpanded ? nil : lineLimit)
                    .clipped()
                
                    .animation(animation, value: configuration.isExpanded)
            }
        }
    }
}

extension DisclosureGroupStyle where Self == PeekableDisclosureGroupStyle {
    public static func peekable(
        systemImage: String = "chevron.down",
        lineLimit: Int = 3,
        animation: Animation? = .none,
        expandable: Bool = true
    ) -> PeekableDisclosureGroupStyle {
        .init(
            systemImage: systemImage,
            lineLimit: lineLimit,
            animation: animation,
            expandable: expandable
        )
    }
}
