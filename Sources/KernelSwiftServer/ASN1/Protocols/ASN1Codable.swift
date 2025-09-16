//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 09/07/2023.
//
import Vapor

public protocol ASN1Codable: Equatable, Sendable {
    var underlyingData: [UInt8]? { get set }
    func isEqualTo<O: ASN1Codable>(_ other: O) -> Bool
}

extension ASN1Codable {
    public func isEqualTo<O: ASN1Codable>(_ other: O) -> Bool {
        return false
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.isEqualTo(rhs)
    }
}
