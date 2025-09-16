//
//  File.swift
//
//
//  Created by Jonathan Forbes on 29/03/2022.
//

import Foundation

public protocol SafeDecodable: RawRepresentable, Decodable {
    static var fallback: Self { get }
}

extension SafeDecodable where RawValue: Decodable {
    public init(from decoder: Decoder) throws {
        do {
            let container = try decoder.singleValueContainer()
            let rawValue = try container.decode(RawValue.self)
            self = Self(rawValue: rawValue) ?? .fallback
        } catch {
            self = .fallback
        }
    }
}
