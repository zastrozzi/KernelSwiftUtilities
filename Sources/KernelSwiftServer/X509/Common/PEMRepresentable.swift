//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/06/2023.
//
import Vapor

public protocol X509PEMRepresentable {
    var pemRepresentation: String { get }
}

public protocol X509RawRepresentable {
    var rawRepresentation: Data { get }
}
