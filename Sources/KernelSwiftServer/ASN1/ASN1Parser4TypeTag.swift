//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 27/09/2023.
//

import Foundation

extension KernelASN1 {
    public enum ASN1Parser4TypeTag: Equatable, CustomDebugStringConvertible {
        case universal(tag: ASN1UniversalTag)
        case application(tag: UInt8)
        case contextSpecificSimple(tag: UInt8)
        case contextSpecificStructured(tagBytes: [UInt8])
        case `private`(tag: UInt8)
        
        public static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case let (.universal(lhsTag), .universal(rhsTag)): lhsTag == rhsTag
            case let (.application(lhsTag), .application(rhsTag)): lhsTag == rhsTag
            case let (.contextSpecificSimple(lhsTag), .contextSpecificSimple(rhsTag)): lhsTag == rhsTag
            case let (.contextSpecificStructured(lhsTag), .contextSpecificStructured(rhsTag)): lhsTag == rhsTag
            case let (.private(lhsTag), .private(rhsTag)): lhsTag == rhsTag
            default: false
            }
        }
        
        public func hash(into hasher: inout Hasher) {
            String(describing: self).hash(into: &hasher)
        }
        
        public var debugDescription: String {
            switch self {
            case let .universal(tag): ".universal(\(tag.debugDescription))"
            case let .application(tag): ".application(\(tag))"
            case let .contextSpecificSimple(tag): ".contextSpecificSimple(\(tag.toHexOctetString()))"
            case let .contextSpecificStructured(tagBytes): ".contextSpecificStructured(\(tagBytes.toHexString()))"
            case let .private(tag): ".private(\(tag))"
            }
        }
        
        public var length: Int {
            if case let .contextSpecificStructured(tagBytes) = self { tagBytes.count + 1 }
            else { 1 }
        }
    }
}
