//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 09/07/2023.
//
import Vapor

public protocol ASN1ArrayBuildable {
    func buildASN1TypeArray() -> [KernelASN1.ASN1Type]
}
