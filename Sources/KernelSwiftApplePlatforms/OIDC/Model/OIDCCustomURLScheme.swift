//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 13/09/2023.
//

import Foundation

public enum OIDCCustomURLScheme: Codable, Equatable, Sendable {
    case bundleIdentifier
    case custom(scheme: String)
    
    public func resolve() -> String {
        switch self {
        case .bundleIdentifier:
            guard let identifier = Bundle.main.bundleIdentifier else { preconditionFailure("Unable to resolve bundle identifier")}
            return identifier
        case let .custom(scheme): return scheme
        }
    }
}
