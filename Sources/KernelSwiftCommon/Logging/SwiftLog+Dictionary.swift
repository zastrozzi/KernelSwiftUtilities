//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 13/09/2023.
//

import Foundation
import Logging

extension Logger.MetadataValue {
    public static func dictionary(_ value: Dictionary<String, String>) -> Self {
        return self.dictionary(Logger.Metadata(uniqueKeysWithValues: value.map { ($0, .string($1)) }))
    }
}
