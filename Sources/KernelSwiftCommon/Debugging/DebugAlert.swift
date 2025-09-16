//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 13/09/2023.
//

import Foundation

public enum DebugAlert {
    case hidden
    case presented(title: String, message: String)
    
    public var isPresented: Bool {
        get {
            if case .presented = self { true } else { false }
        }
        set { if !newValue { self = .hidden } }
    }
    
    public var title: String {
        if case let .presented(title, _) = self { title }
        else { "" }
    }
    
    public var message: String {
        if case let .presented(_, message) = self { message }
        else { "" }
    }
    
    public mutating func dismiss() {
        self = .hidden
    }
    
    public mutating func present(title: String, message: String) {
        self = .presented(title: title, message: message)
    }
}
