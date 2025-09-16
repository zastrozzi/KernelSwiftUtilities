//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 16/11/2023.
//

import Foundation
import KernelSwiftCommon
import Vapor

extension KernelCryptography.RSA.PublicKey {
    public struct JSONRepresentation: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public var n: String
        public var e: String
        
        public init(
            n: String,
            e: String
        ) {
            self.n = n
            self.e = e
            
        }
        
        public init(from publicKey: KernelCryptography.RSA.PublicKey) {
            self.n = publicKey.n.toString()
            self.e = publicKey.e.toString()
        }
    }
}

//extension KernelCryptography.RSA.PublicKey.JSONRepresentation {
//    public static var sample: KernelCryptography.RSA.PublicKey.JSONRepresentation = {
//        .init(
//            n: KernelNumerics.BigInt.randomLessThan(.init(bitWidth: 2048)).toString(),
//            e: "65537"
//        )
//    }()
//}
