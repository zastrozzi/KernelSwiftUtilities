//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 12/04/2022.
//

import Foundation

@available(*, deprecated)
public struct ContentLengthHeader: BKHttpHeader {
    public let key = HeaderType.contentLength.rawValue
    public let value: String?

    public init(_ count: Int) {
        self.value = "\(count)"
    }

    public init(_ value: String) {
        self.value = value
    }
}
