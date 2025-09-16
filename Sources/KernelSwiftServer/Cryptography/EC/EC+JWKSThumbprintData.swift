//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/10/2023.
//

import Foundation

extension KernelCryptography.EC {
    public struct JWKSThumbprintData: Codable, Equatable {
        public init(
            crv: String,
            kty: String,
            x: String,
            y: String
        ) {
            self.crv = crv
            self.kty = kty
            self.x = x
            self.y = y
        }
        
        public var crv: String
        public var kty: String
        public var x: String
        public var y: String
    }
}
