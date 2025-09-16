//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 05/07/2023.
//
//import Vapor

//extension MutableCollection where Element == UInt8, Self: BidirectionalCollection, Self: RangeReplaceableCollection {
//    public mutating func base64URLEscape() {
//        for (i, byte) in enumerated() {
//            switch byte {
//            case .ascii.plus: self[self.index(self.startIndex, offsetBy: i)] = .ascii.hyphen
//            case .ascii.forwardSlash: self[self.index(self.startIndex, offsetBy: i)] = .ascii.underscore
//            default: break
//            }
//        }
//        self.trimSuffix { char in
//            char == .ascii.equals
//        }
//    }
//    
//    public mutating func base64URLUnescape() {
//        for (i, byte) in self.enumerated() {
//            switch byte {
//            case .ascii.hyphen: self[self.index(self.startIndex, offsetBy: i)] = .ascii.plus
//            case .ascii.underscore: self[self.index(self.startIndex, offsetBy: i)] = .ascii.forwardSlash
//            default: break
//            }
//        }
//        
//        let padding = count % 4
//        if padding > 0 {
//            self.append(contentsOf: Array<UInt8>.init(repeating: .ascii.equals, count: 4 - count % 4))
//        }
//    }
//    
//    public func base64URLUnescaped() -> Self {
//        var data = self
//        data.base64URLUnescape()
//        return data
//    }
//    
//    public func base64URLEscaped() -> Self {
//        var data = self
//        data.base64URLEscape()
//        return data
//    }
//    
////    public func base64URLEncodedString(options: Data.Base64EncodingOptions = []) -> String {
////        return base64EncodedString(options: options).base64URLEscaped()
////    }
//}
//
//extension Collection where Element == UInt8 {
//    public func hexEncodedBytes(uppercase: Bool = false) -> [UInt8] {
//        let table: [UInt8] = uppercase ? radix16table_uppercase : radix16table_lowercase
//        
//        return .init(unsafeUninitializedCapacity: self.count * 2) { buffer, outCount in
//            for byte in self {
//                let nibs = byte.quotientAndRemainder(dividingBy: 16)
//                
//                buffer[outCount + 0] = table[numericCast(nibs.quotient)]
//                buffer[outCount + 1] = table[numericCast(nibs.remainder)]
//                outCount += 2
//            }
//        }
//    }
//}
