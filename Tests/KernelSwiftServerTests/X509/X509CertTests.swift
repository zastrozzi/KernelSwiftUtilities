//
//  File.swift
//
//
//  Created by Jonathan Forbes on 14/09/2023.
//

import Testing
import Foundation
import KernelSwiftServer

@Suite
struct X509CertTests {
    @Test
    func testDistinguishedNameDecode() async throws {
        let subjectOne: KernelX509.Common.DistinguishedName = .init(rdns: [
            .init(attributeType: .countryName, attributeValueType: .printableString, stringValue: "GB"),
            .init(attributeType: .organizationName, attributeValueType: .utf8String, stringValue: "KERNEL EDGE TECHNOLOGIES LTD"),
            .init(attributeType: .organizationIdentifier, attributeValueType: .utf8String, stringValue: "PSDGB-OB-Unknown"),
            .init(attributeType: .commonName, attributeValueType: .utf8String, stringValue: "00000000")
        ])
        let subjectTwo: KernelX509.Common.DistinguishedName = .init(rdns: [
            .init(attributeType: .countryName, attributeValueType: .printableString, stringValue: "NZ"),
            .init(attributeType: .organizationName, attributeValueType: .utf8String, stringValue: "FORBES INDUSTRIES"),
            .init(attributeType: .organizationIdentifier, attributeValueType: .utf8String, stringValue: "PSDNZ-JF-00000000"),
            .init(attributeType: .commonName, attributeValueType: .utf8String, stringValue: "00000000")
        ])
        let builtOne = subjectOne.buildASN1Type()
        let builtTwo = subjectTwo.buildASN1Type()
        let decodedOne: KernelX509.Common.DistinguishedName = try KernelASN1.ASN1Decoder.decode(from: builtOne)
        let decodedTwo: KernelX509.Common.DistinguishedName = try KernelASN1.ASN1Decoder.decode(from: builtTwo)
        #expect(subjectOne == decodedOne)
        #expect(subjectTwo == decodedTwo)
        #expect(subjectOne != subjectTwo)
        #expect(decodedOne != decodedTwo)
        
    }
    
    @Test
    func testCertChainRecomposition() throws {
        let decodedRoot = try recomposeCertificate(certPem: CertPEMStrings.attestRootCert)
        let decodedIntermediate = try recomposeCertificate(certPem: CertPEMStrings.attestIntermediateCert)
        let decodedLeaf = try recomposeCertificate(certPem: CertPEMStrings.attestLeafCert)
        let decodedLeafTBS = KernelASN1.ASN1Writer.dataFromObject(decodedLeaf.buildTBSCertificate())
        let decodedIntermediateTBS = KernelASN1.ASN1Writer.dataFromObject(decodedIntermediate.buildTBSCertificate())
        let intermediateValid = try decodedRoot.subjectPublicKeyInfo.underlyingKey.verify(signature: decodedIntermediate.keySignature, digest: decodedIntermediateTBS)
        let leafValid = try decodedIntermediate.subjectPublicKeyInfo.underlyingKey.verify(signature: decodedLeaf.keySignature, digest: decodedLeafTBS)
        print("INTERMEDIATE VALID?", intermediateValid)
        print("LEAF VALID?", leafValid)
        #expect(intermediateValid)
        #expect(leafValid)
    }
    
    @Test
    func testCertValidityEncodeDecode() async throws {
        let before: Date = .now.startOfDay
        let after: Date = .now.endOfDay
        let validity: KernelX509.Certificate.Validity = .init(notBefore: before, notAfter: after)
        let built = validity.buildASN1Type()
        let decoded: KernelX509.Certificate.Validity = try KernelASN1.ASN1Decoder.decode(from: built)
        #expect(decoded.notAfter == after)
        #expect(decoded.notBefore == before)
    }
    
    @Test(
        arguments: [
            CertPEMStrings.longNameConstraints
        ]
    )
    func testFullCertDecode(certPem: String) async throws {
        guard let parsedCert = try KernelASN1.ASN1Parser4.objectFromPEM(pemString: certPem) else { throw KernelASN1.TypedError(.decodingFailed) }
        let decoded: KernelX509.Certificate = try KernelASN1.ASN1Decoder.decode(from: parsedCert)
        if let basic = try? decoded.extensions.decodeExtension(KernelX509.Extension.BasicConstraints.self) {
            let builtExtension = try basic.buildExtension()
            let bytes = KernelASN1.ASN1Writer.dataFromObject(builtExtension.buildASN1Type())
            let decodedAgain = try KernelASN1.ASN1Parser4.objectFromBytes(bytes).asn1()
            let asExtension: KernelX509.Extension = try .init(from: decodedAgain)
            #expect(builtExtension.extValue == asExtension.extValue)
        }
        if let key = try? decoded.extensions.decodeExtension(KernelX509.Extension.KeyUsage.self) {
            let builtExtension = try key.buildExtension()
            let bytes = KernelASN1.ASN1Writer.dataFromObject(builtExtension.buildASN1Type())
            let decodedAgain = try KernelASN1.ASN1Parser4.objectFromBytes(bytes).asn1()
            let asExtension: KernelX509.Extension = try .init(from: decodedAgain)
            #expect(builtExtension.extValue == asExtension.extValue)
        }
        if let extKey = try? decoded.extensions.decodeExtension(KernelX509.Extension.ExtendedKeyUsage.self) {
            let builtExtension = try extKey.buildExtension()
            let bytes = KernelASN1.ASN1Writer.dataFromObject(builtExtension.buildASN1Type())
            let decodedAgain = try KernelASN1.ASN1Parser4.objectFromBytes(bytes).asn1()
            let asExtension: KernelX509.Extension = try .init(from: decodedAgain)
            #expect(builtExtension.extValue == asExtension.extValue)
        }
        if let subjectKey = try? decoded.extensions.decodeExtension(KernelX509.Extension.SubjectKeyIdentifier.self) {
            let builtExtension = try subjectKey.buildExtension()
            let bytes = KernelASN1.ASN1Writer.dataFromObject(builtExtension.buildASN1Type())
            let decodedAgain = try KernelASN1.ASN1Parser4.objectFromBytes(bytes).asn1()
            let asExtension: KernelX509.Extension = try .init(from: decodedAgain)
            #expect(builtExtension.extValue == asExtension.extValue)
        }
        if let authorityKey = try? decoded.extensions.decodeExtension(KernelX509.Extension.AuthorityKeyIdentifier.self) {
            let builtExtension = try authorityKey.buildExtension()
            let bytes = KernelASN1.ASN1Writer.dataFromObject(builtExtension.buildASN1Type())
            let decodedAgain = try KernelASN1.ASN1Parser4.objectFromBytes(bytes).asn1()
            let asExtension: KernelX509.Extension = try .init(from: decodedAgain)
            #expect(builtExtension.extValue == asExtension.extValue)
        }
        if let authorityInfo = try? decoded.extensions.decodeExtension(KernelX509.Extension.AuthorityInfoAccess.self) {
            let builtExtension = try authorityInfo.buildExtension()
            let bytes = KernelASN1.ASN1Writer.dataFromObject(builtExtension.buildASN1Type())
            let decodedAgain = try KernelASN1.ASN1Parser4.objectFromBytes(bytes).asn1()
            let asExtension: KernelX509.Extension = try .init(from: decodedAgain)
            #expect(builtExtension.extValue == asExtension.extValue)
        }
        if let certPolicies = try? decoded.extensions.decodeExtension(KernelX509.Extension.CertificatePolicies.self) {
            let builtExtension = try certPolicies.buildExtension()
            let bytes = KernelASN1.ASN1Writer.dataFromObject(builtExtension.buildASN1Type())
            let decodedAgain = try KernelASN1.ASN1Parser4.objectFromBytes(bytes).asn1()
            let asExtension: KernelX509.Extension = try .init(from: decodedAgain)
            #expect(builtExtension.extValue == asExtension.extValue)
        }
        if let crlDistrPoints = try? decoded.extensions.decodeExtension(KernelX509.Extension.CRLDistributionPoints.self) {
            let builtExtension = try crlDistrPoints.buildExtension()
            let bytes = KernelASN1.ASN1Writer.dataFromObject(builtExtension.buildASN1Type())
            let decodedAgain = try KernelASN1.ASN1Parser4.objectFromBytes(bytes).asn1()
            let asExtension: KernelX509.Extension = try .init(from: decodedAgain)
            #expect(builtExtension.extValue == asExtension.extValue)
        }
        if let nameConstraints = try? decoded.extensions.decodeExtension(KernelX509.Extension.NameConstraints.self) {
            print(nameConstraints)
            let builtExtension = try nameConstraints.buildExtension()
            let bytes = KernelASN1.ASN1Writer.dataFromObject(builtExtension.buildASN1Type())
            let decodedAgain = try KernelASN1.ASN1Parser4.objectFromBytes(bytes).asn1()
            let asExtension: KernelX509.Extension = try .init(from: decodedAgain)
            #expect(builtExtension.extValue == asExtension.extValue)
        }
        
        let recreated = decoded.pemFile().pemString
        guard let parsedCertRecreated = try KernelASN1.ASN1Parser4.objectFromPEM(pemString: recreated) else { throw KernelASN1.TypedError(.decodingFailed) }
        #expect(certPem == recreated)
        #expect(parsedCert.asn1() == parsedCertRecreated.asn1())
    }

    
    private func recomposeCertificate(certPem: String) throws -> KernelX509.Certificate {
        guard let parsedCert = try KernelASN1.ASN1Parser4.objectFromPEM(pemString: certPem) else { throw KernelASN1.TypedError(.decodingFailed) }
        var extensionsMap: [KernelX509.Extension.ExtensionIdentifier: KernelX509.Extension] = [:]
        let decoded: KernelX509.Certificate = try KernelASN1.ASN1Decoder.decode(from: parsedCert)
        if let basic = try? decoded.extensions.decodeExtension(KernelX509.Extension.BasicConstraints.self) { extensionsMap[.basicConstraints] = try? basic.buildExtension() }
        if let key = try? decoded.extensions.decodeExtension(KernelX509.Extension.KeyUsage.self) { extensionsMap[.keyUsage] = try? key.buildExtension() }
        if let extKey = try? decoded.extensions.decodeExtension(KernelX509.Extension.ExtendedKeyUsage.self) { extensionsMap[.extKeyUsage] = try? extKey.buildExtension() }
        if let subjectKey = try? decoded.extensions.decodeExtension(KernelX509.Extension.SubjectKeyIdentifier.self) { extensionsMap[.subjectKeyIdentifier] = try? subjectKey.buildExtension() }
        if let authorityKey = try? decoded.extensions.decodeExtension(KernelX509.Extension.AuthorityKeyIdentifier.self) { extensionsMap[.authorityKeyIdentifier] = try? authorityKey.buildExtension() }
        if let authorityInfo = try? decoded.extensions.decodeExtension(KernelX509.Extension.AuthorityInfoAccess.self) { extensionsMap[.authorityInfoAccess] = try? authorityInfo.buildExtension() }
        if let certPolicies = try? decoded.extensions.decodeExtension(KernelX509.Extension.CertificatePolicies.self) { extensionsMap[.certificatePolicies] = try? certPolicies.buildExtension() }
        if let crlDistrPoints = try? decoded.extensions.decodeExtension(KernelX509.Extension.CRLDistributionPoints.self) { extensionsMap[.crlDistributionPoints] = try? crlDistrPoints.buildExtension() }
        if let nameConstraints = try? decoded.extensions.decodeExtension(KernelX509.Extension.NameConstraints.self) { extensionsMap[.nameConstraints] = try? nameConstraints.buildExtension() }
        if let subjectAlternativeName = try? decoded.extensions.decodeExtension(KernelX509.Extension.SubjectAlternativeName.self) { extensionsMap[.subjectAlternativeName] = try? subjectAlternativeName.buildExtension() }
        
        var newExtensions: [KernelX509.Extension] = []
        decoded.extensions.extensionOrdinals.sorted(by: { $0.key < $1.key }).forEach { (index, identifier) in
            if let knownExtension = extensionsMap[identifier] { newExtensions.append(knownExtension) }
            else if let unknownExtension = decoded.extensions.items.first(where: { $0.extId == identifier }) {
                newExtensions.append(unknownExtension)
            }
        }
        let newCertificate: KernelX509.Certificate = .init(
            version: decoded.version,
            serialNumber: decoded.serialNumber,
            signatureAlgorithm: decoded.signatureAlgorithm,
            issuer: decoded.issuer,
            validity: decoded.validity,
            subject: decoded.subject,
            subjectPublicKeyInfo: decoded.subjectPublicKeyInfo,
            extensions: .init(items: newExtensions),
            keySignature: decoded.keySignature
        )
        let pem = newCertificate.pemFile().pemString
        guard let parsedCertRecreated = try KernelASN1.ASN1Parser4.objectFromPEM(pemString: pem) else { throw KernelASN1.TypedError(.decodingFailed) }
        KernelASN1.ASN1Printer.printObjectVerbose(parsedCert, fullLength: true, decodedOctets: true, decodedBits: true)
        KernelASN1.ASN1Printer.printObjectVerbose(parsedCertRecreated, fullLength: true, decodedOctets: true, decodedBits: true)
        print(pem)
        #expect(certPem == pem)
        return decoded
    }
}
