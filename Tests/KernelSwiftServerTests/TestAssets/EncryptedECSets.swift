//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/11/2023.
//

import Foundation
import KernelSwiftCommon
import KernelSwiftServer

public enum EncryptedECSets {}

extension EncryptedECSets {
    public struct EncryptedECSet: Sendable {
        let domain: KernelNumerics.EC.Domain
        let s: KernelNumerics.BigInt
        let password: String
        let aes: KernelCryptography.AES.KeySize
        let pem: String
        
    }
}

extension EncryptedECSets {
    public static let aes128p256v1: EncryptedECSet = .init(
        domain: try! .init(fromOID: .x962Prime256v1),
        s: .init("00fb1c65006e7883dabfa1fc481e0785a2cc90a311d334feba006ee371df90ba94", radix: 16)!,
        password: "abcd",
        aes: .b128,
        pem:
"""
-----BEGIN ENCRYPTED PRIVATE KEY-----
MIHeMEkGCSqGSIb3DQEFDTA8MBsGCSqGSIb3DQEFDDAOBAgf8bK5JkQjEgICCAAw
HQYJYIZIAWUDBAECBBA4X7WkIy/xo1lflJSoFGbcBIGQcY4ApL6/2EorD8q+c9GM
3OTj62dOn+Kx9zv4rwDGWJdc9XyeIp0gi0l89GRCQpGMzQFMVhQY7onsavzdiuKa
Yaf3g+zB3Qpl9z4NEImhDFumKgwJ6iPkMfpoWHetALjNFnaMa2IhpSjCjOX5jtKh
YafVNAH2i8dXwrnfr+MuVp5N3U+Zhqo7RhbEhbSzAv2I
-----END ENCRYPTED PRIVATE KEY-----
"""
    )
    
    public static let aes192p256v1: EncryptedECSet = .init(
        domain: try! .init(fromOID: .x962Prime256v1),
        s: .init("03c6cfa396639e6fd3e7efa123fbdbce5447bf025f461d355862d5802d9883a4", radix: 16)!,
        password: "abcd",
        aes: .b192,
        pem:
"""
-----BEGIN ENCRYPTED PRIVATE KEY-----
MIHeMEkGCSqGSIb3DQEFDTA8MBsGCSqGSIb3DQEFDDAOBAix+xEHt2h9ZQICCAAw
HQYJYIZIAWUDBAEWBBBv50LDBM0g0qJf820MKfhDBIGQJk4NChLwm5b3ZE+IHMtQ
PaJHQMHA+OcMBstlq0PbC9I76qZC07a0jH8/LYVvuWcB6xPHP5n9a3LmzpeEvg8R
8AFhm/uEuB16KnGf5xBVLlu/zc4vHYLFLgC4FfNhJ+mCYq7oWiQl9mhO8lIFfnB2
gt6bONbJNsFgii77iyD+zTxZyR8+XIhx7A/r8h/NBoaE
-----END ENCRYPTED PRIVATE KEY-----
"""
    )
    
    public static let aes256p256v1: EncryptedECSet = .init(
        domain: try! .init(fromOID: .x962Prime256v1),
        s: .init("5787f2632e1d6e21ac3430b738be1a29b5ad7f2a97bccdbf63406b068bdc616a", radix: 16)!,
        password: "abcd",
        aes: .b256,
        pem:
"""
-----BEGIN ENCRYPTED PRIVATE KEY-----
MIHeMEkGCSqGSIb3DQEFDTA8MBsGCSqGSIb3DQEFDDAOBAhP7OenCjWEcwICCAAw
HQYJYIZIAWUDBAEqBBBVQfJvAtxhz2VDGh3XDoRTBIGQ95hGvIDwSS4wDEbywE/u
QlvCMm0yyk15LQMP1UYH39VZUayatCzuG9KJmizkAQEBfNVxfrXTlTDnItfAvmlm
Pl9Cr5Vyj1xS0xCiP8GFfB12IGLgVXpU6Jy3Y1f/aZCaezYeSi1dWMH9GxuOqThf
J3i+EhfYbcv/StLF8gGKF2xdjIQ6CJeXZiHc0T36RzMk
-----END ENCRYPTED PRIVATE KEY-----
"""
    )
}
