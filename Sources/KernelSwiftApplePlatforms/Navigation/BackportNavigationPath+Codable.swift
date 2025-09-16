//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 31/08/2022.
//

import Foundation

#if compiler(>=5.7)
@available(iOS, deprecated: 17.0, message: "Use SwiftUI Navigation API")
extension BackportNavigationPath {
    public struct CodableRepresentation {
        static let encoder = JSONEncoder()
        static let decoder = JSONDecoder()
        
        public init(elements: [Codable]) {
            self.elements = elements
        }
        
        public var elements: [Codable]
    }
    
    public var codable: CodableRepresentation? {
        if #available(iOS 14.0, *) {
            let codableElements = elements.compactMap { $0 as? Codable }
            guard codableElements.count == elements.count else { return nil }
            
            return CodableRepresentation(elements: codableElements)
        } else {
            return nil
        }
    }
    
    public init(_ codable: CodableRepresentation) {
        self.init(codable.elements.map { ($0 as Any) as! AnyHashable })
    }
}


@available(iOS, deprecated: 17.0, message: "Use SwiftUI Navigation API")
extension BackportNavigationPath.CodableRepresentation: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        for element in elements.reversed() {
            if #available(iOS 14.0, *) {
                guard let typeName = _mangledTypeName(type(of: element)) else {
                    throw encodingError("Unable to create '_mangledTypeName' from \(String(describing: type(of: element)))")
                }
                try container.encode(typeName)
            } else {
                throw encodingError("BackportNavigationPath CodableRepresentation unavailable for this platform")
            }
            #if swift(<5.7)
            let data = try Self.encodeExistential(element)
            let string = String(decoding: data, as: UTF8.self)
            try container.encode(string)
            #else
            let string = try String(decoding: Self.encoder.encode(element), as: UTF8.self)
            try container.encode(string)
            #endif
        }
    }
    
    fileprivate func encodingError(_ description: String) -> EncodingError {
        let context = EncodingError.Context(codingPath: [], debugDescription: description)
        return EncodingError.invalidValue(elements, context)
    }
    
    fileprivate static func encodeExistential(_ element: Encodable) throws -> Data {
        func encodeOpened<A: Encodable>(_ element: A) throws -> Data {
            try BackportNavigationPath.CodableRepresentation.encoder.encode(element)
        }
        
        return try _openExistential(element, do: encodeOpened(_:))
    }
}


@available(iOS, deprecated: 17.0, message: "Use SwiftUI Navigation API")
extension BackportNavigationPath.CodableRepresentation: Decodable {
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        self.elements = []
        
        while !container.isAtEnd {
            let typeName = try container.decode(String.self)
            guard let type = _typeByName(typeName) else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot instantiate type from name '\(typeName)'")
            }
            
            guard let codableType = type as? Codable.Type else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "'\(typeName)' does not conform to Codable.")
            }
            
            let encodedValue = try container.decode(String.self)
            let data = Data(encodedValue.utf8)
            
            #if swift(<5.7)
            func decodeExistential(type: Codable.Type) throws -> Codable {
                func decodeOpened<A: Codable>(type: A.Type) throws -> A {
                    try BackportNavigationPath.CodableRepresentation.decoder.decode(A.self, from: data)
                }
                return try _openExistential(type, do: decodeOpened)
            }
            let value = try decodeExistential(type: codableType)
            #else
            let value = try Self.decoder.decode(codableType, from: data)
            #endif
            
            self.elements.insert(value, at: 0)
        }
    }
}


@available(iOS, deprecated: 17.0, message: "Use SwiftUI Navigation API")
extension BackportNavigationPath.CodableRepresentation: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        do {
            let encodedLhs = try encodeExistential(lhs)
            let encodedRhs = try encodeExistential(rhs)
            return encodedLhs == encodedRhs
        } catch {
            return false
        }
    }
}


@available(iOS, deprecated: 17.0, message: "Use SwiftUI Navigation API")
extension BackportNavigationPath: Equatable {
    public static func == (lhs: BackportNavigationPath, rhs: BackportNavigationPath) -> Bool {
        lhs.elements.map { $0.hashValue } == rhs.elements.map { $0.hashValue }
    }
}
#endif
