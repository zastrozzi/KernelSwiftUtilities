//
//  File.swift
//
//
//  Created by Jonathan Forbes on 10/07/2023.
//

extension KernelX509.Extension {
    public struct AuthorityKeyIdentifier: X509ExtensionTransformable {
        
        public var critical: Bool
        public let keyIdentifier: [UInt8]
        
        public init(critical: Bool = false, keyIdentifier: [UInt8]) {
            self.keyIdentifier = keyIdentifier
            self.critical = critical
        }
        
        public init(critical: Bool = false, publicKey: KernelX509.Certificate.PublicKey) {
            self.init(critical: critical, keyIdentifier: publicKey.underlyingKey.fingerprintBytes(.sha1pkcs1DerHex))
        }
    }
}

extension KernelX509.Extension.AuthorityKeyIdentifier: X509ExtensionBuildable {
    public func buildExtension() throws -> KernelX509.Extension {
        let built = KernelASN1.ASN1Writer.dataFromObject(
            try buildExtensionData(), taggingMode: .implicit
        )
        
        return .init(extId: .authorityKeyIdentifier, critical: critical, extValue: built)
    }
    
    public func buildExtensionData() throws -> KernelASN1.ASN1Type {
        return .sequence([.tagged(0, .implicit(.octetString(.init(data: keyIdentifier))))])
    }
}

extension KernelX509.Extension.AuthorityKeyIdentifier: X509ExtensionDecodable {
    public static var extIdentifier: KernelX509.Extension.ExtensionIdentifier { .authorityKeyIdentifier }
    public init(from ext: KernelX509.Extension) throws {
        self.critical = ext.critical
        guard ext.extId == Self.extIdentifier else { throw Self.extensionDecodingFailed() }
        let parsed = try KernelASN1.ASN1Parser4.objectFromBytes(ext.extValue)
        //        print("PARSED AKEY", parsed.asn1())
        guard case let .sequence(seqItems) = parsed.type, !seqItems.isEmpty else { throw Self.decodingError(.octetString, type: parsed) }
        guard case let .tagged(0, .implicit(.any(obj))) = seqItems[0].type.toASN1Type() else { throw Self.decodingError(.octetString, type: parsed) }
        self.keyIdentifier = obj.anyData
    }
}
