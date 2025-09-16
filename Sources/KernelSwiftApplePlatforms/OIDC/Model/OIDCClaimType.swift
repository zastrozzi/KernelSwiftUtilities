//
//  File.swift
//
//
//  Created by Jonathan Forbes on 23/04/2023.
//

import Foundation

public enum OIDCClaimType: String, Codable, Equatable, CaseIterable, Sendable {
    case normal = "normal"
    case aggregated = "aggregated"
    case `distributed` = "distributed"
}

