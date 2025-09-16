//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 25/10/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelCryptography.Cipher {
    public enum BlockMode: String, RawRepresentableAsString, Sendable {
        case CBC = "CBC"    // Cipher Block Chaining
        case CFB = "CFB"    // Cipher Feedback
        case CTR = "CTR"    // Counter
        case ECB = "ECB"    // Electronic Codebook
        case GCM = "GCM"    // Galois Counter
        case OFB = "OFB"    // Output Feedback
        
        public var macSize: Int { self == .GCM ? 16 : 32 }
    }
}

extension KernelCryptography.Cipher.BlockMode: FluentStringEnum, OpenAPIStringEnumSampleable {
    public static let fluentEnumName: String = "k_crypto-cipher_block_mode"
}
