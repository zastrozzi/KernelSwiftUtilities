//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 15/04/2023.
//

import Foundation

public enum CookieSameSite: String, Codable, Equatable, CaseIterable {
    case strict = "strict"
    case lax = "lax"
    case noneSetting = "none"
}
