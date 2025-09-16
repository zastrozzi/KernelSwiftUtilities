//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 19/04/2023.
//

import Foundation

public enum JWKPublicKeyUse: String, Codable, Equatable, CaseIterable {
    case signature = "sig"
    case encryption = "enc"
}
