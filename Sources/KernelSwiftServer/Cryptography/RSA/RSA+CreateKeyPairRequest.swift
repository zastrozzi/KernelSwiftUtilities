//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 30/10/2023.
//

import Foundation
import Vapor
import KernelSwiftCommon

extension KernelCryptography.RSA {
    public struct CreateKeyPairRequest: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public let keySize: KeySize
        public init(
            keySize: KeySize
        ) {
            self.keySize = keySize
        }
    }
}
