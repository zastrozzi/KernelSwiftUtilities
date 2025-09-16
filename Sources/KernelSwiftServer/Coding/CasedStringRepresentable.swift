//
//  File.swift
//
//
//  Created by Jonathan Forbes on 04/11/2022.
//

import Foundation

public protocol CapitalisedStringRepresentable: Codable, RawRepresentable where RawValue == String {}
public protocol LowercasedStringRepresentable: Codable, RawRepresentable where RawValue == String {}
public protocol UppercasedStringRepresentable: Codable, RawRepresentable where RawValue == String {}

extension CapitalisedStringRepresentable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawString = try container.decode(String.self)
        let lowercasedString = rawString.lowercased()
        let capitalisedString = lowercasedString.capitalized
        if let capitalisedCase = Self(rawValue: capitalisedString) {
            self = capitalisedCase
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot initialize capitalised \(Self.self) from invalid String value \(rawString)")
        }
    }
}

extension LowercasedStringRepresentable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawString = try container.decode(String.self)
        let lowercasedString = rawString.lowercased()
        if let lowercasedCase = Self(rawValue: lowercasedString) {
            self = lowercasedCase
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot initialize lowercased \(Self.self) from invalid String value \(rawString)")
        }
    }
}

extension UppercasedStringRepresentable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawString = try container.decode(String.self)
        let uppercasedString = rawString.uppercased()
        if let uppercasedCase = Self(rawValue: uppercasedString) {
            self = uppercasedCase
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot initialize uppercased \(Self.self) from invalid String value \(rawString)")
        }
    }
}
