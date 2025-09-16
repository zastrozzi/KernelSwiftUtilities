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
    public struct CacheStatusResponse: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public let statusReports: [KeySizeStatusReport]
        
        public init(
            statusReports: [KeySizeStatusReport]
        ) {
            self.statusReports = statusReports
        }
    }
}

extension KernelCryptography.RSA.CacheStatusResponse {
    public struct KeySizeStatusReport: Codable, Equatable, Content, OpenAPIEncodableSampleable, Sendable {
        public let keySize: KernelCryptography.RSA.KeySize
        public let cacheState: KernelCryptography.Common.CacheState
        public let keyGenStatus: KernelCryptography.Common.KeyGenStatus
        public let availableCount: Int
        public let targetCount: Int
        
        public init(
            keySize: KernelCryptography.RSA.KeySize,
            cacheState: KernelCryptography.Common.CacheState,
            keyGenStatus: KernelCryptography.Common.KeyGenStatus,
            availableCount: Int,
            targetCount: Int
        ) {
            self.keySize = keySize
            self.cacheState = cacheState
            self.keyGenStatus = keyGenStatus
            self.availableCount = availableCount
            self.targetCount = targetCount
        }
    }
}
//
//extension KernelCryptography.RSA.CacheStatusResponse {
//    public static var sample: KernelCryptography.RSA.CacheStatusResponse = .init(
//        statusReports: [.sample2048, .sample3072, .sample4096]
//    )
//}

extension KernelCryptography.RSA.CacheStatusResponse.KeySizeStatusReport {
    public static let sample2048: KernelCryptography.RSA.CacheStatusResponse.KeySizeStatusReport = .init(
        keySize: .b2048,
        cacheState: .active,
        keyGenStatus: .ready,
        availableCount: 100,
        targetCount: 100
    )
    
    public static let sample3072: KernelCryptography.RSA.CacheStatusResponse.KeySizeStatusReport = .init(
        keySize: .b3072,
        cacheState: .disabled,
        keyGenStatus: .ready,
        availableCount: 5,
        targetCount: 20
    )
    
    public static let sample4096: KernelCryptography.RSA.CacheStatusResponse.KeySizeStatusReport = .init(
        keySize: .b4096,
        cacheState: .active,
        keyGenStatus: .busy,
        availableCount: 35,
        targetCount: 50
    )
}
