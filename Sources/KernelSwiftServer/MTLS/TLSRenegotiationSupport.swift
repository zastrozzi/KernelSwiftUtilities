//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 26/10/2022.
//

import Foundation
import NIOSSL

public enum TLSRenegotiationSupport: String, Codable, Equatable, CaseIterable {
    case none = "none"
    case once = "once"
    case always = "always"
    
    public var normalized: NIORenegotiationSupport {
        switch self {
        case .none:
            return .none
        case .once:
            return .once
        case .always:
            return .always
        }
    }
}

extension TLSRenegotiationSupport: OpenAPIStringEnumSampleable {}
