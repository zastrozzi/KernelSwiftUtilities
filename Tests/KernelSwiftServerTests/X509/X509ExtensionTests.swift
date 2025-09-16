//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 23/10/2023.
//

import Testing
import KernelSwiftServer

@Suite
struct X509ExtensionTests {
    @Test
    func testKeyUsageDecode() async throws {
        let keyUsage: KernelX509.Extension.KeyUsage = .init(critical: true, flags:
                .keyCertSign
        )
        let built = try keyUsage.buildExtension()
        print(built.extValue.toHexString())
        let keyUsageRecon: KernelX509.Extension.KeyUsage = try .init(from: built)
        #expect(keyUsage.flags == keyUsageRecon.flags)
    }
    
    @Test
    func testExtKeyUsageDecode() async throws {
        let extKeyUsage: KernelX509.Extension.ExtendedKeyUsage = .init(critical: true, usages: .clientAuth, .serverAuth)
        let built = try extKeyUsage.buildExtension()
        let extKeyUsageRecon: KernelX509.Extension.ExtendedKeyUsage = try .init(from: built)
        #expect(extKeyUsage.usages == extKeyUsageRecon.usages)
    }
}


