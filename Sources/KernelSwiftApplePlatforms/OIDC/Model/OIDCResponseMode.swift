//
//  File.swift
//
//
//  Created by Jonathan Forbes on 23/04/2023.
//

import Foundation

public enum OIDCResponseMode: String, Codable, Equatable, CaseIterable, Sendable {
    case query = "query"
    case fragment = "fragment"
    case formPost = "form_post"

}
