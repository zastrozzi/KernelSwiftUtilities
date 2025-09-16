//
//  File.swift
//
//
//  Created by Jonathan Forbes on 13/07/2023.
//
import KernelSwiftCommon

extension KernelX509.Common {
    public struct GeneralSubtree: ASN1Decodable, ASN1Buildable {
        public var base: KernelX509.Common.GeneralName
        public var minimum: KernelNumerics.BigInt?
        public var maximum: KernelNumerics.BigInt?
        
        
        public init(
            base: KernelX509.Common.GeneralName,
            minimum: KernelNumerics.BigInt? = nil,
            maximum: KernelNumerics.BigInt? = nil
        ) {
            self.base = base
            self.minimum = minimum
            self.maximum = maximum
        }
        
        public init(from decoder: Decoder) throws {
            fatalError()
        }
        
        public init(from asn1Type: KernelASN1.ASN1Type) throws {
            guard case let .sequence(sequenceItems) = asn1Type else { throw Self.decodingError(.sequence, asn1Type) }
            self.base = try .init(from: sequenceItems[0])
            switch sequenceItems.count {
            case 1:
                self.maximum = nil
                self.minimum = nil
            case 2:
                guard case let .tagged(tag, .implicit(.integer(integer))) = sequenceItems[1] else { throw Self.decodingError(.tagged(0, .implicit(.integer)), sequenceItems[1]) }
                switch tag {
                case 0:
                    let val: KernelNumerics.BigInt = integer.int
                    self.minimum = val
                    self.maximum = nil
                case 1:
                    let val: KernelNumerics.BigInt = integer.int
                    self.maximum = val
                    self.minimum = nil
                default: throw Self.decodingError(.tagged(0, .implicit(.integer)), sequenceItems[1])
                }
            case 3:
                guard case let .tagged(0, .implicit(.integer(integer))) = sequenceItems[1] else { throw Self.decodingError(.tagged(0, .implicit(.integer)), sequenceItems[1]) }
                guard case let .tagged(1, .implicit(.integer(integer2))) = sequenceItems[2] else { throw Self.decodingError(.tagged(0, .implicit(.integer)), sequenceItems[2]) }
                let val0: KernelNumerics.BigInt = integer.int
                let val1: KernelNumerics.BigInt = integer2.int
                self.minimum = val0
                self.maximum = val1
            default: throw Self.decodingError(.sequence, asn1Type)
            }
        }
        
        public func buildASN1Type() -> KernelASN1.ASN1Type {
            if let minimum, let maximum {
                .sequence([
                    base.buildASN1Type(),
                    .tagged(0x00, .implicit(.integer(.init(int: minimum)))),
                    .tagged(0x01, .implicit(.integer(.init(int: maximum))))
                ])
            } else if let minimum {
                .sequence([
                    base.buildASN1Type(),
                    .tagged(0x00, .implicit(.integer(.init(int: minimum))))
                ])
            } else if let maximum {
                .sequence([
                    base.buildASN1Type(),
                    .tagged(0x01, .implicit(.integer(.init(int: maximum))))
                ])
            } else {
                .sequence([
                    base.buildASN1Type()
                ])
            }
        }
    }
}
