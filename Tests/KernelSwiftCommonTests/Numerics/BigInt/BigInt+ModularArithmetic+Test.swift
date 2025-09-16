//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/10/2023.
//

import XCTest
import KernelSwiftCommon

final class BigIntModularArithmeticTest: XCTestCase {
    typealias BigInt = KernelNumerics.BigInt
    typealias DoubleWord = KernelNumerics.BigInt.DoubleWord
    typealias DoubleWords = KernelNumerics.BigInt.DoubleWords
    
    
    
    func testShiftedModulusDivision() {
        assertModulusDivisionIntToInt(30, 20)
        assertModulusDivisionIntToInt(30, 120)
        assertModulusDivisionIntToInt(130, 20)
        assertModulusDivisionIntToInt(130, 120)
        assertModulusDivisionBigIntToBigInt(BigInt.one << 512 - 1, BigInt.one)
        assertModulusDivisionBigIntToBigInt(BigInt.one << 512 - 1, BigInt.one << 512 - 1)
        assertModulusDivisionBigIntToBigInt(BigInt.one << 512, BigInt.one)
        assertModulusDivisionBigIntToBigInt(BigInt.one << 512, BigInt.one << 512 - 1)
    }
    
    func testSmallModulusDivisionSignInterop() {
        XCTAssertEqual(BigInt(7) % BigInt(4), BigInt(3))
        XCTAssertEqual(BigInt(-7) % BigInt(4), BigInt(-3))
        XCTAssertEqual(BigInt(7) % BigInt(-4), BigInt(3))
        XCTAssertEqual(BigInt(-7) % BigInt(-4), BigInt(-3))
        XCTAssertEqual(BigInt(7) % 4, BigInt(3))
        XCTAssertEqual(BigInt(-7) % 4, BigInt(-3))
        XCTAssertEqual(BigInt(7) % (-4), BigInt(3))
        XCTAssertEqual(BigInt(-7) % (-4), BigInt(-3))
        XCTAssertEqual(BigInt(7).mod(BigInt(4)), BigInt(3))
        XCTAssertEqual(BigInt(-7).mod(BigInt(4)), BigInt(1))
        XCTAssertEqual(BigInt(7).mod(BigInt(-4)), BigInt(3))
        XCTAssertEqual(BigInt(-7).mod(BigInt(-4)), BigInt(1))
        XCTAssertEqual(BigInt(7).mod(4), 3)
        XCTAssertEqual(BigInt(-7).mod(4), 1)
        XCTAssertEqual(BigInt(7).mod(-4), 3)
        XCTAssertEqual(BigInt(-7).mod(-4), 1)
        XCTAssertEqual(BigInt(8).mod(4), 0)
        XCTAssertEqual(BigInt(-8).mod(4), 0)
        XCTAssertEqual(BigInt(8).mod(-4), 0)
        XCTAssertEqual(BigInt(-8).mod(-4), 0)
        assertModulusDivisionBigIntToBigInt(BigInt(7), BigInt(4))
        assertModulusDivisionBigIntToBigInt(BigInt(-7), BigInt(4))
        assertModulusDivisionBigIntToBigInt(BigInt(7), BigInt(-4))
        assertModulusDivisionBigIntToBigInt(BigInt(-7), BigInt(-4))
        assertModulusDivisionBigIntToBigInt(BigInt(DoubleWords(repeating: UInt64.max, count: 50)), BigInt(DoubleWords(repeating: UInt64.max, count: 35)))
    }
    
    func testModulusDivisionZeroProducts() {
        XCTAssertEqual(BigInt(0) / BigInt(7), BigInt.zero)
        XCTAssertEqual(-BigInt(0) / BigInt(7), BigInt.zero)
        XCTAssertEqual(BigInt(0) / BigInt(-7), BigInt.zero)
        XCTAssertEqual(-BigInt(0) / BigInt(-7), BigInt.zero)
        XCTAssertEqual(BigInt(7) % BigInt(7), BigInt.zero)
        XCTAssertEqual(BigInt(-7) % BigInt(7), BigInt.zero)
        XCTAssertEqual(BigInt(7) % BigInt(-7), BigInt.zero)
        XCTAssertEqual(BigInt(-7) % BigInt(-7), BigInt.zero)
        XCTAssertEqual(BigInt(7) % 7, BigInt.zero)
        XCTAssertEqual(BigInt(-7) % 7, BigInt.zero)
        XCTAssertEqual(BigInt(7) % (-7), BigInt.zero)
        XCTAssertEqual(BigInt(-7) % (-7), BigInt.zero)
    }
    
    func testModulusDivisionBigIntModInt() {
        for _ in 0 ..< 100 {
            let x = BigInt(bitWidth: 1000)
            let m = x.storage[0] == 0 ? 1 : Int(x.storage[0] & 0x7fffffffffffffff)
            XCTAssertEqual(x.mod(m), x.mod(BigInt(m)).toInt()!)
            XCTAssertEqual(x.mod(-m), x.mod(-BigInt(m)).toInt()!)
        }
    }
    
    func testLargeModulusDivisionSignInterop() {
        let x = BigInt(bitWidth: 1000)
        assertModulusDivisionBigIntToInt(x, 1)
        assertModulusDivisionBigIntToInt(x, -1)
        assertModulusDivisionBigIntToInt(x, 10)
        assertModulusDivisionBigIntToInt(x, -10)
        assertModulusDivisionBigIntToInt(x, Int.max)
        assertModulusDivisionBigIntToInt(x, Int.max - 1)
        assertModulusDivisionBigIntToInt(x, Int.min)
        assertModulusDivisionBigIntToInt(x, Int.min + 1)
    }
    
    private func assertModulusDivisionBigIntToBigInt(_ x1: BigInt, _ x2: BigInt) {
        let r1 = x1 % x2
        let q1 = x1 / x2
        XCTAssertEqual(x1, x2 * q1 + r1)
        XCTAssertTrue(r1.abs < x2.abs)
        let (q2, r2) = x1.quotientAndRemainder(dividingBy: x2)
        XCTAssertEqual(q1, q2)
        XCTAssertEqual(r1, r2)
        var q3 = BigInt.zero
        var r3 = BigInt.zero
        x1.quotientAndRemainder(dividingBy: x2, &q3, &r3)
        XCTAssertEqual(q1, q3)
        XCTAssertEqual(r1, r3)
        XCTAssertEqual(x1.mod(Int.min), x1.mod(BigInt(Int.min)).toInt()!)
    }
    
    private func assertModulusDivisionIntToInt(_ bw1: Int, _ bw2: Int) {
        let x1 = BigInt(bitWidth: bw1)
        let x2 = BigInt(bitWidth: bw2) + BigInt.one
        assertModulusDivisionBigIntToBigInt(x1, x2)
    }
    
    private func assertModulusDivisionBigIntToInt(_ x1: BigInt, _ x2: Int) {
        let (q1, r1) = x1.quotientAndRemainder(dividingBy: x2)
        let (q2, r2) = x1.quotientAndRemainder(dividingBy: BigInt(x2))
        XCTAssertEqual(q1, q2)
        XCTAssertEqual(r1, r2.toInt()!)
        XCTAssertEqual(x1 / x2, x1 / BigInt(x2))
        XCTAssertEqual(x1 % x2, x1 % BigInt(x2))
        XCTAssertEqual(x1.mod(x2), x1.mod(BigInt(x2)).toInt()!)
    }
}
