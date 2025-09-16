//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 15/06/2023.
//

extension KernelASN1 {
    public struct ASN1Tagged: ASN1Codable {
        
        public var underlyingData: [UInt8]?
        public var tag: UInt8
        public var wrapped: ASN1Type
        
        public init(tag: UInt8, wrapped: ASN1Type) {
            self.tag = tag
            self.wrapped = wrapped
            //        self.underlyingData = underlyingData
        }
        
        public func isEqualTo<O>(_ other: O) -> Bool where O : ASN1Codable {
            guard let other = other as? Self else { return false }
            return (self.tag == other.tag && String(describing: self.wrapped) == String(describing: other.wrapped))
        }
    }
    
}
