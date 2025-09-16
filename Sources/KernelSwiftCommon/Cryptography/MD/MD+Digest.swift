//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 09/10/2023.
//

import Foundation
import Collections

extension KernelSwiftCommon.Cryptography.MD {
    public struct Digest {
        public let algorithm: KernelSwiftCommon.Cryptography.Algorithms.MessageDigestAlgorithm
        
//        var buffer: ByteBuffer
//        var storage: ByteBuffer
        @usableFromInline internal var customisationBuffer: [UInt8] = []
        @usableFromInline internal var buffer: [UInt8] = []
        @usableFromInline internal var _storage: [any UnsignedInteger] = []
        @usableFromInline internal var storageWords: [UInt32] = []
        @usableFromInline internal var storageDoubleWords: [UInt64] = []
        @usableFromInline internal var byteCount: Int = .zero
        @usableFromInline internal var totalBytes: Int = .zero
        
        public init(_ algorithm: KernelSwiftCommon.Cryptography.Algorithms.MessageDigestAlgorithm) {
            self.algorithm = algorithm
            reset()
        }
        
        @inlinable
        public mutating func reset() {
            buffer = .init(repeating: .zero, count: algorithm.blockSizeBytes)
            switch algorithm.digestStorageWidth {
            case .word: storageWords = .init(repeating: .zero, count: algorithm.digestStorageSize)
            case .doubleWord: storageDoubleWords = .init(repeating: .zero, count: algorithm.digestStorageSize)
            }
            switch algorithm {
            case .SHA1:     for (i, h) in DigestConstants.sha1_initial_hash_values.enumerated()     { storageWords[i] = h }
            case .SHA2_224: for (i, h) in DigestConstants.sha2_224_initial_hash_values.enumerated() { storageWords[i] = h }
            case .SHA2_256: for (i, h) in DigestConstants.sha2_256_initial_hash_values.enumerated() { storageWords[i] = h }
            case .SHA2_384: for (i, h) in DigestConstants.sha2_384_initial_hash_values.enumerated() { storageDoubleWords[i] = h }
            case .SHA2_512: for (i, h) in DigestConstants.sha2_512_initial_hash_values.enumerated() { storageDoubleWords[i] = h }
            default: break
            }
            customisationBuffer = .init(repeating: .zero, count: algorithm.digestCustomisationBytesCount)
            byteCount = .zero
            totalBytes = .zero
        }
        
        @inlinable
        public mutating func update(_ input: [UInt8]) {
            var rem = input.count
            var idx = Int.zero
            while rem > .zero {
                let len = min(rem, buffer.count - byteCount)
                for i in .zero ..< len { buffer[byteCount + i] = input[idx + i] }
                byteCount += len
                idx += len
                rem -= len
                if byteCount == buffer.count {
                    if algorithm.usesKeccak {
                        for i in .zero ..< buffer.count { customisationBuffer[i] ^= buffer[i] }
                    }
                    switch algorithm {
                    case .SHA1: updateBufferSHA1()
                    case .SHA2_224, .SHA2_256: updateBufferSHA2_224_256()
                    case .SHA2_384, .SHA2_512: updateBufferSHA2_384_512()
                    case .SHA3_224, .SHA3_256, .SHA3_384, .SHA3_512: updateBufferSHA3()
                    }
                    byteCount = .zero
                }
            }
            totalBytes += input.count
        }
        
        @inlinable
        public mutating func digest() -> [UInt8] {
            var d: [UInt8] = .init(repeating: .zero, count: algorithm.outputSizeBytes)
            padBuffer()
            switch algorithm {
            case .SHA3_224, .SHA3_256, .SHA3_384, .SHA3_512:
                var z: [UInt8] = []
                while true {
                    for i in .zero ..< buffer.count { z.append(customisationBuffer[i]) }
                    if z.count < algorithm.outputSizeBytes {
                        updateBufferSHA3()
                    } else {
                        for i in .zero ..< algorithm.outputSizeBytes { d[i] = z[i] }
                        break
                    }
                }
            case .SHA1, .SHA2_224, .SHA2_256:
                for i in .zero ..< algorithm.outputSizeBytes {
                    d[i] = .init((storageWords[i >> 2] >> ((3 - (i & 0x3)) * 8)) & 0xff)
                }
            case .SHA2_384, .SHA2_512:
                for i in .zero ..< algorithm.outputSizeBytes {
                    d[i] = .init((storageDoubleWords[i >> 3] >> ((7 - (i & 0x7)) * 8)) & 0xff)
                }
            }
            reset()
            return d
        }
        
        @inlinable
        mutating func padBuffer() {
            switch algorithm {
            case .SHA1: update(paddingSHA1())
            case .SHA2_224, .SHA2_256: update(paddingSHA2_224_256())
            case .SHA2_384, .SHA2_512: update(paddingSHA2_384_512())
            case .SHA3_224, .SHA3_256, .SHA3_384, .SHA3_512: update(paddingSHA3())
            }
        }
    }
}

extension KernelSwiftCommon.Cryptography.MD {
    public static func hash(_ algorithm: KernelSwiftCommon.Cryptography.Algorithms.MessageDigestAlgorithm, _ input: [UInt8]) -> [UInt8] {
        var digest: KernelSwiftCommon.Cryptography.MD.Digest = .init(algorithm)
        digest.update(input)
        return digest.digest()
    }
}

public protocol MDDeterministicHashable {
    func deterministicHash(using algorithm: KernelSwiftCommon.Cryptography.Algorithms.MessageDigestAlgorithm) -> Int
    func bytesToHash() -> [UInt8]
}

extension MDDeterministicHashable {
    public func deterministicHash(using algorithm: KernelSwiftCommon.Cryptography.Algorithms.MessageDigestAlgorithm = .SHA1) -> Int {
        let hashValue = KernelSwiftCommon.Cryptography.MD.hash(algorithm, bytesToHash()).reduce(0) { result, byte in
            result &+ Int(byte)
        }
        return hashValue
    }
}
