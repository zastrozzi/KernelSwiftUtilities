//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 08/09/2023.
//

import Foundation

public enum JSONWebSignatureAlgorithm: String, Codable, Equatable, CaseIterable, Sendable {
    case ps256 = "PS256"
    case ps384 = "PS384"
    case ps512 = "PS512"
    case es256 = "ES256"
    case es256k = "ES256K"
    case es384 = "ES384"
    case es512 = "ES512"
    case eddsa = "EdDSA"
    case rs256 = "RS256"
    case rs384 = "RS384"
    case rs512 = "RS512"
    case hs256 = "HS256"
    case hs384 = "HS384"
    case hs512 = "HS512"
    case fallback
}
