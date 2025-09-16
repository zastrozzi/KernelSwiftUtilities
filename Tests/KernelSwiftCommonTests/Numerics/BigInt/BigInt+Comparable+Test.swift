//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 19/10/2023.
//

import XCTest
import KernelSwiftCommon

class BigIntComparableTest: XCTestCase {
    typealias BigInt = KernelNumerics.BigInt
    
    
    
    func testBigIntToBigInt() {
        bigInt_bigInt(BigInt.zero, BigInt.zero)
        for _ in 0 ..< 10 {
            let a = BigInt(bitWidth: 100)
            let b = BigInt(bitWidth: 100)
            bigInt_bigInt(a, a)
            bigInt_bigInt(a, -a)
            bigInt_bigInt(-a, a)
            bigInt_bigInt(-a, -a)
            bigInt_bigInt(a, b)
            bigInt_bigInt(a, -b)
            bigInt_bigInt(-a, b)
            bigInt_bigInt(-a, -b)
        }
    }
    
    func testBigIntToInt() {
        bigInt_int(BigInt.zero, 0)
        for _ in 0 ..< 10 {
            let a = BigInt(bitWidth: 50)
            bigInt_int(a, 0)
            bigInt_int(a, 1)
            bigInt_int(a, -1)
            bigInt_int(a, Int.max)
            bigInt_int(a, Int.min)
            bigInt_int(-a, 0)
            bigInt_int(-a, 1)
            bigInt_int(-a, -1)
            bigInt_int(-a, Int.max)
            bigInt_int(-a, Int.min)
        }
    }
    
    func testIntToBigInt() {
        int_bigInt(0, BigInt.zero)
        for _ in 0 ..< 10 {
            let b = BigInt(bitWidth: 50)
            int_bigInt(0, b)
            int_bigInt(1, b)
            int_bigInt(-1, b)
            int_bigInt(Int.max, b)
            int_bigInt(Int.min, b)
            int_bigInt(0, -b)
            int_bigInt(1, -b)
            int_bigInt(-1, -b)
            int_bigInt(Int.max, -b)
            int_bigInt(Int.min, -b)
        }
    }
    
    func testAllOperators() {
        for _ in 0 ..< 100 {
            let a = BigInt(bitWidth: 50)
            let b = BigInt(bitWidth: 50)
            equality(a, b)
            nonEquality(a, b)
            lessThan(a, b)
            lessEqual(a, b)
            greaterThan(a, b)
            greaterEqual(a, b)
        }
    }
    
    private func bigInt_bigInt(_ a: BigInt, _ b: BigInt) {
        let eq = a == b
        let ne = a != b
        let lt = a < b
        let le = a <= b
        let gt = a > b
        let ge = a >= b
        XCTAssertNotEqual(eq, ne)
        XCTAssertNotEqual(lt, eq || gt)
        XCTAssertNotEqual(gt, eq || lt)
        XCTAssertEqual(le, eq || lt)
        XCTAssertEqual(ge, eq || gt)
    }
    
    private func bigInt_int(_ a: BigInt, _ b: Int) {
        let eq = a == b
        let ne = a != b
        let lt = a < b
        let le = a <= b
        let gt = a > b
        let ge = a >= b
        XCTAssertNotEqual(eq, ne)
        XCTAssertNotEqual(lt, eq || gt)
        XCTAssertNotEqual(gt, eq || lt)
        XCTAssertEqual(le, eq || lt)
        XCTAssertEqual(ge, eq || gt)
    }
    
    private func int_bigInt(_ a: Int, _ b: BigInt) {
        let eq = a == b
        let ne = a != b
        let lt = a < b
        let le = a <= b
        let gt = a > b
        let ge = a >= b
        XCTAssertNotEqual(eq, ne)
        XCTAssertNotEqual(lt, eq || gt)
        XCTAssertNotEqual(gt, eq || lt)
        XCTAssertEqual(le, eq || lt)
        XCTAssertEqual(ge, eq || gt)
    }
    
    private func equality(_ a: BigInt, _ b: BigInt) {
        let ia = a.toInt()!
        let ib = b.toInt()!
        XCTAssertEqual(a == b, ia == b)
        XCTAssertEqual(a == b, a == ib)
        XCTAssertEqual(a == -b, ia == -b)
        XCTAssertEqual(a == -b, a == -ib)
        XCTAssertEqual(-a == b, -ia == b)
        XCTAssertEqual(-a == b, -a == ib)
        XCTAssertEqual(-a == -b, -ia == -b)
        XCTAssertEqual(-a == -b, -a == -ib)
    }
    
    private func nonEquality(_ a: BigInt, _ b: BigInt) {
        let ia = a.toInt()!
        let ib = b.toInt()!
        XCTAssertEqual(a != b, ia != b)
        XCTAssertEqual(a != b, a != ib)
        XCTAssertEqual(a != -b, ia != -b)
        XCTAssertEqual(a != -b, a != -ib)
        XCTAssertEqual(-a != b, -ia != b)
        XCTAssertEqual(-a != b, -a != ib)
        XCTAssertEqual(-a != -b, -ia != -b)
        XCTAssertEqual(-a != -b, -a != -ib)
    }
    
    private func lessThan(_ a: BigInt, _ b: BigInt) {
        let ia = a.toInt()!
        let ib = b.toInt()!
        XCTAssertEqual(a < b, ia < b)
        XCTAssertEqual(a < b, a < ib)
        XCTAssertEqual(a < -b, ia < -b)
        XCTAssertEqual(a < -b, a < -ib)
        XCTAssertEqual(-a < b, -ia < b)
        XCTAssertEqual(-a < b, -a < ib)
        XCTAssertEqual(-a < -b, -ia < -b)
        XCTAssertEqual(-a < -b, -a < -ib)
    }
    
    private func lessEqual(_ a: BigInt, _ b: BigInt) {
        let ia = a.toInt()!
        let ib = b.toInt()!
        XCTAssertEqual(a <= b, ia <= b)
        XCTAssertEqual(a <= b, a <= ib)
        XCTAssertEqual(a <= -b, ia <= -b)
        XCTAssertEqual(a <= -b, a <= -ib)
        XCTAssertEqual(-a <= b, -ia <= b)
        XCTAssertEqual(-a <= b, -a <= ib)
        XCTAssertEqual(-a <= -b, -ia <= -b)
        XCTAssertEqual(-a <= -b, -a <= -ib)
    }
    
    private func greaterThan(_ a: BigInt, _ b: BigInt) {
        let ia = a.toInt()!
        let ib = b.toInt()!
        XCTAssertEqual(a > b, ia > b)
        XCTAssertEqual(a > b, a > ib)
        XCTAssertEqual(a > -b, ia > -b)
        XCTAssertEqual(a > -b, a > -ib)
        XCTAssertEqual(-a > b, -ia > b)
        XCTAssertEqual(-a > b, -a > ib)
        XCTAssertEqual(-a > -b, -ia > -b)
        XCTAssertEqual(-a > -b, -a > -ib)
    }
    
    private func greaterEqual(_ a: BigInt, _ b: BigInt) {
        let ia = a.toInt()!
        let ib = b.toInt()!
        XCTAssertEqual(a >= b, ia >= b)
        XCTAssertEqual(a >= b, a >= ib)
        XCTAssertEqual(a >= -b, ia >= -b)
        XCTAssertEqual(a >= -b, a >= -ib)
        XCTAssertEqual(-a >= b, -ia >= b)
        XCTAssertEqual(-a >= b, -a >= ib)
        XCTAssertEqual(-a >= -b, -ia >= -b)
        XCTAssertEqual(-a >= -b, -a >= -ib)
    }
}
