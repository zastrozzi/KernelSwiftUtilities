//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 10/10/2024.
//

public struct CommaSeparatedStringEnumSet<
    Value: RawRepresentable & Codable & Equatable & CaseIterable & Sendable & Hashable
>: Codable, Equatable, Sendable, LosslessStringConvertible, ExpressibleByArrayLiteral
where Value.RawValue == String {
    public typealias ArrayLiteralElement = Value
    
    public init?(_ description: String) {
        let rawElements = description.components(separatedBy: ",")
        let convertedElements = rawElements.compactMap { Value(rawValue: $0) }
        self.value = .init(convertedElements)
    }
    
    public var description: String {
        self.toString()
    }
    
    public var value: Set<Value>
    
    public init(_ elements: Set<Value>) {
        self.value = elements
    }
    
    public init(arrayLiteral elements: Value...) {
        self.value = .init(elements)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        let rawElements = string.components(separatedBy: ",")
        let convertedElements = rawElements.compactMap { Value(rawValue: $0) }
        self.value = .init(convertedElements)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let elementStrings = value.map { $0.rawValue }
        let spacedString = elementStrings.joined(separator: ",")
        try container.encode(spacedString)
    }
    
    public func toString() -> String {
        let elementStrings = value.map { $0.rawValue }
        let spacedString = elementStrings.joined(separator: ",")
        return spacedString
    }
}
