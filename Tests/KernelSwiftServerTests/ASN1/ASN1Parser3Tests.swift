//
//  File.swift
//
//
//  Created by Jonathan Forbes on 17/07/2023.
//


import Testing
import KernelSwiftServer

@Suite
struct ASN1Parser3Tests {
    @Test
    func testAttestPEMParsings() async throws {
        guard let parsedCredCert = try KernelASN1.ASN1Parser3.objectFromPEM(pemString: CertPEMStrings.attestLeafCert) else { throw KernelASN1.TypedError(.decodingFailed) }
        print("LEAF CERT")
        KernelASN1.ASN1Printer.printObjectVerbose(parsedCredCert, decodedOctets: true)
        let credBytes = try KernelASN1.ASN1Writer2.dataFromObject(parsedCredCert)
        let credPem = KernelASN1.PEMFile(for: .crt, from: credBytes).pemString
        guard let parsedCredPem = try KernelASN1.ASN1Parser3.objectFromPEM(pemString: credPem) else { throw KernelASN1.TypedError(.decodingFailed) }
        print("LEAF CERT RECREATED")
        KernelASN1.ASN1Printer.printObjectVerbose(parsedCredPem, decodedOctets: true)
        
        guard let parsedIntermediateCert = try KernelASN1.ASN1Parser3.objectFromPEM(pemString: CertPEMStrings.attestIntermediateCert) else { throw KernelASN1.TypedError(.decodingFailed) }
        print("INTERMEDIATE CERT")
        KernelASN1.ASN1Printer.printObjectVerbose(parsedIntermediateCert, decodedOctets: true)
        let intermediateBytes = try KernelASN1.ASN1Writer2.dataFromObject(parsedIntermediateCert)
        let intermediatePem = KernelASN1.PEMFile(for: .crt, from: intermediateBytes).pemString
        guard let parsedIntermediatePem = try KernelASN1.ASN1Parser3.objectFromPEM(pemString: intermediatePem) else { throw KernelASN1.TypedError(.decodingFailed) }
        print("INTERMEDIATE CERT RECREATED")
        KernelASN1.ASN1Printer.printObjectVerbose(parsedIntermediatePem, decodedOctets: true)
        
        guard let parsedRootCert = try KernelASN1.ASN1Parser3.objectFromPEM(pemString: CertPEMStrings.attestRootCert) else { throw KernelASN1.TypedError(.decodingFailed) }
        print("ROOT CERT")
        KernelASN1.ASN1Printer.printObjectVerbose(parsedRootCert, decodedOctets: true)
        let rootBytes = try KernelASN1.ASN1Writer2.dataFromObject(parsedRootCert)
        let rootPem = KernelASN1.PEMFile(for: .crt, from: rootBytes).pemString
        guard let parsedRootPem = try KernelASN1.ASN1Parser3.objectFromPEM(pemString: rootPem) else { throw KernelASN1.TypedError(.decodingFailed) }
        print("ROOT CERT RECREATED")
        KernelASN1.ASN1Printer.printObjectVerbose(parsedRootPem, decodedOctets: true)
        guard let parsedAttestReceipt = try KernelASN1.ASN1Parser3.objectFromPEM(pemString: CertPEMStrings.attestReceipt) else { throw KernelASN1.TypedError(.decodingFailed) }
        print("ATTEST RECEIPT")
        KernelASN1.ASN1Printer.printObjectVerbose(parsedAttestReceipt, decodedOctets: true)
    }
    
    @Test(
        arguments: [
            CertPEMStrings.openBanking,
            CertPEMStrings.minica,
            CertPEMStrings.rsapss256,
            CertPEMStrings.longNameConstraints
        ]
    )
    func testFullCertParse(certPem: String) async throws {
        guard let parsedCert = try KernelASN1.ASN1Parser3.objectFromPEM(pemString: certPem) else { throw KernelASN1.TypedError(.decodingFailed) }
        
        let bytes = try KernelASN1.ASN1Writer2.dataFromObject(parsedCert)
        let pem = KernelASN1.PEMFile(for: .crt, from: bytes).pemString
        //        guard let parsedCert2 = try KernelASN1.ASN1Parser3.objectFromPEM(pemString: pem) else { throw KernelASN1.TypedError(.decodingFailed) }
        #expect(certPem == pem)
    }
    
    @Test(
        arguments: [
            CSRPEMStrings.obwac
        ]
    )
    func testFullCSRParse(csrPem: String) async throws {
        guard let parsedCSR = try KernelASN1.ASN1Parser3.objectFromPEM(pemString: csrPem) else { throw KernelASN1.TypedError(.decodingFailed) }
        KernelASN1.ASN1Printer.printObjectVerbose(parsedCSR, decodedOctets: true)
        let bytes = try KernelASN1.ASN1Writer2.dataFromObject(parsedCSR)
        let pem = KernelASN1.PEMFile(for: .csr, from: bytes).pemString
        #expect(csrPem == pem)
    }
    
    @Test
    func testWriter2() async throws {
        let type: KernelASN1.ASN1Type.VerboseTypeWithMetadata = .sequence([
            .tag(0, constructed: false,
                 .sequence([
                    .tag(0, constructed: true, .integer(.init(int: .init(1000))).writing()).writing(),
                    .tag(1, constructed: false, .utf8String(.init(string: "Testing testing")).writing()).writing()
                 ]).writing()
            ).writing()
        ]).writing()
        let bytes = try KernelASN1.ASN1Writer2.dataFromObject(type, taggingMode: .explicit)
        let pem = KernelASN1.PEMFile(for: .csr, from: bytes).pemString
        guard let parsedObj = try KernelASN1.ASN1Parser3.objectFromPEM(pemString: pem) else { throw KernelASN1.TypedError(.decodingFailed) }
        let bytes2 = try KernelASN1.ASN1Writer2.dataFromObject(parsedObj, taggingMode: .explicit)
        let pem2 = KernelASN1.PEMFile(for: .csr, from: bytes2).pemString
        #expect(pem == pem2)
    }
    
    @Test
    func testWriter2ParseRounds() async throws {
        let type: KernelASN1.ASN1Type.VerboseTypeWithMetadata = .sequence([
            .sequence([
                .tag(0, constructed: true, .integer(.init(int: .init(1000))).writing()).writing(),
                .tag(1, constructed: false, .utf8String(.init(string: "Testing testing")).writing()).writing()
            ]).writing()
        ]).writing(.init(taggingMode: .explicit))
        let bytes = try KernelASN1.ASN1Writer2.dataFromObject(type, taggingMode: .explicit)
        let pem = KernelASN1.PEMFile(for: .csr, from: bytes).pemString
        guard let parsedObj = try KernelASN1.ASN1Parser3.objectFromPEM(pemString: pem) else { throw KernelASN1.TypedError(.decodingFailed) }
        let bytes2 = try KernelASN1.ASN1Writer2.dataFromObject(parsedObj, taggingMode: .explicit)
        let pem2 = KernelASN1.PEMFile(for: .csr, from: bytes2).pemString
        guard let parsedObj2 = try KernelASN1.ASN1Parser3.objectFromPEM(pemString: pem2) else { throw KernelASN1.TypedError(.decodingFailed) }
        let bytes3 = try KernelASN1.ASN1Writer2.dataFromObject(parsedObj2, taggingMode: .implicit)
        let pem3 = KernelASN1.PEMFile(for: .csr, from: bytes3).pemString
        //        guard let parsedObj3 = try KernelASN1.ASN1Parser3.objectFromPEM(pemString: pem3) else { throw KernelASN1.TypedError(.decodingFailed) }
        #expect(pem == pem2)
        #expect(pem2 == pem3)
        #expect(pem == pem3)
    }
}
