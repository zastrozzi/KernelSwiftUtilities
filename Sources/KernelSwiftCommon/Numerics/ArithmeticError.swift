//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 14/05/2023.
//

import Foundation

public enum ArithmeticError: Error, CustomStringConvertible, LocalizedError {
    case outOfRange
    case ecPointDecoding
    case ecPointEncoding
    
    public var reason: String {
        switch self {
        case .outOfRange: return "Value is out of range"
        case .ecPointDecoding: return "EC Point decoding failed"
        case .ecPointEncoding: return "EC Point encoding failed"
        }
    }
    
    public var description: String {
//        let x: UInt8 = .asn1.
        return "ArithmeticError: \(self.reason)"
    }
    
    public var errorDescription: String? { description }
}
