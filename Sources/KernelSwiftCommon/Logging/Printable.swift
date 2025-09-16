//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 21/02/2022.
//

import Foundation

public typealias Printable = CustomStringConvertible & CustomDebugStringConvertible

extension CustomDebugStringConvertible where Self: RawRepresentable, Self.RawValue == String {
    public var debugDescription: String {
        return rawValue
    }
}

extension CustomStringConvertible where Self: CustomDebugStringConvertible {
    public var description: String {
        return debugDescription
    }
}
