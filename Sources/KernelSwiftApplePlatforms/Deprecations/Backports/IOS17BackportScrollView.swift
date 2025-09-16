//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 19/08/2023.
//

import Foundation
import SwiftUI

public struct IOS17BackportScrollView<Content: View>: View {
    var content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    
    public var body: some View {
        if #available(iOS 17.0, macOS 13.3, *) {
            ScrollView {
                VStack(spacing: 0) {
                    content()
                }
                    .listRowSeparator(.hidden)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .scrollBounceBehavior(.basedOnSize)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .listStyle(.plain)
        } else {
            ScrollView(.vertical) { content() }
        }
    }
}

