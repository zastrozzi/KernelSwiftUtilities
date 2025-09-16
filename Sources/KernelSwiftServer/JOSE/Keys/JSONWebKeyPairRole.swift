//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 27/04/2023.
//

import Foundation

public enum JSONWebKeyKeyPairRole: String, Codable, Equatable, CaseIterable {
    case publicKey = "publicKey"
    case privateKey = "privateKey"
}
