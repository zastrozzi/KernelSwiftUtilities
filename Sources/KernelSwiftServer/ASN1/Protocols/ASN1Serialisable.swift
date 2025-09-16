//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 09/07/2023.
//
import Vapor

public protocol ASN1Serialisable: ASN1Buildable {
    func serialiseForASN1() -> [UInt8]
}

extension ASN1Serialisable {
    public func serialiseForASN1() -> [UInt8] {
        let built = buildASN1Type()
        return KernelASN1.ASN1Writer.dataFromObject(built)
    }
}
