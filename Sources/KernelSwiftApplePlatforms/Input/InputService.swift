//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 28/08/2023.
//

import Foundation
import SwiftUI
import KernelSwiftCommon


@available(iOS 17.0, macOS 14.0, *)
extension KernelDI.Injector {
    public var inputService: InputService {
        get { self[InputService.Token.self] }
        set { self[InputService.Token.self] = newValue }
    }
}


@available(iOS 17.0, macOS 14.0, *)
@Observable
public final class InputService: KernelDI.Injectable, @unchecked Sendable {
    
    public var currencyKeyboardSelection: InputCurrency = .STERLING
    public var hasCurrencyKeyboard: Bool = false
    public var currentInputCanSubmit: Bool = false
    public var currentInputSubmitted: () -> Void = { }
    //    var goalsTab: GoalsTabSelection = .SAVINGS
    
    required public init() {}
    
    public func submitCurrentInput() {
        if currentInputCanSubmit {
            currentInputSubmitted()
        }
    }
    
    public func setCurrentInputCanSubmit(_ value: Bool) {
        withAnimation(.smooth) {
            currentInputCanSubmit = value
        }
    }
    
    public func removeCurrencyKeyboard() {
        hasCurrencyKeyboard = false
    }
    
    public func resetCanSubmit(delayed: Bool = false) {
        if delayed {
            Task.detached {
                try await Task.sleep(for: .milliseconds(300))
                withAnimation(.smooth) {
                    self.currentInputCanSubmit = false
                }
            }
        } else {
            self.currentInputCanSubmit = false
        }
    }
    
    public func setCurrencyKeyboardSelection(_ currency: InputCurrency) {
        currencyKeyboardSelection = currency
    }
}

