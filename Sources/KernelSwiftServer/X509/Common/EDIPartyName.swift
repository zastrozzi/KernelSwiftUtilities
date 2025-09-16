//
//  File.swift
//
//
//  Created by Jonathan Forbes on 10/07/2023.
//

extension KernelX509.Common {
    public struct EDIPartyName: ASN1Decodable, ASN1Buildable {
        public var nameAssigner: KernelASN1.ASN1DirectoryString?
        public var partyName: KernelASN1.ASN1DirectoryString
        
        public init(
            nameAssigner: KernelASN1.ASN1DirectoryString? = nil,
            partyName: KernelASN1.ASN1DirectoryString
        ) {
            self.nameAssigner = nameAssigner
            self.partyName = partyName
        }
        
        public init(from asn1Type: KernelASN1.ASN1Type) throws {
            if case let .any(asn1) = asn1Type {
                //            print(asn1.underlyingData?.toHexString() ?? "", "UNDERLYING")
                var bytes = asn1.underlyingData ?? [0]
                bytes[0] = .asn1.typeTag.sequence
//                let parsed = try KernelASN1.ASN1Parser4.objectFromBytes(bytes)
//                KernelASN1.ASN1Printer.printObjectVerbose(parsed)
                guard case let .sequence(sequenceItems) = asn1Type else { throw Self.decodingError(.sequence, asn1Type) }
                switch sequenceItems.count {
                case 1:
                    self.nameAssigner = nil
                    let pName: KernelASN1.ASN1DirectoryString = try .init(from: sequenceItems[0])
                    self.partyName = pName
                case 2:
                    self.nameAssigner = try .init(from: sequenceItems[0])
                    let pName: KernelASN1.ASN1DirectoryString = try .init(from: sequenceItems[1])
                    self.partyName = pName
                default: throw Self.decodingError(.sequence, asn1Type)
                }
                return
            }
            guard case let .sequence(sequenceItems) = asn1Type else { throw Self.decodingError(.sequence, asn1Type) }
            switch sequenceItems.count {
            case 1:
                self.nameAssigner = nil
                let pName: KernelASN1.ASN1DirectoryString = try .init(from: sequenceItems[0])
                self.partyName = pName
            case 2:
                self.nameAssigner = try .init(from: sequenceItems[0])
                let pName: KernelASN1.ASN1DirectoryString = try .init(from: sequenceItems[1])
                self.partyName = pName
            default: throw Self.decodingError(.sequence, asn1Type)
            }
        }
        
        public func buildASN1Type() -> KernelASN1.ASN1Type {
            if let nameAssigner {
                .sequence([
                    nameAssigner.buildASN1Type(),
                    partyName.buildASN1Type()
                ])
            } else {
                .sequence([
                    partyName.buildASN1Type()
                ])
            }
        }
    }
}
