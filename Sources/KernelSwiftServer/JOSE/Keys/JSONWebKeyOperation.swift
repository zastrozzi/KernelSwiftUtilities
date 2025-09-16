//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 21/04/2023.
//

import Foundation

public enum JSONWebKeyOperation: String, Codable, Equatable, CaseIterable {
    case sign = "sign"
    case verify = "verify"
    case encrypt = "encrypt"
    case decrypt = "decrypt"
    case wrapKey = "wrapKey"
    case unwrapKey = "unwrapKey"
    case deriveKey = "deriveKey"
    case deriveBits = "deriveBits"
}
