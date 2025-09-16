//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 05/11/2023.
//

import Foundation

extension KernelNumerics.EC.Curve {
    public typealias other = Other
    
    public enum Other {
        public static let curve25519: KernelNumerics.EC.Domain = .init(
            oid: .unknownOID("curve25519"),
            p: "0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffed",
            a: "0x76d06",
            b: "0x01",
            g: .init(
                x: "0x09",
                y: "0x20ae19a1b8a086b4e01edd2c7748d14c923d4d7e6d7c61b229e9c5a27eced3d9"
            ),
            order: "0x1000000000000000000000000000000014def9dea2f79cd65812631a5cf5d3ed",
            cofactor: 0x8
        )
    }
}
