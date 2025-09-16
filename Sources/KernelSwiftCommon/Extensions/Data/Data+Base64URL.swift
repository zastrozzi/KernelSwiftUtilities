//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 22/04/2023.
//

import Foundation

extension Data {
    public init?(base64URLEncoded: String, options: Data.Base64DecodingOptions = []) {
        self.init(base64Encoded: base64URLEncoded.base64URLUnescaped(), options: options)
    }
    
    public init?(base64URLEncoded: Data, options: Data.Base64DecodingOptions = []) {
        self.init(base64Encoded: base64URLEncoded.base64URLUnescaped(), options: options)
    }
    
    public func base64URLEncodedString(options: Data.Base64EncodingOptions = []) -> String {
        return base64EncodedString(options: options).base64URLEscaped()
    }
    
    public func base64URLEncodedData(options: Data.Base64EncodingOptions = []) -> Data {
        return base64EncodedData(options: options).base64URLEscaped()
    }
    
    public mutating func base64URLUnescape() {
        for (i, byte) in self.enumerated() {
            switch byte {
            case .ascii.hyphen: self[self.index(self.startIndex, offsetBy: i)] = .ascii.plus
            case .ascii.underscore: self[self.index(self.startIndex, offsetBy: i)] = .ascii.forwardSlash
            default: break
            }
        }
        
        let padding = count % 4
        if padding > 0 {
            self += Data(repeating: .ascii.equals, count: 4 - count % 4)
        }
    }

    mutating func base64URLEscape() {
        for (i, byte) in enumerated() {
            switch byte {
            case .ascii.plus: self[self.index(self.startIndex, offsetBy: i)] = .ascii.hyphen
            case .ascii.forwardSlash: self[self.index(self.startIndex, offsetBy: i)] = .ascii.underscore
            default: break
            }
        }
        self = split(separator: .ascii.equals).first ?? .init()
    }

    func base64URLUnescaped() -> Data {
        var data = self
        data.base64URLUnescape()
        return data
    }

    func base64URLEscaped() -> Data {
        var data = self
        data.base64URLEscape()
        return data
    }
}
