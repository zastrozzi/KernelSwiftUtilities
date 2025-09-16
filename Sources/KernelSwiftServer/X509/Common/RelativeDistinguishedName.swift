//
//  File.swift
//
//
//  Created by Jonathan Forbes on 19/06/2023.
//

import Vapor

extension KernelX509.Common {
    public struct RelativeDistinguishedName: Equatable, Content, OpenAPIEncodableSampleable {
        public let attributeType: AttributeType
        public let attributeValueType: AttributeValueType
        public let stringValue: String
        
        public init(
            attributeType: KernelX509.Common.RelativeDistinguishedName.AttributeType,
            attributeValueType: KernelX509.Common.RelativeDistinguishedName.AttributeValueType,
            stringValue: String
        ) {
            self.attributeType = attributeType
            self.attributeValueType = attributeValueType
            self.stringValue = stringValue
        }
        
    }
}

extension KernelX509.Common.RelativeDistinguishedName: ASN1Buildable {
    public func buildASN1Type() -> KernelASN1.ASN1Type {
        let attributeValue: KernelASN1.ASN1Type
        switch attributeValueType {
        case .printableString: attributeValue = .printableString(.init(string: stringValue))
        case .utf8String: attributeValue = .utf8String(.init(string: stringValue))
        case .ia5String: attributeValue = .ia5String(.init(string: stringValue))
        }
        return .set([
            .sequence([
                attributeType.buildASN1Type(),
                attributeValue
            ])
        ])
    }
}

extension KernelX509.Common.RelativeDistinguishedName: ASN1Decodable {
    //    public static var asn1DecodingSchema: DecodingSchema {[]}
    
    public init(from asn1Type: KernelASN1.ASN1Type) throws {
        var asn1Type = asn1Type
        if case let .any(wrappedAny) = asn1Type {
            print(wrappedAny.underlyingData?.toHexString() ?? "", "UNDERLYING")
            var bytes = wrappedAny.underlyingData ?? [0]
            bytes[0] = .asn1.typeTag.set
            let parsed = try KernelASN1.ASN1Parser4.objectFromBytes(bytes)
            asn1Type = parsed.asn1()
        }
        
        
        guard
            case let .set(setItems) = asn1Type,
            case let .sequence(sequenceItems) = setItems[0]
        else { throw Self.decodingError(.sequence, asn1Type) }
        switch sequenceItems[1] {
        case let .printableString(printableStr):
            self.attributeValueType = .printableString
            self.stringValue = printableStr.string
        case let .utf8String(utf8Str):
            self.attributeValueType = .utf8String
            self.stringValue = utf8Str.string
        case let .ia5String(ia5String):
            self.attributeValueType = .ia5String
            self.stringValue = ia5String.string
            
        default: throw Self.decodingError(nil, asn1Type)
        }
        self.attributeType = try .init(from: sequenceItems[0])
    }
}
