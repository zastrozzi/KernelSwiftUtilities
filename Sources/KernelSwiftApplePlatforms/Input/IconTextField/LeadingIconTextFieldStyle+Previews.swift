//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 19/03/2025.
//

import Foundation
import SwiftUI

struct LeadingIconTextFieldStylePreviews: View {
    @State var inputText: String = ""
    @State var iconInputText: String = ""
    @FocusState var inputFocused: Bool
    @FocusState var iconInputFocused: Bool
    
    var body: some View {
        ScrollView {
            LazyVStack {
                TextField("Text Field", text: $inputText)
                    .focused($inputFocused)
                #if os(iOS)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                #endif
                    .textContentType(.emailAddress)
                    .textFieldStyle(
                        LeadingIconTextFieldStyle(
                            isFocused: $inputFocused,
                            focusedStrokeColor: .accentColor,
                            defocusedStrokeColor: .systemFill,
                            focusedLeadingIconName: "mail.and.text.magnifyingglass",
//                            defocusedLeadingIconName: "mail",
//                            showLeadingIconWhenDefocused: true,
                            font: .body
                        )
                    )
                    .submitLabel(.continue)
                LeadingIconTextField(
                    "Leading Icon Text Field",
                    text: $iconInputText,
                    isFocused: $iconInputFocused,
                    focusedStrokeColor: .accentColor,
                    defocusedStrokeColor: .blue,
                    focusedBackgroundStyle: .init(Color.blue.gradient.quaternary.shadow(.inner(radius: 10)).shadow(.drop(radius: 5, y: 5))),
                    defocusedBackgroundStyle: .init(Color.green.gradient.shadow(.inner(radius: 10)).shadow(.drop(radius: 5, y: 5))),
                    defocusedPlaceholderColor: .white.opacity(0.7),
                    defocusedColor: .white,
                    defocusedIconColor: .white.opacity(0.7),
                    focusedLeadingIconName: "mail.and.text.magnifyingglass",
                    defocusedLeadingIconName: "mail",
                    showLeadingIconWhenDefocused: true,
                    font: .body.weight(.medium),
                    cornerRadius: 40,
                    cornerStyle: .continuous
                )
//                    .focused($iconInputFocused)
#if os(iOS)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .autocapitalization(.none)
                    .submitLabel(.continue)
                #endif
                    
            }.padding()
        }
    }
}

#Preview {
    LeadingIconTextFieldStylePreviews()
}
