//
//  File.swift
//
//
//  Created by Jonathan Forbes on 11/07/2023.
//

extension KernelX509.Extension {
    public struct BasicConstraints: X509ExtensionTransformable {
        public var critical: Bool
        public var isCertificateAuthority: Bool
        public var pathLengthConstraint: Int?
        
        public init(
            critical: Bool = false,
            isCertificateAuthority: Bool,
            pathLengthConstraint: Int? = nil
        ) {
            self.isCertificateAuthority = isCertificateAuthority
            self.pathLengthConstraint = pathLengthConstraint
            self.critical = critical
        }
    }
}

extension KernelX509.Extension.BasicConstraints: X509ExtensionBuildable {
    public func buildExtension() throws -> KernelX509.Extension {
        let asn1Type: KernelASN1.ASN1Type
        if let pathLengthConstraint {
            asn1Type = .sequence([
                .boolean(.init(value: isCertificateAuthority)),
                .integer(.init(int: .init(pathLengthConstraint)))
            ])
        } else {
            asn1Type = .sequence([.boolean(.init(value: isCertificateAuthority))])
        }
        let bytes = KernelASN1.ASN1Writer.dataFromObject(asn1Type)
        //        let octet: KernelASN1.ASN1Type = .octetString(.init(data: built))
        //        let bytes = KernelASN1.ASN1Writer2.dataFromObject(octet)
        return .init(extId: Self.extIdentifier, critical: critical, extValue: bytes)
    }
    
    public func buildExtensionData() throws -> KernelASN1.ASN1Type {
        if let pathLengthConstraint {
            .sequence([
                .boolean(.init(value: isCertificateAuthority)),
                .integer(.init(int: .init(pathLengthConstraint)))
            ])
        } else {
            .sequence([.boolean(.init(value: isCertificateAuthority))])
        }
    }
    
    //    public static var asn1DecodingSchema: DecodingSchema {[]}
}

extension KernelX509.Extension.BasicConstraints: X509ExtensionDecodable {
    public static var extIdentifier: KernelX509.Extension.ExtensionIdentifier { .basicConstraints }
    public init(from ext: KernelX509.Extension) throws {
        self.critical = ext.critical
        guard ext.extId == Self.extIdentifier else { throw Self.extensionDecodingFailed() }
        let parsed = try KernelASN1.ASN1Parser4.objectFromBytes(ext.extValue)
        guard case let .sequence(seqItems) = parsed.type else { throw Self.decodingError(.sequence, type: parsed) }
        switch seqItems.count {
        case 1:
            guard case let .boolean(asn1Boolean) = seqItems[0].type else { throw Self.decodingError(.boolean, type: seqItems[0]) }
            self.isCertificateAuthority = asn1Boolean.value
            self.pathLengthConstraint = nil
        case 2:
            guard case let .boolean(asn1Boolean) = seqItems[0].type else { throw Self.decodingError(.boolean, type: seqItems[0]) }
            guard case let .integer(asn1Integer) = seqItems[1].type else { throw Self.decodingError(.integer, type: seqItems[1]) }
            self.isCertificateAuthority = asn1Boolean.value
            self.pathLengthConstraint = asn1Integer.int.toInt()
        default: throw Self.decodingError(.sequence, type: parsed)
        }
    }
}
