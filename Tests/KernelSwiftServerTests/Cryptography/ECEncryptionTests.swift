//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 03/11/2023.
//

import Testing
import KernelSwiftServer
import KernelSwiftCommon

@Suite
public struct ECEncryptionTests {
    @Test(arguments: [EncryptedECSets.aes128p256v1, EncryptedECSets.aes192p256v1, EncryptedECSets.aes256p256v1])
    public func executeTestECEncryptedSet(set: EncryptedECSets.EncryptedECSet) throws {
        let asn1 = try KernelASN1.ASN1Parser4.objectFromPEM(pemString: set.pem)!
        let passwordBytes: [UInt8] = .init(set.password.utf8)
        let privateKey: KernelCryptography.EC.PrivateKey = try .init(pkcs8Encrypted: asn1.asn1(), password: passwordBytes)
        #expect(privateKey.s == set.s)
        #expect(set.domain.oid == privateKey.domain.oid)
    }
    
    @Test(arguments: KernelNumerics.EC.Curve.knownCurveOIDs)
    public func executeTestECEncryptionGCM(curve oid: KernelSwiftCommon.ObjectID) async throws {
        try await executeTestECEncryption(curve: oid, strategy: KernelCryptography.Cipher.GCM.self)
    }
    
    @Test(arguments: KernelNumerics.EC.Curve.knownCurveOIDs)
    public func executeTestECEncryptionECB(curve oid: KernelSwiftCommon.ObjectID) async throws {
        try await executeTestECEncryption(curve: oid, strategy: KernelCryptography.Cipher.ECB.self)
    }
    
    @Test(arguments: KernelNumerics.EC.Curve.knownCurveOIDs)
    public func executeTestECEncryptionCBC(curve oid: KernelSwiftCommon.ObjectID) async throws {
        try await executeTestECEncryption(curve: oid, strategy: KernelCryptography.Cipher.CBC.self)
    }
    
    @Test(arguments: KernelNumerics.EC.Curve.knownCurveOIDs)
    public func executeTestECEncryptionCFB(curve oid: KernelSwiftCommon.ObjectID) async throws {
        try await executeTestECEncryption(curve: oid, strategy: KernelCryptography.Cipher.CFB.self)
    }
    
    @Test(arguments: KernelNumerics.EC.Curve.knownCurveOIDs)
    public func executeTestECEncryptionOFB(curve oid: KernelSwiftCommon.ObjectID) async throws {
        try await executeTestECEncryption(curve: oid, strategy: KernelCryptography.Cipher.OFB.self)
    }
    
    @Test(arguments: KernelNumerics.EC.Curve.knownCurveOIDs)
    public func executeTestECEncryptionCTR(curve oid: KernelSwiftCommon.ObjectID) async throws {
        try await executeTestECEncryption(curve: oid, strategy: KernelCryptography.Cipher.CTR.self)
    }
    
    private func executeTestECEncryption(curve oid: KernelSwiftCommon.ObjectID, strategy: KernelCryptography.Cipher.CipherStrategy.Type) async throws {
        let message: [UInt8] = .init("The quick brown fox jumps over the lazy dog".utf8)
        let ecSet: KernelCryptography.EC.Components = try await .init(oid: oid)
        let pubKey = ecSet.publicKey(.pkcs8)
        let privKey = ecSet.privateKey(.pkcs8)
//        print("MESSAGE \(strategy.self.blockMode.rawValue)", oid.rawValue)
//        print(String(utf8EncodedBytes: message))
//        print(message.toHexString())
//        print("")
        let encrypted = try pubKey.encrypt(input: message, keySize: .b128, as: strategy.self.self)
//        print("ENCRYPT \(strategy.self.blockMode.rawValue)", oid.rawValue)
//        print(encrypted.toHexString())
//        print("")
        let decrypted = try privKey.decrypt(input: encrypted, keySize: .b128, as: strategy.self.self)
//        print("DECRYPT \(strategy.self.blockMode.rawValue)", oid.rawValue)
//        print(String(utf8EncodedBytes: decrypted))
//        print(decrypted.toHexString())
//        print("")
        #expect(message == decrypted)
    }
    
    @Test(
        arguments:
            KernelNumerics.EC.Curve.knownCurveOIDs
    )
    public func executeTestECEncryptionChaChaPoly(curve oid: KernelSwiftCommon.ObjectID) async throws {
        let message: [UInt8] = .init("The quick brown fox jumps over the lazy dog".utf8)
        let ecSet: KernelCryptography.EC.Components = try await .init(oid: oid)
        let pubKey = ecSet.publicKey(.pkcs8)
        let privKey = ecSet.privateKey(.pkcs8)
//        print("MESSAGE CHACHA", oid.rawValue)
//        print(String(utf8EncodedBytes: message))
//        print(message.toHexString())
//        print("")
        let encrypted = try pubKey.encryptChaCha(input: message)
//        print("ENCRYPT CHACHA", oid.rawValue)
//        print(encrypted.toHexString())
//        print("")
        let decrypted = try privKey.decryptChaCha(input: encrypted)
//        print("DECRYPT CHACHA", oid.rawValue)
//        print(String(utf8EncodedBytes: decrypted))
//        print(decrypted.toHexString())
//        print("")
        #expect(message == decrypted)
    }
    
    @Test(
        arguments:
            KernelNumerics.EC.Curve.knownCurveOIDs
    )
    public func executeTestECEncryptionChaChaPolyLarge(curve oid: KernelSwiftCommon.ObjectID) async throws {
        let message: [UInt8] = .zeroes(10000)
        let ecSet: KernelCryptography.EC.Components = try await .init(oid: oid)
        let pubKey = ecSet.publicKey(.pkcs8)
        let privKey = ecSet.privateKey(.pkcs8)
//        print("TESTING CHACHA", oid.rawValue)
        let encrypted = try pubKey.encryptChaCha(input: message)
//        print("ENCRYPTED CHACHA", oid.rawValue)
        let decrypted = try privKey.decryptChaCha(input: encrypted)
//        print("DECRYPTED CHACHA", oid.rawValue)
        #expect(message == decrypted)
    }
    
    @Test(
        arguments:
            KernelNumerics.EC.Curve.knownCurveOIDs
    )
    public func executeTestECEncryptionLarge(curve oid: KernelSwiftCommon.ObjectID) async throws {
        let strategy = KernelCryptography.Cipher.GCM.self
        let message: [UInt8] = .zeroes(10000)
        let ecSet: KernelCryptography.EC.Components = try await .init(oid: oid)
        let pubKey = ecSet.publicKey(.pkcs8)
        let privKey = ecSet.privateKey(.pkcs8)
//        print("MESSAGE \(strategy.self.blockMode.rawValue)", oid.rawValue)
        let encrypted = try pubKey.encrypt(input: message, keySize: .b256, as: strategy.self.self)
//        print("ENCRYPT \(strategy.self.blockMode.rawValue)", oid.rawValue)
        let decrypted = try privKey.decrypt(input: encrypted, keySize: .b256, as: strategy.self.self)
//        print("DECRYPT \(strategy.self.blockMode.rawValue)", oid.rawValue)
        #expect(message == decrypted)
    }
//    
//    public func testECEncryptionChaCha() async throws {
//        try await KernelNumerics.EC.Curve.knownCurveOIDs.concurrentForEach { curve in
//            try await self.executeTestECEncryptionChaChaPoly(curve: curve)
//        }
//    }
//    
//    public func testECEncryptionChaChaLarge() async throws {
//        try await KernelNumerics.EC.Curve.knownCurveOIDs.concurrentForEach { curve in
//            try await self.executeTestECEncryptionChaChaPolyLarge(curve: curve)
//        }
//    }
//    
//    public func testECEncryptionGCM() async throws {
//        try await KernelNumerics.EC.Curve.knownCurveOIDs.concurrentForEach { curve in
//            try await self.executeTestECEncryption(curve: curve, strategy: KernelCryptography.Cipher.GCM.self)
//        }
//    }
//    
//    public func testECEncryptionGCMLarge() async throws {
//        try await KernelNumerics.EC.Curve.knownCurveOIDs.concurrentForEach { curve in
//            try await self.executeTestECEncryptionLarge(curve: curve, strategy: KernelCryptography.Cipher.GCM.self)
//        }
//    }
//    
//    public func testECEncryptionECB() async throws {
//        try await KernelNumerics.EC.Curve.knownCurveOIDs.concurrentForEach { curve in
//            try await self.executeTestECEncryption(curve: curve, strategy: KernelCryptography.Cipher.ECB.self)
//        }
//    }
//    
//    public func testECEncryptionCBC() async throws {
//        try await KernelNumerics.EC.Curve.knownCurveOIDs.concurrentForEach { curve in
//            try await self.executeTestECEncryption(curve: curve, strategy: KernelCryptography.Cipher.CBC.self)
//        }
//    }
//    
//    public func testECEncryptionCFB() async throws {
//        try await KernelNumerics.EC.Curve.knownCurveOIDs.concurrentForEach { curve in
//            try await self.executeTestECEncryption(curve: curve, strategy: KernelCryptography.Cipher.CFB.self)
//        }
//    }
//    
//    public func testECEncryptionOFB() async throws {
//        try await KernelNumerics.EC.Curve.knownCurveOIDs.concurrentForEach { curve in
//            try await self.executeTestECEncryption(curve: curve, strategy: KernelCryptography.Cipher.OFB.self)
//        }
//    }
//    
//    public func testECEncryptionCTR() async throws {
//        try await KernelNumerics.EC.Curve.knownCurveOIDs.concurrentForEach { curve in
//            try await self.executeTestECEncryption(curve: curve, strategy: KernelCryptography.Cipher.CTR.self)
//        }
//    }
}
