//
//  File.swift
//
//
//  Created by Jonathan Forbes on 18/09/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelCBOR {
    public enum CBORType: Sendable {
        case unsignedInt(UInt64)
        case negativeInt(UInt64)
        case byteString([UInt8])
        case utf8String(String)
        indirect case array([CBORType])
        indirect case map([CBORType: CBORType])
        indirect case tagged(CBORTag, CBORType)
        case simple(UInt8)
        case boolean(Bool)
        case null
        case undefined
        case half(KernelNumerics.UniversalFloat16)
        case float(Float32)
        case double(Float64)
        case `break`
        case date(Date)
    }
}

extension KernelCBOR.CBORType: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case let .unsignedInt(value): "unsignedInt(\(value))"
        case let .negativeInt(value): "negativeInt(\(value))"
        case let .byteString(value): "byteString(\(value.toHexString()))"
        case let .utf8String(value): "utf8String(\(value))"
        case let .array(array): "array(" + array.map { $0.debugDescription }.joined(separator: ", ") + ")"
        case let .map(dict): "map(" + dict.map { $0.key.debugDescription + ":" + $0.value.debugDescription }.joined(separator: ", ") + ")"
        case let .tagged(tag, type): "tagged(\(tag.rawValue)," + type.debugDescription + ")"
        case let .simple(value): "simple(\(value))"
        case let .boolean(value): "boolean(\(value))"
        case .null: "null"
        case .undefined: "undefined"
        case let .half(value): "half(\(value))"
        case let .float(value): "float(\(value))"
        case let .double(value): "double(\(value))"
        case .break: "break"
        case let .date(value): "date(\(value))"
        }
    }
}

extension KernelCBOR.CBORType: ExpressibleByArrayLiteral, ExpressibleByBooleanLiteral, ExpressibleByDictionaryLiteral, ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral, ExpressibleByNilLiteral, ExpressibleByStringLiteral {
    public init(arrayLiteral elements: Self...) { self = .array(elements) }
    public init(booleanLiteral value: Bool) { self = .boolean(value) }
    public init(dictionaryLiteral elements: (Self, Self)...) { self = .map(elements.reduce(into: [:]) { $0[$1.0] = $1.1 }) }
    public init(floatLiteral value: Float32) { self = .float(value) }
    public init(integerLiteral value: Int) { self = value < 0 ? .negativeInt(~.init(bitPattern: .init(value))) : .unsignedInt(.init(value)) }
    public init(nilLiteral: ()) { self = .null }
    
    public init(extendedGraphemeClusterLiteral value: String) { self = .utf8String(value) }
    public init(unicodeScalarLiteral value: String) { self = .utf8String(value) }
    public init(stringLiteral value: String) { self = .utf8String(value) }
}

extension KernelCBOR.CBORType {
    public subscript(index: Self) -> Self? {
        get {
            switch (self, index) {
            case let (.array(arg0), .unsignedInt(arg1)): arg0[Int(arg1)]
            case let (.map(arg0), arg1): arg0[arg1]
            default: nil
            }
        }
        
        set {
            switch (self, index) {
            case let (.array(arg0), .unsignedInt(arg1)):
                var newArg0 = arg0
                if let newValue, newArg0.endIndex >= Int(arg1) { newArg0[Int(arg1)] = newValue }
                self = .array(newArg0)
            case let (.map(arg0), arg1):
                var newArg0 = arg0
                newArg0[arg1] = newValue // not sure if we should be doing a null check here on newValue. Let's wait and see...
                self = .map(newArg0)
            default: break
            }
        }
    }
}

extension KernelCBOR.CBORType: Equatable, Hashable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.unsignedInt(arg0), .unsignedInt(arg1)): arg0 == arg1
        case let (.negativeInt(arg0), .negativeInt(arg1)): arg0 == arg1
        case let (.byteString(arg0), .byteString(arg1)): arg0 == arg1
        case let (.utf8String(arg0), .utf8String(arg1)): arg0 == arg1
        case let (.array(arg0), .array(arg1)): arg0 == arg1
        case let (.map(arg0), .map(arg1)): arg0 == arg1
        case let (.tagged(arg0Tag, arg0Type), .tagged(arg1Tag, arg1Type)): arg0Tag == arg1Tag && arg0Type == arg1Type
        case let (.simple(arg0), .simple(arg1)): arg0 == arg1
        case let (.boolean(arg0), .boolean(arg1)): arg0 == arg1
        case
            (.null, .null),
            (.undefined, .undefined),
            (.break, .break): true
        case let (.half(arg0), .half(arg1)): arg0 == arg1
        case let (.float(arg0), .float(arg1)): arg0 == arg1
        case let (.double(arg0), .double(arg1)): arg0 == arg1
        case let (.date(arg0), .date(arg1)): arg0 == arg1
        default: false
        }
    }
}
