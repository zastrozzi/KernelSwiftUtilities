//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 23/10/2023.
//

import Testing
import KernelSwiftServer

@Suite
struct CSRTests {
    @Test
    func testCSRKeyUsageDecode() async throws {
        let csrParamsPem = CSRPEMStrings.extKeyUsageParams
        let decoded: KernelX509.CSR.CertificateSigningRequest = try KernelASN1.ASN1Decoder.decode(from: csrParamsPem)
        let keyUsage = try decoded.extensions.decodeExtension(KernelX509.Extension.KeyUsage.self)
        let extKeyUsage = try decoded.extensions.decodeExtension(KernelX509.Extension.ExtendedKeyUsage.self)
        let recreatedPem = decoded.pemFile().pemString
        #expect(keyUsage.flags == [.nonRepudiation, .digitalSignature])
        #expect(extKeyUsage.usages == [.clientAuth, .serverAuth])
        #expect(csrParamsPem == recreatedPem)
    }
}
