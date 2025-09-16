//
//  File.swift
//
//
//  Created by Jonathan Forbes on 02/10/2023.
//

import Foundation

extension KernelNumerics.EC.Curve {
    public typealias secg = SECG
    
    public enum SECG {
        public static let secp112r1: KernelNumerics.EC.Domain = .init(
            oid: .secp112r1,
            p: "0xdb7c2abf62e35e668076bead208b",
            a: "0xdb7c2abf62e35e668076bead2088",
            b: "0x659ef8ba043916eede8911702b22",
            g: .init(
                x: "0x09487239995a5ee76b55f9c2f098",
                y: "0xa89ce5af8724c0a23e0e0ff77500"
            ),
            order: "0xdb7c2abf62e35e7628dfac6561c5",
            cofactor: 0x1
        )
        
        public static let secp112r2: KernelNumerics.EC.Domain = .init(
            oid: .secp112r2,
            p: "0xdb7c2abf62e35e668076bead208b",
            a: "0x6127c24c05f38a0aaaf65c0ef02c",
            b: "0x51def1815db5ed74fcc34c85d709",
            g: .init(
                x: "0x4ba30ab5e892b4e1649dd0928643",
                y: "0xadcd46f5882e3747def36e956e97"
            ),
            order: "0x36df0aafd8b8d7597ca10520d04b",
            cofactor: 0x4
        )
        
        public static let secp128r1: KernelNumerics.EC.Domain = .init(
            oid: .secp128r1,
            p: "0xfffffffdffffffffffffffffffffffff",
            a: "0xfffffffdfffffffffffffffffffffffc",
            b: "0xe87579c11079f43dd824993c2cee5ed3",
            g: .init(
                x: "0x161ff7528b899b2d0c28607ca52c5b86",
                y: "0xcf5ac8395bafeb13c02da292dded7a83"
            ),
            order: "0xfffffffe0000000075a30d1b9038a115",
            cofactor: 0x1
        )
        
        public static let secp128r2: KernelNumerics.EC.Domain = .init(
            oid: .secp128r2,
            p: "0xfffffffdffffffffffffffffffffffff",
            a: "0xd6031998d1b3bbfebf59cc9bbff9aee1",
            b: "0x5eeefca380d02919dc2c6558bb6d8a5d",
            g: .init(
                x: "0x7b6aa5d85e572983e6fb32a7cdebc140",
                y: "0x27b6916a894d3aee7106fe805fc34b44"
            ),
            order: "0x3fffffff7fffffffbe0024720613b5a3",
            cofactor: 0x4
        )
    }
}
