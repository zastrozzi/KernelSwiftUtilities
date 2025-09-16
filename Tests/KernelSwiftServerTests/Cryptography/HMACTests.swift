//
//  File.swift
//
//
//  Created by Jonathan Forbes on 10/10/2023.
//

import Testing
import KernelSwiftServer

@Suite
public struct HMACTests {
    static let testRounds: Int = 10
    
    @Test
    func test224() {
        var hmac = KernelCryptography.HMAC(.SHA2_224)
        for _ in .zero ..< Self.testRounds {
            hmac.initialise(HMACTestAssets.key1)
            #expect(HMACTestAssets.hmac1_224 == hmac.finalise(HMACTestAssets.data1))
            hmac.initialise(HMACTestAssets.key2)
            #expect(HMACTestAssets.hmac2_224 == hmac.finalise(HMACTestAssets.data2))
            hmac.initialise(HMACTestAssets.key3)
            #expect(HMACTestAssets.hmac3_224 == hmac.finalise(HMACTestAssets.data3))
            hmac.initialise(HMACTestAssets.key4)
            #expect(HMACTestAssets.hmac4_224 == hmac.finalise(HMACTestAssets.data4))
            hmac.initialise(HMACTestAssets.key5)
            #expect(HMACTestAssets.hmac5_224 == [UInt8](hmac.finalise(HMACTestAssets.data5)[0 ..< 16]))
            hmac.initialise(HMACTestAssets.key6)
            #expect(HMACTestAssets.hmac6_224 == hmac.finalise(HMACTestAssets.data6))
            hmac.initialise(HMACTestAssets.key7)
            #expect(HMACTestAssets.hmac7_224 == hmac.finalise(HMACTestAssets.data7))
        }
    }
    
    @Test
    func test256() {
        var hmac = KernelCryptography.HMAC(.SHA2_256)
        for _ in .zero ..< Self.testRounds {
            hmac.initialise(HMACTestAssets.key1)
            #expect(HMACTestAssets.hmac1_256 == hmac.finalise(HMACTestAssets.data1))
            hmac.initialise(HMACTestAssets.key2)
            #expect(HMACTestAssets.hmac2_256 == hmac.finalise(HMACTestAssets.data2))
            hmac.initialise(HMACTestAssets.key3)
            #expect(HMACTestAssets.hmac3_256 == hmac.finalise(HMACTestAssets.data3))
            hmac.initialise(HMACTestAssets.key4)
            #expect(HMACTestAssets.hmac4_256 == hmac.finalise(HMACTestAssets.data4))
            hmac.initialise(HMACTestAssets.key5)
            #expect(HMACTestAssets.hmac5_256 == [UInt8](hmac.finalise(HMACTestAssets.data5)[0 ..< 16]))
            hmac.initialise(HMACTestAssets.key6)
            #expect(HMACTestAssets.hmac6_256 == hmac.finalise(HMACTestAssets.data6))
            hmac.initialise(HMACTestAssets.key7)
            #expect(HMACTestAssets.hmac7_256 == hmac.finalise(HMACTestAssets.data7))
        }
    }
    
    @Test
    func test384() {
        var hmac = KernelCryptography.HMAC(.SHA2_384)
        for _ in .zero ..< Self.testRounds {
            hmac.initialise(HMACTestAssets.key1)
            #expect(HMACTestAssets.hmac1_384 == hmac.finalise(HMACTestAssets.data1))
            hmac.initialise(HMACTestAssets.key2)
            #expect(HMACTestAssets.hmac2_384 == hmac.finalise(HMACTestAssets.data2))
            hmac.initialise(HMACTestAssets.key3)
            #expect(HMACTestAssets.hmac3_384 == hmac.finalise(HMACTestAssets.data3))
            hmac.initialise(HMACTestAssets.key4)
            #expect(HMACTestAssets.hmac4_384 == hmac.finalise(HMACTestAssets.data4))
            hmac.initialise(HMACTestAssets.key5)
            #expect(HMACTestAssets.hmac5_384 == [UInt8](hmac.finalise(HMACTestAssets.data5)[0 ..< 16]))
            hmac.initialise(HMACTestAssets.key6)
            #expect(HMACTestAssets.hmac6_384 == hmac.finalise(HMACTestAssets.data6))
            hmac.initialise(HMACTestAssets.key7)
            #expect(HMACTestAssets.hmac7_384 == hmac.finalise(HMACTestAssets.data7))
        }
    }
    
    @Test
    func test512() {
        var hmac = KernelCryptography.HMAC(.SHA2_512)
        for _ in .zero ..< Self.testRounds {
            hmac.initialise(HMACTestAssets.key1)
            #expect(HMACTestAssets.hmac1_512 == hmac.finalise(HMACTestAssets.data1))
            hmac.initialise(HMACTestAssets.key2)
            #expect(HMACTestAssets.hmac2_512 == hmac.finalise(HMACTestAssets.data2))
            hmac.initialise(HMACTestAssets.key3)
            #expect(HMACTestAssets.hmac3_512 == hmac.finalise(HMACTestAssets.data3))
            hmac.initialise(HMACTestAssets.key4)
            #expect(HMACTestAssets.hmac4_512 == hmac.finalise(HMACTestAssets.data4))
            hmac.initialise(HMACTestAssets.key5)
            #expect(HMACTestAssets.hmac5_512 == [UInt8](hmac.finalise(HMACTestAssets.data5)[0 ..< 16]))
            hmac.initialise(HMACTestAssets.key6)
            #expect(HMACTestAssets.hmac6_512 == hmac.finalise(HMACTestAssets.data6))
            hmac.initialise(HMACTestAssets.key7)
            #expect(HMACTestAssets.hmac7_512 == hmac.finalise(HMACTestAssets.data7))
        }
    }
    
    @Test
    func test224Static() {
        for _ in .zero ..< Self.testRounds {
            #expect(HMACTestAssets.hmac1_224 == KernelCryptography.HMAC.hash(.SHA2_224, HMACTestAssets.key1, HMACTestAssets.data1))
            #expect(HMACTestAssets.hmac2_224 == KernelCryptography.HMAC.hash(.SHA2_224, HMACTestAssets.key2, HMACTestAssets.data2))
            #expect(HMACTestAssets.hmac3_224 == KernelCryptography.HMAC.hash(.SHA2_224, HMACTestAssets.key3, HMACTestAssets.data3))
            #expect(HMACTestAssets.hmac4_224 == KernelCryptography.HMAC.hash(.SHA2_224, HMACTestAssets.key4, HMACTestAssets.data4))
            #expect(HMACTestAssets.hmac5_224 == [UInt8](KernelCryptography.HMAC.hash(.SHA2_224, HMACTestAssets.key5, HMACTestAssets.data5)[0 ..< 16]))
            #expect(HMACTestAssets.hmac6_224 == KernelCryptography.HMAC.hash(.SHA2_224, HMACTestAssets.key6, HMACTestAssets.data6))
            #expect(HMACTestAssets.hmac7_224 == KernelCryptography.HMAC.hash(.SHA2_224, HMACTestAssets.key7, HMACTestAssets.data7))
        }
    }
    
    @Test
    func test256Static() {
        for _ in .zero ..< Self.testRounds {
            #expect(HMACTestAssets.hmac1_256 == KernelCryptography.HMAC.hash(.SHA2_256, HMACTestAssets.key1, HMACTestAssets.data1))
            #expect(HMACTestAssets.hmac2_256 == KernelCryptography.HMAC.hash(.SHA2_256, HMACTestAssets.key2, HMACTestAssets.data2))
            #expect(HMACTestAssets.hmac3_256 == KernelCryptography.HMAC.hash(.SHA2_256, HMACTestAssets.key3, HMACTestAssets.data3))
            #expect(HMACTestAssets.hmac4_256 == KernelCryptography.HMAC.hash(.SHA2_256, HMACTestAssets.key4, HMACTestAssets.data4))
            #expect(HMACTestAssets.hmac5_256 == [UInt8](KernelCryptography.HMAC.hash(.SHA2_256, HMACTestAssets.key5, HMACTestAssets.data5)[0 ..< 16]))
            #expect(HMACTestAssets.hmac6_256 == KernelCryptography.HMAC.hash(.SHA2_256, HMACTestAssets.key6, HMACTestAssets.data6))
            #expect(HMACTestAssets.hmac7_256 == KernelCryptography.HMAC.hash(.SHA2_256, HMACTestAssets.key7, HMACTestAssets.data7))
        }
    }
    
    @Test
    func test384Static() {
        for _ in .zero ..< Self.testRounds {
            #expect(HMACTestAssets.hmac1_384 == KernelCryptography.HMAC.hash(.SHA2_384, HMACTestAssets.key1, HMACTestAssets.data1))
            #expect(HMACTestAssets.hmac2_384 == KernelCryptography.HMAC.hash(.SHA2_384, HMACTestAssets.key2, HMACTestAssets.data2))
            #expect(HMACTestAssets.hmac3_384 == KernelCryptography.HMAC.hash(.SHA2_384, HMACTestAssets.key3, HMACTestAssets.data3))
            #expect(HMACTestAssets.hmac4_384 == KernelCryptography.HMAC.hash(.SHA2_384, HMACTestAssets.key4, HMACTestAssets.data4))
            #expect(HMACTestAssets.hmac5_384 == [UInt8](KernelCryptography.HMAC.hash(.SHA2_384, HMACTestAssets.key5, HMACTestAssets.data5)[0 ..< 16]))
            #expect(HMACTestAssets.hmac6_384 == KernelCryptography.HMAC.hash(.SHA2_384, HMACTestAssets.key6, HMACTestAssets.data6))
            #expect(HMACTestAssets.hmac7_384 == KernelCryptography.HMAC.hash(.SHA2_384, HMACTestAssets.key7, HMACTestAssets.data7))
        }
    }
    
    @Test
    func test512Static() {
        for _ in .zero ..< Self.testRounds {
            #expect(HMACTestAssets.hmac1_512 == KernelCryptography.HMAC.hash(.SHA2_512, HMACTestAssets.key1, HMACTestAssets.data1))
            #expect(HMACTestAssets.hmac2_512 == KernelCryptography.HMAC.hash(.SHA2_512, HMACTestAssets.key2, HMACTestAssets.data2))
            #expect(HMACTestAssets.hmac3_512 == KernelCryptography.HMAC.hash(.SHA2_512, HMACTestAssets.key3, HMACTestAssets.data3))
            #expect(HMACTestAssets.hmac4_512 == KernelCryptography.HMAC.hash(.SHA2_512, HMACTestAssets.key4, HMACTestAssets.data4))
            #expect(HMACTestAssets.hmac5_512 == [UInt8](KernelCryptography.HMAC.hash(.SHA2_512, HMACTestAssets.key5, HMACTestAssets.data5)[0 ..< 16]))
            #expect(HMACTestAssets.hmac6_512 == KernelCryptography.HMAC.hash(.SHA2_512, HMACTestAssets.key6, HMACTestAssets.data6))
            #expect(HMACTestAssets.hmac7_512 == KernelCryptography.HMAC.hash(.SHA2_512, HMACTestAssets.key7, HMACTestAssets.data7))
        }
    }
}
