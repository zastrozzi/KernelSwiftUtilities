//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 21/06/2023.
//

extension KernelX509.Extension {
    public struct ExtendedKeyUsage: X509ExtensionTransformable {
        public var critical: Bool
        public var usages: Set<KernelX509.Common.ExtendedKeyUsageIdentifier>
        
        public init(critical: Bool = false, usages: KernelX509.Common.ExtendedKeyUsageIdentifier...) {
            self.init(critical: critical, usages: usages)
        }
        
        init(critical: Bool = false, usages: [KernelX509.Common.ExtendedKeyUsageIdentifier]) {
            self.critical = critical
            self.usages = .init(usages)
        }
        
    }
}

extension KernelX509.Extension.ExtendedKeyUsage: X509ExtensionDecodable {
    public static var extIdentifier: KernelX509.Extension.ExtensionIdentifier { .extKeyUsage }
    public init(from ext: KernelX509.Extension) throws {
        guard ext.extId == Self.extIdentifier else { throw Self.extensionDecodingFailed() }
        let parsed = try KernelASN1.ASN1Parser2.objectFromBytes(ext.extValue)
        guard case let .sequence(sequenceItems) = parsed else { throw Self.extensionDecodingFailed() }
        self.critical = ext.critical
        self.usages = .init(try sequenceItems.map { try .init(from: $0) })
    }
}

extension KernelX509.Extension.ExtendedKeyUsage: X509ExtensionBuildable {
    public func buildExtension() throws -> KernelX509.Extension {
        let sequence: KernelASN1.ASN1Type = .sequence(usages.sorted().map { $0.buildASN1Type() })
        let serialised = KernelASN1.ASN1Writer.dataFromObject(sequence)
        return .init(extId: .extKeyUsage, critical: critical, extValue: serialised)
    }
    
    public func buildExtensionData() throws -> KernelASN1.ASN1Type {
        .sequence(usages.map { $0.buildASN1Type() })
    }
    
//    public static var asn1DecodingSchema: DecodingSchema {[]}
}

