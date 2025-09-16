//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 06/03/2025.
//

import Foundation
import SwiftUI
import Observation

public struct OTPInputView: View {
    @FocusState private var isFocused: Bool
    @Environment(\.isEnabled) var isEnabled
    var onCompleteHandler: (String) -> Void
    
    @State var otpField = ""
    
    public init(onComplete: @escaping (String) -> Void) {
        onCompleteHandler = onComplete
    }
    
    public var body: some View {
        ZStack {
            HStack {
                otpCell(text: otp1)
                otpCell(text: otp2)
                otpCell(text: otp3)
                otpCell(text: otp4)
                otpCell(text: otp5)
                otpCell(text: otp6)
            }
#if os(iOS)
            TextField("", text: $otpField)
                .frame(height: 60)
                .disabled(!isEnabled)
                .focused($isFocused)
                .textContentType(.oneTimeCode)
                .foregroundColor(.clear)
                .accentColor(.clear)
                .background(Color.clear)
                .keyboardType(.numberPad)
#endif
        }
        .frame(height: 60)
        .padding()
        .onChange(of: isFocused, syncFocusState)
        .onChange(of: otpField, syncOTPState)
    }
    
    @ViewBuilder
    private func otpCell(text: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 7).foregroundStyle(Color.secondarySystemFill)
            Text(String(text)).font(.system(size: 34, weight: .bold, design: .rounded)).frame(height: 60)
        }
    }
    
    private func syncFocusState(_ oldValue: Bool, _ newValue: Bool) {
        if newValue { otpField = "" }
    }
    
    private func syncOTPState(_ oldValue: String, _ newValue: String) {
        if newValue.count == 6 {
            onCompleteHandler(newValue)
            isFocused = false
        }
    }
    
    var otp1: String {
        guard otpField.count >= 1 else { return "" }
        return String(Array(otpField)[0])
    }
    
    var otp2: String {
        guard otpField.count >= 2 else { return "" }
        return String(Array(otpField)[1])
    }
    
    var otp3: String {
        guard otpField.count >= 3 else { return "" }
        return String(Array(otpField)[2])
    }
    
    var otp4: String {
        guard otpField.count >= 4 else { return "" }
        return String(Array(otpField)[3])
    }
    
    var otp5: String {
        guard otpField.count >= 5 else { return "" }
        return String(Array(otpField)[4])
    }
    
    var otp6: String {
        guard otpField.count >= 6 else { return "" }
        return String(Array(otpField)[5])
    }
}
