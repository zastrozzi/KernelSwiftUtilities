//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 05/10/2023.
//

import Foundation
import Vapor
import KernelSwiftCommon

extension KernelCryptography.RSA {
    public struct ConfigureCacheRequest: Codable, Equatable, Content, OpenAPIEncodableSampleable, Sendable {
        public var cacheSettings: [CacheSettings]
        
        public init(
            cacheSettings: [CacheSettings]
        ) {
            self.cacheSettings = cacheSettings
        }
    }
}

extension KernelCryptography.RSA.ConfigureCacheRequest {
    public static let sample: KernelCryptography.RSA.ConfigureCacheRequest =
        .init(cacheSettings: [.sample256, .sample512, .sample1024, .sample2048, .sample4096])
}
