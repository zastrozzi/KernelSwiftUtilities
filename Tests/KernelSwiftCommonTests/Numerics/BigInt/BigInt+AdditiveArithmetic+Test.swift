//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 19/10/2023.
//

import Testing
import KernelSwiftCommon

@Suite
struct BigIntAdditiveArithmeticTests {
    typealias BigInt = KernelNumerics.BigInt
    
    @Test
    func testFixedWidthAddition() {
        #expect(BigInt(7)   + BigInt(4)     == BigInt(11))
        #expect(BigInt(7)   + BigInt(-4)    == BigInt(3))
        #expect(BigInt(-7)  + BigInt(4)     == BigInt(-3))
        #expect(BigInt(-7)  + BigInt(-4)    == BigInt(-11))
        #expect(BigInt(-7)  + BigInt(0)     == BigInt(-7))
        #expect(BigInt(7)   + BigInt(0)     == BigInt(7))
        #expect(BigInt(7)   + 4             == BigInt(11))
        #expect(BigInt(7)   + (-4)          == BigInt(3))
        #expect(BigInt(-7)  + 4             == BigInt(-3))
        #expect(BigInt(-7)  + (-4)          == BigInt(-11))
        #expect(BigInt(-7)  + 0             == BigInt(-7))
        #expect(BigInt(7)   + 0             == BigInt(7))
        #expect(7           + BigInt(4)     == BigInt(11))
        #expect(7           + BigInt(-4)    == BigInt(3))
        #expect((-7)        + BigInt(4)     == BigInt(-3))
        #expect((-7)        + BigInt(-4)    == BigInt(-11))
        #expect((-7)        + BigInt(0)     == BigInt(-7))
        #expect(7           + BigInt(0)     == BigInt(7))
        #expect(0           + BigInt(7)     == BigInt(7))
        #expect(0           + BigInt(-7)    == BigInt(-7))
        #expect(0           + BigInt(0)     == BigInt(0))
    }
    
    @Test
    func testFixedWidthSubtraction() {
        #expect(BigInt(7)   - BigInt(4)     == BigInt(3))
        #expect(BigInt(7)   - BigInt(-4)    == BigInt(11))
        #expect(BigInt(-7)  - BigInt(4)     == BigInt(-11))
        #expect(BigInt(-7)  - BigInt(-4)    == BigInt(-3))
        #expect(BigInt(-7)  - BigInt(0)     == BigInt(-7))
        #expect(BigInt(7)   - BigInt(0)     == BigInt(7))
        #expect(BigInt(7)   - 4             == BigInt(3))
        #expect(BigInt(7)   - (-4)          == BigInt(11))
        #expect(BigInt(-7)  - 4             == BigInt(-11))
        #expect(BigInt(-7)  - (-4)          == BigInt(-3))
        #expect(BigInt(-7)  - 0             == BigInt(-7))
        #expect(BigInt(7)   - 0             == BigInt(7))
        #expect(7           - BigInt(4)     == BigInt(3))
        #expect(7           - BigInt(-4)    == BigInt(11))
        #expect((-7)        - BigInt(4)     == BigInt(-11))
        #expect((-7)        - BigInt(-4)    == BigInt(-3))
        #expect((-7)        - BigInt(0)     == BigInt(-7))
        #expect(7           - BigInt(0)     == BigInt(7))
        #expect(0           - BigInt(7)     == BigInt(-7))
        #expect(0           - BigInt(-7)    == BigInt(7))
        #expect(0           - BigInt(0)     == BigInt(0))
    }
    
    @Test
    func testMutatingAddition() {
        var x1 = BigInt(7)
        x1 += BigInt(4)
        #expect(x1 == BigInt(11))
        var x2 = BigInt(7)
        x2 += BigInt(-4)
        #expect(x2 == BigInt(3))
        var x3 = BigInt(-7)
        x3 += BigInt(4)
        #expect(x3 == BigInt(-3))
        var x4 = BigInt(-7)
        x4 += BigInt(-4)
        #expect(x4 == BigInt(-11))
    }
    
    @Test
    func testMutatingSubtraction() {
        var x1 = BigInt(7)
        x1 -= BigInt(4)
        #expect(x1 == BigInt(3))
        var x2 = BigInt(7)
        x2 -= BigInt(-4)
        #expect(x2 == BigInt(11))
        var x3 = BigInt(-7)
        x3 -= BigInt(4)
        #expect(x3 == BigInt(-11))
        var x4 = BigInt(-7)
        x4 -= BigInt(-4)
        #expect(x4 == BigInt(-3))
    }
    
    @Test
    func testAdditionEquivalence() {
        for i in 0 ..< 1000 {
            let a = i % 2 == 0 ? BigInt(bitWidth: 1000) : -BigInt(bitWidth: 1000)
            let b = BigInt(bitWidth: 800)
            let n = BigInt(bitWidth: 500)
            let ab = a + b
            let an = a * n
            #expect(ab - a == b)
            #expect(ab - b == a)
            #expect(an - a == a * (n - 1))
        }
    }
    
    @Test
    func testIterativeMutatingAddition() {
        for i in 0 ..< 1000 {
            let a = i % 2 == 0 ? BigInt(bitWidth: 1000) : -BigInt(bitWidth: 1000)
            var b = a
            for _ in 0 ..< 100 {
                b += a
            }
            #expect(b == a * 101)
        }
    }
    
    @Test
    func testFixedWidthAdditionOperandEquivalence() {
        prepareFixedWidthAdditionOperandEquivalenceCases(.init(bitWidth: 1000))
        prepareFixedWidthAdditionOperandEquivalenceCases(.init(0))
        prepareFixedWidthAdditionOperandEquivalenceCases(.init(1))
        prepareFixedWidthAdditionOperandEquivalenceCases(.init(-1))
        prepareFixedWidthAdditionOperandEquivalenceCases(.init(Int.max))
        prepareFixedWidthAdditionOperandEquivalenceCases(-.init(Int.max))
        prepareFixedWidthAdditionOperandEquivalenceCases(.init(Int.min))
        prepareFixedWidthAdditionOperandEquivalenceCases(-.init(Int.min))
    }
    
    @Test
    func testFixedWidthSubtractionOperandEquivalence() {
        prepareFixedWidthSubtractionOperandEquivalenceCases(BigInt(bitWidth: 1000))
        prepareFixedWidthSubtractionOperandEquivalenceCases(BigInt(0))
        prepareFixedWidthSubtractionOperandEquivalenceCases(BigInt(1))
        prepareFixedWidthSubtractionOperandEquivalenceCases(BigInt(-1))
        prepareFixedWidthSubtractionOperandEquivalenceCases(BigInt(Int.max))
        prepareFixedWidthSubtractionOperandEquivalenceCases(-BigInt(Int.max))
        prepareFixedWidthSubtractionOperandEquivalenceCases(BigInt(Int.min))
        prepareFixedWidthSubtractionOperandEquivalenceCases(-BigInt(Int.min))
    }
    
    private func executeFixedWidthAdditionOperandEquivalence(_ x: BigInt, _ y: Int) {
        #expect(x + y == x + BigInt(y))
        #expect((-x) + y == (-x) + BigInt(y))
        if y != Int.min {
            #expect(x + (-y) == x + BigInt(-y))
            #expect((-x) + (-y) == (-x) + BigInt(-y))
        }
    }
    
    private func prepareFixedWidthAdditionOperandEquivalenceCases(_ x: BigInt) {
        executeFixedWidthAdditionOperandEquivalence(x, 0)
        executeFixedWidthAdditionOperandEquivalence(x, 1)
        executeFixedWidthAdditionOperandEquivalence(x, -1)
        executeFixedWidthAdditionOperandEquivalence(x, Int.max)
        executeFixedWidthAdditionOperandEquivalence(x, Int.min)
        executeFixedWidthAdditionOperandEquivalence(x, Int.max - 1)
        executeFixedWidthAdditionOperandEquivalence(x, Int.min + 1)
    }
    
    private func executeFixedWidthSubtractionOperandEquivalence(_ x: BigInt, _ y: Int) {
        #expect(x - y == x - BigInt(y))
        #expect((-x) - y == (-x) - BigInt(y))
        if y != Int.min {
            #expect(x - (-y) == x - BigInt(-y))
            #expect((-x) - (-y) == (-x) - BigInt(-y))
        }
    }
    
    private func prepareFixedWidthSubtractionOperandEquivalenceCases(_ x: BigInt) {
        executeFixedWidthSubtractionOperandEquivalence(x, 0)
        executeFixedWidthSubtractionOperandEquivalence(x, 1)
        executeFixedWidthSubtractionOperandEquivalence(x, -1)
        executeFixedWidthSubtractionOperandEquivalence(x, Int.max)
        executeFixedWidthSubtractionOperandEquivalence(x, Int.min)
        executeFixedWidthSubtractionOperandEquivalence(x, Int.max - 1)
        executeFixedWidthSubtractionOperandEquivalence(x, Int.min + 1)
    }
}
