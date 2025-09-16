//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 11/03/2025.
//

import Foundation
import SwiftUI

struct FlatButtonStylePreviews: View {
    @State var buttonEnabled: Bool = true
    @State var buttonTaps: Int = 0
    
    var body: some View {
        ScrollView {
            LazyVStack {
                Button("Trailing Full Width") {
                    buttonTaps += 1
                }.buttonStyle(
                    .flat
                        .backgroundColor(.accentColor)
                        .color(.white)
                        .fullWidth(true)
                        .font(.headline)
                        .padding(.init(vertical: 10, horizontal: 10))
                        .trailingIconName("arrow.right")
                        .trailingIconFont(.system(size: 16, weight: .semibold, design: .rounded))
                        .trailingInnerSpacing(true)
                        .scalingAnchorPoint(.leading)
                )
                .disabled(!(buttonEnabled && (buttonTaps < 5)))
            }.padding()
        }
    }
}

#Preview {
    FlatButtonStylePreviews()
}
