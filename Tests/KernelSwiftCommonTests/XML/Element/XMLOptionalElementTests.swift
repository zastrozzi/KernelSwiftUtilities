//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 19/06/2025.
//

import Testing
import KernelSwiftCommon

private struct ExpectNonNil: Decodable, Equatable {
    var optional: String? = ""
    
    private enum CodingKeys: String, CodingKey {
        case optional
    }
    
    init() {}
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if container.contains(.optional) {
            optional = try container.decode(String.self, forKey: .optional)
        }
    }
}

private struct ExpectOptional: Decodable, Equatable {
    var optional: String? = ""
    
    private enum CodingKeys: String, CodingKey {
        case optional
    }
    
    init() {}
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if container.contains(.optional) {
            optional = try container.decode(String?.self, forKey: .optional)
        }
    }
}

private struct DecodeIfPresent: Decodable, Equatable {
    var optional: String? = ""
    
    private enum CodingKeys: String, CodingKey {
        case optional
    }
    
    init() {}
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        optional = try container.decodeIfPresent(String.self, forKey: .optional)
    }
}

@Suite
struct XMLOptionalElementTests {
    @Test
    func testOptionalElements() throws {
        let decoder = KernelXML.XMLDecoder()
        
        let xml = """
        <container><optional></optional></container>
        """.data(using: .utf8)!
        
        let decoded1 = try decoder.decode(ExpectOptional.self, from: xml)
        #expect(decoded1 == ExpectOptional())
        let decoded2 = try decoder.decode(DecodeIfPresent.self, from: xml)
        #expect(decoded2 == DecodeIfPresent())
    }
}
