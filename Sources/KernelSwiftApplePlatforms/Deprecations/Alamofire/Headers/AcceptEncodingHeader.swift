//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 12/04/2022.
//

import Foundation

@available(*, deprecated)
public struct AcceptEncodingHeader: KernelSwiftHttpHeader {
    public let key = HeaderType.acceptEncoding.rawValue
    public let value: String?

    public init(_ value: String) {
        self.value = value
    }

    public static func gzip() -> Self {
        return Self("gzip;q=1.0, *;q=0.5")
    }
}
