
//
//  File.swift
//
//
//  Created by Jonathan Forbes on 19/10/2023.
//
import XCTest
import KernelSwiftCommon

public class BigIntPrimeTest: XCTestCase {
#if DEBUG
    public let bitCount: Int = 128
    public let resCount: Int = 10
    public let coreCount: Int = 10
#else
    public let bitCount: Int = 256
    public let resCount: Int = 10
    public let coreCount: Int = 18
#endif
    
    public func testBigIntPrimeGen() async throws {
        print("BITS: \(bitCount) | TOTAL: \(resCount) | CORES: \(coreCount)")
        let _ = try await KernelNumerics.BigInt.Prime.probablePairs(bitCount, concurrentCoreCount: coreCount, total: resCount)
    }
    
}
