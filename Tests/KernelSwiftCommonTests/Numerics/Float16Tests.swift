import XCTest

import KernelSwiftCommon
//import KernelSwiftServer

final class Float16Tests: XCTestCase {
    func testSingleWidthToHalfWidthBits() {
        for (single, half) in Float16TestAssets.singleWidthHalfWidthConversions {
            let halfConverted = KernelNumerics.X86Float16.singleWidthToHalfWidthBits(single)
            XCTAssertEqual(half, halfConverted)
        }
    }
    
    func testHalfWidthToSingleWidthBits() {
        for (half, single) in Float16TestAssets.halfWidthSingleWidthApproximations {
            let singleConverted = KernelNumerics.X86Float16.halfWidthToSingleWidthBits(half)
            XCTAssertEqual(single, singleConverted)
        }
    }
}

