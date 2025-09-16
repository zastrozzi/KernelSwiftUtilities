//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 19/10/2023.
//

import XCTest
import KernelSwiftCommon

class BigIntScalingArithmeticTest: XCTestCase {
    typealias BigInt = KernelNumerics.BigInt
    
    func testQuotientExactBigIntToBigInt() {
        quotientExactBigIntToBigInt(BigInt.zero, BigInt.one)
        for _ in 0 ..< 100 {
            let x = BigInt(bitWidth: 200)
            var d = BigInt.one
            for _ in 0 ..< 10 {
                quotientExactBigIntToBigInt(x * d, d)
                quotientExactBigIntToBigInt(x * d, x)
                d *= 10
            }
        }
    }
    
    func testQuotientExactBigIntToInt() {
        quotientExactBigIntToInt(BigInt.one, 1)
        for _ in 0 ..< 100 {
            let x = BigInt(bitWidth: 200)
            var d = 1
            for _ in 0 ..< 10 {
                quotientExactBigIntToInt(x * d, d)
                d *= 10
            }
        }
    }
    
    private func executeQuotientExactBigIntToBigInt(_ x: BigInt, _ d: BigInt) {
        let q = x.quotientExact(dividingBy: d)
        if x != q * d {
            print(x)
            print(q)
            print(q * d)
        }
        XCTAssertEqual(x, q * d)
    }
    
    private func executeQuotientExactBigIntToInt(_ x: BigInt, _ d: Int) {
        let q = x.quotientExact(dividingBy: BigInt(d))
        XCTAssertEqual(x, q * d)
    }
    
    private func quotientExactBigIntToBigInt(_ x: BigInt, _ d: BigInt) {
        executeQuotientExactBigIntToBigInt(x, d)
        executeQuotientExactBigIntToBigInt(x, -d)
        executeQuotientExactBigIntToBigInt(-x, d)
        executeQuotientExactBigIntToBigInt(-x, -d)
    }
    
    private func quotientExactBigIntToInt(_ x: BigInt, _ d: Int) {
        executeQuotientExactBigIntToInt(x, d)
        executeQuotientExactBigIntToInt(x, -d)
        executeQuotientExactBigIntToInt(-x, d)
        executeQuotientExactBigIntToInt(-x, -d)
    }
}
