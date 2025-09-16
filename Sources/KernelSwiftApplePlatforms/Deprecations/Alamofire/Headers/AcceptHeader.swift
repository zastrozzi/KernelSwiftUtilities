//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 12/04/2022.
//

import Foundation

@available(*, deprecated)
public struct AcceptHeader: BKHttpHeader {
    public var key = HeaderType.accept.rawValue
    public var value: String?
    
    public init(_ value: String) {
        self.value = value
    }
    
    public static func json() -> Self {
        return Self("application/json")
    }

    public static func formUrlEncoded() -> Self {
        return Self("application/x-www-form-urlencoded")
    }
}
