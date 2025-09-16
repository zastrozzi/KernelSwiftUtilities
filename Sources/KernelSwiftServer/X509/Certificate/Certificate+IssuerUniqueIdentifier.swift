//
//  File.swift
//
//
//  Created by Jonathan Forbes on 15/09/2023.
//
extension KernelX509.Certificate {
    public struct IssuerUniqueIdentifier: ASN1Decodable, ASN1Buildable {
        public var rawData: [UInt8]
        
        public init(rawData: [UInt8]) {
            self.rawData = rawData
        }
        
        public init(from decoder: Decoder) throws {
            fatalError()
        }
        
        public init(from asn1Type: KernelASN1.ASN1Type) throws {
            guard case let .tagged(1, .implicit(.bitString(bitString))) = asn1Type else { throw Self.decodingError(.tagged(1, .implicit(.bitString)), asn1Type) }
            self.rawData = bitString.value
            
        }
        
        public func buildASN1Type() -> KernelASN1.ASN1Type {
            .tagged(1, .implicit(.bitString(.init(unusedBits: 0, data: rawData))))
        }
    }
}
