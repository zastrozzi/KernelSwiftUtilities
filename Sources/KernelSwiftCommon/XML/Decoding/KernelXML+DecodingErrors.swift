//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 19/06/2025.
//

import Foundation

extension DecodingError {
    static func typeMismatch(at path: [CodingKey], expectation: Any.Type, found: KernelXML.Boxable) -> DecodingError {
        let description = "Expected to decode \(expectation) but found \(typeDescription(of: found)) instead."
        return .typeMismatch(expectation, Context(codingPath: path, debugDescription: description))
    }
    
    static func typeDescription(of box: KernelXML.Boxable) -> String {
        switch box {
        case is KernelXML.NullBox:
            return "a null value"
        case is KernelXML.BooleanBox:
            return "a boolean value"
        case is KernelXML.DecimalBox:
            return "a decimal value"
        case is KernelXML.IntBox:
            return "a signed integer value"
        case is KernelXML.UIntBox:
            return "an unsigned integer value"
        case is KernelXML.FloatBox:
            return "a floating-point value"
        case is KernelXML.DoubleBox:
            return "a double floating-point value"
        case is KernelXML.UnkeyedBox:
            return "a array value"
        case is KernelXML.KeyedBox:
            return "a dictionary value"
        case _:
            return "\(type(of: box))"
        }
    }
}
