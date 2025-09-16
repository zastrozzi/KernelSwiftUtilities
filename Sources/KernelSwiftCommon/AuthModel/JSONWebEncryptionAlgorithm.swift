//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 08/09/2023.
//

import Foundation

public enum JSONWebEncryptionAlgorithm: String, Codable, Equatable, CaseIterable, Sendable {
    case rsaoaep = "RSA-OAEP"
    case rsaoeap256 = "RSA-OAEP-256"
    case rsaoeap384 = "RSA-OAEP-384"
    case rsaoeap512 = "RSA-OAEP-512"
    case ecdhes = "ECDH-ES"
    case ecdhesa128kw = "ECDH-ES+A128KW"
    case ecdhesa192kw = "ECDH-ES+A192KW"
    case ecdhesa256kw = "ECDH-ES+A256KW"
    case a128kw = "A128KW"
    case a192kw = "A192KW"
    case a256kw = "A256KW"
    case a128gcmkw = "A128GCMKW"
    case a192gcmkw = "A192GCMKW"
    case a256gcmkw = "A256GCMKW"
    case direct = "dir"
    case fallback
}
