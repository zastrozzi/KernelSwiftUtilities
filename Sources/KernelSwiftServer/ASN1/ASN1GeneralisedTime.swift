//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 15/06/2023.
//

extension KernelASN1 {
    public struct ASN1GeneralisedTime: ASN1Codable, ASN1TimeRepresentable {
        public var underlyingData: [UInt8]?
        public var string: String
        
        public static let format: String = "yyyyMMddHHmmss'Z'"
        
        public init(string: String) {
            self.string = string
        }
        
        public func isEqualTo<O>(_ other: O) -> Bool where O : ASN1Codable {
            guard let other = other as? Self else { return false }
            return self.string == other.string
        }
    }
}
