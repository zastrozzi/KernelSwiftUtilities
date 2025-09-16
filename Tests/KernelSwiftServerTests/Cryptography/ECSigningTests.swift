//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 24/11/2023.
//

import Testing
import KernelSwiftServer
import KernelSwiftCommon
import Foundation

@Suite
public struct ECSigningTests {
    
    @Test(arguments: KernelNumerics.EC.Curve.knownCurveOIDs)
    func executeSignatureTest(curve oid: KernelSwiftCommon.ObjectID) async throws {
        let rounds: Int = 2
//        let message2: [UInt8] = .init("The quick brown fox jumps over the lazy dog!".utf8)
//        let rawBytes1: [UInt8] = "The quick brown fox jumps over the lazy dog".utf8Bytes
//        let rawBytes2: [UInt8] = "The quick brown fox jumps over the lazy dog!".utf8Bytes

        var genTime: Double = 0
        var signTime: Double = 0
        var verifyTime: Double = 0
        
        for _ in 0..<rounds {
            let genStart = ProcessInfo.processInfo.systemUptime
            let ecSet: KernelCryptography.EC.Components = try .init(oidSync: oid)
            let pubKey = ecSet.publicKey(.pkcs8)
            let privKey = ecSet.privateKey(.pkcs8)
            let genEnd = ProcessInfo.processInfo.systemUptime
            genTime += (genEnd - genStart)
            let message1: [UInt8] = "The quick brown fox jumps over the lazy dog".utf8Bytes
            let sigStart = ProcessInfo.processInfo.systemUptime
            let sig1 = privKey.sign(message: message1, deterministic: false)
            let sigEnd = ProcessInfo.processInfo.systemUptime
            signTime += (sigEnd - sigStart)
            let verifyStart = ProcessInfo.processInfo.systemUptime
            let verified = pubKey.verify(signature: sig1, message: message1)
            #expect(verified)
            let verifyEnd = ProcessInfo.processInfo.systemUptime
            verifyTime += (verifyEnd - verifyStart)
        }
        print("TESTED", oid, "SIG: \(averageMsString(signTime, rounds))", "VERIFY: \(averageMsString(verifyTime, rounds))", "GEN: \(averageMsString(genTime, rounds))")
//        let sig2 = privKey.sign(message: rawBytes1)
        
//        XCTAssertFalse(pubKey.verify(signature: sig1, message: message2))
//        XCTAssertTrue(pubKey.verify(signature: sig2, message: rawBytes1))
//        XCTAssertFalse(pubKey.verify(signature: sig2, message: rawBytes2))
    }
}

func averageMsString(_ acc: Double, _ rounds: Int) -> String {
    (acc / .init(rounds) * 1000).formatted(.number.rounded(increment: 0.01)) + "ms"
}
