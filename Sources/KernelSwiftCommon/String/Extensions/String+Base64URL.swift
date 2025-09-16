//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 22/04/2023.
//

import Foundation

extension String {
    public func base64URLEscaped() -> String {
        replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
    
    public func base64URLUnescaped() -> String {
        replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
            .appending(String(repeating: "=", count: 4 - (count % 4)))
    }
    
    public mutating func base64URLEscape() { self = base64URLEscaped() }
    
    public mutating func base64URLUnescape() { self = base64URLUnescaped() }
}
