import XCTest
import KernelSwiftCommon

final class UnsignedIntegerTests: XCTestCase {
    func testInt8() throws {
        testIntegerBigEndian(ofType: Int8.self, value: +0x01, bytes: [0x01])
        testIntegerBigEndian(ofType: Int8.self, value: -0x01, bytes: [0xff])
        testIntegerLittleEndian(ofType: Int8.self, value: +0x01, bytes: [0x01])
        testIntegerLittleEndian(ofType: Int8.self, value: -0x01, bytes: [0xff])
    }
    
    func testInt16() {
        testIntegerBigEndian(ofType: Int16.self, value: +0x0123, bytes: [0x01, 0x23])
        testIntegerBigEndian(ofType: Int16.self, value: -0x0123, bytes: [0xfe, 0xdd])
        testIntegerLittleEndian(ofType: Int16.self, value: +0x0123, bytes: [0x23, 0x01])
        testIntegerLittleEndian(ofType: Int16.self, value: -0x0123, bytes: [0xdd, 0xfe])
    }
    
    func testInt32() {
        testIntegerBigEndian(ofType: Int32.self, value: +0x0123_4567, bytes: [0x01, 0x23, 0x45, 0x67])
        testIntegerBigEndian(ofType: Int32.self, value: -0x0123_4567, bytes: [0xfe, 0xdc, 0xba, 0x99])
        testIntegerLittleEndian(ofType: Int32.self, value: +0x0123_4567, bytes: [0x67, 0x45, 0x23, 0x01])
        testIntegerLittleEndian(ofType: Int32.self, value: -0x0123_4567, bytes: [0x99, 0xba, 0xdc, 0xfe])
    }
    
    func testInt64() {
        testIntegerBigEndian(ofType: Int64.self, value: +0x0123_4567_89ab_cdef, bytes: [0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef])
        testIntegerBigEndian(ofType: Int64.self, value: -0x0123_4567_89ab_cdef, bytes: [0xfe, 0xdc, 0xba, 0x98, 0x76, 0x54, 0x32, 0x11])
        testIntegerLittleEndian(ofType: Int64.self, value: +0x0123_4567_89ab_cdef, bytes: [0xef, 0xcd, 0xab, 0x89, 0x67, 0x45, 0x23, 0x01])
        testIntegerLittleEndian(ofType: Int64.self, value: -0x0123_4567_89ab_cdef, bytes: [0x11, 0x32, 0x54, 0x76, 0x98, 0xba, 0xdc, 0xfe])
    }
}

fileprivate func testIntegerBigEndian<I>(ofType type: I.Type, value: I, bytes: [UInt8], line: UInt = #line) where I: FixedWidthInteger {
    XCTAssertEqual(I(bigEndianBytes: bytes), value, line: line)
}

fileprivate func testIntegerLittleEndian<I>(ofType type: I.Type, value: I, bytes: [UInt8], line: UInt = #line) where I: FixedWidthInteger {
    XCTAssertEqual(I(littleEndianBytes: bytes), value, line: line)
}
