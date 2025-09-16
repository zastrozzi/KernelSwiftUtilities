//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 12/04/2022.
//

import Foundation

@available(*, deprecated)
public struct ContentTypeHeader: BKHttpHeader {
    public let key = HeaderType.contentType.rawValue
    public let value: String?

    public init(_ value: String) {
        self.value = value
    }

    public static func json() -> Self {
        return Self("application/json")
    }

    public static func formUrlEncoded() -> Self {
        return Self("application/x-www-form-urlencoded")
    }
    
    public static func binary() -> Self {
        return Self("application/x-binary")
    }
}
