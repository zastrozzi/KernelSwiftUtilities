//
//  File.swift
//
//
//  Created by Jonathan Forbes on 13/07/2023.
//

extension KernelX509.Extension {
    public struct NameConstraints: X509ExtensionTransformable {
        public static var extIdentifier: KernelX509.Extension.ExtensionIdentifier { .nameConstraints }
        public var critical: Bool
        public var permitted: [KernelX509.Common.GeneralSubtree]?
        public var excluded: [KernelX509.Common.GeneralSubtree]?
        
        public init(
            critical: Bool = false,
            permitted: [KernelX509.Common.GeneralSubtree]? = nil,
            excluded: [KernelX509.Common.GeneralSubtree]? = nil
        ) {
            self.critical = critical
            self.permitted = permitted
            self.excluded = excluded
        }
        
    }
}

extension KernelX509.Extension.NameConstraints: X509ExtensionDecodable {
    
    public init(from ext: KernelX509.Extension) throws {
        guard ext.extId == Self.extIdentifier else { throw Self.extensionDecodingFailed() }
        let parsed = try KernelASN1.ASN1Parser4.objectFromBytes(ext.extValue)
        parsed.printVerbose(fullLength: true, decodedOctets: true, decodedBits: true)
        guard case let .sequence(sequenceItems) = parsed.type else { throw Self.decodingError(.timeOfDay, type: parsed) }
        self.critical = ext.critical
        switch sequenceItems.count {
        case 0:
            self.permitted = nil
            self.excluded = nil
        case 1:
            guard case let .tagged(tag, .constructed(tag0Items)) = sequenceItems[0].asn1() else { throw Self.extensionDecodingFailed() }
            let subtree: [KernelX509.Common.GeneralSubtree] = try tag0Items.map { try .init(from: $0) }
            switch tag {
            case 0:
                self.permitted = subtree
                self.excluded = nil
            case 1:
                self.permitted = nil
                self.excluded = subtree
            default: throw Self.extensionDecodingFailed()
            }
        case 2:
            guard case let .tagged(0, .constructed(sequenceItems0)) = sequenceItems[0].asn1() else { throw Self.extensionDecodingFailed() }
            guard case let .tagged(1, .constructed(sequenceItems1)) = sequenceItems[1].asn1() else { throw Self.extensionDecodingFailed() }
            
            let subtree0: [KernelX509.Common.GeneralSubtree] = try sequenceItems0.map { try .init(from: $0) }
            let subtree1: [KernelX509.Common.GeneralSubtree] = try sequenceItems1.map { try .init(from: $0) }
            self.permitted = subtree0
            self.excluded = subtree1
        default: throw Self.extensionDecodingFailed()
        }
    }
}

extension KernelX509.Extension.NameConstraints: X509ExtensionBuildable {
    
    public func buildExtensionData() throws -> KernelASN1.ASN1Type {
        if let permitted, let excluded {
            .sequence([
                .tagged(0, .constructed(permitted.map { $0.buildASN1Type() })),
                .tagged(1, .constructed(excluded.map { $0.buildASN1Type() }))
            ])
        } else if let permitted {
            .sequence([
                .tagged(0, .constructed(permitted.map { $0.buildASN1Type() }))
            ])
        } else if let excluded {
            .sequence([
                .tagged(1, .constructed(excluded.map { $0.buildASN1Type() }))
            ])
        } else {
            .sequence([])
        }
    }
    
    //    public static var asn1DecodingSchema: DecodingSchema {[]}
}
