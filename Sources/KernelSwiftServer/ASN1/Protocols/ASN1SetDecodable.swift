//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 09/07/2023.
//
import Vapor

public protocol ASN1SetDecodable: Decodable, Encodable {}
extension Set: ASN1Decodable where Element: ASN1SetDecodable {}
