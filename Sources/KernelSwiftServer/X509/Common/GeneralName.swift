//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 10/07/2023.
//

import Vapor

extension KernelX509.Common {
    public enum GeneralName {
        case otherName(OtherName)
        case rfc822Name(KernelASN1.ASN1IA5String)
        case dnsName(KernelASN1.ASN1IA5String)
        case x400Address(KernelASN1.ASN1IA5String) // Dangerous to leave this as simply 'ASN1Type'. See CVE-2023-0286. Should be an ORAddress eventually.
        case directoryName(DistinguishedName)
        case ediPartyName(EDIPartyName)
        case uniformResourceIdentifier(KernelASN1.ASN1IA5String)
        case ipAddress(KernelASN1.ASN1OctetString)
        case registeredID(KernelASN1.ASN1ObjectIdentifier)
    }
}

extension KernelX509.Common.GeneralName: ASN1Decodable, ASN1Buildable {
    public init(from asn1Type: KernelASN1.ASN1Type) throws {
        guard case let .tagged(tag, .implicit(taggedASN1Type)) = asn1Type else { throw Self.decodingError(nil, asn1Type) }
        switch tag {
        case 0: self = .otherName(try .init(from: taggedASN1Type))
        case 1: self = .rfc822Name(try .init(from: taggedASN1Type))
        case 2: self = .dnsName(try .init(from: taggedASN1Type))
        case 3: self = .x400Address(try .init(from: taggedASN1Type))
        case 4: self = .directoryName(try .init(from: taggedASN1Type))
        case 5: self = .ediPartyName(try .init(from: taggedASN1Type))
        case 6: self = .uniformResourceIdentifier(try .init(from: taggedASN1Type))
        case 7: self = .ipAddress(try .init(from: taggedASN1Type))
        case 8: self = .registeredID(try .init(from: taggedASN1Type))
        default:
            print("FAILED GENERAL NAME DECODE", tag, taggedASN1Type)
            throw Self.decodingError(nil, asn1Type)
        }
    }
    
    public init(from decoder: Decoder) throws {
        fatalError()
    }
    
    public func buildASN1Type() -> KernelASN1.ASN1Type {
        switch self {
        case let .otherName(wrapped): .tagged(0, .implicit(wrapped.buildASN1Type()))
        case let .rfc822Name(wrapped): .tagged(1, .implicit(wrapped.buildASN1Type()))
        case let .dnsName(wrapped): .tagged(2, .implicit(wrapped.buildASN1Type()))
        case let .x400Address(wrapped): .tagged(3, .implicit(wrapped.buildASN1Type()))
        case let .directoryName(wrapped): .tagged(4, .implicit(wrapped.buildASN1Type()))
        case let .ediPartyName(wrapped): .tagged(5, .implicit(wrapped.buildASN1Type()))
        case let .uniformResourceIdentifier(wrapped): .tagged(6, .implicit(wrapped.buildASN1Type()))
        case let .ipAddress(wrapped): .tagged(7, .implicit(wrapped.buildASN1Type()))
        case let .registeredID(wrapped): .tagged(8, .implicit(wrapped.buildASN1Type()))
        }
    }
}
