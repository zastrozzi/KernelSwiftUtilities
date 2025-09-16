//
//  File.swift
//
//
//  Created by Jonathan Forbes on 18/09/2023.
//

import Foundation

public protocol _KernelCBOREncodable {
    func encodeCBOR(options: KernelCBOR.CBORCodingOptions) -> [UInt8]
    func cborType(options: KernelCBOR.CBORCodingOptions) -> KernelCBOR.CBORType
}

extension KernelCBOR {
    public typealias CBOREncodable = _KernelCBOREncodable
}

extension KernelCBOR.CBOREncodable {
    public func encodeCBOR(options: KernelCBOR.CBORCodingOptions) -> [UInt8] {
        self.cborType(options: options).encodeCBOR(options: options)
    }
}

extension KernelCBOR.CBORType: KernelCBOR.CBOREncodable {
    public func encodeCBOR(options: KernelCBOR.CBORCodingOptions) -> [UInt8] {
        switch self {
        default: return []
        }
    }
    
    public func cborType(options: KernelCBOR.CBORCodingOptions) -> KernelCBOR.CBORType { return self }
}
