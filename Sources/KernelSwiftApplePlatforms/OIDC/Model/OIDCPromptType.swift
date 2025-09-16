//
//  File.swift
//
//
//  Created by Jonathan Forbes on 13/04/2023.
//

import Foundation

public enum OIDCPromptType: String, Codable, Equatable, CaseIterable, Sendable {
    case login = "login"
    case consent = "consent"
    case none = "none"
    case selectAccount = "select_account"
    case create = "create"
}
