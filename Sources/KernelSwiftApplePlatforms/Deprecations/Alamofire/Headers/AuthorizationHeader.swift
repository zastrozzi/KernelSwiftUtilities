//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 12/04/2022.
//

import Foundation

@available(*, deprecated)
public struct AuthorizationHeader: KernelSwiftHttpHeader {
    public let key = HeaderType.authorization.rawValue
    public let value: String?

    public init(_ value: String? = nil) {
        self.value = value
    }

    public static func token(_ value: String?) -> Self {
        let tokenValue = value.map { "Token \($0)" }
        return Self(tokenValue)
    }

    public static func bearer(_ value: String?) -> Self {
        let bearerValue = value.map { "Bearer \($0)" }
        return Self(bearerValue)
    }

    public static func basic(_ value: String?) -> Self {
        let basicValue = value.map { "Basic \($0)" }
        return Self(basicValue)
    }
    
    public static func customPrefix(_ customPrefix: String, _ value: String) -> Self {
        let customPrefixValue = "\(customPrefix) \(value)"
        return Self(customPrefixValue)
    }
}
