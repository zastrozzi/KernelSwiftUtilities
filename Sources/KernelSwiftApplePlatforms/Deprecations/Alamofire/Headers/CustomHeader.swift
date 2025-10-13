//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 12/04/2022.
//

import Foundation

@available(*, deprecated)
public struct CustomHeader: KernelSwiftHttpHeader {
    public let key: String
    public let value: String?

    public init(
        key: String,
        value: String?
    ) {
        self.key = key
        self.value = value
    }
}
