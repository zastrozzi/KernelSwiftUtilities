//
//  File.swift
//
//
//  Created by Jonathan Forbes on 11/04/2023.
//

import Foundation

public enum OIDCSubjectType: String, Codable, Equatable, CaseIterable, Sendable {
    case pairwise = "pairwise"
    case `public` = "public"
}
