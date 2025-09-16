//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 21/04/2023.
//

import Foundation

public enum JSONWebEllipticCurve: String, Codable, Equatable, CaseIterable {
    case p256 = "P-256"
    case p384 = "P-384"
    case p521 = "P-521"
    case secp256k1 = "secp256k1"
    case ed25519 = "Ed25519"
    case ed448 = "Ed448"
    case x25519 = "X25519"
    case x448 = "X448"
}
