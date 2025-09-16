//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 11/10/2023.
//

import Foundation

extension UInt8 {
    public typealias hmac = HMAC
    
    public enum HMAC {
        public static let opad: UInt8 = 0x5c
        public static let ipad: UInt8 = 0x36
    }
}
