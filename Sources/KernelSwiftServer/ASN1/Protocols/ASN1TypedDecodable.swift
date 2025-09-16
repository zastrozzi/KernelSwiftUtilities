//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 09/07/2023.
//
import Vapor

public protocol ASN1TypedDecodable: ASN1Decodable {
    //    associatedtype CodingKeys: CodingKey & Hashable & CaseIterable
    init(from asn1Type: KernelASN1.ASN1Type) throws
}

extension ASN1TypedDecodable {    
    public init(from asn1Type: KernelASN1.ASN1Type) throws {
        let decoder = KernelASN1.ASN1Decoder(asn1Type: asn1Type, decoding: Self.self)
        try self.init(from: decoder)
    }
    
    public func encode(to encoder: Encoder) throws {
        fatalError()
    }
}
