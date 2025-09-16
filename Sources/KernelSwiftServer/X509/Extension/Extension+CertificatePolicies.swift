//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 09/07/2023.
//

extension KernelX509.Extension {
    public struct CertificatePolicies: X509ExtensionTransformable {
        public var critical: Bool
        internal var policies: [KernelX509.Policy.Information]
        
        public init(critical: Bool = false, policies: KernelX509.Policy.Information...) {
            self.init(critical: critical, policies: policies)
        }
        
        init(critical: Bool = false, policies: [KernelX509.Policy.Information]) {
            self.critical = critical
            self.policies = .init(policies)
        }
        
    }
}

extension KernelX509.Extension.CertificatePolicies: X509ExtensionDecodable {
    public static var extIdentifier: KernelX509.Extension.ExtensionIdentifier { .certificatePolicies }
    public init(from ext: KernelX509.Extension) throws {
        guard ext.extId == Self.extIdentifier else { throw Self.extensionDecodingFailed() }
        let parsed = try KernelASN1.ASN1Parser2.objectFromBytes(ext.extValue)
        guard case let .sequence(sequenceItems) = parsed else { throw Self.extensionDecodingFailed() }
        self.critical = ext.critical
        self.policies = .init(try sequenceItems.map { try .init(from: $0) })
    }
}

extension KernelX509.Extension.CertificatePolicies: X509ExtensionBuildable {
    public func buildExtension() throws -> KernelX509.Extension {
        let sequence: KernelASN1.ASN1Type = .sequence(policies.map { $0.buildASN1Type() })
        let serialised = KernelASN1.ASN1Writer.dataFromObject(sequence)
        return .init(extId: .certificatePolicies, critical: critical, extValue: serialised)
    }
    
    public func buildExtensionData() throws -> KernelASN1.ASN1Type {
        .sequence(policies.map { $0.buildASN1Type() })
    }
    
    //    public static var asn1DecodingSchema: DecodingSchema {[]}
}

