//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 31/03/2025.
//

import Testing
import KernelSwiftCommon

@Suite
struct URIEncoderTests {
    @Test
    func testEncodedDeep() throws {
        struct TestStruct: Encodable {
            
            var foo: String?
            var nestedFoo: NestedStruct
        }
        struct NestedStruct: Encodable {
            var grandNestedFoo: GrandNestedStruct
            var foo: String
        }
        struct GrandNestedStruct: Encodable {
            var foos: [String]
        }
        
        let serializer = KernelNetworking.URISerializer(configuration: .init(style: .deepObject, explode: true, spaceEscapingCharacter: .percentEncoded))
        let encoder = KernelNetworking.URIEncoder(serializer: serializer)
        let encodedString = try encoder.encode(TestStruct(foo: "bar", nestedFoo: .init(grandNestedFoo: .init(foos: ["bar1", "bar2"]), foo: "bar")), forKey: "")
        #expect(encodedString == "foo=bar&nestedFoo%5Bfoo%5D=bar&nestedFoo%5BgrandNestedFoo%5D%5Bfoos%5D=bar1&nestedFoo%5BgrandNestedFoo%5D%5Bfoos%5D=bar2")
    }
    
    @Test
    func testEncodedPrimitive() throws {
        let serializer = KernelNetworking.URISerializer(configuration: .init(style: .form, explode: true, spaceEscapingCharacter: .percentEncoded))
        let encoder = KernelNetworking.URIEncoder(serializer: serializer)
        let encodedString = try encoder.encode("bar", forKey: "foo")
        #expect(encodedString == "foo=bar")
    }
}
