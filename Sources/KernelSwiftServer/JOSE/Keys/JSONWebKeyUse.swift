//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 21/04/2023.
//

import Foundation

public enum JSONWebKeyUse: String, Codable, Equatable, CaseIterable {
    case signature = "sig"
    case encryption = "enc"
}
