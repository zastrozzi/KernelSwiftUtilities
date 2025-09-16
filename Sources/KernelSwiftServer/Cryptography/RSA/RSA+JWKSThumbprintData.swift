//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/10/2023.
//

import Foundation

extension KernelCryptography.RSA {
    public struct JWKSThumbprintData: Codable, Equatable {
        public init(
            e: String,
            kty: String,
            n: String
        ) {
            self.e = e
            self.kty = kty
            self.n = n
            //            self.use = use
        }
        
        public var e: String
        public var kty: String
        public var n: String
        //        public var use: String
    }
}
