//
//  File.swift
//
//
//  Created by Jonathan Forbes on 18/09/2023.
//

import Foundation

extension UInt64 {
    public typealias cbor = CBOR
    
    public enum CBOR {
        public static let tag: @Sendable (KernelCBOR.CBORTag) -> KernelCBOR.CBORTag.RawValue = { $0.rawValue }
    }
}
