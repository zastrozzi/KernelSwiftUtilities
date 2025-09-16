//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 09/07/2023.
//

import KernelSwiftCommon

public protocol ASN1Decodable: Decodable, Encodable, Sendable {
    init(from asn1Type: KernelASN1.ASN1Type) throws
}

extension Optional: ASN1Decodable where Wrapped: ASN1Decodable {}

extension ASN1Decodable {    
    public init(from asn1Type: KernelASN1.ASN1Type) throws {
        let decoder = KernelASN1.ASN1Decoder(asn1Type: asn1Type, decoding: Self.self)
        try self.init(from: decoder)
    }
    
    public func encode(to encoder: Encoder) throws {
        throw KernelASN1.TypedError(.notImplemented)
    }
    
    public init(from decoder: Decoder) throws {
        throw KernelASN1.TypedError(.notImplemented)
    }
    
    public static func decodingError(_ expecting: KernelASN1.ASN1Type.RawType? = nil, _ context: KernelASN1.ASN1Type? = nil) -> KernelASN1.TypedError {
        return KernelASN1.TypedError.decodingFailed(Self.self, expected: expecting, context: context)
    }
    
    public static func decodingError(_ expecting: KernelASN1.ASN1Type.RawType? = nil, type: KernelASN1.ASN1Type.VerboseTypeWithMetadata? = nil) -> KernelASN1.TypedError {
        return KernelASN1.TypedError.decodingFailed(Self.self, expected: expecting, context: type?.type.toASN1Type())
    }
}

