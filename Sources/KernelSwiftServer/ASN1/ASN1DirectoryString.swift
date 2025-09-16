//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 10/07/2023.
//

extension KernelASN1 {
    public enum ASN1DirectoryString {
        case printableString(ASN1PrintableString)
        case utf8String(ASN1UTF8String)
        case t61String(ASN1T61String)
        case ia5String(ASN1IA5String)
        case graphicString(ASN1GraphicString)
        case generalString(ASN1GeneralString)
    }
}

extension KernelASN1.ASN1DirectoryString: ASN1Decodable {
    public init(from asn1Type: KernelASN1.ASN1Type) throws {
        switch asn1Type {
        case let .printableString(str): self = .printableString(str)
        case let .utf8String(str): self = .utf8String(str)
        case let .t61String(str): self = .t61String(str)
        case let .ia5String(str): self = .ia5String(str)
        case let .graphicString(str): self = .graphicString(str)
        case let .generalString(str): self = .generalString(str)
        default: throw Self.decodingError(nil, asn1Type)
        }
    }
    
    public init(from decoder: Decoder) throws {
        fatalError()
    }
}

extension KernelASN1.ASN1DirectoryString: ASN1Buildable {
    public func buildASN1Type() -> KernelASN1.ASN1Type {
        switch self {
        case let .printableString(str): .printableString(str)
        case let .utf8String(str): .utf8String(str)
        case let .t61String(str): .t61String(str)
        case let .ia5String(str): .ia5String(str)
        case let .graphicString(str): .graphicString(str)
        case let .generalString(str): .generalString(str)
        }
    }
}
