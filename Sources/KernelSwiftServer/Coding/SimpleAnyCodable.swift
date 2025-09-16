//
//  File.swift
//
//
//  Created by Jonathan Forbes on 04/04/2022.
//

import Foundation

struct SimpleAnyCodable : Encodable {
    private let _encode: (Encoder) throws -> Void
    
    let base: Codable
    let codableType: SimpleAnyCodableType

    init<Base : Codable>(_ base: Base) {
        self.base = base
        self._encode = {
            var container = $0.singleValueContainer()
            try container.encode(base)
        }
        self.codableType = SimpleAnyCodableType(type(of: base))
    }

    func encode(to encoder: Encoder) throws {
        try _encode(encoder)
    }
}

struct SimpleAnyCodableType {
    private let _decodeJSON: (JSONDecoder, Data) throws -> SimpleAnyCodable

    let base: Codable.Type

    init<Base : Codable>(_ base: Base.Type) {
        self.base = base
        self._decodeJSON = { decoder, data in
            SimpleAnyCodable(try decoder.decode(base, from: data))
        }
    }

    func decode(from decoder: JSONDecoder, data: Data) throws -> SimpleAnyCodable {
        return try _decodeJSON(decoder, data)
    }
}

