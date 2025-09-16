//
//  File.swift
//
//
//  Created by Jonathan Forbes on 19/06/2023.
//

extension KernelX509.CSR {
    public struct CertificateSigningRequest: ASN1Decodable {
        
        public var version: KernelX509.CSR.Version
        public var subject: KernelX509.Common.DistinguishedName
        public var publicKey: KernelX509.Certificate.PublicKey
        
        public var extensions: KernelX509.ExtensionSet
        public var keySignature: KernelX509.Certificate.Signature
        public var privateKey: KernelX509.Certificate.PrivateKey?
        
        public init(
            version: KernelX509.CSR.Version,
            subject: KernelX509.Common.DistinguishedName,
            publicKey: KernelX509.Certificate.PublicKey,
            privateKey: KernelX509.Certificate.PrivateKey? = nil,
            keySignature: KernelX509.Certificate.Signature,
            extensions: KernelX509.ExtensionSet
        ) {
            self.extensions = extensions
            self.subject = subject
            self.publicKey = publicKey
            self.keySignature = keySignature
            self.privateKey = privateKey
            self.version = version
        }
        
        public init(
            version: KernelX509.CSR.Version,
            subject: KernelX509.Common.DistinguishedName,
            publicKey: KernelX509.Certificate.PublicKey,
            privateKey: KernelX509.Certificate.PrivateKey,
            signatureAlgorithm: KernelCryptography.Algorithms.AlgorithmIdentifier,
            extensions: KernelX509.ExtensionSet
        ) throws {
            let requestInfo: RequestInfo = .init(
                version: version,
                subject: subject,
                publicKey: publicKey,
                extensions: extensions
            )
            
            let serializedRequestInfo = requestInfo.serializeRequestInfo()
            let signature = try privateKey.sign(bytes: serializedRequestInfo, signatureAlgorithm: signatureAlgorithm)
            self.init(version: requestInfo.version, subject: requestInfo.subject, publicKey: requestInfo.publicKey, privateKey: privateKey, keySignature: signature, extensions: requestInfo.extensions)
        }
        
        public init(requestInfo: RequestInfo, keySignature: KernelX509.Certificate.Signature) {
            self.version = requestInfo.version
            self.subject = requestInfo.subject
            self.publicKey = requestInfo.publicKey
            self.extensions = requestInfo.extensions
            self.keySignature = keySignature
            self.privateKey = nil
        }
        
        public init(from decoder: KernelASN1.ASN1Decoder) throws {
            try self.init(from: decoder.asn1Type)
        }
        
        
        public init(from asn1Type: KernelASN1.ASN1Type) throws {
            guard case let .sequence(rootASN1SequenceItems) = asn1Type else { throw Self.decodingError(.sequence, asn1Type) }
            let signature: KernelX509.Certificate.Signature = try .init(from: [rootASN1SequenceItems[1], rootASN1SequenceItems[2]])
            let reqInfo: RequestInfo = try .init(from: rootASN1SequenceItems[0])
            self.init(requestInfo: reqInfo, keySignature: signature)
        }
    }
}

extension KernelX509.CSR.CertificateSigningRequest {
    public struct RequestInfo: ASN1Decodable {
        public var version: KernelX509.CSR.Version
        public var subject: KernelX509.Common.DistinguishedName
        public var publicKey: KernelX509.Certificate.PublicKey
        public var extensions: KernelX509.ExtensionSet
        //        @ASN1(type: .tagged(0, .sequence)) public var extensions: [KernelX509.Extension]
        
        //        public static var asn1DecodingSchema: DecodingSchema {[]}
        
        public init(
            version: KernelX509.CSR.Version,
            subject: KernelX509.Common.DistinguishedName,
            publicKey: KernelX509.Certificate.PublicKey,
            extensions: KernelX509.ExtensionSet
        ) {
            self.extensions = extensions
            self.version = version
            self.subject = subject
            self.publicKey = publicKey
        }
        
        public func buildExtensions() -> KernelASN1.ASN1Type {
            //            var extensionTypes: [ASN1Type] = []
            
            return .tagged(0, .explicit(.sequence([
                .objectIdentifier(.init(oid: .pkcs9ExtensionRequest)),
                .set([
                    .sequence(extensions.items.map { $0.buildASN1Type() })
                ])
            ])))
        }
        
        func buildRequestInfo() -> KernelASN1.ASN1Type {
            let extensions = buildExtensions()
            return .sequence([
                version.buildASN1Type(),
                subject.buildASN1Type(),
                publicKey.buildASN1Type(),
                extensions
            ])
        }
        
        public func serializeRequestInfo() -> [UInt8] {
            KernelASN1.ASN1Writer.dataFromObject(buildRequestInfo())
        }
        
        public init(from decoder: Decoder) throws {
            fatalError()
        }
        
        public init(from asn1Type: KernelASN1.ASN1Type) throws {
            guard case let .sequence(asn1SequenceItems) = asn1Type else { throw Self.decodingError(.sequence, asn1Type) }
            self.version = try .init(from: asn1SequenceItems[0])
            self.subject = try .init(from: asn1SequenceItems[1])
            self.publicKey = try .init(from: asn1SequenceItems[2])
            guard
                case let .tagged(asn1Tag, .constructed(asn1TaggedSequenceItems)) = asn1SequenceItems[3],
                //                case let .tagged(asn1Tag, .explicit(asn1TaggedType)) = asn1SequenceItems[3],
                asn1Tag == 0,
                case let .sequence(asn1TaggedAttributeItems) = asn1TaggedSequenceItems[0],
                case let .objectIdentifier(asn1ObjectID) = asn1TaggedAttributeItems[0],
                asn1ObjectID.oid == .pkcs9ExtensionRequest,
                case let .set(extSetItems) = asn1TaggedAttributeItems[1],
                case let .sequence(extSequenceItems) = extSetItems[0]
            else { throw Self.decodingError(nil, asn1Type) }
            self.extensions = .init(items: try extSequenceItems.map {
                try .init(from: $0)
            })
        }
    }
}

extension KernelX509.CSR.CertificateSigningRequest {
    public func buildExtensions() -> KernelASN1.ASN1Type {
        return .tagged(0, .explicit(.sequence([
            .objectIdentifier(.init(oid: .pkcs9ExtensionRequest)),
            .set([
                .sequence(extensions.items.map { $0.buildASN1Type() })
            ])
        ])))
    }
    
    func buildRequestInfo() -> KernelASN1.ASN1Type {
        let extensions = buildExtensions()
        return .sequence([
            version.buildASN1Type(),
            subject.buildASN1Type(),
            publicKey.buildASN1Type(),
            extensions
        ])
    }
    
    public func privateKeyPEMFile() throws -> KernelASN1.PEMFile {
        guard let privateKey else { throw KernelX509.TypedError(.privateKeyNotIncluded) }
        return .init(for: .encryptedPrivateKey, from: privateKey.underlyingKey)
    }
    
    public func pemFile() -> KernelASN1.PEMFile {
        //        guard let privateKey else { throw KernelX509.Error(.privateKeyNotIncluded) }
        return .init(for: .csr, from: self)
    }
}

extension KernelX509.CSR.CertificateSigningRequest: ASN1Buildable, ASN1Serialisable {
    public func buildASN1Type() -> KernelASN1.ASN1Type {
        return .sequence([
            buildRequestInfo()
        ] + keySignature.buildASN1TypeArray())
    }
}
