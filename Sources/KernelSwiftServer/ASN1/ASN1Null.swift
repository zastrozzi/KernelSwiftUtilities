//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 15/06/2023.
//

extension KernelASN1 {
    public struct ASN1Null: ASN1Codable {
        public var underlyingData: [UInt8]?
        
        public init() {
        }
        
        public func isEqualTo<O>(_ other: O) -> Bool where O : ASN1Codable {
            return other is Self
        }
    }
}
