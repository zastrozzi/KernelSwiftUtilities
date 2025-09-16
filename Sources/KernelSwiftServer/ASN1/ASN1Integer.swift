//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 15/06/2023.
//
import KernelSwiftCommon

extension KernelASN1 {
    public struct ASN1Integer: ASN1Codable {
        public var underlyingData: [UInt8]?
        public var data: [UInt8]
        public var int: KernelNumerics.BigInt
        
        public init(data: [UInt8]) {
            self.data = data
            self.int = .init(signedBytes: data)
        }
        
        public init(int: KernelNumerics.BigInt) {
            self.int = int
            var arr: [UInt8] = []
            var foundNonNil: Bool = false
            for byte in int.signedBytes() {
                if foundNonNil { arr.append(byte) }
                else if byte != 0x00 && foundNonNil == false {
                    arr.append(byte)
                    foundNonNil = true
                }
            }
            if arr.isEmpty { arr.append(0x00) }
            if arr[.zero] >= 0x80 { arr.prepend(.zero) }
            self.data = arr
        }
        
        public init(data: [UInt8], exactLength: Int) {
            var modulus = data
            if modulus.count < exactLength { modulus.prepend(.zeroes(exactLength - modulus.count)) }
            if modulus[.zero] >= 0x80 { modulus.prepend(.zero) }
            self.init(data: modulus)
        }
        
        public func isEqualTo<O>(_ other: O) -> Bool where O : ASN1Codable {
            guard let other = other as? Self else { return false }
            return self.int == other.int
        }
    }
    
}
