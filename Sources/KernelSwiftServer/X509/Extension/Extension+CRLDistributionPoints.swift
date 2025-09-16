//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 10/07/2023.
//

extension KernelX509.Extension {
    public struct CRLDistributionPoints: X509ExtensionTransformable {
        public var critical: Bool
        internal var distributionPoints: [KernelX509.CRL.DistributionPoint]
        
        public init(critical: Bool = false, distributionPoints: KernelX509.CRL.DistributionPoint...) {
            self.init(critical: critical, distributionPoints: distributionPoints)
        }
        
        init(critical: Bool = false, distributionPoints: [KernelX509.CRL.DistributionPoint]) {
            self.critical = critical
            self.distributionPoints = distributionPoints
        }
        
    }
}

extension KernelX509.Extension.CRLDistributionPoints: X509ExtensionDecodable {
    public static var extIdentifier: KernelX509.Extension.ExtensionIdentifier { .crlDistributionPoints }
    public init(from ext: KernelX509.Extension) throws {
        guard ext.extId == Self.extIdentifier else { throw Self.extensionDecodingFailed() }
        let parsed = try KernelASN1.ASN1Parser4.objectFromBytes(ext.extValue)
        guard case let .sequence(sequenceItems) = parsed.asn1() else { throw Self.extensionDecodingFailed() }
        self.critical = ext.critical
        self.distributionPoints = .init(try sequenceItems.map { try .init(from: $0) })
    }
}

extension KernelX509.Extension.CRLDistributionPoints: X509ExtensionBuildable {
    public func buildExtension() throws -> KernelX509.Extension {
        let sequence: KernelASN1.ASN1Type = .sequence(distributionPoints.map { $0.buildASN1Type() })
        let serialised = KernelASN1.ASN1Writer.dataFromObject(sequence)
        return .init(extId: .crlDistributionPoints, critical: critical, extValue: serialised)
    }
    
    public func buildExtensionData() throws -> KernelASN1.ASN1Type {
        .sequence(distributionPoints.map { $0.buildASN1Type() })
    }
    
    //    public static var asn1DecodingSchema: DecodingSchema {[]}
}

