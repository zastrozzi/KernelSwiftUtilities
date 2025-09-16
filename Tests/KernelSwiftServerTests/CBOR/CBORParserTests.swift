//
//  File.swift
//
//
//  Created by Jonathan Forbes on 19/09/2023.
//

//import XCTest
//@testable import KernelVaporUtilities
import KernelSwiftServer
import Testing

@Suite
struct CBORParserTests {
    @Test(
        arguments: [
            [.init(0)],
            [.init(1)],
            [.init(23)],
            CBORTestAssets.unsignedInt_255,
            CBORTestAssets.unsignedInt_1000,
            CBORTestAssets.unsignedInt_65535,
            CBORTestAssets.unsignedInt_10000,
            CBORTestAssets.unsignedInt_4294967295,
            CBORTestAssets.unsignedInt_1000000000000,
            CBORTestAssets.unsignedInt_18446744073709551615,
            CBORTestAssets.negativeInt_1_small,
            CBORTestAssets.negativeInt_1,
            CBORTestAssets.negativeInt_24,
            CBORTestAssets.negativeInt_256,
            CBORTestAssets.negativeInt_1000,
            CBORTestAssets.negativeInt_999999,
            CBORTestAssets.negativeInt_999999999999,
            CBORTestAssets.utf8String_1,
            CBORTestAssets.utf8String_2,
            CBORTestAssets.utf8String_3,
            CBORTestAssets.utf8String_4,
            CBORTestAssets.utf8String_5,
            CBORTestAssets.utf8String_6,
            CBORTestAssets.utf8String_7,
            CBORTestAssets.array_1,
            CBORTestAssets.array_2,
            CBORTestAssets.array_3,
            CBORTestAssets.array_4,
            CBORTestAssets.array_5,
            CBORTestAssets.array_6,
            CBORTestAssets.array_7,
            CBORTestAssets.array_8,
            CBORTestAssets.array_9,
            CBORTestAssets.map_1,
            CBORTestAssets.map_2,
            CBORTestAssets.tagged_0,
            CBORTestAssets.tagged_1,
            CBORTestAssets.tagged_2,
            CBORTestAssets.tagged_3,
            CBORTestAssets.tagged_4,
            CBORTestAssets.half_0,
            CBORTestAssets.half_1,
            CBORTestAssets.float_0,
            CBORTestAssets.float_1,
            CBORTestAssets.double_0,
            CBORTestAssets.bigTest,
        ]
    )
    func testCBORParserTreeGenerationBytes(bytes: [UInt8]) async throws {
        var parser = KernelCBOR.CBORParser(bytes: bytes)
        try parser.generateParsingTree()
        let rootObject = try parser.rootParsingTreeMetadata()
        #expect(bytes.count == rootObject.combinedLength)
    }

    @Test(
        arguments: [
            [.init(0)],
            [.init(1)],
            [.init(23)],
            CBORTestAssets.unsignedInt_255,
            CBORTestAssets.unsignedInt_1000,
            CBORTestAssets.unsignedInt_65535,
            CBORTestAssets.unsignedInt_10000,
            CBORTestAssets.unsignedInt_4294967295,
            CBORTestAssets.unsignedInt_1000000000000,
            CBORTestAssets.unsignedInt_18446744073709551615,
            CBORTestAssets.negativeInt_1_small,
            CBORTestAssets.negativeInt_1,
            CBORTestAssets.negativeInt_24,
            CBORTestAssets.negativeInt_256,
            CBORTestAssets.negativeInt_1000,
            CBORTestAssets.negativeInt_999999,
            CBORTestAssets.negativeInt_999999999999,
            CBORTestAssets.utf8String_1,
            CBORTestAssets.utf8String_2,
            CBORTestAssets.utf8String_3,
            CBORTestAssets.utf8String_4,
            CBORTestAssets.utf8String_5,
            CBORTestAssets.utf8String_6,
            CBORTestAssets.utf8String_7,
            CBORTestAssets.array_1,
            CBORTestAssets.array_2,
            CBORTestAssets.array_3,
            CBORTestAssets.array_4,
            CBORTestAssets.array_5,
            CBORTestAssets.array_6,
            CBORTestAssets.array_7,
            CBORTestAssets.array_8,
            CBORTestAssets.array_9,
            CBORTestAssets.map_1,
            CBORTestAssets.map_2,
            CBORTestAssets.tagged_0,
            CBORTestAssets.tagged_1,
            CBORTestAssets.tagged_2,
            CBORTestAssets.tagged_3,
            CBORTestAssets.tagged_4,
            CBORTestAssets.half_0,
            CBORTestAssets.half_1,
            CBORTestAssets.float_0,
            CBORTestAssets.float_1,
            CBORTestAssets.double_0,
            CBORTestAssets.bigTest,
        ]
    )
    func testCBORParserBytes(bytes: [UInt8]) async throws {
        let parsed = try KernelCBOR.CBORParser.objectFromBytes(bytes)
        print(parsed)
    }
    
    @Test(
        arguments: [
            [.init(0)],
            [.init(1)],
            [.init(23)],
            CBORTestAssets.unsignedInt_255,
            CBORTestAssets.unsignedInt_1000,
            CBORTestAssets.unsignedInt_65535,
            CBORTestAssets.unsignedInt_10000,
            CBORTestAssets.unsignedInt_4294967295,
            CBORTestAssets.unsignedInt_1000000000000,
            CBORTestAssets.unsignedInt_18446744073709551615,
            CBORTestAssets.negativeInt_1_small,
            CBORTestAssets.negativeInt_1,
            CBORTestAssets.negativeInt_24,
            CBORTestAssets.negativeInt_256,
            CBORTestAssets.negativeInt_1000,
            CBORTestAssets.negativeInt_999999,
            CBORTestAssets.negativeInt_999999999999,
            CBORTestAssets.utf8String_1,
            CBORTestAssets.utf8String_2,
            CBORTestAssets.utf8String_3,
            CBORTestAssets.utf8String_4,
            CBORTestAssets.utf8String_5,
            CBORTestAssets.utf8String_6,
            CBORTestAssets.utf8String_7,
            CBORTestAssets.array_1,
            CBORTestAssets.array_2,
            CBORTestAssets.array_3,
            CBORTestAssets.array_4,
            CBORTestAssets.array_5,
            CBORTestAssets.array_6,
            CBORTestAssets.array_7,
            CBORTestAssets.array_8,
            CBORTestAssets.array_9,
            CBORTestAssets.map_1,
            CBORTestAssets.map_2,
            CBORTestAssets.tagged_0,
            CBORTestAssets.tagged_1,
            CBORTestAssets.tagged_2,
            CBORTestAssets.tagged_3,
            CBORTestAssets.tagged_4,
            CBORTestAssets.half_0,
            CBORTestAssets.half_1,
            CBORTestAssets.float_0,
            CBORTestAssets.float_1,
            CBORTestAssets.double_0,
            CBORTestAssets.bigTest,
        ]
    )
    func testCBORParserWriterRoundTripBytes(bytes: [UInt8]) async throws {
//        print("--ROUND TRIP START--")
//        print(bytes.toHexString())
        let parsed = try KernelCBOR.CBORParser.objectFromBytes(bytes)
//        print(parsed)
        let written = try KernelCBOR.CBORWriter.dataFromCBORType(parsed)
//        print(written.toHexString())
        let parsedAgain = try KernelCBOR.CBORParser.objectFromBytes(written)
//        print(parsedAgain)
        #expect(parsed == parsedAgain)
//        print("--ROUND TRIP END--")
    }
}
