//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 25/10/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelCryptography.AES {
    public enum KeySize: String, Codable, Equatable, CaseIterable, RawRepresentableAsString, Sendable, LosslessStringConvertible {
        case b128 = "b128"  // 128 bit
        case b192 = "b192"  // 192 bit
        case b256 = "b256"  // 256 bit
        
        public init?(_ description: String) {
            self.init(rawValue: description)
        }
        
        public var description: String {
            self.rawValue
        }
        
        public var intValue: Int {
            switch self {
            case .b128  : 128
            case .b192  : 192
            case .b256  : 256
            }
        }
        
        public init(_ intValue: Int, withTolerance t: Int = 0) throws {
            if t != .zero {
                switch intValue {
                case (128 - t)...(128 + t)  : self = .b128
                case (192 - t)...(192 + t)  : self = .b192
                case (256 - t)...(256 + t)  : self = .b256
                default: throw KernelCryptography.TypedError(.invalidKeyLength)
                }
            }
            else {
                switch intValue {
                case 128...128  : self = .b128
                case 192...192  : self = .b192
                case 256...256  : self = .b256
                default: throw KernelCryptography.TypedError(.invalidKeyLength)
                }
            }
        }
        
        public var byteWidth: Int { intValue / 8 }
        
        public var cbc_oid: KernelSwiftCommon.ObjectID {
            switch self {
            case .b128: .aes128_cbc
            case .b192: .aes192_cbc
            case .b256: .aes256_cbc
            }
        }
        
        public init(oid: KernelSwiftCommon.ObjectID) throws {
            switch oid {
            case .aes128_cbc: self = .b128
            case .aes192_cbc: self = .b192
            case .aes256_cbc: self = .b256
            default: throw KernelCryptography.TypedError(.decryptionFailed)
            }
        }
    }
}

extension KernelCryptography.AES.KeySize: FluentStringEnum, OpenAPIStringEnumSampleable {
    public static let fluentEnumName: String = "k_crypto-aes_key_size"
}
