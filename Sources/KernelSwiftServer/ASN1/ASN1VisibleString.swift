//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 11/07/2023.
//

extension KernelASN1 {
    public struct ASN1VisibleString: ASN1Codable, ASN1StringRepresentable {
        public var underlyingData: [UInt8]?
        public var string: String
        
        public init(string: String) {
            self.string = string
        }
        
        public func isEqualTo<O>(_ other: O) -> Bool where O : ASN1Codable {
            guard let other = other as? Self else { return false }
            return self.string == other.string
        }
    }
}

extension KernelASN1.ASN1VisibleString: ASN1Decodable, ASN1Buildable {
    public init(from asn1Type: KernelASN1.ASN1Type) throws {
        if case let .any(asn1) = asn1Type {
            let bytes = asn1.anyData
            self.string = .init(utf8EncodedBytes: bytes)
            return
        }
        guard case let .visibleString(asn1) = asn1Type else { throw Self.decodingError(.visibleString, asn1Type) }
        self = asn1
    }
    
    public func buildASN1Type() -> KernelASN1.ASN1Type { .visibleString(self) }
}
