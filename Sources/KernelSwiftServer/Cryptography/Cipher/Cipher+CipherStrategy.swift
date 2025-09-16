//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 31/10/2023.
//

import Foundation
import KernelSwiftCommon

public protocol _KernelCryptographyCipherStrategyRepresentable {
    static var blockMode: KernelCryptography.Cipher.BlockMode { get }
    init(aes: AES, macSecret: [UInt8], mode: KernelCryptography.Cipher.CipherMode)
    
    var aes: AES { get set }
    var macSecret: [UInt8] { get }
    var mode: KernelCryptography.Cipher.CipherMode { get set }
    
    @discardableResult mutating func decrypt(_ input: inout [UInt8]) throws -> [UInt8]
    @discardableResult mutating func encrypt(_ input: inout [UInt8]) throws -> [UInt8]
    mutating func normalise(_ input: inout [UInt8], _ remaining: Int)
    mutating func processBuffer(_ input: inout [UInt8], _ index: inout Int, _ remaining: inout Int) throws
}

extension KernelCryptography.Cipher {
    public typealias CipherStrategy = _KernelCryptographyCipherStrategyRepresentable
    @_documentation(visibility: private)
    public typealias AES = KernelCryptography.AES
    @_documentation(visibility: private)
    public typealias HMAC = KernelCryptography.HMAC
    @_documentation(visibility: private)
    public typealias MD = KernelCryptography.MD
}

extension KernelCryptography.Cipher.CipherStrategy {
    @_documentation(visibility: private)
    public typealias AES = KernelCryptography.AES
    @_documentation(visibility: private)
    public typealias HMAC = KernelCryptography.HMAC
    @_documentation(visibility: private)
    public typealias MD = KernelCryptography.MD
    
    internal init(_ secret: [UInt8], _ macSecret: [UInt8]) {
        let aes: AES = switch secret.count {
        case AES.val.keySize128: .init(key: secret, nr: 10)
        case AES.val.keySize192: .init(key: secret, nr: 12)
        default: .init(key: secret, nr: 14)
        }
        self.init(aes: aes, macSecret: macSecret, mode: .encryption)
    }
    
    @discardableResult
    public mutating func decrypt(_ input: inout [UInt8]) throws -> [UInt8] {
        mode = .decryption
        var hmac: HMAC = .init(.SHA2_256, macSecret)
        hmac.update(input)
        let tag = hmac.finalise()
        var rem = input.count, index: Int = .zero
        while rem >= .zero { try processBuffer(&input, &index, &rem) }
        normalise(&input, rem)
        return tag
    }
    
    @discardableResult
    public mutating func encrypt(_ input: inout [UInt8]) throws -> [UInt8] {
        mode = .encryption
        var rem = input.count, index: Int = .zero
        while rem >= .zero { try processBuffer(&input, &index, &rem) }
        var hmac: HMAC = .init(.SHA2_256, macSecret)
        hmac.update(input)
        return hmac.finalise()
    }
    
    public mutating func processBuffer(_ input: inout [UInt8], _ index: inout Int, _ remaining: inout Int) throws {
        throw KernelCryptography.TypedError(.implementationMissing)
    }
    
    public mutating func normalise(_ input: inout [UInt8], _ remaining: Int) {}
}

