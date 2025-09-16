//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 02/10/2023.
//

import Foundation

extension KernelNumerics.EC.Curve {
    public typealias x962 = X962
    
    public enum X962 {
        public static let prime192v1: KernelNumerics.EC.Domain = .init(
            oid: .x962Prime192v1,
            p: "0xfffffffffffffffffffffffffffffffeffffffffffffffff",
            a: "0xfffffffffffffffffffffffffffffffefffffffffffffffc",
            b: "0x64210519e59c80e70fa7e9ab72243049feb8deecc146b9b1",
            g: .init(
                x: "0x188da80eb03090f67cbf20eb43a18800f4ff0afd82ff1012",
                y: "0x07192b95ffc8da78631011ed6b24cdd573f977a11e794811"
            ),
            order: "0xffffffffffffffffffffffff99def836146bc9b1b4d22831",
            cofactor: 0x1
        )
        
        public static let prime192v2: KernelNumerics.EC.Domain = .init(
            oid: .x962Prime192v2,
            p: "0xfffffffffffffffffffffffffffffffeffffffffffffffff",
            a: "0xfffffffffffffffffffffffffffffffefffffffffffffffc",
            b: "0xcc22d6dfb95c6b25e49c0d6364a4e5980c393aa21668d953",
            g: .init(
                x: "0xeea2bae7e1497842f2de7769cfe9c989c072ad696f48034a",
                y: "0x6574d11d69b6ec7a672bb82a083df2f2b0847de970b2de15"
            ),
            order: "0xfffffffffffffffffffffffe5fb1a724dc80418648d8dd31",
            cofactor: 0x1
        )
        
        public static let prime192v3: KernelNumerics.EC.Domain = .init(
            oid: .x962Prime192v3,
            p: "0xfffffffffffffffffffffffffffffffeffffffffffffffff",
            a: "0xfffffffffffffffffffffffffffffffefffffffffffffffc",
            b: "0x22123dc2395a05caa7423daeccc94760a7d462256bd56916",
            g: .init(
                x: "0x7d29778100c65a1da1783716588dce2b8b4aee8e228f1896",
                y: "0x38a90f22637337334b49dcb66a6dc8f9978aca7648a943b0"
            ),
            order: "0xffffffffffffffffffffffff7a62d031c83f4294f640ec13",
            cofactor: 0x1
        )
        
        public static let prime239v1: KernelNumerics.EC.Domain = .init(
            oid: .x962Prime239v1,
            p: "0x7fffffffffffffffffffffff7fffffffffff8000000000007fffffffffff",
            a: "0x7fffffffffffffffffffffff7fffffffffff8000000000007ffffffffffc",
            b: "0x6b016c3bdcf18941d0d654921475ca71a9db2fb27d1d37796185c2942c0a",
            g: .init(
                x: "0x0ffa963cdca8816ccc33b8642bedf905c3d358573d3f27fbbd3b3cb9aaaf",
                y: "0x7debe8e4e90a5dae6e4054ca530ba04654b36818ce226b39fccb7b02f1ae"
            ),
            order: "0x7fffffffffffffffffffffff7fffff9e5e9a9f5d9071fbd1522688909d0b",
            cofactor: 0x1
        )
        
        public static let prime239v2: KernelNumerics.EC.Domain = .init(
            oid: .x962Prime239v2,
            p: "0x7fffffffffffffffffffffff7fffffffffff8000000000007fffffffffff",
            a: "0x7fffffffffffffffffffffff7fffffffffff8000000000007ffffffffffc",
            b: "0x617fab6832576cbbfed50d99f0249c3fee58b94ba0038c7ae84c8c832f2c",
            g: .init(
                x: "0x38af09d98727705120c921bb5e9e26296a3cdcf2f35757a0eafd87b830e7",
                y: "0x5b0125e4dbea0ec7206da0fc01d9b081329fb555de6ef460237dff8be4ba"
            ),
            order: "0x7fffffffffffffffffffffff800000cfa7e8594377d414c03821bc582063",
            cofactor: 0x1
        )
        
        public static let prime239v3: KernelNumerics.EC.Domain = .init(
            oid: .x962Prime239v3,
            p: "0x7fffffffffffffffffffffff7fffffffffff8000000000007fffffffffff",
            a: "0x7fffffffffffffffffffffff7fffffffffff8000000000007ffffffffffc",
            b: "0x255705fa2a306654b1f4cb03d6a750a30c250102d4988717d9ba15ab6d3e",
            g: .init(
                x: "0x6768ae8e18bb92cfcf005c949aa2c6d94853d0e660bbf854b1c9505fe95a",
                y: "0x1607e6898f390c06bc1d552bad226f3b6fcfe48b6e818499af18e3ed6cf3"
            ),
            order: "0x7fffffffffffffffffffffff7fffff975deb41b3a6057c3c432146526551",
            cofactor: 0x1
        )
        
        public static let prime256v1: KernelNumerics.EC.Domain = .init(
            oid: .x962Prime256v1,
            p: "0xffffffff00000001000000000000000000000000ffffffffffffffffffffffff",
            a: "0xffffffff00000001000000000000000000000000fffffffffffffffffffffffc",
            b: "0x5ac635d8aa3a93e7b3ebbd55769886bc651d06b0cc53b0f63bce3c3e27d2604b",
            g: .init(
                x: "0x6b17d1f2e12c4247f8bce6e563a440f277037d812deb33a0f4a13945d898c296",
                y: "0x4fe342e2fe1a7f9b8ee7eb4a7c0f9e162bce33576b315ececbb6406837bf51f5"
            ),
            order: "0xffffffff00000000ffffffffffffffffbce6faada7179e84f3b9cac2fc632551",
            cofactor: 0x1
        )
    }
}
