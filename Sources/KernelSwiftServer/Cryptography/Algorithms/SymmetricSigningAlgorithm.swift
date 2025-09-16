//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 11/04/2023.
//

import Foundation

extension KernelCryptography.Algorithms {
    public enum SymmetricSigningAlgorithm: String, Codable, Equatable, CaseIterable, Sendable {
        case HS256 = "HS256"
        case HS384 = "HS384"
        case HS512 = "HS512"
    }
}
