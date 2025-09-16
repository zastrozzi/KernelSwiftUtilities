//
//  File.swift
//
//
//  Created by Jonathan Forbes on 14/09/2023.
//

import Foundation
import KernelSwiftCommon
import KernelSwiftServer
import Testing

@Suite
struct CertificateTests {
    func testCertificateRecomposition(certPem: String) throws
        -> KernelX509.Certificate
    {
        //        let certPem: String = CertPEMStrings.attestRootCert
        guard
            let parsedCert = try KernelASN1.ASN1Parser4.objectFromPEM(
                pemString: certPem)
        else { throw KernelASN1.TypedError(.decodingFailed) }
        var extensionsMap:
            [KernelX509.Extension.ExtensionIdentifier: KernelX509.Extension] =
                [:]
        let decoded: KernelX509.Certificate = try KernelASN1.ASN1Decoder.decode(
            from: parsedCert)
        if let basic = try? decoded.extensions.decodeExtension(
            KernelX509.Extension.BasicConstraints.self)
        {
            extensionsMap[.basicConstraints] = try? basic.buildExtension()
        }
        if let key = try? decoded.extensions.decodeExtension(
            KernelX509.Extension.KeyUsage.self)
        {
            extensionsMap[.keyUsage] = try? key.buildExtension()
        }
        if let extKey = try? decoded.extensions.decodeExtension(
            KernelX509.Extension.ExtendedKeyUsage.self)
        {
            extensionsMap[.extKeyUsage] = try? extKey.buildExtension()
        }
        if let subjectKey = try? decoded.extensions.decodeExtension(
            KernelX509.Extension.SubjectKeyIdentifier.self)
        {
            extensionsMap[.subjectKeyIdentifier] =
                try? subjectKey.buildExtension()
        }
        if let authorityKey = try? decoded.extensions.decodeExtension(
            KernelX509.Extension.AuthorityKeyIdentifier.self)
        {
            extensionsMap[.authorityKeyIdentifier] =
                try? authorityKey.buildExtension()
        }
        if let authorityInfo = try? decoded.extensions.decodeExtension(
            KernelX509.Extension.AuthorityInfoAccess.self)
        {
            extensionsMap[.authorityInfoAccess] =
                try? authorityInfo.buildExtension()
        }
        if let certPolicies = try? decoded.extensions.decodeExtension(
            KernelX509.Extension.CertificatePolicies.self)
        {
            extensionsMap[.certificatePolicies] =
                try? certPolicies.buildExtension()
        }
        if let crlDistrPoints = try? decoded.extensions.decodeExtension(
            KernelX509.Extension.CRLDistributionPoints.self)
        {
            extensionsMap[.crlDistributionPoints] =
                try? crlDistrPoints.buildExtension()
        }
        if let nameConstraints = try? decoded.extensions.decodeExtension(
            KernelX509.Extension.NameConstraints.self)
        {
            extensionsMap[.nameConstraints] =
                try? nameConstraints.buildExtension()
        }
        if let subjectAlternativeName = try? decoded.extensions.decodeExtension(
            KernelX509.Extension.SubjectAlternativeName.self)
        {
            extensionsMap[.subjectAlternativeName] =
                try? subjectAlternativeName.buildExtension()
        }

        var newExtensions: [KernelX509.Extension] = []
        decoded.extensions.extensionOrdinals.sorted(by: { $0.key < $1.key })
            .forEach { (index, identifier) in
                if let knownExtension = extensionsMap[identifier] {
                    newExtensions.append(knownExtension)
                } else if let unknownExtension = decoded.extensions.items.first(
                    where: { $0.extId == identifier })
                {
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
        guard
            let parsedCertRecreated = try KernelASN1.ASN1Parser4.objectFromPEM(
                pemString: pem)
        else { throw KernelASN1.TypedError(.decodingFailed) }
        parsedCert.printVerbose(
            fullLength: true, decodedOctets: true, decodedBits: true)
        parsedCertRecreated.printVerbose(
            fullLength: true, decodedOctets: true, decodedBits: true)
        //        print(pem)
        #expect(certPem == pem)
        return decoded
    }

    @Test
    func testCertificateChainRecomposition() throws {
        let decodedRoot = try testCertificateRecomposition(
            certPem: CertPEMStrings.attestRootCert)
        let decodedIntermediate = try testCertificateRecomposition(
            certPem: CertPEMStrings.attestIntermediateCert)
        let decodedLeaf = try testCertificateRecomposition(
            certPem: CertPEMStrings.attestLeafCert)

        let decodedLeafTBS = KernelASN1.ASN1Writer.dataFromObject(
            decodedLeaf.buildTBSCertificate())
        let decodedIntermediateTBS = KernelASN1.ASN1Writer.dataFromObject(
            decodedIntermediate.buildTBSCertificate())
        let leafValid = try decodedIntermediate.subjectPublicKeyInfo
            .underlyingKey.verify(
                signature: decodedLeaf.keySignature, digest: decodedLeafTBS)
        let intermediateValid = try decodedRoot.subjectPublicKeyInfo
            .underlyingKey.verify(
                signature: decodedIntermediate.keySignature,
                digest: decodedIntermediateTBS)
        //        print("INTERMEDIATE VALID?", intermediateValid)
        //        print("LEAF VALID?", leafValid)
        #expect(intermediateValid)
        #expect(leafValid)
    }

    @Test(arguments: KernelNumerics.EC.Curve.knownCurveOIDs)
    func generateSelfSignedCertificateEC(curve: KernelSwiftCommon.ObjectID)
        throws
    {
        print("SELF SIGNED", curve)
        let comp = try KernelCryptography.EC.Components(oidSync: curve)
        let pubKey = comp.publicKey(.pkcs8)
        let privKey = comp.privateKey(.pkcs8)
        let certPubKey: KernelX509.Certificate.PublicKey = .init(
            underlyingKey: .ec(pubKey))
        let certPrivKey: KernelX509.Certificate.PrivateKey = .init(
            keyAlgorithm: pubKey.keyAlg(), underlyingKey: .ec(privKey))
        let subjectKeyInfoExt = try KernelX509.Extension.SubjectKeyIdentifier(
            publicKey: certPubKey
        ).buildExtension()
        let keyUsageExt = try KernelX509.Extension.KeyUsage(
            critical: true, flags: .digitalSignature, .nonRepudiation
        ).buildExtension()
        let extKeyUsageExt = try KernelX509.Extension.ExtendedKeyUsage(
            critical: false, usages: .clientAuth, .serverAuth
        ).buildExtension()

        let csr: KernelX509.CSR.CertificateSigningRequest = try .init(
            version: .v1,
            subject: .init(rdns: [
                .init(
                    attributeType: .countryName,
                    attributeValueType: .printableString, stringValue: "GB"),
                .init(
                    attributeType: .organizationName,
                    attributeValueType: .utf8String,
                    stringValue: "KERNEL EDGE TECHNOLOGIES LTD"),
                .init(
                    attributeType: .organizationIdentifier,
                    attributeValueType: .utf8String,
                    stringValue: "KERNELEDGE_ORG"),
                .init(
                    attributeType: .commonName, attributeValueType: .utf8String,
                    stringValue: "KERNELEDGE"),
                .init(
                    attributeType: .emailAddress,
                    attributeValueType: .utf8String,
                    stringValue: "jono@kerneledge.com"),
            ]),
            publicKey: certPubKey,
            privateKey: certPrivKey,
            signatureAlgorithm: privKey.sigAlg(),
            extensions: .init(items: [
                keyUsageExt,
                extKeyUsageExt,
                subjectKeyInfoExt,
            ])
        )

        let cert: KernelX509.Certificate = try .makeSelfSignedCertificate(
            csr,
            sigAlg: privKey.sigAlg(),
            validity: .init(
                notBefore: .now.startOfYear, notAfter: .now.endOfYear)
        )

        guard
            let parsedCert = try KernelASN1.ASN1Parser4.objectFromPEM(
                pemString: cert.pemFile().pemString)
        else { throw KernelASN1.TypedError(.decodingFailed) }
        //        print("CERT", curve)
        //        print(cert.pemFile().pemString)
        //        KernelASN1.ASN1Printer.printObjectVerbose(parsedCert, fullLength: true, decodedOctets: true, decodedBits: true)
        let decodedCert: KernelX509.Certificate = try KernelASN1.ASN1Decoder
            .decode(from: parsedCert)
        let decodedCertTBS = KernelASN1.ASN1Writer.dataFromObject(
            decodedCert.buildTBSCertificate())
        let decodedCertValid = try certPubKey.underlyingKey.verify(
            signature: decodedCert.keySignature, digest: decodedCertTBS)
        //        print("CERT VALID?", curve, decodedCertValid)
        #expect(decodedCertValid)
    }

    @Test(arguments: KernelNumerics.EC.Curve.knownCurveOIDs)
    func generateRootSignedCertificateEC(curve: KernelSwiftCommon.ObjectID)
        throws
    {
        let rootComp = try KernelCryptography.EC.Components(oidSync: curve)
        let rootPubKey = rootComp.publicKey(.pkcs8)
        let rootPrivKey = rootComp.privateKey(.pkcs8)
        let rootCertPubKey: KernelX509.Certificate.PublicKey = .init(
            underlyingKey: .ec(rootPubKey))
        let rootCertPrivKey: KernelX509.Certificate.PrivateKey = .init(
            keyAlgorithm: rootPubKey.keyAlg(), underlyingKey: .ec(rootPrivKey))
        let rootIssuer: KernelX509.Common.DistinguishedName = .init(rdns: [
            .init(
                attributeType: .countryName,
                attributeValueType: .printableString, stringValue: "GB"),
            .init(
                attributeType: .organizationName,
                attributeValueType: .utf8String,
                stringValue: "KERNEL EDGE TECHNOLOGIES LTD"),
            .init(
                attributeType: .organizationIdentifier,
                attributeValueType: .utf8String, stringValue: "KERNELEDGE_ORG"),
            .init(
                attributeType: .commonName, attributeValueType: .utf8String,
                stringValue: "KERNELEDGE"),
            .init(
                attributeType: .emailAddress, attributeValueType: .utf8String,
                stringValue: "jono@kerneledge.com"),
        ])

        let leafComp = try KernelCryptography.EC.Components(oidSync: curve)
        let leafPubKey = leafComp.publicKey(.pkcs8)
        let leafPrivKey = leafComp.privateKey(.pkcs8)
        let leafCertPubKey: KernelX509.Certificate.PublicKey = .init(
            underlyingKey: .ec(leafPubKey))
        let leafCertPrivKey: KernelX509.Certificate.PrivateKey = .init(
            keyAlgorithm: leafPubKey.keyAlg(), underlyingKey: .ec(leafPrivKey))
        let subjectKeyInfoExt = try KernelX509.Extension.SubjectKeyIdentifier(
            publicKey: leafCertPubKey
        ).buildExtension()
        let authorityKeyInfoExt = try KernelX509.Extension
            .AuthorityKeyIdentifier(publicKey: rootCertPubKey).buildExtension()
        let keyUsageExt = try KernelX509.Extension.KeyUsage(
            critical: true, flags: .digitalSignature, .nonRepudiation
        ).buildExtension()
        let extKeyUsageExt = try KernelX509.Extension.ExtendedKeyUsage(
            critical: false, usages: .clientAuth, .serverAuth
        ).buildExtension()

        let csr: KernelX509.CSR.CertificateSigningRequest = try .init(
            version: .v1,
            subject: .init(rdns: [
                .init(
                    attributeType: .countryName,
                    attributeValueType: .printableString, stringValue: "GB"),
                .init(
                    attributeType: .organizationName,
                    attributeValueType: .utf8String,
                    stringValue: "SOME CLIENT LTD"),
                .init(
                    attributeType: .organizationIdentifier,
                    attributeValueType: .utf8String,
                    stringValue: "SOME_CLIENT_ORG"),
                .init(
                    attributeType: .commonName, attributeValueType: .utf8String,
                    stringValue: "SomeClient"),
                .init(
                    attributeType: .emailAddress,
                    attributeValueType: .utf8String,
                    stringValue: "user@someclient.com"),
            ]),
            publicKey: leafCertPubKey,
            privateKey: leafCertPrivKey,
            signatureAlgorithm: leafPrivKey.sigAlg(),
            extensions: .init(items: [
                keyUsageExt,
                extKeyUsageExt,
                subjectKeyInfoExt,
                authorityKeyInfoExt,
            ])
        )

        let cert: KernelX509.Certificate = try .signCertificate(
            csr,
            issuer: rootIssuer,
            privKey: rootCertPrivKey,
            sigAlg: rootPrivKey.sigAlg(),
            validity: .init(
                notBefore: .now.startOfYear, notAfter: .now.endOfYear)
        )

        guard
            let parsedCert = try KernelASN1.ASN1Parser4.objectFromPEM(
                pemString: cert.pemFile().pemString)
        else { throw KernelASN1.TypedError(.decodingFailed) }
        let decodedCert: KernelX509.Certificate = try KernelASN1.ASN1Decoder
            .decode(from: parsedCert)
        let decodedCertTBS = KernelASN1.ASN1Writer.dataFromObject(
            decodedCert.buildTBSCertificate())
        let decodedCertValid = try rootCertPubKey.underlyingKey.verify(
            signature: decodedCert.keySignature, digest: decodedCertTBS)
        #expect(decodedCertValid)
    }

    @Test(arguments: KernelNumerics.EC.Curve.knownCurveOIDs)
    func generateRootSignedCertificateECRounds(
        curve: KernelSwiftCommon.ObjectID
    ) throws {
        let rounds = 10
        let rootComp = try KernelCryptography.EC.Components(oidSync: curve)
        let rootPubKey = rootComp.publicKey(.pkcs8)
        let rootPrivKey = rootComp.privateKey(.pkcs8)
        let rootCertPubKey: KernelX509.Certificate.PublicKey = .init(
            underlyingKey: .ec(rootPubKey))
        let rootCertPrivKey: KernelX509.Certificate.PrivateKey = .init(
            keyAlgorithm: rootPubKey.keyAlg(), underlyingKey: .ec(rootPrivKey))
        let rootIssuer: KernelX509.Common.DistinguishedName = .init(rdns: [
            .init(
                attributeType: .countryName,
                attributeValueType: .printableString, stringValue: "GB"),
            .init(
                attributeType: .organizationName,
                attributeValueType: .utf8String,
                stringValue: "KERNEL EDGE TECHNOLOGIES LTD"),
            .init(
                attributeType: .organizationIdentifier,
                attributeValueType: .utf8String, stringValue: "KERNELEDGE_ORG"),
            .init(
                attributeType: .commonName, attributeValueType: .utf8String,
                stringValue: "KERNELEDGE"),
            .init(
                attributeType: .emailAddress, attributeValueType: .utf8String,
                stringValue: "jono@kerneledge.com"),
        ])

        let leafComp = try KernelCryptography.EC.Components(oidSync: curve)
        let leafPubKey = leafComp.publicKey(.pkcs8)
        let leafPrivKey = leafComp.privateKey(.pkcs8)
        let leafCertPubKey: KernelX509.Certificate.PublicKey = .init(
            underlyingKey: .ec(leafPubKey))
        let leafCertPrivKey: KernelX509.Certificate.PrivateKey = .init(
            keyAlgorithm: leafPubKey.keyAlg(), underlyingKey: .ec(leafPrivKey))
        let subjectKeyInfoExt = try KernelX509.Extension.SubjectKeyIdentifier(
            publicKey: leafCertPubKey
        ).buildExtension()
        let authorityKeyInfoExt = try KernelX509.Extension
            .AuthorityKeyIdentifier(publicKey: rootCertPubKey).buildExtension()
        let keyUsageExt = try KernelX509.Extension.KeyUsage(
            critical: true, flags: .digitalSignature, .nonRepudiation
        ).buildExtension()
        let extKeyUsageExt = try KernelX509.Extension.ExtendedKeyUsage(
            critical: false, usages: .clientAuth, .serverAuth
        ).buildExtension()

        let csr: KernelX509.CSR.CertificateSigningRequest = try .init(
            version: .v1,
            subject: .init(rdns: [
                .init(
                    attributeType: .countryName,
                    attributeValueType: .printableString, stringValue: "GB"),
                .init(
                    attributeType: .organizationName,
                    attributeValueType: .utf8String,
                    stringValue: "SOME CLIENT LTD"),
                .init(
                    attributeType: .organizationIdentifier,
                    attributeValueType: .utf8String,
                    stringValue: "SOME_CLIENT_ORG"),
                .init(
                    attributeType: .commonName, attributeValueType: .utf8String,
                    stringValue: "SomeClient"),
                .init(
                    attributeType: .emailAddress,
                    attributeValueType: .utf8String,
                    stringValue: "user@someclient.com"),
            ]),
            publicKey: leafCertPubKey,
            privateKey: leafCertPrivKey,
            signatureAlgorithm: leafPrivKey.sigAlg(),
            extensions: .init(items: [
                keyUsageExt,
                extKeyUsageExt,
                subjectKeyInfoExt,
                authorityKeyInfoExt,
            ])
        )

        var signTime: Double = 0
        var verifyTime: Double = 0
        for _ in 0..<rounds {
            let signStart = ProcessInfo.processInfo.systemUptime
            let cert: KernelX509.Certificate = try .signCertificate(
                csr,
                issuer: rootIssuer,
                privKey: rootCertPrivKey,
                sigAlg: rootPrivKey.sigAlg(),
                validity: .init(
                    notBefore: .now.startOfYear, notAfter: .now.endOfYear)
            )
            let signEnd = ProcessInfo.processInfo.systemUptime
            signTime += (signEnd - signStart)

            let verifyStart = ProcessInfo.processInfo.systemUptime
            let verified = try rootCertPubKey.underlyingKey.verify(
                signature: cert.keySignature,
                digest: cert.buildTBSCertificate().serialise())
            #expect(verified)
            let verifyEnd = ProcessInfo.processInfo.systemUptime
            verifyTime += (verifyEnd - verifyStart)
        }
        print(
            "ROOT SIGNED \(curve) SIG: \(averageMsString(signTime, rounds)) VERIFY: \(averageMsString(verifyTime, rounds))"
        )
    }
}
