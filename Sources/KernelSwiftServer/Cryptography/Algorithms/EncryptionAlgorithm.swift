//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 11/04/2023.
//

import Foundation

extension KernelCryptography.Algorithms {
    public enum EncryptionAlgorithm: String, Codable, Equatable, CaseIterable {
        case RSA_OAEP = "RSA-OAEP"
        case RSA_OAEP_256 = "RSA-OAEP-256"
        case RSA_OAEP_384 = "RSA-OAEP-384"
        case RSA_OAEP_512 = "RSA-OAEP-512"
        case ECDH_ES = "ECDH-ES"
        case ECDH_ES_A128KW = "ECDH-ES+A128KW"
        case ECDH_ES_A192KW = "ECDH-ES+A192KW"
        case ECDH_ES_A256KW = "ECDH-ES+A256KW"
        case A128KW = "A128KW"
        case A192KW = "A192KW"
        case A256KW = "A256KW"
        case A128GCMKW = "A128GCMKW"
        case A192GCMKW = "A192GCMKW"
        case A256GCMKW = "A256GCMKW"
        case dir = "dir"
    }
}
