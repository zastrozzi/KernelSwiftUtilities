//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 13/05/2023.
//

import Collections

extension Dictionary where Key == String {
    public func value(for key: CodingKey) throws -> Value {
        guard let value = self[key.stringValue] else {
            throw DecodingError.valueNotFound(Value.self, .init(codingPath: [key], debugDescription: "No value found for key '\(key.stringValue)' in dictionary \(self)"))
        }
        return value
    }
}

extension TreeDictionary where Key == String {
    public func value(for key: CodingKey) throws -> Value {
        guard let value = self[key.stringValue] else {
            throw DecodingError.valueNotFound(Value.self, .init(codingPath: [key], debugDescription: "No value found for key '\(key.stringValue)' in dictionary \(self)"))
        }
        return value
    }
}
