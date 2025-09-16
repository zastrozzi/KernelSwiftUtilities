//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 21/06/2023.
//

extension KernelX509.Extension {
    public struct SubjectKeyIdentifier: X509ExtensionTransformable {
        public var critical: Bool
        public let keyIdentifier: [UInt8]
        
        public init(critical: Bool = false, keyIdentifier: [UInt8]) {
            self.critical = critical
            self.keyIdentifier = keyIdentifier
        }
        
        public init(critical: Bool = false, publicKey: KernelX509.Certificate.PublicKey) {
            self.init(critical: critical, keyIdentifier: publicKey.underlyingKey.fingerprintBytes(.sha1pkcs1DerHex))
        }
    }
}

extension KernelX509.Extension.SubjectKeyIdentifier: X509ExtensionBuildable {
    public func buildExtensionData() throws -> KernelASN1.ASN1Type {
        .octetString(.init(data: keyIdentifier))
    }
}

extension KernelX509.Extension.SubjectKeyIdentifier: X509ExtensionDecodable {
    public static var extIdentifier: KernelX509.Extension.ExtensionIdentifier { .subjectKeyIdentifier }
    public init(from ext: KernelX509.Extension) throws {
        self.critical = ext.critical
        guard ext.extId == Self.extIdentifier else { throw KernelASN1.TypedError(.decodingFailed) }
        let parsed = try KernelASN1.ASN1Parser2.objectFromBytes(ext.extValue)
        guard case let .octetString(asn1OctetStr) = parsed else { throw KernelASN1.TypedError(.decodingFailed) }
        self.keyIdentifier = asn1OctetStr.value
    }
}
