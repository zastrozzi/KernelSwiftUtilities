//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 11/07/2023.
//

import Vapor
import KernelSwiftCommon

extension KernelX509.Policy {
    public enum DisplayText {
        case ia5String(String)
        case visibleString(String)
        case bmpString(String)
        case utf8String(String)
    }
}

extension KernelX509.Policy.DisplayText: ASN1Decodable, ASN1Buildable {
    public init(from asn1Type: KernelASN1.ASN1Type) throws {
//        print("trying...", asn1Type)
        switch asn1Type {
        case let .ia5String(asn1String):
            self = .ia5String(asn1String.string)
            return
        case let .visibleString(asn1String):
            self = .visibleString(asn1String.string)
            return
        case let .bmpString(asn1String):
            self = .bmpString(asn1String.string)
            return
        case let .utf8String(asn1String):
            self = .utf8String(asn1String.string)
            return
        default:
            throw Self.decodingError(nil, asn1Type)
        }
    }
    
    public init(from decoder: Decoder) throws {
        fatalError()
    }
    
    public func buildASN1Type() -> KernelASN1.ASN1Type {
        switch self {
        case let .ia5String(nativeString): .ia5String(.init(string: nativeString))
        case let .visibleString(nativeString): .visibleString(.init(string: nativeString))
        case let .bmpString(nativeString): .bmpString(.init(string: nativeString))
        case let .utf8String(nativeString): .utf8String(.init(string: nativeString))
        }
    }
}
