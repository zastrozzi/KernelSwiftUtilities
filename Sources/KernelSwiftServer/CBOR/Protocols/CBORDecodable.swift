//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 26/09/2023.
//

import Foundation
import KernelSwiftCommon

public protocol _KernelCBORDecodable: Decodable {
    init(from cborType: KernelCBOR.CBORType) throws
}

extension KernelCBOR {
    public typealias CBORDecodable = _KernelCBORDecodable
}

extension Optional: KernelCBOR.CBORDecodable where Wrapped: KernelCBOR.CBORDecodable {}

extension KernelCBOR.CBORDecodable {
    public init(from cborType: KernelCBOR.CBORType) throws {
        let decoder = KernelCBOR.CBORDecoder(cborType: cborType, decoding: Self.self)
        try self.init(from: decoder)
    }
    
    public static func decodingError(_ expected: KernelCBOR.CBORRawType? = nil, _ received: KernelCBOR.CBORType? = nil) -> KernelCBOR.TypedError {
        .decodingFailed(Self.self, expected: expected, received: received)
    }
}
