//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 31/10/2023.
//

import Testing
import KernelSwiftServer
import KernelSwiftCommon

@Suite
public struct GCMCipherTests {
    @Test
    func test1() throws {
        var gcm = KernelCryptography.Cipher.GCM(secret: CipherTestAssets.K1, macSecret: CipherTestAssets.IV1)
        var x = CipherTestAssets.P1
        let tag = try gcm.encrypt(&x)
        #expect(x == CipherTestAssets.C1)
        #expect(tag == CipherTestAssets.T1)
    }
    
    @Test
    func test2() throws {
        var gcm = KernelCryptography.Cipher.GCM(secret: CipherTestAssets.K2, macSecret: CipherTestAssets.IV2)
        var x = CipherTestAssets.P2
        let tag = try gcm.encrypt(&x)
        #expect(x == CipherTestAssets.C2)
        #expect(tag == CipherTestAssets.T2)
    }
    
    @Test
    func test3() throws {
        var gcm = KernelCryptography.Cipher.GCM(secret: CipherTestAssets.K3, macSecret: CipherTestAssets.IV3)
        var x = CipherTestAssets.P3
        let tag = try gcm.encrypt(&x)
        #expect(x == CipherTestAssets.C3)
        #expect(tag == CipherTestAssets.T3)
    }
    
    @Test
    func test7() throws {
        var gcm = KernelCryptography.Cipher.GCM(secret: CipherTestAssets.K7, macSecret: CipherTestAssets.IV7)
        var x = CipherTestAssets.P7
        let tag = try gcm.encrypt(&x)
        #expect(x == CipherTestAssets.C7)
        #expect(tag == CipherTestAssets.T7)
    }
    
    @Test
    func test8() throws {
        var gcm = KernelCryptography.Cipher.GCM(secret: CipherTestAssets.K8, macSecret: CipherTestAssets.IV8)
        var x = CipherTestAssets.P8
        let tag = try gcm.encrypt(&x)
        #expect(x == CipherTestAssets.C8)
        #expect(tag == CipherTestAssets.T8)
    }
    
    @Test
    func test9() throws {
        var gcm = KernelCryptography.Cipher.GCM(secret: CipherTestAssets.K9, macSecret: CipherTestAssets.IV9)
        var x = CipherTestAssets.P9
        let tag = try gcm.encrypt(&x)
        #expect(x == CipherTestAssets.C9)
        #expect(tag == CipherTestAssets.T9)
    }
    
    @Test
    func test13() throws {
        var gcm = KernelCryptography.Cipher.GCM(secret: CipherTestAssets.K13, macSecret: CipherTestAssets.IV13)
        var x = CipherTestAssets.P13
        let tag = try gcm.encrypt(&x)
        #expect(x == CipherTestAssets.C13)
        #expect(tag == CipherTestAssets.T13)
    }
    
    @Test
    func test14() throws {
        var gcm = KernelCryptography.Cipher.GCM(secret: CipherTestAssets.K14, macSecret: CipherTestAssets.IV14)
        var x = CipherTestAssets.P14
        let tag = try gcm.encrypt(&x)
        #expect(x == CipherTestAssets.C14)
        #expect(tag == CipherTestAssets.T14)
    }
    
    @Test
    func test15() throws {
        var gcm = KernelCryptography.Cipher.GCM(secret: CipherTestAssets.K15, macSecret: CipherTestAssets.IV15)
        var x = CipherTestAssets.P15
        let tag = try gcm.encrypt(&x)
        #expect(x == CipherTestAssets.C15)
        #expect(tag == CipherTestAssets.T15)
    }
}
