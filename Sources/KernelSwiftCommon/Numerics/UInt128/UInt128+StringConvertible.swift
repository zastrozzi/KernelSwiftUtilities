//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 05/11/2023.
//

import Foundation

extension KernelNumerics.UInt128 {
    public init(_ str: String, radix: Int) {
        if radix < 2 || radix > 36 { self.init(); return }
        if str.isEmpty { self.init(); return }
        let d = DoubleWord.val.little.radix.allDigits[radix]
        let dg = str.count / d
        let p = DoubleWord.val.little.radix.all[radix]
        var g = str.count - dg * d
        if g == .zero { g = d }
        var dw: [DoubleWord] = [.zero], i = Int.zero, si = str.startIndex, ei = si
        while si != str.endIndex {
            ei = str.index(after: ei)
            i += 1
            if i == g {
                guard let w: DoubleWord = .init(str[si..<ei], radix: radix) else { self.init(); return }
                if radix == 16 { dw.shiftLeft(60) } else { dw.multiply(p) }
                dw.add(w)
                g = d; i = .zero; si = ei
            }
        }
        self.init(dw.first ?? .zero, dw.last ?? .zero)
    }
    
    @inlinable
    public init(unicodeScalarLiteral value: UnicodeScalar) { self.init(String(value)) }
    
    @inlinable
    public init(extendedGraphemeClusterLiteral value: String) { self.init(value) }
    
    public init(_ str: String) {
        if str.hasPrefix("0x") { self.init(.init(str.dropFirst(2)), radix: 16) }
        else if str.hasPrefix("0b") { self.init(.init(str.dropFirst(2)), radix: 2) }
        else { self.init(str, radix: 10) }
    }
}
