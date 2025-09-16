//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 08/09/2023.
//

import Foundation

public typealias OIDCLocale = Locale

extension OIDCLocale {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let localeStr = try container.decode(String.self)
        self.init(identifier: localeStr)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.identifier(.bcp47))
    }
}
