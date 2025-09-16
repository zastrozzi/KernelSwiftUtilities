//
//  File.swift
//
//
//  Created by Jonathan Forbes on 23/04/2023.
//

import Foundation

public enum OIDCDisplayType: String, Codable, Equatable, CaseIterable, Sendable {
    case page = "page"
    case popup = "popup"
    case touch = "touch"
    case wap = "wap"
}
