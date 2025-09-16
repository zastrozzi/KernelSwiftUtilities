//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 09/04/2025.
//

import struct Storage.CustomerEncryption
import KernelSwiftCommon

extension KernelGoogleCloud.Core.Common {
    public struct CustomerEncryption: OpenAPIContent {
        public var encryptionAlgorithm: String?
        public var keySha256: String?
        
        public init(
            encryptionAlgorithm: String? = nil,
            keySha256: String? = nil
        ) {
            self.encryptionAlgorithm = encryptionAlgorithm
            self.keySha256 = keySha256
        }
    }
}

extension Storage.CustomerEncryption {
    public func toKernelGoogleCloud() -> KernelGoogleCloud.Core.Common.CustomerEncryption {
        .init(
            encryptionAlgorithm: encryptionAlgorithm,
            keySha256: keySha256
        )
    }
}
