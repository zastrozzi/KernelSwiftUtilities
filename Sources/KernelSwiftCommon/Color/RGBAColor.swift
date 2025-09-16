//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 26/11/2023.
//

import Foundation

extension KernelSwiftCommon {
    public struct RGBAColor: Codable, Equatable, Sendable {
        public var r: UInt8
        public var g: UInt8
        public var b: UInt8
        public var a: Double
        
        public init(
            r: UInt8,
            g: UInt8,
            b: UInt8,
            a: Double
        ) {
            self.r = r
            self.g = g
            self.b = b
            self.a = a
        }
        
        public init(fromHex hexString: String) {
            let hex = hexString.removingCharacters(notIn: .hexadecimalDigits)
            var int = UInt64()
            Scanner(string: hex).scanHexInt64(&int)
            let r, g, b, a: UInt8
            switch hex.count {
            case 3: (r, g, b, a) = (.init(((int & 0xf00) >> 8) * 17), .init(((int & 0xf0) >> 4) * 17), .init((int & 0xf) * 17), 255)
            case 6: (r, g, b, a) = (.init((int & 0xff0000) >> 16), .init((int & 0xff00) >> 8), .init(int & 0xff), 255)
            case 8: (r, g, b, a) = (.init((int & 0xff000000) >> 24), .init((int & 0xff0000) >> 16), .init((int & 0xff00) >> 8), .init(int & 0xff))
            default: (r, g, b, a) = (0, 0, 0, 255)
            }
            self.init(r: r, g: g, b: b, a: Double(a) / 255)
        }
        
        public func toHexString(hashPrefixed: Bool = true, truncated: Bool = false, withAlpha: Bool = true) -> String {
            let withAlpha = withAlpha && a != 1
            let str: String = truncated ? .init(format: "%01lX%01lX%01lX", (r & 0xf0) >> 4, (g & 0xf0) >> 4, (b & 0xf0) >> 4) :
            (withAlpha ? .init(format: "%02lX%02lX%02lX%02lX", r, g, b, lroundf(.init(a) * 255)) : .init(format: "%02lX%02lX%02lX", r, g, b))
            return hashPrefixed ? "#" + str : str
        }
        
        public func lighter(by p: UInt = 30) -> Self {
            guard p < 100 && p > 0 else { return self }
            return .init(
                r: .init(min(Int(r) + .init((p * 255) / 100), 255)),
                g: .init(min(Int(g) + .init((p * 255) / 100), 255)),
                b: .init(min(Int(b) + .init((p * 255) / 100), 255)),
                a: a
            )
        }
        
        public func darker(by p: UInt = 30) -> Self {
            guard p < 100 && p > 0 else { return self }
            return .init(
                r: .init(max(Int(r) - .init((p * 255) / 100), 0)),
                g: .init(max(Int(g) - .init((p * 255) / 100), 0)),
                b: .init(max(Int(b) - .init((p * 255) / 100), 0)),
                a: a
            )
        }
    }
}
