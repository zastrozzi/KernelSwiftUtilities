//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 12/04/2022.
//

import Foundation

@available(*, deprecated)
public struct AcceptLanguageHeader: KernelSwiftHttpHeader {
    public let key = HeaderType.acceptLanguage.rawValue
    public let value: String?

    init(_ value: String) {
        self.value = value
    }
}
