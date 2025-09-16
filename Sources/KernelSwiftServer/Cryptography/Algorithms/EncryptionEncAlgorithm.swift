//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 13/04/2023.
//

import Foundation

extension KernelCryptography.Algorithms {
    public enum EncryptionEncAlgorithm: String, Codable, Equatable, CaseIterable {
        case A128CBC_HS256 = "A128CBC-HS256"
        case A128GCM = "A128GCM"
        case A192CBC_HS384 = "A192CBC-HS384"
        case A192GCM = "A192GCM"
        case A256CBC_HS512 = "A256CBC-HS512"
        case A256GCM = "A256GCM"
    }
}
