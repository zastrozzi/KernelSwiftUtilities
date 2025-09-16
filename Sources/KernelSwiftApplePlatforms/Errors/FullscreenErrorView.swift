//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 21/08/2023.
//

import Foundation
import SwiftUI
import KernelSwiftCommon

public struct FullscreenErrorView: View {
    private var errorText: String = "An unknown error has occurred. Please contact support or try again later."
    @Environment(\.dismiss) private var dismiss
    
    public init(errorText: String = "An unknown error has occurred. Please contact support or try again later.") {
        self.errorText = errorText
    }
    
    public var body: some View {
        VStack {
            Spacer()
            Text(errorText).font(.title).multilineTextAlignment(.center)
                .padding()
                .frame(maxWidth: 600)
            Button(action: { dismiss() }) {
                Label("Go back", systemImage: "arrow.backward.circle.fill")
            }.buttonStyle(.borderedProminent)
            Spacer()
        }.frame(maxWidth: .infinity).background(Color.systemBackground)
    }
}
//
//#Preview {
//    FullscreenErrorView()
//}
