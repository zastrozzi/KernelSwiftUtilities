//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 12/06/2022.
//

import Foundation

@available(*, deprecated)
public struct ConnectionHeader: KernelSwiftHttpHeader {
    public let key = HeaderType.connection.rawValue
    public let value: String?

    public init(_ value: String) {
        self.value = value
    }

    public static func close() -> Self {
        return Self("close")
    }

    public static func keepAlive() -> Self {
        return Self("keep-alive")
    }
}
