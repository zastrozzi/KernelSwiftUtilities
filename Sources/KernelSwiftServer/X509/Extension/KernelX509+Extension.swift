//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 21/06/2023.
//
import Vapor
import KernelSwiftCommon

extension KernelX509 {
    public struct Extension: ASN1Decodable, Sendable {
        public var extId: ExtensionIdentifier
        public var critical: Bool
        public var extValue: [UInt8]
//        public var isComposite: Bool = false
        
        public init(
            extId: ExtensionIdentifier,
            critical: Bool,
            extValue: [UInt8]
        ) {
            self.extId = extId
            self.critical = critical
            self.extValue = extValue
//            self.isComposite = isComposite
        }
        
    }
}

extension KernelX509.Extension {
    public init(from asn1Type: KernelASN1.ASN1Type) throws {
        guard case let .sequence(sequenceItems) = asn1Type, sequenceItems.count >= 2 else { throw Self.decodingError(.sequence, asn1Type) }
        let hasCritical = sequenceItems.count == 3
        self.extId = try .init(from: sequenceItems[0])
        if hasCritical {
            guard
                case let .boolean(asn1Boolean) = sequenceItems[1],
                case let .octetString(asn1OctetString) = sequenceItems[2]
            else { throw Self.decodingError(nil, asn1Type) }
            self.critical = asn1Boolean.value
            self.extValue = asn1OctetString.value
        } else {
            guard
                case let .octetString(asn1OctetString) = sequenceItems[1]
            else { throw Self.decodingError(nil, asn1Type) }
            self.critical = false
            self.extValue = asn1OctetString.value
        }
    }
}

extension KernelX509.Extension {
    public struct Critical<WrappedExtension: X509ExtensionBuildable>: X509ExtensionBuildable {
        public var critical: Bool = true
        public static var extIdentifier: KernelX509.Extension.ExtensionIdentifier { WrappedExtension.extIdentifier }
        
        public func buildExtensionData() throws -> KernelASN1.ASN1Type {
            var mutatingWrapped = wrapped
            mutatingWrapped.critical = true
            return try mutatingWrapped.buildExtensionData()
        }
        
        public let wrapped: WrappedExtension

        public init(
            for wrappedExtension: WrappedExtension
        ) {
            self.wrapped = wrappedExtension
            self.critical = true
        }
        
        public func buildNonSerialisedExtension() throws -> KernelASN1.ASN1Type {
            .sequence([
                Self.extIdentifier.buildASN1Type(),
                .boolean(.init(value: true)),
                try buildExtensionData()
            ])
        }
        
        public func buildExtension() throws -> KernelX509.Extension {
            let serialised = KernelASN1.ASN1Writer.dataFromObject(try buildExtensionData())
            return .init(extId: Self.extIdentifier, critical: true, extValue: serialised)
        }
        
//        public func buildExtension() throws -> KernelX509.Extension {
//            var ext = try wrapped.buildExtension()
//            ext.critical = true
//            return ext
//        }
    }
}

extension KernelX509.Extension: ASN1Buildable {
    public func buildASN1Type() -> KernelASN1.ASN1Type {
        if critical {
            return .sequence([
                extId.buildASN1Type(),
                .boolean(.init(value: critical)),
                .octetString(.init(data: extValue))
            ])
        } else {
            return .sequence([
                extId.buildASN1Type(),
                .octetString(.init(data: extValue))
            ])
        }
    }
    
//    public func buildASN1CompositeType() -> [KernelASN1.ASN1Type] {
//        if critical {
//            return [
//                .sequence([
//                    extId.buildASN1Type(),
//                    .boolean(.init(value: critical))
//                ]),
//                .octetString(.init(data: extValue))
//            ]
//        } else {
//            return [
//                .sequence([
//                    extId.buildASN1Type()
//                ]),
//                .octetString(.init(data: extValue))
//            ]
//        }
//    }
}

extension UInt8: ASN1SequenceDecodable {}
