//
//  File.swift
//
//
//  Created by Jonathan Forbes on 19/06/2023.
//

extension KernelX509 {
    public struct Certificate: ASN1Decodable {
        public var version: Version
        public var serialNumber: SerialNumber
        public var signatureAlgorithm: KernelCryptography.Algorithms.AlgorithmIdentifier
        public var issuer: KernelX509.Common.DistinguishedName
        public var validity: KernelX509.Certificate.Validity
        public var subject: KernelX509.Common.DistinguishedName
        public var subjectPublicKeyInfo: KernelX509.Certificate.PublicKey
        public var issuerUniqueID: KernelX509.Certificate.IssuerUniqueIdentifier?
        public var subjectUniqueID: KernelX509.Certificate.SubjectUniqueIdentifier?
        public var extensions: KernelX509.ExtensionSet
        public var keySignature: KernelX509.Certificate.Signature
        
        public init(
            version: KernelX509.Certificate.Version,
            serialNumber: KernelX509.Certificate.SerialNumber,
            signatureAlgorithm: KernelCryptography.Algorithms.AlgorithmIdentifier,
            issuer: KernelX509.Common.DistinguishedName,
            validity: KernelX509.Certificate.Validity,
            subject: KernelX509.Common.DistinguishedName,
            subjectPublicKeyInfo: KernelX509.Certificate.PublicKey,
            issuerUniqueID: KernelX509.Certificate.IssuerUniqueIdentifier? = nil,
            subjectUniqueID: KernelX509.Certificate.SubjectUniqueIdentifier? = nil,
            extensions: KernelX509.ExtensionSet,
            keySignature: KernelX509.Certificate.Signature
        ) {
            self.version = version
            self.serialNumber = serialNumber
            self.signatureAlgorithm = signatureAlgorithm
            self.issuer = issuer
            self.validity = validity
            self.subject = subject
            self.subjectPublicKeyInfo = subjectPublicKeyInfo
            self.issuerUniqueID = issuerUniqueID
            self.subjectUniqueID = subjectUniqueID
            self.extensions = extensions
            self.keySignature = keySignature
        }
        
        public init(
            version: KernelX509.Certificate.Version,
            serialNumber: KernelX509.Certificate.SerialNumber,
            signatureAlgorithm: KernelCryptography.Algorithms.AlgorithmIdentifier,
            issuer: KernelX509.Common.DistinguishedName,
            validity: KernelX509.Certificate.Validity,
            subject: KernelX509.Common.DistinguishedName,
            subjectPublicKeyInfo: KernelX509.Certificate.PublicKey,
            issuerUniqueID: KernelX509.Certificate.IssuerUniqueIdentifier? = nil,
            subjectUniqueID: KernelX509.Certificate.SubjectUniqueIdentifier? = nil,
            extensions: KernelX509.ExtensionSet
        ) {
            self.version = version
            self.serialNumber = serialNumber
            self.signatureAlgorithm = signatureAlgorithm
            self.issuer = issuer
            self.validity = validity
            self.subject = subject
            self.subjectPublicKeyInfo = subjectPublicKeyInfo
            self.issuerUniqueID = issuerUniqueID
            self.subjectUniqueID = subjectUniqueID
            self.extensions = extensions
            fatalError()
        }
        
        public init(from dbType: KernelX509.Fluent.Model.Certificate) throws {
            self.version = .init(rawValue: dbType.tbsCert.version)
            self.serialNumber = .init(rawValue: dbType.tbsCert.serialNumber)
            var sigAlg: KernelCryptography.Algorithms.AlgorithmIdentifier
            sigAlg = .init(algorithm: dbType.tbsCert.signatureAlgorithm.algorithm)
            if let curve = dbType.tbsCert.signatureAlgorithm.parameters.curve {
                sigAlg.parameters = .objectIdentifier(.init(oid: curve))
            }
            self.signatureAlgorithm = sigAlg
            self.issuer = .init(from: dbType.tbsCert.issuer)
            self.validity = .init(notBefore: dbType.tbsCert.validity.notBefore, notAfter: dbType.tbsCert.validity.notAfter)
            self.subject = .init(from: dbType.tbsCert.subject)
            self.subjectPublicKeyInfo = .init(
                keyAlgorithm: .init(algorithm: dbType.tbsCert.subjectPublicKeyInfo.keyAlgorithm.algorithm),
                underlyingKey: dbType.tbsCert.subjectPublicKeyInfo.underlyingKey
            )
            if let subjectKeyCurve = dbType.tbsCert.subjectPublicKeyInfo.keyAlgorithm.parameters.curve {
                self.subjectPublicKeyInfo.keyAlgorithm.parameters = .objectIdentifier(.init(oid: subjectKeyCurve))
            }
            self.issuerUniqueID = nil
            self.subjectUniqueID = nil
            self.extensions = dbType.tbsCert.extensions ?? .init(items: [])
            self.keySignature = try .init(from: [
                sigAlg.buildASN1Type(),
                .bitString(dbType.signature)
            ])
        }
        
        public init(from asn1Type: KernelASN1.ASN1Type) throws {
            guard case let .sequence(rootASN1SequenceItems) = asn1Type else { throw Self.decodingError(.sequence, asn1Type) }
            
            guard case let .sequence(dataASN1SequenceItems) = rootASN1SequenceItems[0] else { throw Self.decodingError(.sequence, rootASN1SequenceItems[0]) }
            self.version = try .init(from: dataASN1SequenceItems[0])
//            print(self.version, "VERSION")
            self.serialNumber = try .init(from: dataASN1SequenceItems[1])
            self.signatureAlgorithm = try .init(from: dataASN1SequenceItems[2])
            self.issuer = try .init(from: dataASN1SequenceItems[3])
            self.validity = try .init(from: dataASN1SequenceItems[4])
            self.subject = try .init(from: dataASN1SequenceItems[5])
            self.subjectPublicKeyInfo = try .init(from: dataASN1SequenceItems[6])
            switch dataASN1SequenceItems.count {
            case 8:
                if case .tagged(1, _) = dataASN1SequenceItems[7] {
                    self.issuerUniqueID = try .init(from: dataASN1SequenceItems[7])
                    self.subjectUniqueID = nil
                    self.extensions = .init(items: [])
                }
                else if case .tagged(2, _) = dataASN1SequenceItems[7] {
                    self.issuerUniqueID = nil
                    self.subjectUniqueID = try .init(from: dataASN1SequenceItems[7])
                    self.extensions = .init(items: [])
                }
                else if case let .tagged(3, .constructed(asn1ConstructedTypes)) = dataASN1SequenceItems[7], case let .sequence(extSequenceItems) = asn1ConstructedTypes[0] {
                    self.extensions = .init(items: try extSequenceItems.map { try .init(from: $0) })
                    self.issuerUniqueID = nil
                    self.subjectUniqueID = nil
                }
                else { throw Self.decodingError(.sequence, asn1Type) }
            case 9:
                if case .tagged(1, _) = dataASN1SequenceItems[7] {
                    self.issuerUniqueID = try .init(from: dataASN1SequenceItems[7])
                    if case .tagged(2, _) = dataASN1SequenceItems[8] {
                        self.subjectUniqueID = try .init(from: dataASN1SequenceItems[8])
                        self.extensions = .init(items: [])
                    }
                    else if case let .tagged(3, .constructed(asn1ConstructedTypes)) = dataASN1SequenceItems[8], case let .sequence(extSequenceItems) = asn1ConstructedTypes[0] {
                        self.extensions = .init(items: try extSequenceItems.map { try .init(from: $0) })
                        self.subjectUniqueID = nil
                    }
                    else { throw Self.decodingError(.sequence, asn1Type) }
                }
                else if case .tagged(2, _) = dataASN1SequenceItems[7] {
                    self.subjectUniqueID = try .init(from: dataASN1SequenceItems[7])
                    if case let .tagged(3, .constructed(asn1ConstructedTypes)) = dataASN1SequenceItems[8], case let .sequence(extSequenceItems) = asn1ConstructedTypes[0] {
                        self.extensions = .init(items: try extSequenceItems.map { try .init(from: $0) })
                        self.issuerUniqueID = nil
                    }
                    else { throw Self.decodingError(.sequence, asn1Type) }
                }
                else { throw Self.decodingError(.sequence, asn1Type) }
            case 10:
                if case .tagged(1, _) = dataASN1SequenceItems[7] {
                    self.issuerUniqueID = try .init(from: dataASN1SequenceItems[7])
                }
                if case .tagged(2, _) = dataASN1SequenceItems[8] {
                    self.subjectUniqueID = try .init(from: dataASN1SequenceItems[8])
                }
                if case let .tagged(3, .constructed(asn1ConstructedTypes)) = dataASN1SequenceItems[9], case let .sequence(extSequenceItems) = asn1ConstructedTypes[0] {
                    self.extensions = .init(items: try extSequenceItems.map { try .init(from: $0) })
                }
                else { throw Self.decodingError(.sequence, asn1Type) }
            default: throw Self.decodingError(.sequence, asn1Type)
            }
            //            guard
            //                case let .tagged(asn1Tag, .constructed(asn1ConstructedTypes)) = dataASN1SequenceItems[7],
            //                asn1Tag == 3,
            //                case let .sequence(extSequenceItems) = asn1ConstructedTypes[0]
            //            else { throw Self.decodingError(.tagged(3, .explicit(.sequence)), dataASN1SequenceItems[7]) }
            //            self.extensions = .init(items: try extSequenceItems.map {
            //                try .init(from: $0)
            //            })
            self.keySignature = try .init(from: [rootASN1SequenceItems[1], rootASN1SequenceItems[2]])
        }
        
        public init(from decoder: KernelASN1.ASN1Decoder) throws {
            try self.init(from: decoder.asn1Type)
        }
        
        public func pemFile() -> KernelASN1.PEMFile {
            //        guard let privateKey else { throw KernelX509.Error(.privateKeyNotIncluded) }
            return .init(for: .crt, from: self)
        }
        
        public func buildExtensions() -> KernelASN1.ASN1Type {
            //            var extensionTypes: [ASN1Type] = []
            
            return .tagged(3, .explicit(.sequence(extensions.items.map { $0.buildASN1Type() })))
        }
        
        
    }
}

extension KernelX509.Certificate: ASN1Buildable, ASN1Serialisable {
    public func buildASN1Type() -> KernelASN1.ASN1Type {
        return .sequence([
            buildTBSCertificate()
        ] + keySignature.buildASN1TypeArray())
    }
    
    public func buildTBSCertificate() -> KernelASN1.ASN1Type {
//        print("KEY SIG IN BUILD", keySignature.signatureAlgorithmASN1())
        var tbsCertificateTypes: [KernelASN1.ASN1Type] = [
            version.buildASN1Type(),
            serialNumber.buildASN1Type(),
            keySignature.signatureAlgorithmASN1(),
            issuer.buildASN1Type(),
            validity.buildASN1Type(),
            subject.buildASN1Type(),
            subjectPublicKeyInfo.buildASN1Type()
        ]
        if let issuerUniqueID { tbsCertificateTypes.append(issuerUniqueID.buildASN1Type()) }
        if let subjectUniqueID { tbsCertificateTypes.append(subjectUniqueID.buildASN1Type()) }
        //        let extensions = buildExtensions()
        if !extensions.items.isEmpty {
            let builtExtensions = buildExtensions()
            tbsCertificateTypes.append(builtExtensions)
        }
        return .sequence(tbsCertificateTypes)
    }
}

extension KernelX509.Certificate {
    public static func makeSelfSignedCertificate(
        _ csr: KernelX509.CSR.CertificateSigningRequest,
        sigAlg: KernelCryptography.Algorithms.AlgorithmIdentifier,
        validity: Validity,
        serialNumber: SerialNumber? = nil,
        issuerUniqueID: IssuerUniqueIdentifier? = nil,
        subjectUniqueID: SubjectUniqueIdentifier? = nil
    ) throws -> KernelX509.Certificate {
        guard let privKey = csr.privateKey else { throw KernelX509.TypedError(.privateKeyNotIncluded) }
        let version: Version = .v3
        let serialNumber = serialNumber ?? .init(rawValue: .randomLessThan("10000000000000"))
        let issuer = csr.subject
        let subject = csr.subject
        let subjectPublicKeyInfo = csr.publicKey
        var tbsCertificateTypes: [KernelASN1.ASN1Type] = [
            version.buildASN1Type(),
            serialNumber.buildASN1Type(),
            sigAlg.buildASN1Type(),
            issuer.buildASN1Type(),
            validity.buildASN1Type(),
            subject.buildASN1Type(),
            subjectPublicKeyInfo.buildASN1Type()
        ]
        if let issuerUniqueID { tbsCertificateTypes.append(issuerUniqueID.buildASN1Type()) }
        if let subjectUniqueID { tbsCertificateTypes.append(subjectUniqueID.buildASN1Type()) }
        if !csr.extensions.items.isEmpty {
            let builtExtensions: KernelASN1.ASN1Type = .tagged(3, .explicit(.sequence(csr.extensions.items.map { $0.buildASN1Type() })))
            tbsCertificateTypes.append(builtExtensions)
        }
        let tbsBytes = KernelASN1.ASN1Writer.dataFromObject(.sequence(tbsCertificateTypes))
        let signature = try privKey.sign(bytes: tbsBytes, signatureAlgorithm: sigAlg)
        
        return self.init(
            version: version,
            serialNumber: serialNumber,
            signatureAlgorithm: sigAlg,
            issuer: issuer,
            validity: validity,
            subject: subject,
            subjectPublicKeyInfo: subjectPublicKeyInfo,
            issuerUniqueID: issuerUniqueID,
            subjectUniqueID: subjectUniqueID,
            extensions: csr.extensions,
            keySignature: signature
        )
    }
    
    public static func signCertificate(
        _ csr: KernelX509.CSR.CertificateSigningRequest,
        issuer: KernelX509.Common.DistinguishedName,
        privKey: KernelX509.Certificate.PrivateKey,
        sigAlg: KernelCryptography.Algorithms.AlgorithmIdentifier,
        validity: Validity,
        serialNumber: SerialNumber? = nil,
        issuerUniqueID: IssuerUniqueIdentifier? = nil,
        subjectUniqueID: SubjectUniqueIdentifier? = nil
    ) throws -> KernelX509.Certificate {
//        guard let privKey = csr.privateKey else { throw KernelX509.TypedError(.privateKeyNotIncluded) }
        let version: Version = .v3
        let serialNumber = serialNumber ?? .init(rawValue: .randomLessThan("10000000000000"))
//        let issuer = csr.subject
        let subject = csr.subject
        let subjectPublicKeyInfo = csr.publicKey
        var tbsCertificateTypes: [KernelASN1.ASN1Type] = [
            version.buildASN1Type(),
            serialNumber.buildASN1Type(),
            sigAlg.buildASN1Type(),
            issuer.buildASN1Type(),
            validity.buildASN1Type(),
            subject.buildASN1Type(),
            subjectPublicKeyInfo.buildASN1Type()
        ]
        if let issuerUniqueID { tbsCertificateTypes.append(issuerUniqueID.buildASN1Type()) }
        if let subjectUniqueID { tbsCertificateTypes.append(subjectUniqueID.buildASN1Type()) }
        if !csr.extensions.items.isEmpty {
            let builtExtensions: KernelASN1.ASN1Type = .tagged(3, .explicit(.sequence(csr.extensions.items.map { $0.buildASN1Type() })))
            tbsCertificateTypes.append(builtExtensions)
        }
        let tbsBytes = KernelASN1.ASN1Writer.dataFromObject(.sequence(tbsCertificateTypes))
        let signature = try privKey.sign(bytes: tbsBytes, signatureAlgorithm: sigAlg)
        
        return self.init(
            version: version,
            serialNumber: serialNumber,
            signatureAlgorithm: sigAlg,
            issuer: issuer,
            validity: validity,
            subject: subject,
            subjectPublicKeyInfo: subjectPublicKeyInfo,
            issuerUniqueID: issuerUniqueID,
            subjectUniqueID: subjectUniqueID,
            extensions: csr.extensions,
            keySignature: signature
        )
    }
}
