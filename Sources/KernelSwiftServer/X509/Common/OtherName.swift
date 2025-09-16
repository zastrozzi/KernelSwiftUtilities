//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 10/07/2023.
//
import KernelSwiftCommon

extension KernelX509.Common {
    public struct OtherName: ASN1Decodable, ASN1Buildable {
        public var typeID: KernelSwiftCommon.ObjectID
        public var value: KernelASN1.ASN1Type
        
        public init(
            typeID: KernelSwiftCommon.ObjectID,
            value: KernelASN1.ASN1Type
        ) {
            self.typeID = typeID
            self.value = value
        }
        
        public init(from asn1Type: KernelASN1.ASN1Type) throws {
            if case let .any(asn1) = asn1Type {
                var bytes = asn1.underlyingData ?? [0]
                bytes[0] = .asn1.typeTag.sequence
                let parsed = try KernelASN1.ASN1Parser4.objectFromBytes(bytes)
//                KernelASN1.ASN1Printer.printObjectVerbose(parsed)
                guard
                    case let .sequence(sequenceItems) = parsed.asn1(),
                    sequenceItems.count == 2,
                    case let .objectIdentifier(asn1ObjectIdentifier) = sequenceItems[0],
                    let oid = asn1ObjectIdentifier.oid,
                    case let .tagged(0, .explicit(taggedASN1Type)) = sequenceItems[1]
                else { throw Self.decodingError(.sequence, asn1Type) }
                self.typeID = oid
                self.value = taggedASN1Type
                return
            }
            guard
                case let .sequence(sequenceItems) = asn1Type,
                sequenceItems.count == 2,
                case let .objectIdentifier(asn1ObjectIdentifier) = sequenceItems[0],
                let oid = asn1ObjectIdentifier.oid,
                case let .tagged(0, .explicit(taggedASN1Type)) = sequenceItems[1]
            else { throw Self.decodingError(.sequence, asn1Type) }
            self.typeID = oid
            self.value = taggedASN1Type
        }
//        
        public func buildASN1Type() -> KernelASN1.ASN1Type {
            .sequence([
                .objectIdentifier(.init(oid: typeID)),
                .tagged(0, .explicit(value))
            ])
        }
    }
}
