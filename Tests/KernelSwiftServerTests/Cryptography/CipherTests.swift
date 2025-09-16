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
public struct CipherTests {
    
    @Test
    public func testECB() throws {
        var cipher128e = KernelCryptography.Cipher.ECB(secret: CipherTestAssets.key128, macSecret: [])
        var x = CipherTestAssets.input
        _ = try cipher128e.encrypt(&x)
        #expect(CipherTestAssets.ECB128Output[0 ..< CipherTestAssets.ECB128Output.count] == x[0 ..< CipherTestAssets.ECB128Output.count])
        var cipher128d = KernelCryptography.Cipher.ECB(secret: CipherTestAssets.key128, macSecret: [])
        _ = try cipher128d.decrypt(&x)
        #expect(CipherTestAssets.input == x)
        
        var cipher192e = KernelCryptography.Cipher.ECB(secret: CipherTestAssets.key192, macSecret: [])
        x = CipherTestAssets.input
        _ = try cipher192e.encrypt(&x)
        #expect(CipherTestAssets.ECB192Output[0 ..< CipherTestAssets.ECB192Output.count] == x[0 ..< CipherTestAssets.ECB192Output.count])
        var cipher192d = KernelCryptography.Cipher.ECB(secret: CipherTestAssets.key192, macSecret: [])
        _ = try cipher192d.decrypt(&x)
        #expect(CipherTestAssets.input == x)
        
        var cipher256e = KernelCryptography.Cipher.ECB(secret: CipherTestAssets.key256, macSecret: [])
        x = CipherTestAssets.input
        _ = try cipher256e.encrypt(&x)
        #expect(CipherTestAssets.ECB256Output[0 ..< CipherTestAssets.ECB256Output.count] == x[0 ..< CipherTestAssets.ECB256Output.count])
        var cipher256d = KernelCryptography.Cipher.ECB(secret: CipherTestAssets.key256, macSecret: [])
        _ = try cipher256d.decrypt(&x)
        #expect(CipherTestAssets.input == x)
    }
    
    @Test
    public func testCBC() throws {
        var cipher128e = KernelCryptography.Cipher.CBC(secret: CipherTestAssets.key128, macSecret: [], xor: CipherTestAssets.iv)
        var x = CipherTestAssets.input
        _ = try cipher128e.encrypt(&x)
        #expect(CipherTestAssets.CBC128Output[0 ..< CipherTestAssets.CBC128Output.count] == x[0 ..< CipherTestAssets.CBC128Output.count])
        var cipher128d = KernelCryptography.Cipher.CBC(secret: CipherTestAssets.key128, macSecret: [], xor: CipherTestAssets.iv)
        _ = try cipher128d.decrypt(&x)
        #expect(CipherTestAssets.input == x)
        
        var cipher192e = KernelCryptography.Cipher.CBC(secret: CipherTestAssets.key192, macSecret: [], xor: CipherTestAssets.iv)
        x = CipherTestAssets.input
        _ = try cipher192e.encrypt(&x)
        #expect(CipherTestAssets.CBC192Output[0 ..< CipherTestAssets.CBC192Output.count] == x[0 ..< CipherTestAssets.CBC192Output.count])
        var cipher192d = KernelCryptography.Cipher.CBC(secret: CipherTestAssets.key192, macSecret: [], xor: CipherTestAssets.iv)
        _ = try cipher192d.decrypt(&x)
        #expect(CipherTestAssets.input == x)
        
        var cipher256e = KernelCryptography.Cipher.CBC(secret: CipherTestAssets.key256, macSecret: [], xor: CipherTestAssets.iv)
        x = CipherTestAssets.input
        _ = try cipher256e.encrypt(&x)
        #expect(CipherTestAssets.CBC256Output[0 ..< CipherTestAssets.CBC256Output.count] == x[0 ..< CipherTestAssets.CBC256Output.count])
        var cipher256d = KernelCryptography.Cipher.CBC(secret: CipherTestAssets.key256, macSecret: [], xor: CipherTestAssets.iv)
        _ = try cipher256d.decrypt(&x)
        #expect(CipherTestAssets.input == x)
    }
    
    @Test
    public func testCFB() throws {
        var cipher128e = KernelCryptography.Cipher.CFB(secret: CipherTestAssets.key128, macSecret: [], xor: CipherTestAssets.iv)
        var x = CipherTestAssets.input
        _ = try cipher128e.encrypt(&x)
        #expect(CipherTestAssets.CFB128Output == x)
        var cipher128d = KernelCryptography.Cipher.CFB(secret: CipherTestAssets.key128, macSecret: [], xor: CipherTestAssets.iv)
        _ = try cipher128d.decrypt(&x)
        #expect(CipherTestAssets.input == x)

        var cipher192e = KernelCryptography.Cipher.CFB(secret: CipherTestAssets.key192, macSecret: [], xor: CipherTestAssets.iv)
        x = CipherTestAssets.input
        _ = try cipher192e.encrypt(&x)
        #expect(CipherTestAssets.CFB192Output == x)
        var cipher192d = KernelCryptography.Cipher.CFB(secret: CipherTestAssets.key192, macSecret: [], xor: CipherTestAssets.iv)
        _ = try cipher192d.decrypt(&x)
        #expect(CipherTestAssets.input == x)

        var cipher256e = KernelCryptography.Cipher.CFB(secret: CipherTestAssets.key256, macSecret: [], xor: CipherTestAssets.iv)
        x = CipherTestAssets.input
        _ = try cipher256e.encrypt(&x)
        #expect(CipherTestAssets.CFB256Output == x)
        var cipher256d = KernelCryptography.Cipher.CFB(secret: CipherTestAssets.key256, macSecret: [], xor: CipherTestAssets.iv)
        _ = try cipher256d.decrypt(&x)
        #expect(CipherTestAssets.input == x)
    }
    
    @Test
    public func testOFB() throws {
        var cipher128e = KernelCryptography.Cipher.OFB(secret: CipherTestAssets.key128, macSecret: [], xor: CipherTestAssets.iv)
        var x = CipherTestAssets.input
        _ = try cipher128e.encrypt(&x)
        #expect(CipherTestAssets.OFB128Output == x)
        var cipher128d = KernelCryptography.Cipher.OFB(secret: CipherTestAssets.key128, macSecret: [],  xor: CipherTestAssets.iv)
        _ = try cipher128d.decrypt(&x)
        #expect(CipherTestAssets.input == x)

        var cipher192e = KernelCryptography.Cipher.OFB(secret: CipherTestAssets.key192, macSecret: [],  xor: CipherTestAssets.iv)
        x = CipherTestAssets.input
        _ = try cipher192e.encrypt(&x)
        #expect(CipherTestAssets.OFB192Output == x)
        var cipher192d = KernelCryptography.Cipher.OFB(secret: CipherTestAssets.key192, macSecret: [],  xor: CipherTestAssets.iv)
        _ = try cipher192d.decrypt(&x)
        #expect(CipherTestAssets.input == x)

        var cipher256e = KernelCryptography.Cipher.OFB(secret: CipherTestAssets.key256, macSecret: [],  xor: CipherTestAssets.iv)
        x = CipherTestAssets.input
        _ = try cipher256e.encrypt(&x)
        #expect(CipherTestAssets.OFB256Output == x)
        var cipher256d = KernelCryptography.Cipher.OFB(secret: CipherTestAssets.key256, macSecret: [],  xor: CipherTestAssets.iv)
        _ = try cipher256d.decrypt(&x)
        #expect(CipherTestAssets.input == x)
    }
    
    @Test
    public func testCTR() throws {
        var cipher128e = KernelCryptography.Cipher.CTR(secret: CipherTestAssets.key128, macSecret: [],  xor: CipherTestAssets.ctr)
        var x = CipherTestAssets.input
        _ = try cipher128e.encrypt(&x)
        #expect(CipherTestAssets.CTR128Output == x)
        var cipher128d = KernelCryptography.Cipher.CTR(secret: CipherTestAssets.key128, macSecret: [],  xor: CipherTestAssets.ctr)
        _ = try cipher128d.decrypt(&x)
        #expect(CipherTestAssets.input == x)

        var cipher192e = KernelCryptography.Cipher.CTR(secret: CipherTestAssets.key192, macSecret: [],  xor: CipherTestAssets.ctr)
        x = CipherTestAssets.input
        _ = try cipher192e.encrypt(&x)
        #expect(CipherTestAssets.CTR192Output == x)
        var cipher192d = KernelCryptography.Cipher.CTR(secret: CipherTestAssets.key192, macSecret: [],  xor: CipherTestAssets.ctr)
        _ = try cipher192d.decrypt(&x)
        #expect(CipherTestAssets.input == x)

        var cipher256e = KernelCryptography.Cipher.CTR(secret: CipherTestAssets.key256, macSecret: [],  xor: CipherTestAssets.ctr)
        x = CipherTestAssets.input
        _ = try cipher256e.encrypt(&x)
        #expect(CipherTestAssets.CTR256Output == x)
        var cipher256d = KernelCryptography.Cipher.CTR(secret: CipherTestAssets.key256, macSecret: [],  xor: CipherTestAssets.ctr)
        _ = try cipher256d.decrypt(&x)
        #expect(CipherTestAssets.input == x)
    }
}
