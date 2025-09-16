//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 11/02/2025.
//

import Foundation

public protocol UUIDHashable {
    func bytesToHash() -> [UInt8]
    func uuidHash(using algorithm: KernelSwiftCommon.Cryptography.Algorithms.MessageDigestAlgorithm) -> UUID
}

extension UUIDHashable {
    public func uuidHash(using algorithm: KernelSwiftCommon.Cryptography.Algorithms.MessageDigestAlgorithm = .SHA2_256) -> UUID {
        let hashValue = KernelSwiftCommon.Cryptography.MD.hash(algorithm, bytesToHash())
        let hashBytes: [UInt8] = .init(hashValue.prefix(16))
        var uuidBytes = UUID.zeroBytes
        UUID.setBytes(hashBytes, to: &uuidBytes)
        
        return UUID(uuid: uuidBytes)
    }
}

extension UUID {
    public static func uuidHash(
        bytes: [UInt8],
        using algorithm: KernelSwiftCommon.Cryptography.Algorithms.MessageDigestAlgorithm = .SHA2_256
    ) -> UUID {
        let hashValue = KernelSwiftCommon.Cryptography.MD.hash(algorithm, bytes)
        let hashBytes: [UInt8] = .init(hashValue.prefix(16))
        var uuidBytes = UUID.zeroBytes
        UUID.setBytes(hashBytes, to: &uuidBytes)
        
        return UUID(uuid: uuidBytes)
    }
}
