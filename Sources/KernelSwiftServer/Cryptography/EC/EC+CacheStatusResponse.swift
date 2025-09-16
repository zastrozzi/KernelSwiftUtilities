//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 30/10/2023.
//

import Foundation
import Vapor
import KernelSwiftCommon

extension KernelCryptography.EC {
    public struct CacheStatusResponse: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public let statusReports: [KeyTypeStatusReport]
        
        public init(
            statusReports: [KeyTypeStatusReport]
        ) {
            self.statusReports = statusReports
        }
    }
}

extension KernelCryptography.EC.CacheStatusResponse {
    public struct KeyTypeStatusReport: Codable, Equatable, Content, OpenAPIEncodableSampleable, Sendable {
        public let keyType: KernelNumerics.EC.Curve
        public let cacheState: KernelCryptography.Common.CacheState
        public let keyGenStatus: KernelCryptography.Common.KeyGenStatus
        public let availableCount: Int
        public let targetCount: Int
        
        public init(
            keyType: KernelNumerics.EC.Curve,
            cacheState: KernelCryptography.Common.CacheState,
            keyGenStatus: KernelCryptography.Common.KeyGenStatus,
            availableCount: Int,
            targetCount: Int
        ) {
            self.keyType = keyType
            self.cacheState = cacheState
            self.keyGenStatus = keyGenStatus
            self.availableCount = availableCount
            self.targetCount = targetCount
        }
    }
}
//
//extension KernelCryptography.EC.CacheStatusResponse {
//    public static var sample: KernelCryptography.EC.CacheStatusResponse = .init(
//        statusReports: [.sampleP192, .sampleP239, .sampleP256]
//    )
//}

extension KernelCryptography.EC.CacheStatusResponse.KeyTypeStatusReport {
    public static let sampleP192: KernelCryptography.EC.CacheStatusResponse.KeyTypeStatusReport = .init(
        keyType: .oid(.x962Prime192v1),
        cacheState: .active,
        keyGenStatus: .ready,
        availableCount: 100,
        targetCount: 100
    )
    
    public static let sampleP239: KernelCryptography.EC.CacheStatusResponse.KeyTypeStatusReport = .init(
        keyType: .oid(.x962Prime239v1),
        cacheState: .disabled,
        keyGenStatus: .ready,
        availableCount: 5,
        targetCount: 20
    )
    
    public static let sampleP256: KernelCryptography.EC.CacheStatusResponse.KeyTypeStatusReport = .init(
        keyType: .oid(.x962Prime256v1),
        cacheState: .active,
        keyGenStatus: .busy,
        availableCount: 550,
        targetCount: 1000
    )
}
