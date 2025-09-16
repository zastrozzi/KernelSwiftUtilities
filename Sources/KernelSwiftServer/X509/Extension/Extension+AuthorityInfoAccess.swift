//
//  File.swift
//
//
//  Created by Jonathan Forbes on 09/07/2023.
//

extension KernelX509.Extension {
    public struct AuthorityInfoAccess: X509ExtensionTransformable {
        public static var extIdentifier: KernelX509.Extension.ExtensionIdentifier { .authorityInfoAccess }
        public var critical: Bool
        public let descriptions: [KernelX509.Common.AuthorityInfoAccessDescription]
        
        public init(
            critical: Bool,
            descriptions: [KernelX509.Common.AuthorityInfoAccessDescription]
        ) {
            self.descriptions = descriptions
            self.critical = critical
        }
    }
}

extension KernelX509.Extension.AuthorityInfoAccess: X509ExtensionBuildable {
    //    public func buildExtension() throws -> KernelX509.Extension {
    //        let sequence: KernelASN1.ASN1Type = .sequence(descriptions.map { $0.buildASN1Type() })
    //        let bytes = KernelASN1.ASN1Writer.dataFromObject(sequence)
    //        return .init(extId: .authorityInfoAccess, critical: critical, extValue: bytes)
    //    }
    
    public func buildExtensionData() throws -> KernelASN1.ASN1Type {
        .sequence(descriptions.map { $0.buildASN1Type() })
    }
    
    //    public static var asn1DecodingSchema: DecodingSchema {[]}
}

extension KernelX509.Extension.AuthorityInfoAccess: X509ExtensionDecodable {
    public init(from ext: KernelX509.Extension) throws {
        self.critical = ext.critical
        guard ext.extId == Self.extIdentifier else { throw Self.extensionDecodingFailed() }
        //        print(ext.extValue.toHexString())
        let parsed = try KernelASN1.ASN1Parser4.objectFromBytes(ext.extValue)
        //        print("PARSED", parsed)
        guard case let .sequence(seq) = parsed.asn1() else { throw Self.extensionDecodingFailed() }
        self.descriptions = try seq.map { try .init(from: $0) }
    }
}
