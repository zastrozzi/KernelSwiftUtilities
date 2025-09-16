//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 21/09/2023.
//

import Testing
import KernelSwiftServer

@Suite
struct ASN1Parser4Tests {

    @Test(
        arguments: [
            ASN1DERTestAssets.berTerminator,
            ASN1DERTestAssets.booleanTrue,
            ASN1DERTestAssets.integer_0,
            ASN1DERTestAssets.integer_255,
            ASN1DERTestAssets.integer_256,
            ASN1DERTestAssets.constructedTagged0Integer_2,
            ASN1DERTestAssets.constructedTagged1Integer_2,
            ASN1DERTestAssets.explicitTagged0Integer_2,
            ASN1DERTestAssets.explicitTagged1Integer_2,
            ASN1DERTestAssets.implicitTagged1Integer_256,
            ASN1DERTestAssets.implicitTagged0Integer_2,
            ASN1DERTestAssets.implicitTagged2String1,
            ASN1DERTestAssets.implicitTagged2StringInSequence,
            ASN1DERTestAssets.implicitTagged2StringInSequenceMultiple,
            ASN1DERTestAssets.implicitTagged2StringInSequenceMultiple2,
            ASN1DERTestAssets.constructedStructuredTagged0Integer_2,
            ASN1DERTestAssets.constructedStructuredTagged1Integer_2,
            ASN1DERTestAssets.constructedStructuredTagged20000Integer_2,
            ASN1DERTestAssets.constructedStructuredTagged20001Integer_2,
            ASN1DERTestAssets.explicitStructuredTagged0Integer_2,
            ASN1DERTestAssets.explicitStructuredTagged1Integer_2,
            ASN1DERTestAssets.explicitStructuredTagged20000Integer_2,
            ASN1DERTestAssets.explicitStructuredTagged20001Integer_2,
            ASN1DERTestAssets.sequence_1,
            ASN1DERTestAssets.sequence_2
        ]
    )
    func testMetadataGenerationForBytes(bytes: [UInt8]) throws {
        let parsed = try KernelASN1.ASN1Parser4.objectFromBytes(bytes)
//        let parsed = try parser.parseObject()
        KernelASN1.ASN1Printer.printObjectVerbose(parsed)
    }
    
    @Test(
        arguments: [
            (CertPEMStrings.attestLeafCert, KernelASN1.PEMFile.Format.crt),
            (CertPEMStrings.minica, KernelASN1.PEMFile.Format.crt),
            (CertPEMStrings.rsapss256, KernelASN1.PEMFile.Format.crt),
            (CertPEMStrings.longNameConstraints, KernelASN1.PEMFile.Format.crt),
            (CSRPEMStrings.extKeyUsageParams, KernelASN1.PEMFile.Format.csr),
            (CSRPEMStrings.obwac, KernelASN1.PEMFile.Format.csr),
            (ECPEMStrings.ecPrivateKey, KernelASN1.PEMFile.Format.ecPrivateKey),
            (RSAPEMStrings.rsaPublicKeyPKCS1, KernelASN1.PEMFile.Format.rsaPublicKey),
            (RSAPEMStrings.rsaPublicKeyPKCS8, KernelASN1.PEMFile.Format.publicKey),
            (RSAPEMStrings.rsaPrivateKeyPKCS1, KernelASN1.PEMFile.Format.rsaPrivateKey),
            (RSAPEMStrings.rsaPrivateKeyPKCS8, KernelASN1.PEMFile.Format.privateKey)
        ]
    )
    func testFullPEMParse(_ testPair: (inputPem: String, outputFormat: KernelASN1.PEMFile.Format)) throws {
        guard let parsed = try KernelASN1.ASN1Parser4.objectFromPEM(pemString: testPair.inputPem) else { throw KernelASN1.TypedError(.decodingFailed) }
//        print("INPUT PEM")
//        print(testPair.inputPem)
//        print("PARSED ASN1")
        KernelASN1.ASN1Printer.printObjectVerbose(parsed, fullLength: true, decodedOctets: true, decodedBits: true)
        let bytes = try KernelASN1.ASN1Writer2.dataFromObject(parsed)
        let pem = KernelASN1.PEMFile(for: testPair.outputFormat, from: bytes).pemString
        #expect(testPair.inputPem == pem)
    }
//
    @Test
    func testPKCS7Parse() async throws {
        guard let parsedAttestReceipt = try KernelASN1.ASN1Parser4.objectFromPEM(pemString: CertPEMStrings.attestReceipt) else { throw KernelASN1.TypedError(.decodingFailed) }
//        print("ATTEST RECEIPT")
        KernelASN1.ASN1Printer.printObjectVerbose(parsedAttestReceipt, decodedOctets: true, decodedBits: true)
        let bytes = try KernelASN1.ASN1Writer2.dataFromObject(parsedAttestReceipt, taggingMode: .explicit)
        let pem = KernelASN1.PEMFile(for: .pkcs7, from: bytes).pemString
        guard let parsedAttestReceiptPEM = try KernelASN1.ASN1Parser4.objectFromPEM(pemString: pem) else { throw KernelASN1.TypedError(.decodingFailed) }
//        print("ATTEST RECEIPT PEM")
        KernelASN1.ASN1Printer.printObjectVerbose(parsedAttestReceiptPEM, decodedOctets: true, decodedBits: true)
    }
}

