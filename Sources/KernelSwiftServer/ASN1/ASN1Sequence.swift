//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 15/06/2023.
//

extension KernelASN1 {
    public struct ASN1Sequence: ASN1Codable {
        public var underlyingData: [UInt8]?
        public var objects: [ASN1Type]
        
        public init(objects: [ASN1Type]) {
            self.objects = objects
        }
        
        public func isEqualTo<O>(_ other: O) -> Bool where O : ASN1Codable {
            guard let other = other as? Self else { return false }
            return self.objects.map { String(describing: $0) } == other.objects.map { String(describing: $0) }
        }
        
        public subscript(index: Int) -> ASN1Type? {
            guard self.objects.count >= index else { return nil }
            let object = self.objects[index]
            if case .null = object { return nil }
            return object
        }
    }
}
