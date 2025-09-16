//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/11/2023.
//

import Foundation
import KernelSwiftCommon
import Vapor

extension KernelCryptography.RSA {
    public struct EncryptPrivateKeyRequest: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public var aes: KernelCryptography.AES.KeySize
        public var password: String
        
        public init(
            aes: KernelCryptography.AES.KeySize,
            password: String
        ) {
            self.aes = aes
            self.password = password
        }
        
        public init(
            aes: KernelCryptography.AES.KeySize,
            password: [UInt8]
        ) {
            self.aes = aes
            self.password = password.toHexString()
        }
        
        public var passwordBytes: [UInt8] { .init(password.utf8) }
    }
}



extension KernelCryptography.RSA.EncryptPrivateKeyRequest {
    public static var sample: KernelCryptography.RSA.EncryptPrivateKeyRequest {
        .init(aes: .b256, password: "010203")
    }
}
