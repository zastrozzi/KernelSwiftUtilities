//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 21/04/2023.
//

import Foundation

public struct JSONWebKeySet: Codable {
//    public static func == (lhs: JSONWebKeySet, rhs: JSONWebKeySet) -> Bool {
//        return lhs.keys.elementsEqual(rhs.keys) { k1, k2 in
//            RSAJSONWebKey.equals(lhs: k1, rhs: k2)
//        }
//    }
    
    public var keys: [JSONWebKey]
    
    public init(keys: [JSONWebKey]) {
        self.keys = keys
    }
    
//    public init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        let anyKeys = try values.decode([AnyJSONWebKey].self, forKey: .keys)
//        keys = try anyKeys.map { try $0.concrete() }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        let anyKeys = try keys.map { try $0.concrete(type: AnyJSONWebKey.self) }
//        try container.encode(anyKeys, forKey: .keys)
//    }
    
    public enum CodingKeys: String, CodingKey {
        case keys
    }
    
//    public static func decodeKeys<K: JSONWebKey>(from data : Data) throws -> K
//    {
//        return try JSONDecoder().decode(K.self, from: data)
//    }
}
