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
    public struct CacheSettings: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public var keyType: KernelNumerics.EC.Curve
        public var state: KernelCryptography.Common.CacheState
        public var count: Int
        
        public init(
            keyType: KernelNumerics.EC.Curve,
            state: KernelCryptography.Common.CacheState,
            count: Int
        ) {
            self.keyType = keyType
            self.state = state
            self.count = count
        }
    }
}

extension KernelCryptography.EC.CacheSettings {
    public static var sample192: KernelCryptography.EC.CacheSettings {
        .init(keyType: .oid(.x962Prime192v1), state: .active, count: 100)
    }
    
    public static var sample239: KernelCryptography.EC.CacheSettings {
        .init(keyType: .oid(.x962Prime239v1), state: .active, count: 300)
    }
    
    public static var sample256: KernelCryptography.EC.CacheSettings {
        .init(keyType: .oid(.x962Prime256v1), state: .active, count: 500)
    }
}
