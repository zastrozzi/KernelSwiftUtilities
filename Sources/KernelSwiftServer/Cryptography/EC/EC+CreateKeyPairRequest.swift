//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/10/2023.
//

import Foundation
import Vapor
import KernelSwiftCommon

extension KernelCryptography.EC {
    public struct CreateKeyPairRequest: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public let keyType: KernelNumerics.EC.Curve
        public init(
            keyType: KernelNumerics.EC.Curve
        ) {
            self.keyType = keyType
        }
    }
}
