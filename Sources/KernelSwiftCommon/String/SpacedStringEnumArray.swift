//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 08/09/2023.
//

import Foundation

public struct SpacedStringEnumArray<Value: RawRepresentable & Codable & Equatable & CaseIterable & Sendable>: Codable, Equatable, Sendable where Value.RawValue == String {
    public var value: [Value]
    
    public init(_ elements: [Value]) {
        self.value = elements
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        let rawElements = string.components(separatedBy: " ")
        let convertedElements = rawElements.compactMap { Value(rawValue: $0) }
        self.value = convertedElements
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let elementStrings = value.map { $0.rawValue }
        let spacedString = elementStrings.joined(separator: " ")
        try container.encode(spacedString)
    }
    
    public func toString() -> String {
        let elementStrings = value.map { $0.rawValue }
        let spacedString = elementStrings.joined(separator: " ")
        return spacedString
    }
}
