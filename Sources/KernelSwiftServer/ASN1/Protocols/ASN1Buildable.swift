//
//  File.swift
//
//
//  Created by Jonathan Forbes on 09/07/2023.
//
import Vapor

public protocol ASN1Buildable {
    func buildASN1Type() -> KernelASN1.ASN1Type
}

extension ASN1Buildable {
    public func buildTaggedASN1Type(tag: UInt8, _ type: KernelASN1.ASN1Type.RawTaggedType) throws -> KernelASN1.ASN1Type {
        switch type {
        case .explicit: return .tagged(UInt(tag), .explicit(buildASN1Type()))
        case .implicit: return .tagged(UInt(tag), .implicit(buildASN1Type()))
        case .constructed: return .tagged(UInt(tag), .constructed([buildASN1Type()]))
            
        }
    }
}
