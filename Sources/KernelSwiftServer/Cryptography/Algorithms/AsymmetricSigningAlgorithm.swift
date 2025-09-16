//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 11/04/2023.
//

import Foundation

extension KernelCryptography.Algorithms {
    public enum AsymmetricSigningAlgorithm: String, Codable, Equatable, CaseIterable, Sendable {
        case PS256 = "PS256"
        case PS384 = "PS384"
        case PS512 = "PS512"
        case ES256 = "ES256"
        case ES256K = "ES256K"
        case ES384 = "ES384"
        case ES512 = "ES512"
        case EdDSA = "EdDSA"
        case RS256 = "RS256"
        case RS384 = "RS384"
        case RS512 = "RS512"
    }
}

extension KernelCryptography.Algorithms.AsymmetricSigningAlgorithm: OpenAPIStringEnumSampleable {}
