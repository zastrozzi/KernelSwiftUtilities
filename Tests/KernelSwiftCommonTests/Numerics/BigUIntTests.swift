import XCTest

import KernelSwiftCommon
//import KernelSwiftServer

final class BigUIntTests: XCTestCase {
    func testRandomPrimeGen() async throws {
        let (a, b) = try await KernelNumerics.BigUInt.generatePrimesPair(128, concurrentCoreCount: 10, retriesPerCore: 10)
        print(a, b)
    }
    
    func testRandomPrimeGenOrig() async throws {
        let _ = try KernelNumerics.BigUInt.generatePrimeNoAsync(128)
    }
    
    func testBigUIntArraySizes() {
        for _ in 0...10_000 {
            let _ = KernelNumerics.primesBigUInt[0]
            let _ = KernelNumerics.primesBigUInt[15]
            let _ = KernelNumerics.primesBigUInt[31]
            let _ = KernelNumerics.primesBigUInt[63]
        }
    }
    
    func testBigUIntLookupSizes() {
        for _ in 0...10_000 {
            let _ = KernelNumerics.primeBigUIntFromTuple(0)
            let _ = KernelNumerics.primeBigUIntFromTuple(15)
            let _ = KernelNumerics.primeBigUIntFromTuple(31)
            let _ = KernelNumerics.primeBigUIntFromTuple(63)
            let _ = KernelNumerics.primeBigUIntFromTuple(127)
            let _ = KernelNumerics.primeBigUIntFromTuple(255)
        }
    }
}

