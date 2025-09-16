//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 06/11/2023.
//

import Testing
import KernelSwiftServer
import KernelSwiftCommon

@Suite
public struct ChaChaTests {
    
    @Test
    func testRFC8439_1() throws {
        let set = ChaChaTestAssets.rfc8439_1
        var t = set.input
        let aead = try KernelCryptography.ChaCha.ChaChaPoly(set.key, set.nonce)
        let tag = aead.encrypt(&t, set.aad)
        #expect(t == set.cipher)
        #expect(aead.decrypt(&t, tag))
        #expect(t == set.input)
    }
    
    @Test
    func testRFC8439_2() throws {
        let set = ChaChaTestAssets.rfc8439_2
        var t = set.input
        let aead = try KernelCryptography.ChaCha.ChaChaPoly(set.key, set.nonce)
        let tag = aead.encrypt(&t, set.aad)
        #expect(t == set.cipher)
        #expect(tag == set.tag)
        #expect(aead.decrypt(&t, tag, set.aad))
        #expect(t == set.input)
    }
    
    @Test
    func testCryptoSwift_1() throws {
        let set = ChaChaTestAssets.cryptoSwift1
        var t = set.input
        let aead = try KernelCryptography.ChaCha.ChaChaPoly(set.key, set.nonce)
        let tag = aead.encrypt(&t, set.aad)
        #expect(t == set.cipher)
        #expect(tag == set.tag)
        #expect(aead.decrypt(&t, tag, set.aad))
        #expect(t == set.input)
    }
    
    @Test
    func testCryptoSwift_2() throws {
        let set = ChaChaTestAssets.cryptoSwift2
        var t = set.input
        let aead = try KernelCryptography.ChaCha.ChaChaPoly(set.key, set.nonce)
        let tag = aead.encrypt(&t, set.aad)
        #expect(t == set.cipher)
        #expect(tag == set.tag)
        #expect(aead.decrypt(&t, tag, set.aad))
        #expect(t == set.input)
    }
    
    @Test
    func testCryptoSwift_3() throws {
        let key: [UInt8] = .fill(32, with: 17)
        let nonce: [UInt8] = .fill(12, with: 5)
        for i in .zero..<70 {
            let text: [UInt8] = .fill(i, with: 10)
            var x = text
            let chacha = try KernelCryptography.ChaCha.ChaChaPoly(key, nonce)
            let tag = chacha.encrypt(&x)
            let ok = chacha.decrypt(&x, tag)
            #expect(ok)
            #expect(x == text)
        }
    }
}
