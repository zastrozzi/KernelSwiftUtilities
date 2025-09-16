//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 23/08/2023.
//

import Foundation

public enum InteractionFlowError: Error, LocalizedError, CustomStringConvertible {
    case noElements
    case identifierNotFound
    
    public var errorDescription: String? { self.description }
    
    public var description: String {
        let caseDescription: String = switch self {
        case .noElements: "No Elements"
        case .identifierNotFound: "Identifier not found"
        }
        
        return "InteractionFlowError: \(caseDescription)"
    }
}
