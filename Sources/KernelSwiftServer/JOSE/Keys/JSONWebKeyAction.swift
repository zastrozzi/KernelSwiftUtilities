//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 22/04/2023.
//

import Foundation

public enum JSONWebKeyAction: String, Codable, Equatable, CaseIterable {
    case signature = "signature"
    case verification = "verification"
    case encryption = "encryption"
    case decryption = "decryption"
}

extension JSONWebKeyAction {
    public var webKeyOperations: [JSONWebKeyOperation] {
        switch self {
        case .signature: return [.sign]
        case .verification: return [.verify]
        case .decryption: return [.decrypt, .deriveBits, .deriveKey, .unwrapKey]
        case .encryption: return [.encrypt, .wrapKey]
        }
    }
    
    public var keyUse: JSONWebKeyUse {
        switch self {
        case .signature, .verification: return .signature
        case .encryption, .decryption: return .encryption
        }
    }
}
