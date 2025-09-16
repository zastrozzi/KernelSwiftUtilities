//
//  BigIntBurnikelZieglerTest.swift
//  
//
//  Created by Jonathan Forbes on 19/10/2023.
//

import XCTest
import KernelSwiftCommon

final class BigIntBurnikelZieglerTest: XCTestCase {
    typealias BigInt = KernelNumerics.BigInt
    typealias DoubleWord = KernelNumerics.BigInt.DoubleWord
    typealias DoubleWords = KernelNumerics.BigInt.DoubleWords
    
    let b1 = BigInt("1ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff", radix: 16)!
    let b2 = BigInt("ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff", radix: 16)!
    
    func assertBurnikelZiegler(_ dividend: BigInt, _ divisor: BigInt) {
        var q1: DoubleWords = []
        var r1: DoubleWords = []
        var q2: BigInt
        var r2: BigInt
        (q1, r1) = dividend.storage.divMod(divisor.storage)
        (q2, r2) = BigInt.BurnikelZiegler.divMod(dividend, divisor)
        XCTAssertEqual(q1, q2.storage)
        XCTAssertEqual(r1, r2.storage)
    }
    
    func assertQuotientRemainder(_ dividend: BigInt, _ divisor: BigInt) {
        let (q, r) = dividend.quotientAndRemainder(dividingBy: divisor)
        XCTAssertEqual(dividend, divisor * q + r)
    }
    
    func testBurnikelZieglerDivModSignInterop() {
        for _ in 0 ..< 10 {
            let x = BigInt(bitWidth: 2 * (BigInt.val.bz.divLimit + 1) * 64)
            let y = BigInt(bitWidth: (BigInt.val.bz.divLimit + 1) * 64)
            assertBurnikelZiegler(x, y)
            assertQuotientRemainder(x, y)
            assertQuotientRemainder(x, -y)
            assertQuotientRemainder(-x, y)
            assertQuotientRemainder(-x, -y)
        }
        assertBurnikelZiegler(BigInt(DoubleWords(repeating: UInt64.max, count: 2 * (BigInt.val.bz.divLimit + 1))), BigInt(DoubleWords(repeating: UInt64.max, count: BigInt.val.bz.divLimit + 1)))
    }
    
    func testBurnikelZieglerDivModShifts() {
        var n = 2
        for _ in 0 ..< 3 {
            let y1 = BigInt.one << ((BigInt.val.bz.divLimit + 1) * 64 * n)
            let y2 = BigInt(bitWidth: (BigInt.val.bz.divLimit + 1) * 64 * n)
            n *= 2
            let x1 = BigInt.one << ((BigInt.val.bz.divLimit + 1) * 64 * n)
            let x2 = BigInt(bitWidth: (BigInt.val.bz.divLimit + 1) * 64 * n)
            assertBurnikelZiegler(x1, y1)
            assertBurnikelZiegler(x2, y1)
            assertBurnikelZiegler(x1, x2)
            assertBurnikelZiegler(y1, y2)
        }
    }
    
    func testQuotientRemainder() {
        assertQuotientRemainder(b1 * b1, b1)
        assertQuotientRemainder(b2 * b2, b2)
    }

}
