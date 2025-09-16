//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 28/09/2023.
//

import Foundation

extension String: KernelCBOR.CBORDecodable {
    public init(from cborType: KernelCBOR.CBORType) throws {
        guard case let .utf8String(utf8String) = cborType else { throw Self.decodingError(.utf8String, cborType) }
        self = utf8String
    }
}
