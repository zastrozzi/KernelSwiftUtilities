//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 21/04/2023.
//

import Foundation

public enum JSONWebKeyType: String, Codable, Equatable, CaseIterable {
    case rsa = "RSA"
    case okp = "OKP"
    case ec = "EC"
    case oct = "oct"
}
