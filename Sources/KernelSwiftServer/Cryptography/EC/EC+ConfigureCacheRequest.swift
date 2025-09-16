//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/10/2023.
//

import Foundation
import KernelSwiftCommon
import Vapor

extension KernelCryptography.EC {
    public struct ConfigureCacheRequest: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public var cacheSettings: [CacheSettings]
        
        public init(
            cacheSettings: [CacheSettings]
        ) {
            self.cacheSettings = cacheSettings
        }
    }
}

extension KernelCryptography.EC.ConfigureCacheRequest {
    public static var sample: KernelCryptography.EC.ConfigureCacheRequest {
        .init(cacheSettings: [.sample192, .sample239, .sample256])
    }
}
