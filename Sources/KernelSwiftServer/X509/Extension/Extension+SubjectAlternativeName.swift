//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 22/09/2023.
//

import Foundation

extension KernelX509.Extension {
    public struct SubjectAlternativeName: X509ExtensionTransformable {
        public static var extIdentifier: KernelX509.Extension.ExtensionIdentifier { .subjectAlternativeName }
        public var critical: Bool
        public var names: [KernelX509.Common.GeneralName]
        
        
        public init(critical: Bool = false, names: [KernelX509.Common.GeneralName]) {
            self.critical = critical
            self.names = names
        }
        
        public init(critical: Bool = false, names: KernelX509.Common.GeneralName...) {
            self.init(critical: critical, names: names)
        }
    }
}

extension KernelX509.Extension.SubjectAlternativeName: X509ExtensionDecodable {
    public init(from ext: KernelX509.Extension) throws {
        guard ext.extId == Self.extIdentifier else { throw Self.extensionDecodingFailed() }
        let parsed = try KernelASN1.ASN1Parser4.objectFromBytes(ext.extValue)
        guard case let .sequence(sequenceItems) = parsed.asn1() else { throw Self.extensionDecodingFailed() }
        self.critical = ext.critical
        self.names = .init(try sequenceItems.map { try .init(from: $0) })
    }
}

extension KernelX509.Extension.SubjectAlternativeName: X509ExtensionBuildable {
    public func buildExtension() throws -> KernelX509.Extension {
        let sequence: KernelASN1.ASN1Type = .sequence(names.map { $0.buildASN1Type() })
        let serialised = KernelASN1.ASN1Writer.dataFromObject(sequence)
        return .init(extId: .subjectAlternativeName, critical: critical, extValue: serialised)
    }
    
    public func buildExtensionData() throws -> KernelASN1.ASN1Type {
        .sequence(names.map { $0.buildASN1Type() })
    }
}
