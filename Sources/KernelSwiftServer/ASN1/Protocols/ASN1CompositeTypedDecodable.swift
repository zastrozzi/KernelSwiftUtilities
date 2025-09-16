//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 09/07/2023.
//
import Vapor

public protocol ASN1CompositeTypedDecodable: ASN1Decodable {
    static var compositeCount: Int { get }
    init(from asn1TypeArray: [KernelASN1.ASN1Type]) throws
}
