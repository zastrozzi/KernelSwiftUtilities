//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 11/11/2023.
//

import Foundation
import KernelSwiftCommon
import Vapor

extension KernelCryptography.RSA.PrivateKey {
    public struct JSONRepresentation: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public var n: String
        public var e: String
        public var d: String
        public var p: String
        public var q: String
        public var dp: String
        public var dq: String
        public var coefficient: String
        
        public init(
            n: String,
            e: String,
            d: String,
            p: String,
            q: String,
            dp: String,
            dq: String,
            coefficient: String
        ) {
            self.n = n
            self.e = e
            self.d = d
            self.p = p
            self.q = q
            self.dp = dp
            self.dq = dq
            self.coefficient = coefficient
        }
        
        public init(from privateKey: KernelCryptography.RSA.PrivateKey) {
            self.n = privateKey.n.toString()
            self.e = privateKey.e.toString()
            self.d = privateKey.d.toString()
            self.p = privateKey.p.toString()
            self.q = privateKey.q.toString()
            self.dp = privateKey.dp.toString()
            self.dq = privateKey.dq.toString()
            self.coefficient = privateKey.q.modInverse(privateKey.p).toString()
        }
    }
}

//extension KernelCryptography.RSA.PrivateKey.JSONRepresentation {
//    public static var sample: KernelCryptography.RSA.PrivateKey.JSONRepresentation = {
//        .init(
//            n: KernelNumerics.BigInt.randomLessThan(.init(bitWidth: 2048)).toString(),
//            e: "65537",
//            d: KernelNumerics.BigInt.randomLessThan(.init(bitWidth: 2048)).toString(),
//            p: KernelNumerics.BigInt.randomLessThan(.init(bitWidth: 1024)).toString(),
//            q: KernelNumerics.BigInt.randomLessThan(.init(bitWidth: 1024)).toString(),
//            dp: KernelNumerics.BigInt.randomLessThan(.init(bitWidth: 1024)).toString(),
//            dq: KernelNumerics.BigInt.randomLessThan(.init(bitWidth: 1024)).toString(),
//            coefficient: KernelNumerics.BigInt.randomLessThan(.init(bitWidth: 1024)).toString()
//        )
//    }()
//}
