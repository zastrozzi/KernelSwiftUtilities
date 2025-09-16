//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 17/10/2024.
//

import OpenAPIKit30
import Yams
import Vapor

extension OpenAPI {
    public static var jsonEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .sortedKeys
        return encoder
    }
    
    public static var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    
    public static var yamlDecoder: YAMLDecoder {
        let decoder = YAMLDecoder()
        return decoder
    }
    
    public static var yamlEncoder: YAMLEncoder {
        let encoder = YAMLEncoder()
        return encoder
    }
}
