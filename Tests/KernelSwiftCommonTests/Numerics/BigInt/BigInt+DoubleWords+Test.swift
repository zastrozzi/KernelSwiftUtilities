//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 19/10/2023.
//

import XCTest
import KernelSwiftCommon

class BigIntDoubleWordsTest: XCTestCase {
    typealias BigInt = KernelNumerics.BigInt
    typealias DoubleWord = KernelNumerics.BigInt.DoubleWord
    typealias DoubleWords = KernelNumerics.BigInt.DoubleWords
    
    func testWordSize() {
        var x1: DoubleWords = [0, 0, 0]
        XCTAssertEqual(x1.count, 3)
        x1.ensureSize(5)
        XCTAssertEqual(x1.count, 5)
        x1.normalise()
        XCTAssertEqual(x1.count, 1)
        x1 = [0, 0, 1]
        XCTAssertEqual(x1.bitWidth, 129)
        x1.setBit(1)
        XCTAssertEqual(BigInt(x1), (BigInt(1) << 128) + 2)
    }
    
    func testBytesPositive() {
        for _ in 0 ..< 10 {
            let x = BigInt(bitWidth: 1000)
            let x1 = BigInt(magnitudeBytes: x.magnitudeBytes())
            XCTAssertEqual(x, x1)
            let x2 = BigInt(signedBytes: x.signedBytes())
            XCTAssertEqual(x, x2)
        }
    }
    
    func testBytesNegative() {
        for _ in 0 ..< 10 {
            let x = -BigInt(bitWidth: 1000)
            let x1 = -BigInt(magnitudeBytes: x.magnitudeBytes())
            XCTAssertEqual(x, x1)
            let x2 = BigInt(signedBytes: x.signedBytes())
            XCTAssertEqual(x, x2)
        }
    }
}
