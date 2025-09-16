//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 15/06/2023.
//

extension KernelASN1 {
    public struct ASN1OctetString: ASN1Codable {
        public var underlyingData: [UInt8]?
        public var value: [UInt8]
        
        public init(data: [UInt8]) {
            self.value = data
        }
        
        public func isEqualTo<O>(_ other: O) -> Bool where O : ASN1Codable {
            guard let other = other as? Self else { return false }
            return self.value == other.value
        }
    }
}

extension KernelASN1.ASN1OctetString: ASN1Decodable, ASN1Buildable {
    public init(from asn1Type: KernelASN1.ASN1Type) throws {
        if case let .any(asn1) = asn1Type {
            //            print(asn1.underlyingData?.toHexString() ?? "", "UNDERLYING")
//            let bytes = asn1.anyData
            self.value = asn1.anyData
            return
        }
        guard case let .octetString(asn1) = asn1Type else { throw Self.decodingError(.octetString, asn1Type) }
        self = asn1
    }
    
    public func buildASN1Type() -> KernelASN1.ASN1Type { .octetString(self) }
}
