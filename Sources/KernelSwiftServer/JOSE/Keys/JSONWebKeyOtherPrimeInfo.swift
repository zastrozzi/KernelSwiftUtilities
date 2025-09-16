//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 21/04/2023.
//

import Foundation

public struct JSONWebKeyOtherPrimeInfo: Codable, Equatable {
    /// Prime Factor
    /// Base64URLEncoded UInt
    public var r: String
    
    /// Factor CRT Exponent
    /// Base64URLEncoded UInt
    public var d: String
    
    /// Factor CRT Coefficient
    /// Base64URLEncoded UInt
    public var t: String
    
    public init(
        r: String,
        d: String,
        t: String
    ) {
        self.r = r
        self.d = d
        self.t = t
    }

}
