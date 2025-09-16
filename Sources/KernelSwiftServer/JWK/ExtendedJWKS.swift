//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 11/04/2023.
//

import Foundation

public struct ExtendedJWKS: Codable, Equatable {
    public var keys: [ExtendedJWK]
    
    public init(
        keys: [ExtendedJWK]
    ) {
        self.keys = keys
    }

}
