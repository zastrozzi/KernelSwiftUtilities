//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 15/06/2023.
//

extension KernelASN1 {
    public struct ASN1Boolean: ASN1Codable {
        public var underlyingData: [UInt8]?
        public var value: Bool
        
        public init(value: Bool) {
            self.value = value
        }
        
        public func isEqualTo<O>(_ other: O) -> Bool where O : ASN1Codable {
            guard let other = other as? Self else { return false }
            return self.value == other.value
        }
    }
    
}

extension Bool: ASN1Decodable {
    
    public init(from asn1Type: KernelASN1.ASN1Type) throws {
        guard case let .boolean(asn1Bool) = asn1Type else { throw Self.decodingError(.boolean, asn1Type) }
        self = asn1Bool.value
    }
}
