//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 21/02/2022.
//

import Foundation

public protocol Modelable: Codable, Printable {
    var isFault: Bool { get }

    static var encodingStrategy: JSONEncodingStrategy { get }
    static var decodingStrategy: JSONDecodingStrategy { get }

    func encoded() throws -> Data
    static func decoded(_ data: Data) throws -> Self
}

extension Modelable {
    public var isFault: Bool {
        return false
    }

    public static var encodingStrategy: JSONEncodingStrategy {
        return JSONEncodingStrategy()
    }
    public static var decodingStrategy: JSONDecodingStrategy {
        return JSONDecodingStrategy()
    }

    public func encoded() throws -> Data {
        return try encoded(Self.encodingStrategy)
    }

    public static func decoded(_ data: Data) throws -> Self {
        return try decoded(data, using: Self.decodingStrategy)
    }
}

extension Modelable {
    public var debugDescription: String {
        do {
            let data = try encoded()
            return "[\(type(of: self))] \(data.utf8Description)"
        } catch {
            return "<invalid>"
        }
    }
}

public struct NoModel: Modelable { }

extension Array: Modelable where Element: Modelable {
    public func encoded() throws -> Data {
        return try encoded(Element.encodingStrategy)
    }

    public static func decoded(_ data: Data) throws -> Self {
        return try decoded(data, using: Element.decodingStrategy)
    }
}
