//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 19/10/2023.
//

import XCTest
import KernelSwiftCommon

class BigIntBinaryOperationsTest: XCTestCase {
    typealias BigInt = KernelNumerics.BigInt
    
    func executeTestNegation(_ x1: BigInt) {
        var x2 = x1
        x2.negate()
        XCTAssertEqual(x1, -x2)
        XCTAssertEqual(~x1 + 1, -x1)
    }
    
    func testNegationShifts() {
        executeTestNegation(BigInt(0))
        executeTestNegation(BigInt(1))
        executeTestNegation(BigInt(-1))
        executeTestNegation(BigInt(bitWidth: 200))
        var x1 = BigInt.one << 37
        x1.clearBit(37)
        XCTAssert(x1.isZero)
        var x2 = BigInt.one << 150
        x2.clearBit(150)
        XCTAssert(x2.isZero)
    }
    
    func testOrXorAndChains() {
        let a = BigInt(bitWidth: 300)
        let b = BigInt(bitWidth: 300)
        let c = BigInt(bitWidth: 300)
        XCTAssertEqual(b ^ b ^ b, b)
        XCTAssertEqual(a & (b | c), (a & b) | (a & c))
    }
    
    func testBitFlips() {
        let a = BigInt(bitWidth: 300)
        var b = a
        for i in 0 ..< 300 {
            b.flipBit(i)
        }
        for i in 0 ..< 300 {
            XCTAssertEqual(a.testBit(i), !b.testBit(i))
        }
    }
    
    func testZeroOperations() {
        let a = BigInt(bitWidth: 300)
        XCTAssertEqual(a | BigInt.zero, a)
        XCTAssertEqual(a & BigInt.zero, BigInt.zero)
        XCTAssertEqual(a & ~BigInt.zero, a)
        XCTAssertEqual(a ^ BigInt.zero, a)
        XCTAssertEqual(a ^ ~BigInt.zero, ~a)
    }
    
    func testSmallOperations() {
        let b3 = BigInt(3)
        let bm3 = BigInt(-3)
        let b7 = BigInt(7)
        let bm7 = BigInt(-7)
        XCTAssertEqual(b3 & b7, BigInt(3))
        XCTAssertEqual(b3 & bm7, BigInt(1))
        XCTAssertEqual(bm3 & b7, BigInt(5))
        XCTAssertEqual(bm3 & bm7, BigInt(-7))
        XCTAssertEqual(b3 | b7, BigInt(7))
        XCTAssertEqual(b3 | bm7, BigInt(-5))
        XCTAssertEqual(bm3 | b7, BigInt(-1))
        XCTAssertEqual(bm3 | bm7, BigInt(-3))
        XCTAssertEqual(b3 ^ b7, BigInt(4))
        XCTAssertEqual(b3 ^ bm7, BigInt(-6))
        XCTAssertEqual(bm3 ^ b7, BigInt(-6))
        XCTAssertEqual(bm3 ^ bm7, BigInt(4))
        XCTAssertEqual(~b3, BigInt(-4))
        XCTAssertEqual(~bm3, BigInt(2))
        XCTAssertEqual(~b7, BigInt(-8))
        XCTAssertEqual(~bm7, BigInt(6))
    }
    
    func testLargeOperations() {
        for _ in 0 ..< 100 {
            let x = BigInt(bitWidth: 100)
            let y = BigInt(bitWidth: 300)
            executeTestNegation(x)
            executeTestNegation(y)
            XCTAssertEqual(x & y, y & x)
            XCTAssertEqual(x & -y, -y & x)
            XCTAssertEqual(-x & y, y & -x)
            XCTAssertEqual(-x & -y, -y & -x)
            XCTAssertEqual(x | y, y | x)
            XCTAssertEqual(x | -y, -y | x)
            XCTAssertEqual(-x | y, y | -x)
            XCTAssertEqual(-x | -y, -y | -x)
            XCTAssertEqual(x ^ y, y ^ x)
            XCTAssertEqual(x ^ -y, -y ^ x)
            XCTAssertEqual(-x ^ y, y ^ -x)
            XCTAssertEqual(-x ^ -y, -y ^ -x)
        }
    }
    
    func testSingleBitOperationSequences() {
        let x = BigInt(bitWidth: 50)
        var y = x
        y.setBit(-1)
        XCTAssertEqual(x, y)
        y.clearBit(-1)
        XCTAssertEqual(x, y)
        y.flipBit(-1)
        XCTAssertEqual(x, y)
        XCTAssertFalse(y.testBit(-1))
        y = BigInt(0)
        y.setBit(200)
        XCTAssertEqual(y.count, 4)
        XCTAssertEqual(y, BigInt.one << 200)
        XCTAssertTrue(y.testBit(200))
        y.clearBit(200)
        XCTAssertEqual(y.count, 1)
        XCTAssertFalse(y.testBit(200))
        XCTAssertEqual(y, BigInt.zero)
        y.flipBit(200)
        XCTAssertEqual(y, BigInt.one << 200)
        y.flipBit(200)
        XCTAssertEqual(y, BigInt.zero)
    }
    
    func extractPopulation(_ a: BigInt) -> Int {
        var n = 0
        var x = a
        while x.isNotZero {
            if x.isOdd {
                n += 1
            }
            x >>= 1
        }
        return n
    }
    
    func testPopulations() {
        XCTAssertEqual(BigInt.zero.population, 0)
        let x = BigInt("ffffffffffffffff", radix: 16)!
        for i in 0 ..< 100 {
            XCTAssertEqual((BigInt.one << i).population, 1)
            XCTAssertEqual((x << i).population, 64)
        }
        for _ in 0 ..< 100 {
            let x = BigInt(bitWidth: 200)
            XCTAssertEqual(x.population, extractPopulation(x))
        }
    }
}
