//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 21/10/2023.
//

import Foundation
import Vapor
import KernelSwiftCommon

extension KernelCryptography.RSA {
    public struct CacheSettings: Codable, Equatable, Content, OpenAPIEncodableSampleable, Sendable {
        public var keySize: KeySize
        public var state: KernelCryptography.Common.CacheState
        public var count: Int
        
        public init(
            keySize: KeySize,
            state: KernelCryptography.Common.CacheState,
            count: Int
        ) {
            self.keySize = keySize
            self.state = state
            self.count = count
        }
    }
}

extension KernelCryptography.RSA.CacheSettings {
    public static var sample256     : Self { .init(keySize: .b256,  state: .active, count: 10) }
    public static var sample512     : Self { .init(keySize: .b512,  state: .active, count: 10) }
    public static var sample1024    : Self { .init(keySize: .b1024, state: .active, count: 10) }
    public static var sample2048    : Self { .init(keySize: .b2048, state: .active, count: 10) }
    public static var sample4096    : Self { .init(keySize: .b4096, state: .active, count: 10) }
}
