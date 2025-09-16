//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 13/09/2023.
//

import Foundation

public enum OIDCRedirectURI: Codable, Equatable, Sendable {
    case absoluteString(value: String)
    case bundleIdentifier(subpath: String?)
    
    public func resolve() -> String {
        switch self {
        case .absoluteString(let value): 
            return value
        case .bundleIdentifier(let subpath):
            guard let identifier = Bundle.main.bundleIdentifier else { preconditionFailure("Unable to resolve bundle identifier")}
            guard let subpath else { return identifier + ":/" }
            return identifier + ":/" + subpath
        }
    }
}
