//
//  File.swift
//
//
//  Created by Jonathan Forbes on 09/07/2023.
//

import KernelSwiftCommon

extension KernelX509.Certificate {
    public struct SerialNumber: ASN1Decodable, ASN1Buildable {
        public var rawValue: KernelNumerics.BigInt
        
        public init(rawValue: KernelNumerics.BigInt) {
            self.rawValue = rawValue
        }
        
        public init(from decoder: Decoder) throws {
            fatalError()
        }
        
        public init(from asn1Type: KernelASN1.ASN1Type) throws {
            guard case let .integer(asn1Integer) = asn1Type else { throw Self.decodingError(.integer, asn1Type) }
            self.rawValue = asn1Integer.int
        }
        
        public func buildASN1Type() -> KernelASN1.ASN1Type {
            return .integer(.init(int: rawValue))
        }
    }
}
