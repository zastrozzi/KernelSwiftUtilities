//
//  File.swift
//
//
//  Created by Jonathan Forbes on 23/04/2023.
//

import Foundation

public enum OIDCCodeChallengeMethod: String, Codable, Equatable, CaseIterable, Sendable {
    case plain = "plain"
    case s256 = "S256"
}
