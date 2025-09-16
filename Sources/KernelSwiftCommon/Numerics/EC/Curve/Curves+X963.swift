//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 02/10/2023.
//

import Foundation

extension KernelNumerics.EC.Curve {
    public typealias x963 = X963
    
    public enum X963 {
        public static let ansip160k1: KernelNumerics.EC.Domain = .init(
            oid: .ansip160k1,
            p: "0xfffffffffffffffffffffffffffffffeffffac73",
            a: .zero,
            b: .seven,
            g: .init(
                x: "0x3b4c382ce37aa192a4019e763036f4f5dd4d7ebb",
                y: "0x938cf935318fdced6bc28286531733c3f03c4fee"
            ),
            order: "0x0100000000000000000001b8fa16dfab9aca16b6b3",
            cofactor: 0x1
        )
        
        public static let ansip160r1: KernelNumerics.EC.Domain = .init(
            oid: .ansip160r1,
            p: "0xffffffffffffffffffffffffffffffff7fffffff",
            a: "0xffffffffffffffffffffffffffffffff7ffffffc",
            b: "0x1c97befc54bd7a8b65acf89f81d4d4adc565fa45",
            g: .init(
                x: "0x4a96b5688ef573284664698968c38bb913cbfc82",
                y: "0x23a628553168947d59dcc912042351377ac5fb32"
            ),
            order: "0x0100000000000000000001f4c8f927aed3ca752257",
            cofactor: 0x1
        )
        
        public static let ansip160r2: KernelNumerics.EC.Domain = .init(
            oid: .ansip160r2,
            p: "0xfffffffffffffffffffffffffffffffeffffac73",
            a: "0xfffffffffffffffffffffffffffffffeffffac70",
            b: "0xb4e134d3fb59eb8bab57274904664d5af50388ba",
            g: .init(
                x: "0x52dcb034293a117e1f4ff11b30f7199d3144ce6d",
                y: "0xfeaffef2e331f296e071fa0df9982cfea7d43f2e"
            ),
            order: "0x0100000000000000000000351ee786a818f3a1a16b",
            cofactor: 0x1
        )
        
        public static let ansip192k1: KernelNumerics.EC.Domain = .init(
            oid: .ansip192k1,
            p: "0xfffffffffffffffffffffffffffffffffffffffeffffee37",
            a: .zero,
            b: .three,
            g: .init(
                x: "0xdb4ff10ec057e9ae26b07d0280b7f4341da5d1b1eae06c7d",
                y: "0x9b2f2f6d9c5628a7844163d015be86344082aa88d95e2f9d"
            ),
            order: "0xfffffffffffffffffffffffe26f2fc170f69466a74defd8d",
            cofactor: 0x1
        )
        
        public static let ansip224k1: KernelNumerics.EC.Domain = .init(
            oid: .ansip224k1,
            p: "0xfffffffffffffffffffffffffffffffffffffffffffffffeffffe56d",
            a: .zero,
            b: .five,
            g: .init(
                x: "0xa1455b334df099df30fc28a169a467e9e47075a90f7e650eb6b7a45c",
                y: "0x7e089fed7fba344282cafbd6f7e319f7c0b0bd59e2ca4bdb556d61a5"
            ),
            order: "0x010000000000000000000000000001dce8d2ec6184caf0a971769fb1f7",
            cofactor: 0x1
        )
        
        public static let ansip224r1: KernelNumerics.EC.Domain = .init(
            oid: .ansip224r1,
            p: "0xffffffffffffffffffffffffffffffff000000000000000000000001",
            a: "0xfffffffffffffffffffffffffffffffefffffffffffffffffffffffe",
            b: "0xb4050a850c04b3abf54132565044b0b7d7bfd8ba270b39432355ffb4",
            g: .init(
                x: "0xb70e0cbd6bb4bf7f321390b94a03c1d356c21122343280d6115c1d21",
                y: "0xbd376388b5f723fb4c22dfe6cd4375a05a07476444d5819985007e34"
            ),
            order: "0xffffffffffffffffffffffffffff16a2e0b8f03e13dd29455c5c2a3d",
            cofactor: 0x1
        )
        
        public static let ansip256k1: KernelNumerics.EC.Domain = .init(
            oid: .ansip256k1,
            p: "0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f",
            a: "0x0",
            b: "0x7",
            g: .init(
                x: "0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798",
                y: "0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8"
            ),
            order: "0xfffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141",
            cofactor: 0x1
        )
        
        public static let ansip384r1: KernelNumerics.EC.Domain = .init(
            oid: .ansip384r1,
            p: "0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffeffffffff0000000000000000ffffffff",
            a: "0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffeffffffff0000000000000000fffffffc",
            b: "0xb3312fa7e23ee7e4988e056be3f82d19181d9c6efe8141120314088f5013875ac656398d8a2ed19d2a85c8edd3ec2aef",
            g: .init(
                x: "0xaa87ca22be8b05378eb1c71ef320ad746e1d3b628ba79b9859f741e082542a385502f25dbf55296c3a545e3872760ab7",
                y: "0x3617de4a96262c6f5d9e98bf9292dc29f8f41dbd289a147ce9da3113b5f0b8c00a60b1ce1d7e819d7a431d7c90ea0e5f"
            ),
            order: "0xffffffffffffffffffffffffffffffffffffffffffffffffc7634d81f4372ddf581a0db248b0a77aecec196accc52973",
            cofactor: 0x1
        )
        
        public static let ansip521r1: KernelNumerics.EC.Domain = .init(
            oid: .ansip521r1,
            p: "0x01ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff",
            a: "0x01fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc",
            b: "0x0051953eb9618e1c9a1f929a21a0b68540eea2da725b99b315f3b8b489918ef109e156193951ec7e937b1652c0bd3bb1bf073573df883d2c34f1ef451fd46b503f00",
            g: .init(
                x: "0xc6858e06b70404e9cd9e3ecb662395b4429c648139053fb521f828af606b4d3dbaa14b5e77efe75928fe1dc127a2ffa8de3348b3c1856a429bf97e7e31c2e5bd66",
                y: "0x11839296a789a3bc0045c8a5fb42c7d1bd998f54449579b446817afbd17273e662c97ee72995ef42640c550b9013fad0761353c7086a272c24088be94769fd16650"
            ),
            order: "0x01fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffa51868783bf2f966b7fcc0148f709a5d03bb5c9b8899c47aebb6fb71e91386409",
            cofactor: 0x1
        )
    }
}
