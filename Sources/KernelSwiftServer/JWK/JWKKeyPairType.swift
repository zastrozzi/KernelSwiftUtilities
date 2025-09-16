//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 16/04/2023.
//

import Foundation

public enum JWKKeyPairType: String, Codable, Equatable, CaseIterable {
    case rsa = "RSA"
    case okp = "OKP"
    case ec = "EC"
    case oct = "oct"
}
